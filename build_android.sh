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

# 设置 debug 和 release 库安装路径
debug_libs_dir=${current_dir}/libs-android/debug
release_libs_dir=${current_dir}/libs-android/release
##############################################################

# 设置基础参数
ENVSETUP=${current_dir}/auto/envsetup.sh
OPTSSETUP=${current_dir}/auto/optssetup.sh
# 编译脚本
BUILD_LIBRARY=${current_dir}/auto/library_build.sh
BUILD_STATIC=${current_dir}/auto/static_build.sh
BUILD_SHARED=${current_dir}/auto/shared_build.sh

# 检查是否是 jni 编译目录: 当前目录下必须存在且名字为 jni 的文件夹
jni_dir=${current_dir}/jni
if [ ! -d "${jni_dir}" ]; then
    echo "Is this jni project folder?"
    exit 1
fi

# 检查脚本
if [ ! -f "${BUILD_LIBRARY}" ]; then
    echo "Cannot find ${BUILD_LIBRARY}"
    echo "This file is needed to run this program"
    exit 1
elif [ ! -f "${BUILD_STATIC}" ]; then
    echo "Cannot find ${BUILD_STATIC}"
    echo "This file is needed to run this program"
    exit 1
elif [ ! -f "${BUILD_SHARED}" ]; then
    echo "Cannot find ${BUILD_SHARED}"
    echo "This file is needed to run this program"
    exit 1
elif [ ! -f "${ENVSETUP}" ]; then
    echo "Cannot find ${ENVSETUP}"
    echo "This file is needed to run this program"
    exit 1
elif [ ! -f "${OPTSSETUP}" ]; then
    echo "Cannot find ${OPTSSETUP}"
    echo "This file is needed to run this program"
    exit 1
fi

# 执行 envsetup 脚本检查 ndk 环境
. ${ENVSETUP}

# NDK 环境正常
_EXECNDK=${_RUN_EXECUTOR}
# 定义 NDK 支持的所有编译平台
APP_ABI=(
    arm64-v8a
    armeabi
    armeabi-v7a
    mips
    mips64
    x86
    x86_64
)

# 解析命令参数
. ${OPTSSETUP}

# 填充编译选项
# 编译类型: debug / release
BUILD_TYPE=""
if [ ${opts_debug} == 1 ]; then
    BUILD_TYPE="${BUILD_TYPE} debug"
fi
if [ ${opts_release} == 1 ]; then
    BUILD_TYPE="${BUILD_TYPE} release"
fi
# 库类型: static / shared
LIBRARY_TYPE=""
if [ ${opts_static} == 1 ]; then
    LIBRARY_TYPE="${LIBRARY_TYPE} static"
fi
if [ ${opts_shared} == 1 ]; then
    LIBRARY_TYPE="${LIBRARY_TYPE} shared"
fi

# 执行编译
for build_tp in ${BUILD_TYPE[@]}
do
    # 执行清理
    ${_EXECNDK} clean
    if [ $? -ne 0 ]; then
        exit 1
    fi

    cd ${jni_dir}

    . ${BUILD_LIBRARY} ${build_tp} ${current_dir}
    if [ $? -ne 0 ]; then
        exit 1
    fi

    cd ${current_dir}
done

echo ""

exit 0

