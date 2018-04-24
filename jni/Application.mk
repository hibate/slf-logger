
# Uncomment this if you're using STL in your project
# See CPLUSPLUS-SUPPORT.html in the NDK documentation for more information

###############################################
# 以下该参数在批处理中传递
# true / false
#BUILD_SHARED=false

# release / debug
#APP_OPTIM := debug
###############################################

APP_STL := stlport_static

# APP_ABI := arm64-v8a armeabi armeabi-v7a mips mips64 x86 x86_64
APP_ABI := all