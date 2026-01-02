@echo off
setlocal enabledelayedexpansion
cd /d D:\flutter_project\network_app
echo Cleaning build...
call flutter clean
echo Getting dependencies...
call flutter pub get
echo Running app...
call flutter run -d emulator-5554
pause
