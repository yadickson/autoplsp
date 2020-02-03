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
package com.github.yadickson.autoplsp.db.support.oracle.parameter;

import com.github.yadickson.autoplsp.db.support.oracle.OracleRowIdParameter;
import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;
import org.junit.Assert;
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
        parameter = new OracleRowIdParameter(0, null, Direction.INPUT, "", new Procedure(true, "", "", "", ""), "", "");
    }

    @Test
    public void testGetParameters() throws BusinessException {
        Assert.assertNotNull(parameter.getParameters());
    }

    @Test(expected = Exception.class)
    public void testSetParameters() throws BusinessException {
        parameter.setParameters(null);
    }

    @Test
    public void testGetJavaTypeName() throws BusinessException {
        String javaType = parameter.getJavaTypeName();
        assertNotNull(javaType);
        assertEquals("oracle.sql.ROWID", javaType);
    }

    @Test
    public void testGetSqlType() throws BusinessException {
        int sqlType = parameter.getSqlType();
        assertEquals(java.sql.Types.OTHER, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws BusinessException {
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("java.sql.Types.OTHER", sqlType);
    }

    @Test
    public void testResultSetFalse() throws BusinessException {
        assertFalse(parameter.isResultSet());
    }

    @Test
    public void testObjectFalse() throws BusinessException {
        assertFalse(parameter.isObject());
    }

    @Test
    public void tesArrayFalse() throws BusinessException {
        assertFalse(parameter.isArray());
    }
}
