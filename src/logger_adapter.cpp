/*
 * Copyright (C) 2017 Hibate <ycaia86@126.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * logger_adapter.cpp
 *
 *  Created on: 2017年6月22日
 *      Author: Hibate
 */

#include "logger_configurator.h"

class LoggerListenerAdapter : public LoggerListener {
private:
    int (*Callback)(const char* tag, LOG_PRIORITY priority,
            const char* location, const char* message);
public:
    LoggerListenerAdapter(LoggerCallback callback);
    ~LoggerListenerAdapter();

    int onLogging(const char* tag, LOG_PRIORITY priority,
            const char* location, const char* message);
};

LoggerListenerAdapter::LoggerListenerAdapter(LoggerCallback callback) {
    this->Callback = callback;
}

LoggerListenerAdapter::~LoggerListenerAdapter() {
}

int LoggerListenerAdapter::onLogging(const char* tag,
        LOG_PRIORITY priority, const char *location, const char *message) {
    if (NULL != this->Callback) {
        return this->Callback(tag, priority, location, message);
    }
    return -1;
}

#ifdef __cplusplus
extern "C"
{
#endif

int isLoggableAdapter(LOG_PRIORITY priority, int* loggable) {
    return LoggerConfigurator::getInstance()->isLoggable(priority, loggable);
}

int setPriorityAdapter(LOG_PRIORITY priority) {
    return LoggerConfigurator::getInstance()->setPriority(priority);
}

int setLineEnabledAdapter(int iEnable) {
    return LoggerConfigurator::getInstance()->setLineEnabled(iEnable);
}

int addLoggerCallbackAdapter(LoggerCallback callback) {
    if (NULL != callback) {
        LoggerConfigurator* configurator = LoggerConfigurator::getInstance();
        return configurator->addLoggerListener(new LoggerListenerAdapter(callback));
    }
    return 0;
}

#ifdef __cplusplus
}
#endif
