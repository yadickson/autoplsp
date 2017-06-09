/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleDataSetParameter;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import java.util.ArrayList;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

/**
 * Pruebas para la clase RowIdParameter
 *
 * @author Yadickson Soto
 */
public class OracleDataSetParameterTest {

    private OracleDataSetParameter parameter;

    @Before
    public void setup() {
        parameter = new OracleDataSetParameter(0, null);
        parameter.setParameters(new ArrayList<Parameter>());
    }

    @Test
    public void testGetParameters() throws Exception {
        assertNotNull(parameter.getParameters());
    }

    @Test(expected = Exception.class)
    public void testGetJavaTypeName() throws Exception {
        parameter.getJavaTypeName();
    }

    @Test
    public void testGetSqlType() throws Exception {
        int sqlType = parameter.getSqlType();
        assertEquals(oracle.jdbc.OracleTypes.CURSOR, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws Exception {
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("oracle.jdbc.OracleTypes.CURSOR", sqlType);
    }

    @Test
    public void testResultSetTrue() throws Exception {
        assertTrue(parameter.isResultSet());
    }

    @Test
    public void testObjectFalse() throws Exception {
        assertFalse(parameter.isObject());
    }

    @Test
    public void tesArrayFalse() throws Exception {
        assertFalse(parameter.isArray());
    }
}
