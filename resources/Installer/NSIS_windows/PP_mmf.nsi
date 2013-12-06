
;--------------------------------
;!define /date VERSION "%Y-%m-%d_%H-%M-%S"
!define /date VERSION "%Y-%m-%d_%H-%M"
;!define VERSION "1.0.3"
!define BASE_DIR "..\.."

; The name of the installer
Name "PP_mmf ${VERSION}"

; The file to write
OutFile "PP_mmf_Setup_${VERSION}.exe"

; The default installation directory
InstallDir $PROGRAMFILES\PADrend

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKCU "Software\PADrend" "Install_Dir"

; Request application privileges for Windows Vista
;RequestExecutionLevel user
RequestExecutionLevel admin

Icon "ppIcon.ico"
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
; InstType "ply"
InstType "mmf"


; The stuff to install
SectionGroup "Powerplant"

Section "Powerplant .mmf"
SectionIn 1 
SetOutPath $INSTDIR\Data\model\pp
File  /r ${BASE_DIR}\Data\model\pp\*.mmf
SetOutPath $INSTDIR\Data\scenes
File  /r ${BASE_DIR}\Data\scenes\pp_mmf*.minsg
SectionEnd
SectionGroupEnd
