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

rem 检查 ndk 环境，确保已添加至系统环境变量 PATH 中

set "_RUN_EXECUTOR=ndk-build"
where %_RUN_EXECUTOR% > nul 2>&1
if "%errorlevel%" == "0" goto okNdk
echo The NDK environment is not defined correctly.
echo This environment is needed to run this program.
echo Please add the android ndk home to PATH environment variable.
goto end

:okNdk
goto exit

rem 退出当前shell继续执行
:exit
exit /b 0

rem 退出程序
:end
exit /b 1