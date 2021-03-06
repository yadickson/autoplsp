package ${javaPackage}.object;
<#list parameter.parameters as parameter>
<#if parameter.clob>
<#assign importClobUtil = 1>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
<#elseif parameter.date>
<#assign importDateUtil = 1>
</#if>
<#if parameter.date>
<#assign importDate = 1>
</#if>
</#list>

import java.sql.Connection;
import java.sql.SQLException;

<#if importBlobUtil??>
import ${javaPackage}.util.${prefixUtilityName}BlobUtil;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.${prefixUtilityName}ClobUtil;
</#if>
<#if importDateUtil??>
import ${javaPackage}.util.${prefixUtilityName}DateUtil;
</#if>
import ${javaPackage}.util.${prefixUtilityName}ObjectUtil;

<#if importDate??>
import java.util.Date;

</#if>
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
@SuppressWarnings({"rawtypes", "unchecked"})
public class ${parameter.javaTypeName}BuilderTest {

    @InjectMocks
    ${parameter.javaTypeName}BuilderImpl builder;
<#if importBlobUtil??>

    @Mock
    private ${prefixUtilityName}BlobUtil blobUtil;
</#if>
<#if importClobUtil??>

    @Mock
    private ${prefixUtilityName}ClobUtil clobUtil;
</#if>
<#if importDateUtil??>

    @Mock
    private ${prefixUtilityName}DateUtil dateUtil;
</#if>

    @Mock
    private ${prefixUtilityName}ObjectUtil objectUtil;

    @Mock
    private Connection connection;

    @Captor
    private ArgumentCaptor<Object[]> captorObjects;

    @Test
    public void test${parameter.javaTypeName}BuilderProcess() throws SQLException {

        ${parameter.javaTypeName} object = new ${parameter.javaTypeName}();

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = ${parameter.position};
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new ${parameter.javaTypeName}(${parameter.position});
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[0];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = "${parameter.name}";
</#if>
</#list>

<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>

        Object[] obj = new Object[0];

<#list parameter.parameters as parameter>
<#if parameter.date>
        Mockito.when(dateUtil.process(Mockito.eq(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
<#elseif parameter.blob>
        Mockito.when(blobUtil.process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
<#elseif parameter.clob>
        Mockito.when(clobUtil.process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
</#if>
</#list>
        Mockito.when(objectUtil.process(Mockito.same(connection), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture())).thenReturn(obj);

        Object result = builder.process(connection, object);

        Assert.assertNotNull(result);
        Assert.assertSame(obj, result);

        Object[] objParamsResult = captorObjects.getValue();

        Assert.assertNotNull(objParamsResult);
        Assert.assertEquals(${parameter.parameters?size}, objParamsResult.length);
<#list parameter.parameters as parameter>
<#if parameter.date>
        Assert.assertEquals(obj${parameter.propertyName}, objParamsResult[${parameter.position - 1}]);
<#else>
        Assert.assertSame(obj${parameter.propertyName}, objParamsResult[${parameter.position - 1}]);
</#if>
</#list>

<#list parameter.parameters as parameter>
<#if parameter.date>
        Mockito.verify(dateUtil, Mockito.times(1)).process(Mockito.eq(obj${parameter.propertyName}));
<#elseif parameter.blob>
        Mockito.verify(blobUtil, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}));
<#elseif parameter.clob>
        Mockito.verify(clobUtil, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}));
</#if>
</#list>
    }
}
