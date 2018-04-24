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

set "BUILD_APP_OPTIM=%1"
set "BUILD_PROJECT_DIR=%2"

for %%c in (%LIBRARY_TYPE%) do (
    if "%%c" == "shared" (
        call "%BUILD_SHARED%" %BUILD_APP_OPTIM% %BUILD_PROJECT_DIR%
    )
    if "%%c" == "static" (
        call "%BUILD_STATIC%" %BUILD_APP_OPTIM% %BUILD_PROJECT_DIR%
    )
)

goto exit

rem 退出当前shell继续执行
:exit
exit /b 0

rem 退出程序
:end
exit /b 1