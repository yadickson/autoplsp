package ${javaPackage}.util;

import java.sql.Connection;
import java.sql.SQLException;
<#if driverName == 'oracle'>

import oracle.jdbc.OracleConnection;
<#if driverVersionName == 'ojdbc6' >
import oracle.sql.ARRAY;
<#else>
import java.sql.Array;
</#if>
</#if>

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class ArrayUtilTest {

    @InjectMocks
    ArrayUtilImpl arrayUtil;
<#if driverName == 'oracle'>

    @Mock
    private OracleConnection oracleConnection;
</#if>

    @Mock
    private <#if driverVersionName == 'ojdbc6' >ARRAY<#else>Array</#if> array;

    @Mock
    private Connection connection;
<#if driverName == 'oracle' >

    @Test
    public void testProcessArray() throws SQLException {
        Object[] objects = new Object[0];

        Mockito.when(connection.unwrap(Mockito.eq(OracleConnection.class))).thenReturn(oracleConnection);
        Mockito.when(oracleConnection.<#if driverVersionName == 'ojdbc6' >createARRAY<#else>createOracleArray</#if>(Mockito.eq("NAME"), Mockito.same(objects))).thenReturn(array);

        Object result = arrayUtil.process(connection, "NAME", objects);

        Assert.assertNotNull(result);
        Assert.assertSame(array, result);
    }
</#if>

    @Test(expected = SQLException.class)
    public void testProcessArrayError() throws SQLException {
        Object[] objects = new Object[0];
<#if driverName == 'oracle' >

        Mockito.when(connection.unwrap(Mockito.eq(OracleConnection.class))).thenReturn(oracleConnection);
        Mockito.when(oracleConnection.<#if driverVersionName == 'ojdbc6' >createARRAY<#else>createOracleArray</#if>(Mockito.eq("NAME"), Mockito.same(objects))).thenThrow(new RuntimeException());

</#if>
        arrayUtil.process(connection, "NAME", objects);
    }
}
