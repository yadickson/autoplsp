package ${javaPackage}.array;
<#if parameter.parameters[parameter.parameters?size - 1].object>
<#assign importObjectBuilder = 1>
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
<#assign importDateUtil = 1>
<#elseif parameter.parameters[parameter.parameters?size - 1].clob>
<#assign importClobUtil = 1>
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
<#assign importBlobUtil = 1>
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

<#elseif importDateUtil??>
import ${javaPackage}.util.${prefixUtilityName}DateUtil;

<#elseif importClobUtil??>
import ${javaPackage}.util.${prefixUtilityName}ClobUtil;

<#elseif importBlobUtil??>
import ${javaPackage}.util.${prefixUtilityName}BlobUtil;

</#if>
import ${javaPackage}.util.${prefixUtilityName}ArrayUtil;

<#if importDate??>
import java.util.Date;

</#if>
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
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
@SuppressWarnings({"rawtypes", "unchecked"})
public class ${parameter.javaTypeName}BuilderTest {

    @InjectMocks
    ${parameter.javaTypeName}BuilderImpl builder;

    @Mock
    private ${prefixUtilityName}ArrayUtil arrayUtil;

    @Mock
    private Connection connection;
<#if importObjectBuilder??>

    @Mock
    private ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}Builder objectBuilder;
<#elseif importDateUtil??>

    @Mock
    private ${prefixUtilityName}DateUtil dateUtil;
<#elseif importBlobUtil??>

    @Mock
    private ${prefixUtilityName}BlobUtil blobUtil;
<#elseif importClobUtil??>

    @Mock
    private ${prefixUtilityName}ClobUtil clobUtil;
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
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new byte[0];
<#else>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}();
</#if>

        array.add(object);

        Object obj = new Object();

<#if importObjectBuilder??>
        Mockito.when(objectBuilder.process(Mockito.same(connection), Mockito.same(object))).thenReturn(object);
<#elseif importDateUtil??>
        Mockito.when(dateUtil.process(Mockito.same(object))).thenReturn(object);
<#elseif importBlobUtil??>
        Mockito.when(blobUtil.process(Mockito.same(connection), Mockito.same(object))).thenReturn(object);
<#elseif importClobUtil??>
        Mockito.when(clobUtil.process(Mockito.same(connection), Mockito.same(object))).thenReturn(object);
</#if>
        Mockito.when(arrayUtil.process(Mockito.same(connection), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture())).thenReturn(obj);

        Object result = builder.process(connection, array);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj, result);

<#if importObjectBuilder??>
        Mockito.verify(objectBuilder, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(object));
<#elseif importDateUtil??>
        Mockito.verify(dateUtil, Mockito.times(1)).process(Mockito.same(object));
<#elseif importBlobUtil??>
        Mockito.verify(blobUtil, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(object));
<#elseif importClobUtil??>
        Mockito.verify(clobUtil, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(object));
</#if>

        Object[] objParamsResult = captorObjects.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(objParamsResult);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameter.parameters?size}, objParamsResult.length);

<#if parameter.parameters[parameter.parameters?size - 1].date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(object, objParamsResult[0]);
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(object, objParamsResult[0]);
</#if>
    }
}
