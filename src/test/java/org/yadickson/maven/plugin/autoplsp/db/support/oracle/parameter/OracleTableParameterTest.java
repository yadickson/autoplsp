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
package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.common.Direction;
import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import org.mockito.Mock;
import org.mockito.Mockito;
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

    @Test(expected = Exception.class)
    public void testExecuteStatementFail() throws Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(false);

        new OracleTableParameter(1, "tableObject", Direction.Input, connection, "typeObject");
    }

    @Test
    public void testResultSetEmpty() throws Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(true);
        Mockito.when(statement.getResultSet()).thenReturn(resultSet);
        Mockito.doNothing().when(statement).close();
        Mockito.when(resultSet.next()).thenReturn(false);
        Mockito.doNothing().when(resultSet).close();

        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, connection, "typeObject");
        List<Parameter> list = parameter.getParameters();

        assertNotNull(list);
        assertTrue(list.isEmpty());
    }

    @Test
    public void testResultSetOneValue() throws Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(true);
        Mockito.when(statement.getResultSet()).thenReturn(resultSet);
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
    public void testResultSetError() throws Exception {
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(statement);
        Mockito.doNothing().when(statement).setString(Mockito.anyInt(), Mockito.anyString());
        Mockito.when(statement.execute()).thenReturn(true);
        Mockito.when(statement.getResultSet()).thenReturn(resultSet);
        Mockito.doNothing().when(statement).close();
        Mockito.when(resultSet.next()).thenThrow(new RuntimeException());
        Mockito.doNothing().when(resultSet).close();

        new OracleTableParameter(1, "tableObject", Direction.Input, connection, "typeObject");
    }

    @Test
    public void testGetJavaTypeName() throws Exception {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, null, "type_value");
        String javaType = parameter.getJavaTypeName();
        assertNotNull(javaType);
        assertEquals("TypeValueTable", javaType);
    }

    @Test
    public void testGetSqlType() throws Exception {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, null, "type_value");
        int sqlType = parameter.getSqlType();
        assertEquals(oracle.jdbc.OracleTypes.ARRAY, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws Exception {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, null, "type_value");
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("oracle.jdbc.OracleTypes.ARRAY", sqlType);
    }

    @Test
    public void testResultSetFalse() throws Exception {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, null, "type_value");
        assertFalse(parameter.isResultSet());
    }

    @Test
    public void testObjectFalse() throws Exception {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, null, "type_value");
        assertFalse(parameter.isObject());
    }

    @Test
    public void tesArrayTrue() throws Exception {
        OracleTableParameter parameter = new OracleTableParameter(1, "tableObject", Direction.Input, null, "type_value");
        assertTrue(parameter.isArray());
    }

}
