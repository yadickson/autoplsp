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
package org.yadickson.maven.plugin.autoplsp.db.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

/**
 * Pruebas para la clase CharParameter
 *
 * @author Yadickson Soto
 */
public class CharParameterTest {

    private CharParameter parameter;

    @Before
    public void setup() {
        parameter = new CharParameter(0, null, Direction.Input);
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
        assertEquals("String", javaType);
    }

    @Test
    public void testGetSqlType() throws Exception {
        int sqlType = parameter.getSqlType();
        assertEquals(java.sql.Types.VARCHAR, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws Exception {
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("java.sql.Types.VARCHAR", sqlType);
    }

    @Test
    public void tesNumberFalse() throws Exception {
        assertFalse(parameter.isNumber());
    }

    @Test
    public void tesStringTrue() throws Exception {
        assertTrue(parameter.isString());
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
