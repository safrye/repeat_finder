@echo off

msgbox "@welcome.txt" "MessageBox 2.0" 

msgbox "Test #1 of 3" "MsgBox 2.0 by Doug Good" 1 2
if errorlevel =  2 GOTO CANCEL
if errorlevel =  1 GOTO OK

:CANCEL
echo You clicked CANCEL
GOTO TEST2
:OK
echo You clicked OK
GOTO TEST2

:TEST2
msgbox "Test #2 of 3" "Neat program, eh?" 2 3
if errorlevel =  7 goto NO
if errorlevel =  6 goto YES
:NO
echo You clicked NO
GOTO TEST3
:YES
echo You clicked YES
GOTO TEST3

:TEST3
msgbox "Test #3 of 3" "Last one!" 2 6
if errorlevel =  5 goto IGNORE
if errorlevel =  4 goto RETRY
if errorlevel =  3 goto ABORT

:IGNORE
echo You clicked IGNORE
GOTO DONE

:RETRY
echo You clicked RETRY
GOTO DONE

:ABORT
echo You clicked ABORT
GOTO DONE

:DONE
pause