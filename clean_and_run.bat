@echo off
cd /d D:\flutter_project\network_app
call flutter clean
call flutter pub get
call flutter run -d emulator-5554