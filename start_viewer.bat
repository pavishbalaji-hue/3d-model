@echo off
title Gesture-Controlled 3D Human Model Viewer
echo Starting Gesture-Controlled 3D Human Model Viewer...
if exist "%~dp03D-modal--main\index.html" (
    start "" "%~dp03D-modal--main\index.html"
) else (
    start "" "%~dp0index.html"
)
exit
