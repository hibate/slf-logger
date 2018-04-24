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
 * logger.c
 *
 *  Created on: 2017年6月22日
 *      Author: Hibate
 */

#include "logger_adapter.h"

int int2Priority(int level, LOG_PRIORITY* priority) {
    if ((LOG_VERBOSE <= level) && (level < NUM_PRIORITY)) {
        *priority = level;
        return 0;
    }
    return -1;
}

Logger_t Logger = {
    .isLoggable        = isLoggableAdapter,
    .setPriority       = setPriorityAdapter,
    .setLineEnabled    = setLineEnabledAdapter,
    .addLoggerCallback = addLoggerCallbackAdapter
};
