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
 * logger_core.h
 *
 *  Created on: 2017年6月23日
 *      Author: Hibate
 */

#ifndef LOGGER_CORE_H_
#define LOGGER_CORE_H_

#include <stdio.h>
#include <pthread.h>
#include <list>

using namespace std;

class LoggerListener;

class LoggerListenerSubject {
private:
    list<LoggerListener*> listeners;
    pthread_rwlock_t lock;

public:
    LoggerListenerSubject();
    ~LoggerListenerSubject();

    int addLoggerListener(LoggerListener* listener);

    void notifyListeners(const char* tag, LOG_PRIORITY priority,
            const char* location, const char* message);
};


#endif /* LOGGER_CORE_H_ */
