/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugins.generator.logger;

import org.apache.maven.plugin.logging.Log;
import org.junit.Test;
import org.junit.Before;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

/**
 * Logger application test
 *
 * @author Yadickson Soto
 */
public class LoggerManagerTest {

    @Mock
    Log log;

    public LoggerManagerTest() {
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void testConfigurationNull() {
        LoggerManager.getInstance().Configure(null);
        LoggerManager.getInstance().info("");
    }

    @Test
    public void testConfigurationSuccess() {
        Mockito.doNothing().when(log).info(Mockito.anyString());
        LoggerManager.getInstance().Configure(log);
        LoggerManager.getInstance().info("");
    }
}
