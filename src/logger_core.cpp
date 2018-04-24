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
 * logger.cpp
 *
 *  Created on: 2017年6月19日
 *      Author: Hibate
 */

#include <stdio.h>
#include <stdarg.h>
#include "logger.h"
#include "logger_core.h"
#include "logger_configurator.h"

void log_appender_internal(const char* tag,
        LOG_PRIORITY priority, const char* location,
        const char* __format, ...);
void (*log_appender)(const char* tag,
        LOG_PRIORITY priority, const char* location,
        const char* __format, ...) = log_appender_internal;

LoggerListenerSubject::LoggerListenerSubject() {
    pthread_rwlock_init(&this->lock, NULL);
}

LoggerListenerSubject::~LoggerListenerSubject() {
    pthread_rwlock_wrlock(&this->lock);
    list<LoggerListener*>::iterator it;
    for (it = this->listeners.begin(); it != this->listeners.end();) {
        LoggerListener* listener = *it;
        if (NULL != listener) {
            delete listener;
            listener = NULL;
        }
        it = this->listeners.erase(it);
    }
    pthread_rwlock_unlock(&this->lock);
    pthread_rwlock_destroy(&this->lock);
}

int LoggerListenerSubject::addLoggerListener(LoggerListener *listener) {
    if (NULL != listener) {
        pthread_rwlock_wrlock(&this->lock);
        this->listeners.push_back(listener);
        pthread_rwlock_unlock(&this->lock);
    }
    return 0;
}

void LoggerListenerSubject::notifyListeners(const char* tag,
        LOG_PRIORITY priority, const char* location, const char* message) {
    pthread_rwlock_rdlock(&this->lock);
    list<LoggerListener*>::iterator it;
    for (it = this->listeners.begin(); it != this->listeners.end(); it++) {
        LoggerListener* listener = *it;
        if (!listener) {
            continue;
        }
        listener->onLogging(tag, priority, location, message);
    }
    pthread_rwlock_unlock(&this->lock);
}

void log_appender_internal(const char* tag,
        LOG_PRIORITY priority, const char* location,
        const char* __format, ...) {
    int loggable = 0;
    LoggerConfigurator* configurator = LoggerConfigurator::getInstance();
    configurator->isLoggable(priority, &loggable);
    if (0 == loggable) {
        return;
    }

    int lineEnable = 0;
    configurator->isLineEnabled(&lineEnable);

    char buf[LOGGER_BUFFER_MAX_LENGTH];
    va_list args;
    va_start(args, __format);
    vsnprintf(buf, LOGGER_BUFFER_MAX_LENGTH, __format, args);
    va_end(args);

    LoggerListenerSubject* subject = configurator->getLoggerListenerSubject();
    if (NULL != subject) {
        subject->notifyListeners((NULL == tag) ? "" : tag, priority,
                lineEnable ? location : NULL, buf);
    }
}

int _addLoggerListenerInternal(LoggerListener* listener) {
    LoggerConfigurator* configurator = LoggerConfigurator::getInstance();
    LoggerListenerSubject* subject = configurator->getLoggerListenerSubject();
    if (NULL != subject) {
        return subject->addLoggerListener(listener);
    }
    return -1;
}
