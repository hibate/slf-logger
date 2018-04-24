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
@echo Description: Jni project clean script
@echo Current Date: %date% %time:~0,8%
@echo =============================================================

setlocal

rem ##############################################################
set "current_dir=%cd%"
set "libs_dir=%current_dir%\libs"
set "objs_dir=%current_dir%\obj"
rem ##############################################################

:mainEntry
rem 设置基础参数
set "ENVSETUP=%current_dir%\auto\envsetup.bat"

rem 检查是否是 jni 编译目录: 当前目录下必须存在且名字为 jni 的文件夹
set "jni_dir=%current_dir%\jni"
if exist "%jni_dir%" goto okJNI
echo Is this jni project folder?
goto end

:okJNI
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
goto jniClean

:jniClean
rem 执行清理
call %_EXECNDK% clean
goto deleteFiles

:deleteFiles
if exist "%libs_dir%" (
    rd /s /q %libs_dir%
)
if exist "%objs_dir%" (
    rd /s /q %objs_dir%
)

@echo.

goto exit

:end
pause

:exit