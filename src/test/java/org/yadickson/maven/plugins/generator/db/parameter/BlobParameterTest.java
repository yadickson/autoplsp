/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugins.generator.db.parameter;

import org.yadickson.maven.plugins.generator.db.parameter.BlobParameter;
import org.yadickson.maven.plugins.generator.db.common.Direction;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

/**
 * Pruebas para la clase BlobParameter
 *
 * @author Yadickson Soto
 */
public class BlobParameterTest {

    private BlobParameter parameter;

    @Before
    public void setup() {
        parameter = new BlobParameter(0, null, Direction.Input);
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
        assertEquals("java.sql.Blob", javaType);
    }

    @Test
    public void testGetSqlType() throws Exception {
        int sqlType = parameter.getSqlType();
        assertEquals(java.sql.Types.BLOB, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws Exception {
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("java.sql.Types.BLOB", sqlType);
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
