@echo off
title Gesture 3D Viewer - Localhost Server
echo ============================================================
echo Starting Localhost Web Server for Gesture 3D Human Model Viewer
echo (Enables full Webcam ^& Microphone permissions on Chrome/Edge)
echo ============================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start_localhost_server.ps1"

pause
