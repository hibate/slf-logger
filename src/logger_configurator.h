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

//
// Created by Hibate on 2017/6/22.
//

#ifndef LOGGER_CONFIGURATOR_H
#define LOGGER_CONFIGURATOR_H

#include <stdio.h>
#include <pthread.h>
#include "logger.h"
#include "logger_core.h"

class LoggerListener {
public:
    LoggerListener();
    virtual ~LoggerListener();
    virtual int onLogging(const char* tag, LOG_PRIORITY priority,
            const char* location, const char* message);
};

class LoggerConfigurator {
private:
    static LoggerConfigurator* configurator;
    pthread_rwlock_t level_lock;
    pthread_rwlock_t line_enable_lock;

    LOG_PRIORITY level;
    bool        lineEnabled;

    LoggerListenerSubject* subject;

protected:
    LoggerConfigurator();
    ~LoggerConfigurator();

public:
    static LoggerConfigurator* getInstance();
    LoggerListenerSubject* getLoggerListenerSubject();

    int isLoggable(LOG_PRIORITY priority, int* loggable);
    int setPriority(LOG_PRIORITY priority);
    int isLineEnabled(int* enabled);
    int setLineEnabled(int enabled);
    int addLoggerListener(LoggerListener* listener);
};

#endif //LOGGER_CONFIGURATOR_H
