package ${javaPackage}.util;

import java.sql.Connection;
<#if driverName == 'oracle'>

import oracle.jdbc.OracleConnection;
<#if driverVersionName != 'ojdbc6' >
import java.sql.Struct;
</#if>
</#if>

import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;

<#if junit == 'junit5'>
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
<#else>
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
</#if>

<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
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
    public void testProcessObject() throws java.sql.SQLException {
        Object[] objects = new Object[0];

        Mockito.when(connection.unwrap(Mockito.eq(OracleConnection.class))).thenReturn(oracleConnection);
        Mockito.when(oracleConnection.createStruct(Mockito.eq("NAME"), Mockito.same(objects))).thenReturn(struct);

        Object result = objectUtil.process(connection, "NAME", objects);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(struct, result);
    }
</#if>

    @Test<#if junit != 'junit5'>(expected = java.sql.SQLException.class)</#if>
    public void testProcessObjectError() throws java.sql.SQLException {
        Object[] objects = new Object[0];
<#if driverName == 'oracle' >

        Mockito.when(connection.unwrap(Mockito.eq(OracleConnection.class))).thenReturn(oracleConnection);
<#if driverVersionName != 'ojdbc6' >
        Mockito.when(oracleConnection.createStruct(Mockito.eq("NAME"), Mockito.same(objects))).thenThrow(new RuntimeException());
</#if>
</#if>

        <#if junit == 'junit5'>Assertions.assertThrows(java.sql.SQLException.class,() -> </#if>objectUtil.process(connection, "NAME", objects)<#if junit == 'junit5'>)</#if>;
    }
}
