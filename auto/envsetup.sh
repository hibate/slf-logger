#!/bin/sh
#
# Copyright (C) 2017 Hibate <ycaia86@126.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

check_command_exists() {
    cmd=$1
    type ${cmd} >/dev/null 2>&1 || {
        unset cmd
        echo false
        return
    }
    unset cmd
    echo true
}

# 检查 ndk 环境，确保已添加至系统环境变量 PATH 中
_RUN_EXECUTOR=ndk-build
if [ $(check_command_exists ${_RUN_EXECUTOR}) = false ]; then
    echo "The NDK environment is not defined correctly."
    echo "This environment is needed to run this program."
    echo "Please add the android ndk home to PATH environment variable."
    exit 1
fi