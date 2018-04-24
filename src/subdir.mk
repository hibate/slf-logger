LOCAL_PATH=./src

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
    $(LOCAL_PATH)/hb_times.cpp \
    $(LOCAL_PATH)/logger_adapter.cpp \
    $(LOCAL_PATH)/logger_configurator.cpp \
    $(LOCAL_PATH)/logger_core.cpp \
    $(LOCAL_PATH)/logger_formatter.cpp 

C_SRCS += \
    $(LOCAL_PATH)/logger.c 

OBJS += \
    $(LOCAL_PATH)/hb_times.o \
    $(LOCAL_PATH)/logger.o \
    $(LOCAL_PATH)/logger_adapter.o \
    $(LOCAL_PATH)/logger_configurator.o \
    $(LOCAL_PATH)/logger_core.o \
    $(LOCAL_PATH)/logger_formatter.o 

CPP_DEPS += \
    $(LOCAL_PATH)/hb_times.d \
    $(LOCAL_PATH)/logger_adapter.d \
    $(LOCAL_PATH)/logger_configurator.d \
    $(LOCAL_PATH)/logger_core.d \
    $(LOCAL_PATH)/logger_formatter.d 

C_DEPS += \
    $(LOCAL_PATH)/logger.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O3 $(CXXFLAGS) -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O3 $(CFLAGS) -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


