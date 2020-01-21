package ${javaPackage}.repository.mapper;
<#list parameter.parameters as paramrs>
<#if paramrs.date>
<#assign importDate = 1>
</#if>
</#list>

import ${javaPackage}.domain.${parameter.javaTypeName};
<#if importDate??>

import java.util.Date;
</#if>

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
@SuppressWarnings({"rawtypes", "unchecked"})
public class ${parameter.javaTypeName}RowMapperTest {

    @Mock
    private java.sql.ResultSet resultSet;

    @Test
    public void testMapper() throws java.sql.SQLException {
        ${parameter.javaTypeName}RowMapper mapper = new ${parameter.javaTypeName}RowMapper();

<#list parameter.parameters as paramrs>
<#if paramrs.date>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = new java.util.Date();
<#elseif paramrs.blob>
        byte[] ${paramrs.fieldName} = new byte[0];
<#elseif paramrs.number>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = ${paramrs.position};
<#else>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = "${paramrs.name}";
</#if>
</#list>

<#list parameter.parameters as paramrs>
<#if paramrs.date>
        Mockito.when(resultSet.getTimestamp(Mockito.eq(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>))).thenReturn(new java.sql.Timestamp(${paramrs.fieldName}.getTime()));
<#elseif paramrs.clob>
        Mockito.when(resultSet.getString(Mockito.eq(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>))).thenReturn(${paramrs.fieldName});
<#elseif paramrs.blob>
        Mockito.when(resultSet.getBytes(Mockito.eq(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>))).thenReturn(${paramrs.fieldName});
<#elseif paramrs.string>
        Mockito.when(resultSet.getString(Mockito.eq(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>))).thenReturn(${paramrs.fieldName});
<#else>
        Mockito.when(resultSet.getObject(Mockito.eq(<#if position>${paramrs.position}<#else>"${paramrs.name}"</#if>))).thenReturn(${paramrs.fieldName});
</#if>
</#list>

        ${parameter.javaTypeName} result = mapper.mapRow(resultSet, 0);

        Assert.assertNotNull(result);
<#list parameter.parameters as paramrs>
<#if paramrs.date>
        Assert.assertEquals(${paramrs.fieldName}, result.get${paramrs.propertyName}());
<#else>
        Assert.assertSame(${paramrs.fieldName}, result.get${paramrs.propertyName}());
</#if>
</#list>
    }
}
