/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleRowIdParameter;
import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

/**
 * Pruebas para la clase RowIdParameter
 *
 * @author Yadickson Soto
 */
public class OracleRowIdParameterTest {

    private OracleRowIdParameter parameter;

    @Before
    public void setup() {
        parameter = new OracleRowIdParameter(0, null, Direction.Input);
    }

    @Test(expected = Exception.class)
    public void testGetParameters() throws Exception {
        parameter.getParameters();
    }

    @Test(expected = Exception.class)
    public void testSetParameters() throws Exception {
        parameter.setParameters(null);
    }

    @Test
    public void testGetJavaTypeName() throws Exception {
        String javaType = parameter.getJavaTypeName();
        assertNotNull(javaType);
        assertEquals("oracle.sql.ROWID", javaType);
    }

    @Test
    public void testGetSqlType() throws Exception {
        int sqlType = parameter.getSqlType();
        assertEquals(java.sql.Types.OTHER, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws Exception {
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("java.sql.Types.OTHER", sqlType);
    }

    @Test
    public void testResultSetFalse() throws Exception {
        assertFalse(parameter.isResultSet());
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
