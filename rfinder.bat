@echo off
:: repeat_finder starten mit Angabe der Xmere und der FASTA-Sequenz
:: Syntax: rfinder.bat [FASTA-Datei] [Zahl(Min-Xmer)] [Zahl(Max-Xmer)] [Treffer] [Sortiern, w=Wahrscheinlichkeit, a=Anzahl)]

title Repeat-finder Batch
echo.
echo ***   Repeat-finder Batch   ***
echo.

::Variablen setzen
set _arbeitsweg_=c:\Dienst\bin
set wprompt=%_arbeitsweg_%\wprompt.exe
set winput=%_arbeitsweg_%\winput.exe
set msgbox=%_arbeitsweg_%\msgbox.exe
::set rfinder=D:\Data\Perl\NRC_Institute_for_Biological_Sciences\repeat_finder\repeat_finder.pl
set rfinder=C:\Dienst\perl\repeat_finder\repeat_finder.pl
set editor="C:\Program Files (x86)\EditPad\EditPad.exe"

:: Abbruch ohne Eingabedatei
if "x%1"=="x" goto datei-fehlt
:: auf richtige Dateiendung testen
echo Dateiendung: %~x1
::pause
if "%~x1"==".fasta" goto :clean_fasta
if "%~x1"==".fas" goto :clean_fasta
if "%~x1"==".nt" goto :clean_fasta
goto :kein-fasta

:clean_fasta
%wprompt% "Warning" "The FASTA sequence file must be clean!" Ok 1:3
if %errorlevel% == 2 goto :Ende

set datei=%1
set vorname=%~n1
set weg=%~dp1

:min
set min=%2
if "%min%"=="" call :min-eingabe
if "%min%"=="" goto :min

:max
set max=%3
if "%max%"=="" call :max-eingabe
if %max% GEQ %min% (
  goto nach-max
  ) else (
  %wprompt% "Error" "The max value is to low, must be bigger than or equal to %min%!" Ok x & goto :max
  )
:nach-max

:treffer
set treffer=%4
if "%4"=="" call :treffer-eingabe
if "%treffer%"=="" goto :treffer

:sortierung
set sort=
set sortierung=over-represented
:: Sort by number of hits = -S
if "%5"=="h" set sort=-S
if "%5"=="" call :sort-eingabe
if "%sort%"=="-S" set sortierung=hits

:: Ausgabe der Eingabeparameter
echo Weg: %weg%
echo FASTA-Eingabedatei: %datei%
echo Ausgabedatei: %~n1%.rfXmer
echo Min-Xmer: %min%
echo Max-Xmer: %max%
echo Hits: %treffer%
echo Sort: %sortierung%
%wprompt% "Ausgabe" "Min=%min% bp^Max=%max% bp^Hits=%treffer%^Sort=%sortierung%^Repeats in der Datei %datei%" Ok 1:4


:: Program auf rufen x mal von min bis max
echo --- Zyklus ---
echo --------------------------------------------------
:: Variablen                                        1   2       3                  4         5 
for /L %%x in (%min%,+1,%max%) do call :rf-start %%x %datei% %weg%%~n1.rfXmer %treffer% %sort%


:: Ergebnissdatei mit Editor öffnen
start "Editor" /b %editor% "%weg%\%~n1%.rfXmer"
goto Ende

:Ende
goto :eof

:: **********************************************************************************
:: Unterprogramme

:rf-start
echo.
echo Piped sequence file: %2
echo Ausgabedatei: %3%
echo %1-mer:
C:\Perl64\bin\perl.exe %rfinder% %5 -n%1 -r%4 %2 >> %3%
echo --------------------------------------------------
goto :eof

:min-eingabe
%winput% "set min=$input" "Minimale Repeatlaenge (bp)" /num > %tmp%\rfindertemp.bat
if not errorlevel 1 call %tmp%\rfindertemp.bat
if "%min%"=="" goto :min-eingabe
goto :eof

:max-eingabe
%winput% "set max=$input" "Maximale Repeatlaenge (bp)" /num > %tmp%\rfindertemp.bat
if not errorlevel 1 call %tmp%\rfindertemp.bat
if "%max%"=="" goto :max-eingabe
goto :eof

:treffer-eingabe
%winput% "set treffer=$input" "Maximale Treffermenge (Anzahl)" /num > %tmp%\rfindertemp.bat
if not errorlevel 1 call %tmp%\rfindertemp.bat
goto:eof

:sort-eingabe
%wprompt% "Ausgabeformat" "Ausgabe nach Trefferanzahl sortieren?^(Ansonsten wird sortiert nach 'over-representation')" YesNo 2 ?
if not errorlevel 2 set sort=-S
goto:eof

:datei-fehlt
echo Dateiname fehlt!
echo Syntax: rfinder.bat [FASTA-Datei] [Zahl(Min-Xmer)] [Zahl(Max-Xmer)] [Zahl(Anzahl Treffer)]
start "MsbBox" /b %msgbox% "Syntax: rfinder.bat [FASTA-Datei] [Zahl(Min-Xmer)] [Zahl(Max-Xmer) [Zahl(Anzahl Treffer)]" "Dateiname fehlt" 2 1
goto Ende

:kein-fasta
echo Die Datei hat keine FASTA-Dateiendung!
%msgbox% "Die Datei hat keine FASTA-Dateiendung!" "Warning" 2 1 5
goto Ende
