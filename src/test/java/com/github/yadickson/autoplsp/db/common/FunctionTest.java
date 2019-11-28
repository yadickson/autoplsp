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
package com.github.yadickson.autoplsp.db.common;

import static org.junit.Assert.*;
import org.junit.Test;

/**
 * Class Function test
 *
 * @author Yadickson Soto
 */
public class FunctionTest {

    public FunctionTest() {
    }

    @Test
    public void testFunctionAddPackageName() {

        Function function = new Function(true, "packageName", "functionName", "code", "message", true);

        assertNotNull(function.getPackageName());
        assertNotNull(function.getName());
        assertEquals("packageName", function.getPackageName());
        assertEquals("functionName", function.getName());
        assertTrue(function.isFunction());
        assertEquals("packageName.functionName", function.getFullName());
        assertEquals("PackageNameFunctionName", function.getClassName());
    }

    @Test
    public void testFunctionDisableAddPackageName() {

        Function function = new Function(false, "packageName", "functionName", "code", "message", true);

        assertNotNull(function.getPackageName());
        assertNotNull(function.getName());
        assertEquals("packageName", function.getPackageName());
        assertEquals("functionName", function.getName());
        assertTrue(function.isFunction());
        assertEquals("packageName.functionName", function.getFullName());
        assertEquals("FunctionName", function.getClassName());
    }

    @Test
    public void testFunctionWithoutPackageName() {

        Function function = new Function(false, null, "functionName", "code", "message", true);

        assertNull(function.getPackageName());
        assertNotNull(function.getName());
        assertNull(function.getPackageName());
        assertEquals("functionName", function.getName());
        assertTrue(function.isFunction());
        assertEquals("functionName", function.getFullName());
        assertEquals("FunctionName", function.getClassName());
    }

    @Test
    public void testFunctionForceAddWithoutPackageName() {

        Function function = new Function(true, null, "functionName", "code", "message", true);

        assertNull(function.getPackageName());
        assertNotNull(function.getName());
        assertNull(function.getPackageName());
        assertEquals("functionName", function.getName());
        assertTrue(function.isFunction());
        assertEquals("functionName", function.getFullName());
        assertEquals("FunctionName", function.getClassName());
    }
}
