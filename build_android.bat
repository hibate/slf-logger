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

@echo =============================================================
@echo Author: Hibate
@echo Description: Jni project build script
@echo Current Date: %date% %time:~0,8%
@echo =============================================================

setlocal

rem ##############################################################
set "current_dir=%cd%"
set "libs_dir=%current_dir%\libs"
set "objs_dir=%current_dir%\obj"

rem 设置 debug 和 release 库安装路径
set "debug_libs_dir=%current_dir%\libs-android\debug"
set "release_libs_dir=%current_dir%\libs-android\release"
rem ##############################################################

:mainEntry
rem 设置基础参数
set "ENVSETUP=%current_dir%\auto\envsetup.bat"
set "OPTSSETUP=%current_dir%\auto\optssetup.bat"
rem 编译脚本
set "BUILD_LIBRARY=%current_dir%\auto\library_build.bat"
set "BUILD_STATIC=%current_dir%\auto\static_build.bat"
set "BUILD_SHARED=%current_dir%\auto\shared_build.bat"

rem 检查是否是 jni 编译目录: 当前目录下必须存在且名字为 jni 的文件夹
set "jni_dir=%current_dir%\jni"
if exist "%jni_dir%" goto okJNI
echo Is this jni project folder?
goto end

rem 检查脚本
:okJNI
if not exist "%BUILD_LIBRARY%" (
    echo Cannot find "%BUILD_LIBRARY%"
    echo This file is needed to run this program
    goto end
)
if not exist "%BUILD_STATIC%" (
    echo Cannot find "%BUILD_STATIC%"
    echo This file is needed to run this program
    goto end
)
if not exist "%BUILD_SHARED%" (
    echo Cannot find "%BUILD_SHARED%"
    echo This file is needed to run this program
    goto end
)
if exist "%ENVSETUP%" goto okEnvSetup
echo Cannot find "%ENVSETUP%"
echo This file is needed to run this program
goto end

rem 执行 envsetup 脚本检查 ndk 环境
:okEnvSetup
call "%ENVSETUP%"
if errorlevel 0 goto okNdk
goto end

rem NDK 环境正常
:okNdk
set "_EXECNDK=%_RUN_EXECUTOR%"
rem 定义 NDK 支持的所有编译平台
set "APP_ABI=arm64-v8a armeabi armeabi-v7a mips mips64 x86 x86_64"
if exist "%OPTSSETUP%" goto okOptsSetup
echo Cannot find "%OPTSSETUP%"
echo This file is needed to run this program
goto end

rem ###############################

rem 解析命令参数
:okOptsSetup
set CMD_LINE_ARGS=
rem 将参数保存至 CMD_LINE_ARGS 变量以便向 optssetup 脚本传递
:setArgs
if ""%1""=="""" goto doneSetArgs
set "CMD_LINE_ARGS=%CMD_LINE_ARGS% %1"
shift
goto setArgs

rem 执行 optssetup 脚本解析命令参数
:doneSetArgs
call "%OPTSSETUP%" %CMD_LINE_ARGS%
if errorlevel 1 goto end
goto fillBuildOpts

rem ###############################

rem 填充编译选项
:fillBuildOpts
rem 编译类型: debug / release
set BUILD_TYPE=
if "%opts_debug%" == "1" (
    set "BUILD_TYPE=%BUILD_TYPE% debug"
)
if "%opts_release%" == "1" (
    set "BUILD_TYPE=%BUILD_TYPE% release"
)
rem 库类型: static / shared
set LIBRARY_TYPE=
if "%opts_static%" == "1" (
    set "LIBRARY_TYPE=%LIBRARY_TYPE% static"
)
if "%opts_shared%" == "1" (
    set "LIBRARY_TYPE=%LIBRARY_TYPE% shared"
)
goto buildJni

rem 执行编译
:buildJni
for %%c in (%BUILD_TYPE%) do (
    rem 执行清理
    call %_EXECNDK% clean
    if errorlevel 1 goto end
    
    cd %jni_dir%

    call "%BUILD_LIBRARY%" %%c %current_dir%
    if errorlevel 1 goto end
    cd %current_dir%
)

@echo.

goto exit

:end
pause

:exit