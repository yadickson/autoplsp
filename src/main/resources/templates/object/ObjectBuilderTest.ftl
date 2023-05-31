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
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;

<#if junit == 'junit5'>
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
<#else>
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
</#if>

import com.github.javafaker.Faker;

<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
@SuppressWarnings({"rawtypes", "unchecked"})
class ${parameter.javaTypeName}BuilderTest {

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

    Faker faker;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
    }

    @Test
    void test_${parameter.javaTypeName}_builder_process_check_parameters() throws SQLException {
        ${parameter.javaTypeName} object;
<#if !fullConstructor>
        object = new ${parameter.javaTypeName}();
</#if>

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#if !fullConstructor>
<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>
<#else>
        object = new ${parameter.javaTypeName}(${'\n'}            <#list parameter.parameters as parameter>obj${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>

        Object[] obj = new Object[0];

<#list parameter.parameters as parameter>
<#if parameter.date>
        Mockito.when(dateUtil.process(obj${parameter.propertyName})).thenReturn(obj${parameter.propertyName});
<#elseif parameter.blob>
        Mockito.when(blobUtil.process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
<#elseif parameter.clob>
        Mockito.when(clobUtil.process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
</#if>
</#list>
        Mockito.when(objectUtil.process(Mockito.same(connection), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture())).thenReturn(obj);

        Object result = builder.process(connection, object);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj, result);

        Object[] objParamsResult = captorObjects.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(objParamsResult);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameter.parameters?size}, objParamsResult.length);

<#list parameter.parameters as parameterTest>
<#if parameterTest.date>
        Mockito.verify(dateUtil, Mockito.times(1)).process(Mockito.eq(obj${parameterTest.propertyName}));
<#elseif parameterTest.blob>
        Mockito.verify(blobUtil, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(obj${parameterTest.propertyName}));
<#elseif parameterTest.clob>
        Mockito.verify(clobUtil, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(obj${parameterTest.propertyName}));
</#if>
</#list>
    }
<#list parameter.parameters as parameterTest>

    @Test
    void test_${parameter.javaTypeName}_builder_process_check_parameter_${parameterTest.fieldName}_value() throws SQLException {
        ${parameter.javaTypeName} object;
<#if !fullConstructor>
        object = new ${parameter.javaTypeName}();
</#if>

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#if !fullConstructor>
<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>
<#else>
        object = new ${parameter.javaTypeName}(${'\n'}            <#list parameter.parameters as parameter>obj${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>

        Object[] obj = new Object[0];

<#list parameter.parameters as parameter>
<#if parameter.date>
        Mockito.when(dateUtil.process(obj${parameter.propertyName})).thenReturn(obj${parameter.propertyName});
<#elseif parameter.blob>
        Mockito.when(blobUtil.process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
<#elseif parameter.clob>
        Mockito.when(clobUtil.process(Mockito.same(connection), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
</#if>
</#list>
        Mockito.when(objectUtil.process(Mockito.same(connection), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture())).thenReturn(obj);

        Object result = builder.process(connection, object);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj, result);

        Object[] objParamsResult = captorObjects.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(objParamsResult);
<#if parameterTest.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(obj${parameterTest.propertyName}, objParamsResult[${parameterTest.position - 1}]);
<#elseif parameterTest.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(obj${parameterTest.propertyName}, result.get${parameterTest.propertyName}())<#else>assertTrue(java.util.Arrays.equals(obj${parameter.propertyName}, result.get${parameter.propertyName}()))</#if>;
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj${parameterTest.propertyName}, objParamsResult[${parameterTest.position - 1}]);
</#if>
    }
</#list>
}
