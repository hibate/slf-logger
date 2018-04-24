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

# 解析参数

##############################################################
# 显示帮助
opts_help=0

# 编译 debug 版本: 默认禁用
opts_debug=0

# 编译 release 版本: 默认开启
opts_release=1

# 编译 static 库: 默认开启
opts_static=1

# 编译 shared 库: 默认开启
opts_shared=1
##############################################################

OPTS_ARGS="$@"
OLD_IFS="$IFS"
IFS=" "
OPTS_ARGS=(${OPTS_ARGS})
IFS="$OLD_IFS"

for opts_arg in ${OPTS_ARGS[@]}
do
    case ${opts_arg} in
        -h|-help)
            opts_help=1
            ;;
        -debug)
            opts_debug=1
            opts_release=0
            ;;
        -release)
            opts_debug=0
            opts_release=1
            ;;
        -all)
            opts_debug=1
            opts_release=1
            ;;
        -static)
            opts_static=1
            opts_shared=0
            ;;
        -shared)
            opts_static=0
            opts_shared=1
            ;;
        *)
            opts_help=1
            echo "Unknown options ${opts_arg}"
            echo ""
            ;;
    esac
done

options_show_help() {
    echo ""
    echo "Usage: make [options]"
    echo "Options:"
    echo "  -h, -help                 Print this message and exit."
    echo "  -debug                    Build debug library."
    echo "  -release                  Build shared library."
    echo "  -all                      Build debug and shared library."
    echo "  -static                   Build static library."
    echo "  -shared                   Build shared library."
    echo ""
    echo "The default options will build static and shared library on release version."
    echo ""
}

options_show_options() {
    echo ""
    echo "opts_help:    ${opts_help}"
    echo "opts_debug:   ${opts_debug}"
    echo "opts_release: ${opts_release}"
    echo "opts_static:  ${opts_static}"
    echo "opts_shared:  ${opts_shared}"
    echo ""
}

if [ ${opts_help} == 1 ]; then
    options_show_help
    exit 0
fi
