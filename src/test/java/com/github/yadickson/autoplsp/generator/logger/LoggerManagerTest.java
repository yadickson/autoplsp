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
package com.github.yadickson.autoplsp.generator.logger;

import com.github.yadickson.autoplsp.logger.LoggerManager;
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
        LoggerManager.getInstance().configure(null);
        LoggerManager.getInstance().info("");
    }

    @Test
    public void testConfigurationSuccess() {
        Mockito.doNothing().when(log).info(Mockito.anyString());
        LoggerManager.getInstance().configure(log);
        LoggerManager.getInstance().info("");
    }
}
