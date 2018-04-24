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

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <sys/time.h>
#include "hb_times.h"
#include "logger_configurator.h"

#define TIME_FORMAT_LENGTH 24

#ifdef __cplusplus
extern "C"
{
#endif

int priority2Str(LOG_PRIORITY priority, char** buffer) {
    static const char* mapping[NUM_PRIORITY] = {
            "VERBOSE",
            "DEBUG",
            "INFO",
            "WARN",
            "ERROR",
            "FATAL",
            "SILENT",
            "UNKNOWN",
    };
    *buffer = (char*) mapping[priority - 1];
    return 0;
}

int current_gmttime_str(char* time_buffer, int time_format_len) {
    struct timeval tv;
    gettimeofday(&tv, NULL);

    time_t sec = tv.tv_sec;
    __suseconds_t msec = tv.tv_usec / 1000;

    struct tm gmt, *local;
    hb_gmtime(sec, &gmt);
    local = localtime(&sec);

    snprintf(time_buffer, time_format_len,
            "%4d-%02d-%02d %02d:%02d:%02d.%03d",
            gmt.tm_year, gmt.tm_mon, gmt.tm_mday,
            local->tm_hour, local->tm_min, local->tm_sec, (int) msec);
    return 0;
}

int log_format(const char* tag, const char* location,
        const char* message, char** buffer) {
    char value[LOGGER_BUFFER_MAX_LENGTH];
    if (NULL != location) {
        snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "[%.23s] [%.256s] %s",
                tag, (location) ? location : "", (message) ? message : "");
    } else {
        snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "[%.23s] %s", tag, (message) ? message : "");
    }
    *buffer = value;
    return 0;
}

int log_format_with_time(const char* tag, const char* location,
        const char* message, char** buffer) {
    char time_buffer[TIME_FORMAT_LENGTH];
    current_gmttime_str(time_buffer, TIME_FORMAT_LENGTH);

    char value[LOGGER_BUFFER_MAX_LENGTH];
    if (NULL != location) {
        snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "%.30s [%.23s] [%.256s] %s",
                (const char*) time_buffer, tag,
                (location) ? location : "",
                (message) ? message : "");
    } else {
        snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "%.30s [%.23s] %s",
                (const char*) time_buffer,
                tag, (message) ? message : "");
    }
    *buffer = value;
    return 0;
}

int log_format_priority(const char* tag, LOG_PRIORITY priority,
        const char* location, const char* message, char** buffer) {
   char* priorityStr;
   priority2Str(priority, &priorityStr);

   char value[LOGGER_BUFFER_MAX_LENGTH];
   if (NULL != location) {
       snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "[%.10s] [%.23s] [%.256s] %s",
               (const char*) priorityStr, tag,
               (location) ? location : "", (message) ? message : "");
   } else {
       snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "[%.10s] [%.23s] %s",
               (const char*) priorityStr, tag, (message) ? message : "");
   }
   *buffer = value;
   return 0;
}

int log_format_priority_with_time(const char* tag, LOG_PRIORITY priority,
        const char* location, const char* message, char** buffer) {
    char time_buffer[TIME_FORMAT_LENGTH];
    current_gmttime_str(time_buffer, TIME_FORMAT_LENGTH);

    char* priorityStr;
    priority2Str(priority, &priorityStr);

    char value[LOGGER_BUFFER_MAX_LENGTH];
    if (NULL != location) {
        snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "%.30s [%.10s] [%.23s] [%.256s] %s",
               (const char*) time_buffer,
               (const char*) priorityStr, tag,
               (location) ? location : "",
               (message) ? message : "");
    } else {
        snprintf(value, LOGGER_BUFFER_MAX_LENGTH, "%.30s [%.10s] [%.23s] %s",
               (const char*) time_buffer,
               (const char*) priorityStr, tag,
               (message) ? message : "");
    }
    *buffer = value;
    return 0;
}

#ifdef __cplusplus
}
#endif
