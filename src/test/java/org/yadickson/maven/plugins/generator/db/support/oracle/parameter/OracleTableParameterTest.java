/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugins.generator.db.support.oracle.parameter;

import org.yadickson.maven.plugins.generator.db.common.Direction;
import org.yadickson.maven.plugins.generator.db.common.Parameter;
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
