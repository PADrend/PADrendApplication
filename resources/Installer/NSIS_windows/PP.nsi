
;--------------------------------
;!define /date VERSION "%Y-%m-%d_%H-%M-%S"
!define /date VERSION "%Y-%m-%d_%H-%M"
;!define VERSION "1.0.3"
!define BASE_DIR "..\.."

; The name of the installer
Name "PP ${VERSION}"

; The file to write
OutFile "PP_Setup_${VERSION}.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Walkthrough

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Walkthrough" "Install_Dir"

; Request application privileges for Windows Vista
;RequestExecutionLevel user
RequestExecutionLevel admin

Icon "SchweineIcon.ico"
BrandingText " "

;--------------------------------

; Pages

Page license
Page components
Page directory
;PageEx directory
;  DirVerify leave
;  PageCallbacks "" "" dirLeave
;PageExEnd
Page instfiles

;UninstPage uninstConfirm
;UninstPage instfiles
;--------------------------------
LicenseText "A test text, make sure it's all there" "Ok"
LicenseData "Anforderungen.txt"
;--------------------------------


;--------------------------------
InstType "ply"
InstType "mmf"


; The stuff to install
SectionGroup "Powerplant"

Section "Powerplant .ply"
SectionIn 1 
SetOutPath $INSTDIR\Data\model\powerplant
File  /r ${BASE_DIR}\Data\model\powerplant\*.ply
SectionEnd
SectionGroupEnd
