@echo off
title Super Utilitario - Ativacao Full e Limpeza
:: Solicita privilegios de administrador
net session >nul 2>&1 || (powershell -Command "Start-Process '%0' -Verb RunAs" & exit /b)

echo ==================================================
echo [1/4] ATIVANDO WINDOWS (HWID)...
echo ==================================================
powershell -Command "& {$(irm https://get.activated.win)} /hwid"

echo.
echo ==================================================
echo [2/4] ATIVANDO OFFICE (OHOOK)...
echo ==================================================
powershell -Command "& {$(irm https://get.activated.win)} /ohook"

echo.
echo ==================================================
echo [3/4] LIMPANDO ARQUIVOS TEMPORARIOS...
echo ==================================================
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
net stop wuauserv >nul 2>&1
rd /s /q %systemroot%\SoftwareDistribution >nul 2>&1
net start wuauserv >nul 2>&1
echo [OK] Limpeza concluida!

echo.
echo ==================================================
echo [4/4] VERIFICANDO STATUS FINAL...
echo ==================================================
:: Verifica Windows
cscript //nologo %systemroot%\system32\slmgr.vbs /xpr
:: Verifica Office (procura o script de licenca)
where /R "C:\Program Files\Microsoft Office" ospp.vbs >nul 2>&1 && (
    for /f "delims=" %%i in ('where /R "C:\Program Files\Microsoft Office" ospp.vbs') do cscript "%%i" /dstatus
) || echo Office nao detectado ou caminho customizado.
echo ==================================================

echo.
echo [CONCLUIDO] Sistema e Office processados com sucesso!
pause