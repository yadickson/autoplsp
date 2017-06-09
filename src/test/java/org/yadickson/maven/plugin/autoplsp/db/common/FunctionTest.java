/*
 * Copyright (C) 2017 Yadickson Soto
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
package org.yadickson.maven.plugin.autoplsp.db.common;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Class Function test
 *
 * @author Yadickson Soto
 */
public class FunctionTest {

    public FunctionTest() {
    }

    @Test
    public void testFunctionTrue() {

        Function function = new Function("packageName", "functionName");

        assertNotNull(function.getPackageName());
        assertNotNull(function.getName());
        assertEquals("packageName", function.getPackageName());
        assertEquals("functionName", function.getName());
        assertTrue(function.isFunction());
    }
}
