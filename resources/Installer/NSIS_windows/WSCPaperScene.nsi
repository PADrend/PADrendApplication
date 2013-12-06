
;--------------------------------
;!define /date VERSION "%Y-%m-%d_%H-%M-%S"
!define /date VERSION "%Y-%m-%d_%H-%M"
;!define VERSION "1.0.3"
!define BASE_DIR "..\.."

; The name of the installer
Name "WSCPaper_Scene ${VERSION}"

; The file to write
OutFile "WSCPaper_Scene_Setup_${VERSION}.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Walkthrough

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKCU "Software\Walkthrough" "Install_Dir"

; Request application privileges for Windows Vista
;RequestExecutionLevel user
RequestExecutionLevel admin

;Icon "ppIcon.ico"
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
LicenseData "Notice.txt"
;--------------------------------


;--------------------------------
 InstType "ply"
;InstType "mmf"


; The stuff to install
SectionGroup "WSCPaper_Scene"

Section "WSCPaper_Scene .ply"
SectionIn 1 
SetOutPath $INSTDIR\Data\scenes\WSCPaperScene2
File  /r ${BASE_DIR}\Data\scenes\WSCPaperScene2\*.ply
SetOutPath $INSTDIR\Data\scenes
File  /r ${BASE_DIR}\Data\scenes\WSCPaperScene2o_3.minsg
SectionEnd
SectionGroupEnd
