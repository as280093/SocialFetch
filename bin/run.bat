@echo off
chcp 65001 > nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0main.ps1" -Module %1 -Color %2 -Icons "%~3"