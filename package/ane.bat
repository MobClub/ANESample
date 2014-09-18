@echo off

cd /d %~dp0
set adt=java -jar adt.jar
set ane=ShareSDK.ane
set target=ane %ane% .\extension.xml
set swc=.\ShareSDKExtension.swc
set platform-ios-arm=-platform iPhone-ARM -C ./iPhone-ARM . -platformoptions platformoptions.xml
set platform-ios-x86=-platform iPhone-x86 -C ./iPhone-x86 . -platformoptions platformoptions.xml
set platform-android=-platform Android-ARM -C ./Android-ARM .

echo Packaging...
if exist %ane% del %ane% > nul
%adt% -package -target %target% -swc %swc% %platform-ios-arm% %platform-ios-x86% %platform-android%

cls
echo Finish!
pause
