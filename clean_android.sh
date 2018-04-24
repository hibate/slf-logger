#!/bin/bash
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

CURRENT_DATETIME=$(date "+%Y/%m/%d %A %H:%M:%S")

echo "============================================================="
echo "Author: Hibate"
echo "Description: Jni project build script"
echo "Current Date: ${CURRENT_DATETIME}"
echo "============================================================="
echo ""

##############################################################
current_dir=$(pwd)
libs_dir=${current_dir}/libs
objs_dir=${current_dir}/obj
##############################################################

# 设置基础参数
ENVSETUP=${current_dir}/auto/envsetup.sh

# 检查是否是 jni 编译目录: 当前目录下必须存在且名字为 jni 的文件夹
jni_dir=${current_dir}/jni
if [ ! -d "${jni_dir}" ]; then
    echo "Is this jni project folder?"
    exit 1
fi

# 检查脚本
if [ ! -f "${ENVSETUP}" ]; then
    echo "Cannot find ${ENVSETUP}"
    echo "This file is needed to run this program"
    exit 1
fi

# 执行 envsetup 脚本检查 ndk 环境
. ${ENVSETUP}

# NDK 环境正常
_EXECNDK=${_RUN_EXECUTOR}

# 执行清理
${_EXECNDK} clean

if [ -d "${libs_dir}" ]; then
    rm -rf ${libs_dir}
fi
if [ -d "${objs_dir}" ]; then
    rm -rf ${objs_dir}
fi

echo ""

exit 0