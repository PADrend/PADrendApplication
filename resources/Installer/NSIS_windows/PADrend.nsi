; NSIS-installer for PADrend project.
;--------------------------------------------
!include "WinMessages.nsh"

;!define /date VERSION "%Y-%m-%d_%H-%M-%S"
!define /date VERSION "%Y-%m-%d_%H-%M"

!define BASE_DIR "..\..\..\.."

; The name of the installer
Name "PADrend ${VERSION}"

; The file to write
OutFile "PADrend_Setup_${VERSION}.exe"

; The default installation directory
InstallDir $PROGRAMFILES\PADrend

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKCU "Software\PADrend" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel user
; RequestExecutionLevel admin

Icon "PADrendIcon.ico"
BrandingText " "

;VIProductVersion "1.2.3.4"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "Test Application"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "A test comment"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Fake company"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "Test Application is a trademark of Fake company"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© Fake company"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Test Application"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.2.3"

Caption "PADrend"

;--------------------------------

; Pages

Page license
Page components
Page directory
Page instfiles

;UninstPage uninstConfirm
;UninstPage instfiles
;--------------------------------
LicenseText "PADrend ${VERSION}" "Ok"
LicenseData "Notice.txt"
;--------------------------------
InstType "common"
InstType "ext"
InstType "everything"

; The stuff to install
SectionGroup "System"

Section "Install main exe"
SectionIn 1 2 3
SetOutPath $INSTDIR
File /oname=PADrend.exe ${BASE_DIR}\PADrend.exe 
File /oname=Help.txt ${BASE_DIR}\PADrend\doc\Help.txt
SectionEnd
; ---
Section "Cleanup old DLLs"
;SectionIn 
Delete $INSTDIR\*.dll
SectionEnd
; ---

Section "Install DLLs"
SectionIn 1 2 3
SetOutPath $INSTDIR
File ${BASE_DIR}\*.dll
SectionEnd
; ---
Section "Install EScript/STD"
SectionIn 1 2 3
SetOutPath $INSTDIR\modules\EScript\Std
File /r /x .git /x .svn ${BASE_DIR}\modules\EScript\Std\*.escript

SectionEnd
; ---
Section "Store install path in registry"
SectionIn 1 2 3
WriteRegStr HKCU "Software\PADrend" "Install_Dir" "$INSTDIR"

SectionEnd
; ---
SectionGroupEnd
;--------------

SectionGroup "Plugins"

Section "Cleanup old common plugins"
;SectionIn 2
RMDir  $INSTDIR\plugins
SectionEnd
; ---
Section "Cleanup old ext plugins"
;SectionIn 2
RMDir  $INSTDIR\extPlugins
SectionEnd
; ---
Section "Common Plugins (MPL)"
SectionIn 1 2 3
SetOutPath $INSTDIR\plugins
File /r /x .svn /x .git /x .svn ${BASE_DIR}\plugins\*.*
SectionEnd

; ---
Section "ExtPlugins (proprietary)"
SectionIn 2 3
SetOutPath $INSTDIR\extPlugins
File /r /x .svn /x Labyrinth /x .git ${BASE_DIR}\extPlugins\*.*
SectionEnd


SectionGroupEnd

; ------------
SectionGroup "Sources"

Section "Install Sources"
SectionIn 3
SetOutPath $INSTDIR\modules
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\modules\*.
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\modules\*.html
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\modules\*.rc
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\modules\*.h
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\modules\*.cpp
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\modules\*.txt
SetOutPath $INSTDIR\PADrend
; File /r /x .Libs /x .git /x .svn ${BASE_DIR}\PADrend\*.
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\PADrend\*.ico
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\PADrend\*.cpp
File /r /x .Libs /x .git /x .svn ${BASE_DIR}\PADrend\*.txt
SectionEnd

SectionGroupEnd
; ------------

; ---
SectionGroup "Data"

; ---
Section "Install example scene (Szene_1)"
SectionIn 1 2 3
SetOutPath $INSTDIR\data\texture
File ${BASE_DIR}\data\texture\Schwein.low.t.png
File ${BASE_DIR}\data\texture\stone3.bmp
SetOutPath $INSTDIR\data\scene
File ${BASE_DIR}\data\scene\szene_1.minsg
SetOutPath $INSTDIR\data\mesh
File ${BASE_DIR}\data\mesh\Schwein.low.t.mmf
File ${BASE_DIR}\data\mesh\tCube.mmf
File ${BASE_DIR}\data\mesh\tree_lite2.mmf
File ${BASE_DIR}\data\mesh\tree_red.mmf
File ${BASE_DIR}\data\mesh\tree_lite1.mmf
File ${BASE_DIR}\data\mesh\tWall_2.mmf
SectionEnd
; ---
Section "Preset for loading (Szene_1)"
SectionIn 1 2 3
SetOutPath $INSTDIR\presets
File ${BASE_DIR}\presets\10_Szene_1.png
File ${BASE_DIR}\presets\10_Szene_1.escript
SectionEnd
; ; ---

; Section "Install TD Data"
; SectionIn 2
; SetOutPath $INSTDIR\TD
; File /r /x .svn ${BASE_DIR}\TD\*.*
; SectionEnd

; ---

;Section "Install Resources"
;SectionIn 1 2 3
;SetOutPath $INSTDIR\resources
;File /r /x .svn /x *.exe /x .git /x .svn ${BASE_DIR}\resources\*.*
;SectionEnd

; ---

SectionGroupEnd
; ---
Section "Create shortcut on desktop"
SectionIn 1 2 3
SetOutPath $INSTDIR
CreateShortCut "$DESKTOP\PADrend.lnk" "$INSTDIR\PADrend.exe" ""

SectionEnd

; -------------------------------
 ; Function .onMouseOverSection
    ; FindWindow $R0 "#32770" "" $HWNDPARENT
    ; GetDlgItem $R0 $R0 1043 ; description item (must be added to the UI)

    ; StrCmp $0 0 "" +2
    ; ;  MessageBox MB_OK "Windows Commander not found. Unable to get install path."

	  ; SendMessage $R0 ${WM_SETTEXT} 0 "STR:first section description"

    ; StrCmp $0 1 "" +2
		; ;MessageBox MB_OK "Windows Commander not found. Unable to get install path."

		; SendMessage $R0 ${WM_SETTEXT} 0 "STR:second section description"
  ; FunctionEnd
