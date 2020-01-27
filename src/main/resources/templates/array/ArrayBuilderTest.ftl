package ${javaPackage}.array;
<#if parameter.parameters[parameter.parameters?size - 1].object>
<#assign importObjectBuilder = 1>
</#if>
<#list parameter.parameters as paramrs>
<#if paramrs.date>
<#assign importDate = 1>
</#if>
</#list>

import java.sql.Connection;
import java.sql.SQLException;

<#if importObjectBuilder??>
import ${javaPackage}.object.${parameter.parameters[parameter.parameters?size - 1].javaTypeName};
import ${javaPackage}.object.${parameter.parameters[parameter.parameters?size - 1].javaTypeName}Builder;

</#if>
import ${javaPackage}.util.ArrayUtil;

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

    @Mock
    private ArrayUtil arrayUtil;

    @Mock
    private Connection connection;
<#if importObjectBuilder??>

    @Mock
    private ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}Builder objectBuilder;
</#if>

    @Captor
    private ArgumentCaptor<Object[]> captorObjects;

    @Test
    public void test${parameter.javaTypeName}BuilderProcess() throws SQLException {

        ${parameter.javaTypeName} array = new ${parameter.javaTypeName}();

<#if parameter.parameters[parameter.parameters?size - 1].string>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = "${parameter.parameters[parameter.parameters?size - 1].javaTypeName}";
<#elseif parameter.parameters[parameter.parameters?size - 1].number>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = ${parameter.parameters[parameter.parameters?size - 1].position};
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}(${parameter.parameters[parameter.parameters?size - 1].position});
<#else>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}();
</#if>

        array.add(object);

        Object obj = new Object();

<#if importObjectBuilder??>
        Mockito.when(objectBuilder.process(Mockito.same(connection), Mockito.same(object))).thenReturn(object);
</#if>
        Mockito.when(arrayUtil.process(Mockito.same(connection), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture())).thenReturn(obj);

        Object result = builder.process(connection, array);

        Assert.assertNotNull(result);
        Assert.assertSame(obj, result);

<#if importObjectBuilder??>
        Mockito.verify(objectBuilder, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(object));
</#if>

        Object[] objParamsResult = captorObjects.getValue();

        Assert.assertNotNull(objParamsResult);
        Assert.assertEquals(${parameter.parameters?size}, objParamsResult.length);

<#if parameter.parameters[parameter.parameters?size - 1].date>
        Assert.assertEquals(object, objParamsResult[0]);
<#else>
        Assert.assertSame(object, objParamsResult[0]);
</#if>
    }
}
