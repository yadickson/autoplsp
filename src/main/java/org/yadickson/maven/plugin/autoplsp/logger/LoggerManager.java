/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.logger;

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
     *
     * @return
     */
    public static LoggerManager getInstance() {
        return INSTANCE;
    }

    /**
     *
     * @param log
     */
    public void Configure(Log log) {
        this.log = log;
    }

    /**
     *
     * @param message
     */
    public void info(String message) {
        if (log != null) {
            log.info(message);
        }
    }
}
