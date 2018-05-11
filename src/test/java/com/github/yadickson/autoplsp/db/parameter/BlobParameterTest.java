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
package com.github.yadickson.autoplsp.db.parameter;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;
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
        parameter = new BlobParameter(0, null, Direction.INPUT, new Procedure("", ""));
    }

    @Test(expected = Exception.class)
    public void testGetParameters() throws BusinessException {
        parameter.getParameters();
    }

    @Test(expected = Exception.class)
    public void testSetParameters() throws BusinessException {
        parameter.setParameters(null);
    }

    @Test
    public void testGetJavaTypeName() throws BusinessException {
        String javaType = parameter.getJavaTypeName();
        assertNotNull(javaType);
        assertEquals("java.sql.Blob", javaType);
    }

    @Test
    public void testGetSqlType() throws BusinessException {
        int sqlType = parameter.getSqlType();
        assertEquals(java.sql.Types.BLOB, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws BusinessException {
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("java.sql.Types.BLOB", sqlType);
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
