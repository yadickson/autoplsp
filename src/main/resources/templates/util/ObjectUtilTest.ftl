package ${javaPackage}.util;

import java.sql.Connection;
import java.sql.SQLException;
<#if driverName == 'oracle'>

import oracle.jdbc.OracleConnection;
<#if driverVersionName != 'ojdbc6' >
import java.sql.Struct;
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
public class ${prefixUtilityName}ObjectUtilTest {

    @InjectMocks
    ${prefixUtilityName}ObjectUtilImpl objectUtil;
<#if driverName == 'oracle'>

    @Mock
    private OracleConnection oracleConnection;
<#if driverVersionName != 'ojdbc6' >

    @Mock
    private Struct struct;
</#if>
</#if>

    @Mock
    private Connection connection;
<#if driverName == 'oracle' && driverVersionName != 'ojdbc6' >

    @Test
    public void testProcessObject() throws SQLException {
        Object[] objects = new Object[0];

        Mockito.when(connection.unwrap(Mockito.eq(OracleConnection.class))).thenReturn(oracleConnection);
        Mockito.when(oracleConnection.createStruct(Mockito.eq("NAME"), Mockito.same(objects))).thenReturn(struct);

        Object result = objectUtil.process(connection, "NAME", objects);

        Assert.assertNotNull(result);
        Assert.assertSame(struct, result);
    }
</#if>

    @Test(expected = SQLException.class)
    public void testProcessObjectError() throws SQLException {
        Object[] objects = new Object[0];
<#if driverName == 'oracle' >

        Mockito.when(connection.unwrap(Mockito.eq(OracleConnection.class))).thenReturn(oracleConnection);
<#if driverVersionName != 'ojdbc6' >
        Mockito.when(oracleConnection.createStruct(Mockito.eq("NAME"), Mockito.same(objects))).thenThrow(new RuntimeException());
</#if>
</#if>

        objectUtil.process(connection, "NAME", objects);
    }
}
