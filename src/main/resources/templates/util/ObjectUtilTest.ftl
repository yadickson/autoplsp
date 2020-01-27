package ${javaPackage}.util;

import java.sql.Connection;
import java.sql.SQLException;
<#if driverName == 'oracle' && driverVersionName != 'ojdbc6' >

import java.sql.Struct;
</#if>

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class ObjectUtilTest {

    @InjectMocks
    ObjectUtilImpl objectUtil;
<#if driverName == 'oracle' && driverVersionName != 'ojdbc6' >

    @Mock
    private Struct struct;
</#if>

    @Mock
    private Connection connection;
<#if driverName == 'oracle' && driverVersionName != 'ojdbc6' >

    @Test
    public void testProcessObject() throws SQLException {
        Object[] objects = new Object[0];

        Mockito.when(connection.createStruct(Mockito.eq("NAME"), Mockito.same(objects))).thenReturn(struct);

        Object result = objectUtil.process(connection, "NAME", objects);

        Assert.assertNotNull(result);
        Assert.assertSame(struct, result);
    }

    @Test(expected = SQLException.class)
    public void testProcessObjectError() throws SQLException {
        Object[] objects = new Object[0];

        Mockito.when(connection.createStruct(Mockito.eq("NAME"), Mockito.same(objects))).thenThrow(new RuntimeException());

        objectUtil.process(connection, "NAME", objects);
    }
</#if>
}
