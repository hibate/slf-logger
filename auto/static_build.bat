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

setlocal

rem release / debug
set "BUILD_APP_OPTIM=%1"
set "BUILD_PROJECT_DIR=%2"

set build_install_dir=
if "%BUILD_APP_OPTIM%" == "debug" (
    set "build_install_dir=%debug_libs_dir%"
)
if "%BUILD_APP_OPTIM%" == "release" (
    set "build_install_dir=%release_libs_dir%"
)

@echo.
echo Build %BUILD_APP_OPTIM% static library
@echo.

call %_EXECNDK% APP_OPTIM=%BUILD_APP_OPTIM% BUILD_SHARED=false PROJECT_PATH=%BUILD_PROJECT_DIR%
if errorlevel 1 goto end

if exist "%objs_dir%" goto okObjs
goto exit

:okObjs
set "objs_local_dir=%objs_dir%\local"
for %%c in (%APP_ABI%) do (
    if exist "%objs_local_dir%\%%c" (
        if not exist "%build_install_dir%\%%c" (
            md %build_install_dir%\%%c
        )
        copy /y %objs_local_dir%\%%c\*.a %build_install_dir%\%%c\
    )
)

goto exit

rem 退出当前shell继续执行
:exit
exit /b 0

rem 退出程序
:end
exit /b 1