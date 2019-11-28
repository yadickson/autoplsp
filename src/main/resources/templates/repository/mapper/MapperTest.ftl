package ${javaPackage}.repository.mapper;

import ${javaPackage}.domain.${parameter.javaTypeName};

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
<#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = new java.util.Date();
<#elseif paramrs.sqlTypeName == 'java.sql.Types.BLOB'>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = new ${paramrs.javaTypeName}[0];
<#else>
        ${paramrs.javaTypeName} ${paramrs.fieldName} = "${paramrs.name}";
</#if>
</#list>

<#list parameter.parameters as paramrs>
<#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        Mockito.when(resultSet.getTimestamp(Mockito.eq("${paramrs.name}"))).thenReturn(${paramrs.fieldName});
<#elseif paramrs.sqlTypeName == 'java.sql.Types.CLOB'>
        Mockito.when(resultSet.getString(Mockito.eq("${paramrs.name}"))).thenReturn(${paramrs.fieldName});
<#elseif paramrs.sqlTypeName == 'java.sql.Types.BLOB'>
        Mockito.when(resultSet.getBytes(Mockito.eq("${paramrs.name}"))).thenReturn(${paramrs.fieldName});
<#else>
        Mockito.when(resultSet.getObject(Mockito.eq("${paramrs.name}"))).thenReturn(${paramrs.fieldName});
</#if>
</#list>

        ${parameter.javaTypeName} result = mapper.mapRow(resultSet, 0);

        Assert.assertNotNull(result);
<#list parameter.parameters as paramrs>
<#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        Assert.assertEquals(${paramrs.fieldName}, result.get${paramrs.propertyName}());
<#else>
        Assert.assertSame(${paramrs.fieldName}, result.get${paramrs.propertyName}());
</#if>
</#list>
    }
}
