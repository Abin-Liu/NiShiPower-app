; 脚本由 Inno Setup 脚本向导 生成！
; 有关创建 Inno Setup 脚本文件的详细资料请查阅帮助文档！

#define MyAppName "倪石之力"
#define MyAppEngName "NiShiPower"
#define MyAppExeName "NiShiPower.exe"
#define MyAppRegPathKey "Path"
#define MyAppVersion GetFileVersion("NiShiPower.exe")
#define MyAppPublisher "Abin"
#define MyAppURL "http://www.jindu-wx.com/"

[Setup]
; 注: AppId的值为单独标识该应用程序。
; 不要为其他安装程序使用相同的AppId值。
; (生成新的GUID，点击 工具|在IDE中生成GUID。)
AppId={{F51FB5B7-9CB3-4A88-A51B-E9C2E7270EC9}
AppMutex={{C4322418-C3BA-4B5D-80FD-5DAC0274DE27}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppCopyright=Copyright (C) 2012, {#MyAppPublisher}
LicenseFile=EULA.rtf
PrivilegesRequired=admin

DefaultDirName={reg:HKLM\Software\{#MyAppPublisher}\{#MyAppEngName},{#MyAppRegPathKey}|{pf}\{#MyAppEngName}}
DefaultGroupName={#MyAppName}
OutputBaseFilename={#MyAppEngName}_Setup {#MyAppVersion}
Compression=lzma
SolidCompression=yes

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppEngName}.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "Shutdown.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "InputThread.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "WoWThread.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "UI\*"; DestDir: "{app}\UI\"; Flags: ignoreversion recursesubdirs
; 注意: 不要在任何共享系统文件上使用“Flags: ignoreversion”

[Icons]
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopiconName: "{commonprograms}\{#MyAppName}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commonprograms}\{#MyAppName}\使用帮助"; Filename: "{app}\{#MyAppEngName}.chm"
Name: "{commonprograms}\{#MyAppName}\卸载"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "-installaddon"
Filename: "{app}\{#MyAppExeName}"; Description: "运行{#MyAppName}"; Flags: nowait postinstall
Filename: "hh.exe"; Parameters: "{app}\{#MyAppEngName}.chm"; Description: "查看使用帮助"; Flags: nowait postinstall

[UninstallRun]
Filename: "{app}\{#MyAppExeName}"; Parameters: "-uninstalladdon"

[Registry]
Root: HKLM; Subkey: "Software\{#MyAppPublisher}\{#MyAppEngName}"; ValueType: string; ValueName: {#MyAppRegPathKey}; ValueData: "{app}"


