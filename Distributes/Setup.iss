; �ű��� Inno Setup �ű��� ���ɣ�
; �йش��� Inno Setup �ű��ļ�����ϸ��������İ����ĵ���

#define MyAppName "��ʯ֮��"
#define MyAppEngName "NiShiPower"
#define MyAppExeName "NiShiPower.exe"
#define MyAppRegPathKey "Path"
#define MyAppVersion GetFileVersion("NiShiPower.exe")
#define MyAppPublisher "Abin"
#define MyAppURL "http://www.jindu-wx.com/"

[Setup]
; ע: AppId��ֵΪ������ʶ��Ӧ�ó���
; ��ҪΪ������װ����ʹ����ͬ��AppIdֵ��
; (�����µ�GUID����� ����|��IDE������GUID��)
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
; ע��: ��Ҫ���κι���ϵͳ�ļ���ʹ�á�Flags: ignoreversion��

[Icons]
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopiconName: "{commonprograms}\{#MyAppName}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commonprograms}\{#MyAppName}\ʹ�ð���"; Filename: "{app}\{#MyAppEngName}.chm"
Name: "{commonprograms}\{#MyAppName}\ж��"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "-installaddon"
Filename: "{app}\{#MyAppExeName}"; Description: "����{#MyAppName}"; Flags: nowait postinstall
Filename: "hh.exe"; Parameters: "{app}\{#MyAppEngName}.chm"; Description: "�鿴ʹ�ð���"; Flags: nowait postinstall

[UninstallRun]
Filename: "{app}\{#MyAppExeName}"; Parameters: "-uninstalladdon"

[Registry]
Root: HKLM; Subkey: "Software\{#MyAppPublisher}\{#MyAppEngName}"; ValueType: string; ValueName: {#MyAppRegPathKey}; ValueData: "{app}"


