@echo off
setlocal enabledelayedexpansion

REM ===================================================================
REM  SCAFFOLD - provisionamento.bat
REM  Aula 07 - Provisionamento e Automacao de Instalacao
REM
REM  Este arquivo NAO tem codigo pronto - so o roteiro em comentarios.
REM  Cada linha indica qual Peca usar naquele ponto (ver slides/README).
REM  Substituam os comentarios pelo codigo real, mantendo a ordem.
REM ===================================================================

REM 1) Variaveis + cabecalho no log (Pecas 1, 2, 4)
 
set LOGFILE=log_%COMPUTERNAME%.txt
echo Inicio: %DATE% %TIME% > %LOGFILE%
 
set apps=Notepad++.Notepad++ Microsoft.PowerToys Microsoft.WindowsTerminalX
set ok_count=0
set fail_count=0

REM 2) [se precisar] Verificar Admin (Peca 7)

REM 3) for em "apps" (Peca 2):
REM    - instalar / [ja instalado? Peca 8] / [tentar de novo Peca 9]
for %%A in (%apps%) do (
    winget install --id %%A -e --silent --accept-package-agreements --accept-source-agreements
if !errorlevel! neq 0 (
        echo [FALHA] %%A >> %LOGFILE%
        set /a fail_count+=1
    ) else (
        echo [OK] %%A >> %LOGFILE%
        set /a ok_count+=1
    )
)


REM    - if/else + contadores + log (Pecas 3, 4, 5)

REM 4) Resumo final no log
echo Sucesso: !ok_count! ^| Falhas: !fail_count! >> %LOGFILE%
REM 5) [se precisar] os dois requisitos do grupo

pause
