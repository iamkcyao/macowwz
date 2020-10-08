# Zabbix Application Console Monitor

## 建立 cmd console 監控套件

在欲監控的伺服器新增以下兩個Batch檔，並放到特定位置<br>
Create following 2 batch file on monitor server , and save to folder you want.

![](https://i.imgur.com/jgSiKfK.png)

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

## 修改 zabbix_agentd.conf 設定檔<br>
## Edit zabbix_agentd.conf file

設定 ServerActive 伺服器位址<br>
Edit ServerActive parameter server address

```bash
ServerActive=zabbix.xxxxx.com
```

![](https://i.imgur.com/Uoa12eg.png)

設定與Zabbix Web上相同Hostname<br>
Edit same hostname with Zabbix Web

```bash
Hostname=NL-xx-SDWeb02-xxx.xx.xxx.xxx
```

![](https://i.imgur.com/HXeJfnp.png)

將下列兩個設定修改至 **1** <br>
Edit following 2 parameter from 0 to 1 (enable it)

![](https://i.imgur.com/bQZhTwD.png)

```bash
EnableRemoteCommands=1
LogRemoteCommands=1
```

加入下列兩行設定 （檔案路徑可自行更改）<br>
Adding following 2 parameter to file end (batch file path can change if you want)

![](https://i.imgur.com/jDE9YI9.png)

```bash
# Monitor CMD Console
UserParameter=findexe[],"C:\zabbix\findexe.bat" $1
UserParameter=check_status[],"C:\zabbix\check_exe_status.bat" $1
```

設定好存檔，再重啟 zabbix_agentd<br>
Save config file , and restart zabbix_agentd

![](https://i.imgur.com/hoeuKJu.png)

## Zabbix Web 上 Host 及 template 設定<br>
## Zabbix Web Hosts and template Setting

在要監控的 Host 裡加入 Application_Console_Monitor 這個 Template <br>
Import Template to you want monitor hosts

![](https://i.imgur.com/GbasMZS.png)

因為預設每台機器要監控的程式名稱不同，所以加入後需要再 Unlink，讓每台機器監控的清單不同。<br>
After import need to unlink template , let every hosts monitor difference application.

![](https://i.imgur.com/wHF54wh.png)

點選該 host 進入查看 Discovery rules <br>
Click hosts check Discovery rules

![](https://i.imgur.com/NKSK1gW.png)

進入 auto find exe application ， 修改欲監控的 console 名稱，每個名稱以空白間隔，若數量太多也會被 key 欄位的字元長度限制 <br>
Click auto find exe application to edit console file name, every console name use space between 2 console name

![](https://i.imgur.com/aM2VZDM.png)

這邊需要注意的是，被監控程式的檔名不能太長（25個半形字元內），因為監控是用 tasklist 這個指令去抓取程式名稱，所以太長的名稱會導致無法取得完整的名字，就會監控到沒在執行，建議作法如下：


1. 修改程式名稱（25個半形字元內）
2. 修改監控關鍵字（需要方便識別服務用途，Triggers 會顯示該名稱）

![](https://i.imgur.com/GzNP3ug.png)

把預設為 Disabled 的 改為 Enabled
Change from Disabled to Enabled

![](https://i.imgur.com/NmGqz3n.png)

![](https://i.imgur.com/HyHwYCj.png)

在 triggers 確認各項程式監控是否為 Disabled ，也將他打開設為 Enabled
change from Disabled to Enabled


![](https://i.imgur.com/OOH2K8m.png)

然後到 Latest data 選擇該 Hosts，過些時間就可以看到監控的狀態
Check application monitor status in Latest data page

![](https://i.imgur.com/sAdA52L.png)

![](https://i.imgur.com/qPUexsf.png)

> 監控狀態指示
> Monitor Status notice

1：執行中 (Running)

0：未執行 （若為 0 會觸發Triggers） (Not Running then triggers)

![](https://i.imgur.com/OPqwt73.png)

設定完成。
Complete.
