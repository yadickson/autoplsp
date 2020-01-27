package ${javaPackage}.object;
<#list parameter.parameters as parameter>
<#if parameter.clob>
<#assign importClobUtil = 1>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
</#if>
</#list>

import java.sql.Connection;
import java.sql.SQLException;

<#if importBlobUtil??>
import ${javaPackage}.util.BlobUtil;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.ClobUtil;
</#if>
import ${javaPackage}.util.ObjectUtil;

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
    private BlobUtil blobUtil;
</#if>
<#if importClobUtil??>

    @Mock
    private ClobUtil clobUtil;
</#if>

    @Mock
    private ObjectUtil objectUtil;

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
        ${parameter.javaTypeName} obj${parameter.propertyName} = new ${parameter.javaTypeName}();
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = "${parameter.name}";
</#if>
</#list>

<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>

        Object[] obj = new Object[0];

        Mockito.when(objectUtil.process(Mockito.same(connection), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture())).thenReturn(obj);

        Object result = builder.process(connection, object);

        Assert.assertNotNull(result);
        Assert.assertSame(obj, result);

        Object[] objParamsResult = captorObjects.getValue();

        Assert.assertNotNull(objParamsResult);
        Assert.assertEquals(${parameter.parameters?size}, objParamsResult.length);
<#list parameter.parameters as parameter>
        Assert.assertSame(obj${parameter.propertyName}, objParamsResult[${parameter.position - 1}]);
</#list>
    }
}
