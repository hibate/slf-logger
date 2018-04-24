LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

SRC_PATH = ../../src

SRC = \
    $(SRC_PATH)/hb_times.cpp \
    $(SRC_PATH)/logger_formatter.cpp \
    $(SRC_PATH)/logger_configurator.cpp \
    $(SRC_PATH)/logger_adapter.cpp \
    $(SRC_PATH)/logger_core.cpp \
    $(SRC_PATH)/logger.c

INCLUDES = \
    $(SRC_PATH)

EXPORT_INCLUDES = $(INCLUDES)

STATIC_LIBRARIES =

SHARED_LIBRARIES =

LOCAL_MODULE    := libslflogger
LOCAL_SRC_FILES := $(SRC)
LOCAL_C_INCLUDES := $(INCLUDES)
LOCAL_EXPORT_C_INCLUDES := $(EXPORT_INCLUDES)
LOCAL_STATIC_LIBRARIES := $(STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES := $(SHARED_LIBRARIES)

ifeq ($(APP_OPTIM), debug)
LOCAL_CFLAGS += -DDEBUG
endif

ifeq ($(BUILD_SHARED), true)
include $(BUILD_SHARED_LIBRARY)
else
include $(BUILD_STATIC_LIBRARY)
endif