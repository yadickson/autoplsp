/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter;

import org.yadickson.maven.plugin.autoplsp.db.support.oracle.parameter.OracleObjectParameter;
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
public class OracleObjectParameterTest {

    @Mock
    Connection connection;

    @Mock
    PreparedStatement statement;

    @Mock
    ResultSet resultSet;

    public OracleObjectParameterTest() {
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

        new OracleObjectParameter(1, "nameObject", Direction.Input, connection, "typeObject");
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

        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, connection, "typeObject");
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
        
        Mockito.when(resultSet.getString("ATTR_TYPE_NAME")).thenReturn("number");
        Mockito.when(resultSet.getInt("ATTR_NO")).thenReturn(1);
        Mockito.when(resultSet.getString("ATTR_NAME")).thenReturn("parameter");
        
        Mockito.doNothing().when(resultSet).close();

        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, connection, "typeObject");
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

        new OracleObjectParameter(1, "nameObject", Direction.Input, connection, "typeObject");
    }

    @Test
    public void testGetJavaTypeName() throws Exception {
        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, null, "type_value");
        String javaType = parameter.getJavaTypeName();
        assertNotNull(javaType);
        assertEquals("TypeValueObject", javaType);
    }

    @Test
    public void testGetSqlType() throws Exception {
        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, null, "type_value");
        int sqlType = parameter.getSqlType();
        assertEquals(oracle.jdbc.OracleTypes.STRUCT, sqlType);
    }

    @Test
    public void testGetSqlTypeName() throws Exception {
        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, null, "type_value");
        String sqlType = parameter.getSqlTypeName();
        assertNotNull(sqlType);
        assertEquals("oracle.jdbc.OracleTypes.STRUCT", sqlType);
    }

    @Test
    public void testResultSetFalse() throws Exception {
        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, null, "type_value");
        assertFalse(parameter.isResultSet());
    }

    @Test
    public void testObjectTrue() throws Exception {
        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, null, "type_value");
        assertTrue(parameter.isObject());
    }

    @Test
    public void tesArrayFalse() throws Exception {
        OracleObjectParameter parameter = new OracleObjectParameter(1, "nameObject", Direction.Input, null, "type_value");
        assertFalse(parameter.isArray());
    }

}
