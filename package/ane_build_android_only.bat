@echo off

cd /d %~dp0
set adt=java -jar adt.jar
set ane=ShareSDK.ane
set target=ane %ane% .\extension_build_android_only.xml
set swc=.\ShareSDKExtension.swc
set platform-android=-platform Android-ARM -C ./Android-ARM .

echo Packaging...
if exist %ane% del %ane% > nul
%adt% -package -target %target% -swc %swc% %platform-ios-arm% %platform-ios-x86% %platform-android%

cls
echo Finish!
pause
