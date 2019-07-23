/*
 * Copyright (C) 2019 Yadickson Soto
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.github.yadickson.autoplsp.logger;

import org.apache.maven.plugin.logging.Log;

/**
 * Logger application class
 *
 * @author Yadickson Soto
 */
public class LoggerManager {

    private static final LoggerManager INSTANCE = new LoggerManager();
    private Log log;

    /**
     * Getter the instance of the class
     *
     * @return the instance
     */
    public static LoggerManager getInstance() {
        return INSTANCE;
    }

    /**
     * Setter the main logger
     *
     * @param log the logger
     */
    public void configure(Log log) {
        this.log = log;
    }

    /**
     * Logger the info message
     *
     * @param message the message
     */
    public void info(String message) {
        if (log != null) {
            log.info(message);
        }
    }

    /**
     * Logger the warn message
     *
     * @param message the message
     */
    public void warn(String message) {
        if (log != null) {
            log.warn(message);
        }
    }

    /**
     * Logger the error message
     *
     * @param ex the exception
     */
    public void error(Throwable ex) {
        if (log != null) {
            log.error(ex);
        }
    }
}
