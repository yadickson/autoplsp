/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
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
