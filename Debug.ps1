iwr -Uri https://raw.githubusercontent.com/nigurr/DTA_Testing/patch-1/vstest.discoveryengine.exe.config -OutFile vstest.discoveryengine.exe.config
iwr -Uri https://raw.githubusercontent.com/nigurr/DTA_Testing/patch-1/vstest.discoveryengine.x86.exe.config -OutFile vstest.discoveryengine.x86.exe.config
iwr -Uri https://raw.githubusercontent.com/nigurr/DTA_Testing/patch-1/vstest.executionengine.exe.config -OutFile vstest.executionengine.exe.config
iwr -Uri https://raw.githubusercontent.com/nigurr/DTA_Testing/patch-1/vstest.executionengine.x86.exe.config -OutFile vstest.executionengine.x86.exe.config

cp -Force .\*.exe.config 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TestWindow' -Verbose

New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.executionengine.exe"
New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.executionengine.x86.exe"
New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.discoveryengine.exe"
New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.discoveryengine.x86.exe"

New-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.executionengine.exe" -Name GlobalFlag -Value 512
New-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.executionengine.x86.exe" -Name GlobalFlag -Value 512
New-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.discoveryengine.exe" -Name GlobalFlag -Value 512
New-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vstest.discoveryengine.x86.exe" -Name GlobalFlag -Value 512

New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit"
New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\vstest.executionengine.exe"
New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\vstest.executionengine.x86.exe"
New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\vstest.discoveryengine.exe"
New-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SilentProcessExit\vstest.discoveryengine.x86.exe"

Invoke-WebRequest -Uri 'https://download.sysinternals.com/files/Procdump.zip' -OutFile Procdump.zip
Invoke-WebRequest -Uri 'https://download.microsoft.com/download/5/C/C/5CCCFF9B-08C4-4352-9DBF-DF44E3A2E9EA/PerfView.zip' -OutFile PerfView.zip
Expand-Archive "Procdump.zip" -DestinationPath "procdump" -Force
Expand-Archive "PerfView.zip" -DestinationPath "procdump" -Force
cd procdump
.\PerfView.exe  collect /MaxCollectSec:800 /AcceptEula /logFile=collectionLog.txt
start-process powershell -argument "$PWD\procdump.exe -w -s 2 -n 300 -ma vstest.console -accepteula >vstestconsole.txt"
start-process powershell -argument "$PWD\procdump.exe -w -s 2 -n 300 -ma vstest.executionengine -accepteula >vstestexcution.txt"

