@echo off
title Gesture 3D Viewer - Localhost Server
echo ============================================================
echo Starting Localhost Web Server for Gesture 3D Human Model Viewer
echo (Enables full Webcam ^& Microphone permissions on Chrome/Edge)
echo ============================================================
echo.

if exist "%~dp03D-modal--main\start_localhost_server.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp03D-modal--main\start_localhost_server.ps1"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start_localhost_server.ps1"
)

pause
