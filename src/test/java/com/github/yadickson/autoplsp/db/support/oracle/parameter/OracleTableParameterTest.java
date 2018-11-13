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
package com.github.yadickson.autoplsp.db.support.oracle.parameter;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

/**
 * Clase de prueba para
 *
 * @author Yadickson Soto
 */
public class OracleTableParameterTest {

    @Mock
    Connection connection;

    @Mock
    PreparedStatement statement;

    @Mock
    ResultSet resultSet;

    public OracleTableParameterTest() {
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
    }
/*
    @Test(expected = Exception.class)
    public void testExecuteStatementFail() throws Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(false);

        new OracleTableParameter(1, "tableObject", Direction.Input, connection, "typeObject");
    }

    @Test
    public void testResultSetEmpty() throws BusinessException, Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(true);
        Mockito.when(statement.getResultSet()).thenReturn(resultSet);
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.doNothing().when(statement).close();
        Mockito.when(resultSet.next()).thenReturn(false);
        Mockito.doNothing().when(resultSet).close();

        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, connection, "typeObject");
        List<Parameter> list = parameter.getParameters();

        assertNotNull(list);
        assertTrue(list.isEmpty());
    }

    @Test
    public void testResultSetOneValue() throws BusinessException, Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(true);
        Mockito.when(statement.getResultSet()).thenReturn(resultSet);
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.doNothing().when(statement).close();
        Mockito.when(resultSet.next()).thenReturn(true).thenReturn(false);

        Mockito.when(resultSet.getString("NAME")).thenReturn("object");
        Mockito.when(resultSet.getString("TYPE")).thenReturn("object");

        Mockito.doNothing().when(resultSet).close();

        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, connection, "typeObject");
        List<Parameter> list = parameter.getParameters();

        assertNotNull(list);
        assertEquals(1, list.size());
    }

    @Test(expected = Exception.class)
    public void testResultSetError() throws BusinessException, Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(true);
        Mockito.when(statement.getResultSet()).thenReturn(resultSet);
        Mockito.when(statement.executeQuery()).thenReturn(resultSet);
        Mockito.doNothing().when(statement).close();
        Mockito.when(resultSet.next()).thenThrow(new RuntimeException());
        Mockito.doNothing().when(resultSet).close();

        new OracleTableParameter(1, "tableObject", Direction.Input, connection, "typeObject");
    }
*/
    @Test
    public void testGetJavaTypeName() throws BusinessException {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.INPUT, new Procedure("", ""), null, "type_value", "", "TableSuffix");
        String javaType = parameter.getJavaTypeName();
        assertNotNull(javaType);
        assertEquals("TypeValueTableSuffix", javaType);
    }

    @Test
    public void testGetSqlType() throws BusinessException {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.INPUT, new Procedure("", ""), null, "type_value", "", "");
        int sqlType = parameter.getSqlType();
        assertEquals(java.sql.Types.ARRAY, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws BusinessException {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.INPUT, new Procedure("", ""), null, "type_value", "", "");
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("oracle.jdbc.OracleTypes.ARRAY", sqlType);
    }

    @Test
    public void testResultSetFalse() throws BusinessException {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.INPUT, new Procedure("", ""), null, "type_value", "", "");
        assertFalse(parameter.isResultSet());
    }

    @Test
    public void testObjectFalse() throws BusinessException {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.INPUT, new Procedure("", ""), null, "type_value", "", "");
        assertFalse(parameter.isObject());
    }

    @Test
    public void tesArrayTrue() throws BusinessException {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.INPUT, new Procedure("", ""), null, "type_value", "", "");
        assertTrue(parameter.isArray());
    }

}
