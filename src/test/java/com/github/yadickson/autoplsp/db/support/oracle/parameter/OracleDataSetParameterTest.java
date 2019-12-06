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

import com.github.yadickson.autoplsp.db.support.oracle.OracleDataSetParameter;
import com.github.yadickson.autoplsp.db.ConstantTypes;
import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;
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
        parameter = new OracleDataSetParameter(0, null, "", new Procedure(true, "", "", "", ""), "");
        parameter.setParameters(new ArrayList<Parameter>());
    }

    @Test
    public void testGetParameters() throws BusinessException {
        assertNotNull(parameter.getParameters());
    }

    @Test
    public void testGetJavaTypeName() throws BusinessException {
        assertNotNull(parameter.getJavaTypeName());
    }

    @Test
    public void testGetSqlType() throws BusinessException {
        int sqlType = parameter.getSqlType();
        assertEquals(ConstantTypes.ORACLE_CURSOR, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws BusinessException {
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("oracle.jdbc.OracleTypes.CURSOR", sqlType);
    }

    @Test
    public void testResultSetTrue() throws BusinessException {
        assertTrue(parameter.isResultSet());
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
