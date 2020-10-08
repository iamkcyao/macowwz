# Zabbix Application Console Monitor

## 建立 cmd console 監控套件

在欲監控的伺服器新增以下兩個Batch檔，並放到特定位置

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/1.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/1.png)

> check_exe_status.bat   [https://pastebin.com/0qnLRP8U](https://pastebin.com/0qnLRP8U)

```powershell
@echo off
tasklist|findstr ^%1 >/NUL 2>&1
if %errorlevel% == 0 (
echo "1"
) else (
echo "0"
)
```

> findexe.bat   [https://pastebin.com/WL3rZ9Dv](https://pastebin.com/WL3rZ9Dv)

```powershell
@echo off
setlocal enabledelayedexpansion
set /a n=0
set /a n1=0
for %%i in (%*) do (set /a n+=1)
@echo {"data":[
for %%a in (%*) do (
set /a n1+=1
@echo {"{#SERVERNAME}":"%%a"
if !n1! neq !n! (
@echo },
) else (
@echo }
)
)
echo ]}
```

## 修改 zabbix_agentd.conf 設定檔

設定 ServerActive 伺服器位址

```bash
ServerActive=zabbix.9splay.com
```

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/2.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/2.png)

設定與Zabbix Web上相同Hostname

```bash
Hostname=NL-9S-SDWeb02-211.20.178.166
```

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/3.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/3.png)

將下列兩個設定修改至 **1** 

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/4.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/4.png)

```bash
EnableRemoteCommands=1
LogRemoteCommands=1
```

加入下列兩行設定 （檔案路徑可自行更改）

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/5.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/5.png)

```bash
# Monitor CMD Console
UserParameter=findexe[],"C:\zabbix\findexe.bat" $1
UserParameter=check_status[],"C:\zabbix\check_exe_status.bat" $1
```

設定好存檔，再重啟 zabbix_agentd

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/14.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/14.png)

## Zabbix Web 上 Host 及 template 設定

在要監控的 Host 裡加入 Application_Console_Monitor 這個 Template

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/7.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/7.png)

因為預設每台機器要監控的程式名稱不同，所以加入後需要再 Unlink，讓每台機器監控的清單不同。

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/8.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/8.png)

點選該 host 進入查看 Discovery rules 

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/9.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/9.png)

進入 auto find exe application ， 修改欲監控的 console 名稱，每個名稱以空白間隔，若數量太多也會被 key 欄位的

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/10.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/10.png)

這邊需要注意的是，被監控程式的檔名不能太長（25個半形字元內），因為監控是用 tasklist 這個指令去抓取程式名稱，所以太長的名稱會導致無法取得完整的名字，就會監控到沒在執行，建議作法如下：

1. 修改程式名稱（25個半形字元內）
2. 修改監控關鍵字（需要方便識別服務用途，Triggers 會顯示該名稱）

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/6.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/6.png)

設定好後把預設為 Disabled 的 改為 Enabled

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/11.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/11.png)

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/12.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/12.png)

在 triggers 確認各項程式監控是否為 Disabled ，也將他打開設為 Enabled

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/Untitled.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/Untitled.png)

然後到 Latest data 選擇該 Hosts，過些時間就可以看到監控的狀態

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/13-1.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/13-1.png)

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/13.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/13.png)

> 監控狀態指示

1：執行中

0：未執行 （若為 0 會觸發Triggers）

![Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/Untitled%201.png](Zabbix%20Application%20Console%20Monitor%20b4deb6d7f7424c6e8ebdee2aa7efe1cc/Untitled%201.png)

設定完成。