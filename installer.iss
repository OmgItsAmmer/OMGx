; Script for OMG POS NEXUS Installer
; Generated manually with love 💙

[Setup]
AppName=OMG POS NEXUS
AppVersion=1.0
DefaultDirName={pf}\OMG POS NEXUS
DefaultGroupName=OMG POS NEXUS
OutputBaseFilename=OMG_POS_NEXUS_Installer
OutputDir=.
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
; SetupIconFile= windows\runner\resources\app_icon.ico ; ✅ (only if this path is correct)

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Source: "README.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\OMG POS NEXUS"; Filename: "{app}\OMG POS NEXUS.exe"
Name: "{commondesktop}\OMG POS NEXUS"; Filename: "{app}\OMG POS NEXUS.exe"; Tasks: desktopicon
Name: "{group}\Uninstall OMG POS NEXUS"; Filename: "{uninstallexe}"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked
