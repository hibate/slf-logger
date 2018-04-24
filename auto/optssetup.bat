@echo off
rem
rem Copyright (C) 2017 Hibate <ycaia86@126.com>
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem      http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.
rem

rem 解析参数

rem ##############################################################
rem 显示帮助
set "opts_help=0"

rem 编译 debug 版本: 默认禁用
set "opts_debug=0"

rem 编译 release 版本: 默认开启
set "opts_release=1"

rem 编译 static 库: 默认开启
set "opts_static=1"

rem 编译 shared 库: 默认开启
set "opts_shared=1"
rem ##############################################################

:options
if not ""%1"" == """" (
    if "%1" == "-h" (
        set "opts_help=1"
    )
    if "%1" == "-help" (
        set "opts_help=1"
    )
    if "%1" == "-debug" (
        set "opts_debug=1"
        set "opts_release=0"
    )
    if "%1" == "-release" (
        set "opts_debug=0"
        set "opts_release=1"
    )
    if "%1" == "-all" (
        set "opts_debug=1"
        set "opts_release=1"
    )
    if "%1" == "-static" (
        set "opts_static=1"
        set "opts_shared=0"
    )
    if "%1" == "-shared" (
        set "opts_static=0"
        set "opts_shared=1"
    )

    shift
    goto :options
)

if "%opts_help%" == "1" goto showHelp

goto exit

:showHelp
@echo.
echo Usage: make [options]
echo Options:
echo   -h, -help                 Print this message and exit.
echo   -debug                    Build debug library.
echo   -release                  Build shared library.
echo   -all                      Build debug and shared library.
echo   -static                   Build static library.
echo   -shared                   Build shared library.
@echo.
echo The default options will build static and shared library on release version.
goto end

:showOptions
@echo.
echo opts_help:    %opts_help%
echo opts_debug:   %opts_debug%
echo opts_release: %opts_release%
echo opts_static:  %opts_static%
echo opts_shared:  %opts_shared%
@echo.
goto exit

rem 退出当前shell继续执行
:exit
exit /b 0

rem 退出程序
:end
exit /b 1