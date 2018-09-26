@echo off
@setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

@rem Name: 
@rem Purpose: 
@rem 
@rem Author: 
@rem Revision:
@rem

@rem @echo off
@rem @set method=goto:eof
@rem @set mbegin=setlocal
@rem @set mend=endlocal^&goto:eof @rem ^& call :quit ^%errorlevel^%
@set method=@goto:eof
@set mbegin=@set a1xyzefwew=""
@set mend=@goto:eof
@set mreturn=@exit /b !errorlevel!
@set return=@goto :on_exit

@set errorlevel=0

@rem go to rum main()
@goto :main

%method%
: usage ()
%mbegin%

　　echo %~1%

%mend%

%method%
: config ()
%mbegin%


　　set me=%~n0
　　set mex=%~nx0

　　@rem
　　@rem initialize configuration items here
　　@rem
　　set HEAD_LINE=*****************

　　call :parse_commind_line %*

%mend%

%method%
: main ()    
%mbegin%

　　@rem Check if need to show help informaiton
　　if "%~1" neq "" (
　　　　set param1=%~1
　　　　if "!param1:/?=!" neq "!param1!" (
　　　　　　call :usage %~nx0
　　　　　　exit /b 1
　　　　)
　　)

　　@rem load configuration
　　call :config %*

　　@rem initilize log environment
　　　call :init_log

　　@rem log example
　　@rem set log=C:\windows\system32\inetsrv\appcmd.exe set config "UimDirectAuxTestWebSite" /section:UimDirectAuxModule/"+references.[name='JOSE-JWWD_Server\AuthenFilter\uim-direct-aux\UimDirectAuxWebTest\uim_direct_aux\bin\jose-jwt.dll']"
　　@rem call :tee "%log%"

　　@rem 
　　@rem add business logical here
　　@rem

　　@rem for example, call a method
　　@rem call :method1 || ( set errorlevel=1 & %return%)

　　%return%

%mend%

%method%
: method1 ()
%mbegin%

　　@rem mkdir foldername >nul || (set errorlevel=1 & %mreturn%)

　　@rem set errorlevel=0 & %mreturn%

%mend%

%method%
: parse_commind_line ()
%mbegin%    
　　:lbl_param_list    
　　　　shift /1
　　　　if "%1" equ "" (
　　　　　　goto:eof
　　　　)

　　　　@rem read optional args
　　　　@REM set p=%~1
　　　　@REM set p2=%p:/old_filter=%
　　　　@REM if /i "%p%" neq "%p2%" (
　　　　@REM if /i "%~2" neq "" (
　　　　@REM set g_optional_param_name=%~2
　　　　@REM )
　　　　@REM )    
　　goto :lbl_param_list

%mend%

%method%
: print_head ()
%mbegin%
　　@call :log_prefix    
　　@echo %LOG_PREFIX% %HEAD_LINE% %mex% log %HEAD_LINE% > %log_file%
%end%

%method%
: print_foot ()
%mbegin%
　　@call :log_prefix    
　　@echo %LOG_PREFIX% %HEAD_LINE% %mex% log %HEAD_LINE% >> %log_file%
%end%

%method%
: init_log ()
%mbegin%
　　@rem get log file name
　　set log_file=%LOCALAPPDATA%\%me%\log
　　if not exist %log_file% ( 
　　　　mkdir %log_file% || echo "failed to create %log_file% with error %errorlevel%" & got :eof
　　) 
　　set log_file="%log_file%\%mex%.log"

　　@rem initialize the log file
　　call :print_head
%mend%

%method%
@rem
@rem output message to both stdout and %log_file%
@rem
: tee ()
@rem
@rem %* -- message
@rem
%mbegin%
　　@call :log_prefix    
　　@set tee_log=%*

　　@rem remove left "
　　set left_char=%tee_log:~0,1%
　　set left_char=%left_char:"=%
　　if "%left_char%" equ "" (
　　　　set tee_log=%tee_log:~1%
　　)
　　@rem remove right "
　　set right_char=%tee_log:~-1,1%
　　set right_char=%right_char:"=%
　　if "%right_char%" equ "" (
　　　　set tee_log=%tee_log:~0,-1%
　　)

　　@set tee_log=%LOG_PREFIX% %tee_log%
　　echo %tee_log%
　　@echo %tee_log% >> %log_file%
%mend%

%method%
: log_prefix
%mbegin%
　　@set LOG_PREFIX=[%date:~0,-4% %time%]
%mend%

%method%
@rem
@rem exit the batch with checking the error code
@rem please use this method by "goto :on_exit" rather than "call :on_exit"
@rem
: on_exit ()
%mbegin%
　　if %errorlevel% neq 0 (
　　　　echo %LOG_PREFIX% Failed to execute %mex%. For more information, please %log_file%
　　) else (
　　　　echo %LOG_PREFIX% Succeeded in executing %mex%. For details, please %log_file%
　　)
　　call :print_foot    
　　@rem type %log_file%
　　endlocal
　　exit /b %errorlevel%
%mend%