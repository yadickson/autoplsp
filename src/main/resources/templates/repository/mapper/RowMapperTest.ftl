package ${javaPackage}.repository.mapper;
<#list parameter.parameters as paramrs>
<#if paramrs.date>
<#assign importDate = 1>
</#if>
</#list>

import ${javaPackage}.cursor.${parameter.javaTypeName};
<#if importDate??>

import java.util.Date;
</#if>

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
class ${parameter.javaTypeName}RowMapperTest {

    @Mock
    private java.sql.ResultSet resultSet;

    Faker faker;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
    }
<#list parameter.parameters as parameterTest>

    @Test
    void should_check_${proc.constantFullName?lower_case}_row_mapper_check_${parameterTest.name?lower_case}_value() throws java.sql.SQLException {
        ${parameter.javaTypeName}RowMapper mapper = new ${parameter.javaTypeName}RowMapper();

<#list parameter.parameters as paramrs>
<#if paramrs.date>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = faker.date().birthday();
<#elseif paramrs.blob>
        byte[] ${paramrs.fieldName} = new byte[faker.random().nextInt(${paramrs.position} * 100)];
<#elseif paramrs.number>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = faker.random().nextLong();
<#else>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = faker.internet().uuid();
</#if>
</#list>

<#list parameter.parameters as paramrs>
<#if paramrs.date>
        Mockito.when(resultSet.getTimestamp(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>)).thenReturn(new java.sql.Timestamp(${paramrs.fieldName}.getTime()));
<#elseif paramrs.clob>
        Mockito.when(resultSet.getString(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>)).thenReturn(${paramrs.fieldName});
<#elseif paramrs.blob>
        Mockito.when(resultSet.getBytes(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>)).thenReturn(${paramrs.fieldName});
<#elseif paramrs.string>
        Mockito.when(resultSet.getString(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>)).thenReturn(${paramrs.fieldName});
<#else>
        Mockito.when(resultSet.getObject(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>)).thenReturn(${paramrs.fieldName});
</#if>
</#list>

        ${parameter.javaTypeName} result = mapper.mapRow(resultSet, 0);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
<#if parameterTest.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameterTest.fieldName}, result.get${parameterTest.propertyName}());
<#elseif parameterTest.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(${parameterTest.fieldName}, result.get${parameterTest.propertyName}())<#else>assertTrue(java.util.Arrays.equals(${parameterTest.fieldName}, result.get${parameterTest.propertyName}()))</#if>;
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameterTest.fieldName}, result.get${parameterTest.propertyName}());
</#if>
    }
</#list>
}
