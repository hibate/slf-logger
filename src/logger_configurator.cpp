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

#include "logger_configurator.h"

extern int _addLoggerListenerInternal(LoggerListener* listener);

/**
 * LoggerListener
 */

LoggerListener::LoggerListener() {
}

LoggerListener::~LoggerListener() {
}

int LoggerListener::onLogging(const char* tag,
        LOG_PRIORITY priority, const char* location, const char* message) {
    return 0;
}

/**
 * LoggerConfigurator
 */

LoggerConfigurator* LoggerConfigurator::configurator = new LoggerConfigurator();

/**
 * 使用饿汉模式实现线程安全的单例
 * @return 返回单例对象
 */
LoggerConfigurator* LoggerConfigurator::getInstance() {
    return configurator;
}

LoggerConfigurator::LoggerConfigurator() {
    this->level = LOG_INFO;
    this->lineEnabled = false;
    this->subject = new LoggerListenerSubject();

    pthread_rwlock_init(&this->level_lock, NULL);
    pthread_rwlock_init(&this->line_enable_lock, NULL);
}

LoggerConfigurator::~LoggerConfigurator() {
    if (NULL != this->subject) {
        delete this->subject;
    }
    pthread_rwlock_destroy(&this->level_lock);
    pthread_rwlock_destroy(&this->line_enable_lock);
    this->subject = NULL;
}

LoggerListenerSubject* LoggerConfigurator::getLoggerListenerSubject() {
    return this->subject;
}

int LoggerConfigurator::isLoggable(LOG_PRIORITY priority, int *loggable) {
    if (NUM_PRIORITY != priority) {
        pthread_rwlock_rdlock(&this->level_lock);
        *loggable = (this->level <= priority) ? 1 : 0;
        pthread_rwlock_unlock(&this->level_lock);
    } else {
        *loggable = 0;
    }
    return 0;
}

int LoggerConfigurator::setPriority(LOG_PRIORITY priority) {
    if (NUM_PRIORITY != priority) {
        pthread_rwlock_wrlock(&this->level_lock);
        this->level = priority;
        pthread_rwlock_unlock(&this->level_lock);
    }
    return 0;
}

int LoggerConfigurator::isLineEnabled(int *enabled) {
    pthread_rwlock_rdlock(&this->line_enable_lock);
    *enabled = this->lineEnabled ? 1 : 0;
    pthread_rwlock_unlock(&this->line_enable_lock);

    return 0;
}

int LoggerConfigurator::setLineEnabled(int enabled) {
    pthread_rwlock_wrlock(&this->line_enable_lock);
    this->lineEnabled = (enabled == 0) ? false : true;
    pthread_rwlock_unlock(&this->line_enable_lock);

    return 0;
}

int LoggerConfigurator::addLoggerListener(LoggerListener *listener) {
    return _addLoggerListenerInternal(listener);
}
