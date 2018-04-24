# SLF Logger

## 简介

通用日志门面(Simple Logging Facade)，类似于 SLF4J，没有具体的日志实现方案，可自定义或适配第三方开源方案。

## 应用场景

适用于 Linux C/C++、Android Native 使用，暂未适配 Windows。

# 编译

## For Linux

* 编译静态库

```
$ make
```

* 编译动态库

```
$ make shared=1
```

* 清理

```
$ make clean
```

## For Android

### Windows 下编译

安装 Android NDK 并配置好环境变量。双击 `build_android.bat` 执行编译，双击 `clean_android.bat` 执行清理。

默认编译 release 版本的静态库和动态库，编译完成后在当前路径下的 `libs-android` 文件夹下。

查看编译说明:

```
> build_android.bat -h
```

### Linux/Mac 下编译

安装 Android NDK 并配置好环境变量。执行 `build_android.sh` 编译，执行 `clean_android.sh` 清理。

默认编译 release 版本的静态库和动态库，编译完成后在当前路径下的 `libs-android` 文件夹下。

查看编译说明:

```sh
$ build_android.sh -h
```

# 文档

## API

### isLoggable

判断某一个日志级别是否有效: 当且仅当该日志级别大于等于设置的值时有效。

### setPriority

设置日志级别，默认为 `LOG_INFO` 级别。

### setLineEnabled

是否打印源文件、行号信息，默认关闭。

### addLoggerCallback

添加日志回调，在回调中自由实现日志的输出，比如输出到控制台、文件、串口等，或适配到第三方日志框架中。

备注: 支持添加多个回调接口。

### TAG

用于标识当前日志的源。

一般在各个 .c 或 .cpp 文件开头定义即可。

## 使用

### 示例

```c
#define TAG "Main"

#include <stdio.h>
#include "logger.h"

int callback(const char* tag, LOG_PRIORITY priority,
        const char* location, const char* message) {
    char* buffer = NULL;
    log_format_priority_with_time(tag, priority, location, message, &buffer);
    if (NULL == buffer) {
        return -1;
    }

    puts(buffer);
    return 0;
}


int main() {
    Logger.setPriority(LOG_DEBUG);
    Logger.setLineEnabled(1);
    Logger.addLoggerCallback(callback);

    LVERBOSE("verbose");
    LDEBUG("debug");
    LINFO("info");
    LINFO("info");
    LWARN("warn");
    LERROR("error");
    LFATAL("fatal");
    LSILENT("silent");

    LDEBUG("10 + 20 = %d", 10 + 20);

    return 0;
}
```

### 集成至现有代码

* 集成日志

比如现有代码中的日志如下:

```c
#define TRACE(msg, ...)                                            \
    do {                                                           \
        if (LIB_TRACE_LEVEL >= 1) {                                \
            printf(msg, ##__VA_ARGS__);                            \
        }                                                          \
    } while(0)
```

集成后如下:

```c
#define USE_SLF_LOGGER

#ifdef USE_SLF_LOGGER
#define TRACE(msg, ...) LDEBUG(msg, ##__VA_ARGS__)
#else
#define TRACE(msg, ...)                                            \
    do {                                                           \
        if (LIB_TRACE_LEVEL >= 1) {                                \
            printf(msg, ##__VA_ARGS__);                            \
        }                                                          \
    } while(0)
#endif
```

* 设置 TAG

可在编译现有代码时添加宏定义即可:

```
CFLAGS += -DTAG=\"MyLibName\"
```

## 应用至 Android

该部分已封装到 Android 应用层，详情参阅 [https://github.com/hibate/android-modules](https://github.com/hibate/android-modules) 中的 `commons-logger-nativelogger` 模块。

其中 `commons-logger-nativelogger` 模块可配合其中的 `commons-logger-logback` 模块将日志输出至 logback。
