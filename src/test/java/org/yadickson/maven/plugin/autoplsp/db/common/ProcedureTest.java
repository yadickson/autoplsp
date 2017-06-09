/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.db.common;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Class Procedure test
 *
 * @author Yadickson Soto
 */
public class ProcedureTest {

    public ProcedureTest() {
    }

    @Test
    public void testFunctionTrue() {

        Procedure procedure = new Procedure("packageName", "procedureName");

        assertNotNull(procedure.getPackageName());
        assertNotNull(procedure.getName());
        assertEquals("packageName", procedure.getPackageName());
        assertEquals("procedureName", procedure.getName());
        assertFalse(procedure.isFunction());
    }
}
