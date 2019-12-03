package ${javaPackage}.repository;
<#list proc.outputParameters as parameter>
<#if parameter.date>
<#assign importDate = 1>
<#elseif parameter.clob>
<#assign importClobUtil = 1>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
</#if>
</#list>

<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
import ${javaPackage}.domain.${parameter.javaTypeName};
</#if>
</#list>
<#if proc.hasInput>
import ${javaPackage}.domain.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.domain.${proc.className}OUT;
</#if>
<#if !proc.functionInline>
import ${javaPackage}.repository.sp.${proc.className}SP;
<#else>
import ${javaPackage}.repository.sp.${proc.className}SqlQuery;
</#if>
<#if importBlobUtil??>
import ${javaPackage}.util.BlobUtil;
</#if>
<#if proc.checkResult>
import ${javaPackage}.util.CheckResult;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.ClobUtil;
</#if>
<#if importDate??>

import java.util.Date;
<#else>

</#if>
<#if proc.hasObject || proc.hasArray>

import org.springframework.jdbc.core.JdbcTemplate;

</#if>
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InOrder;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
@SuppressWarnings({"unchecked"})
public class ${proc.className}DAOTest {

    @InjectMocks
    ${proc.className}DAOImpl repository;
<#if importBlobUtil??>

    @Mock
    private BlobUtil blobUtil;
</#if>
<#if proc.checkResult>

    @Mock
    private CheckResult checkResult;
</#if>
<#if importClobUtil??>

    @Mock
    private ClobUtil clobUtil;
</#if>
<#if proc.hasObject || proc.hasArray>

    @Mock(name="${jdbcTemplate}")
    private JdbcTemplate jdbcTemplate;
</#if>

    @Mock(name = "${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>")
    private ${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> <#if proc.function>function<#else>procedure</#if>;

    @Test
    public void testExecute() throws java.sql.SQLException {
<#if proc.hasInput>
        ${proc.className}IN params = new ${proc.className}IN(<#list proc.inputParameters as parameter>null<#sep>, </#sep></#list>);
</#if>
<#if proc.hasOutput>
        ${proc.className}OUT out;

        java.util.Map<String, Object> mapResult = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        java.util.List<${parameter.javaTypeName}> obj${parameter.propertyName} = new java.util.ArrayList<<#if !diamond>${parameter.javaTypeName}</#if>>();
<#elseif parameter.clob>
        java.sql.Clob obj${parameter.propertyName} = Mockito.mock(java.sql.Clob);
<#elseif parameter.blob>
        java.sql.Blob obj${parameter.propertyName} = Mockito.mock(java.sql.Blob);
<#elseif parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = ${parameter.position};
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new ${parameter.javaTypeName}();
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = "${parameter.name}";
</#if>
</#list>

<#list proc.outputParameters as parameter>
        mapResult.put("${parameter.name}", obj${parameter.propertyName});
</#list>
</#if>
<#if proc.hasOutput>

        Mockito.when(<#if proc.function>function<#else>procedure</#if>.execute(<#if proc.hasInput>Mockito.anyMap()</#if>)).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        <#if proc.hasOutput>out = </#if>repository.execute(<#if proc.hasInput>params</#if>);
<#if proc.hasOutput>

        Assert.assertNotNull(out);

<#list proc.outputParameters as parameter>
<#if parameter.date>
        Assert.assertEquals(obj${parameter.propertyName}, out.get${parameter.propertyName}());
<#else>
        Assert.assertSame(obj${parameter.propertyName}, out.get${parameter.propertyName}());
</#if>
</#list>
</#if>

        InOrder inOrder = Mockito.inOrder(<#if proc.function>function<#else>procedure</#if><#if proc.checkResult>, checkResult</#if>);

        inOrder.verify(<#if proc.function>function<#else>procedure</#if>, Mockito.times(1)).execute(<#if proc.hasInput>Mockito.anyMap()</#if>);
<#if proc.checkResult>
        inOrder.verify(checkResult, Mockito.times(1)).check(<#if proc.hasOutput>Mockito.same(mapResult)</#if>);
</#if>
    }

    @Test(expected = java.sql.SQLException.class)
    public void testExecuteError() throws java.sql.SQLException {
<#if proc.hasInput>
        ${proc.className}IN params = new ${proc.className}IN(<#list proc.inputParameters as parameter>null<#sep>, </#sep></#list>);
</#if>
<#if proc.hasOutput>

        Mockito.when(<#if proc.function>function<#else>procedure</#if>.execute(<#if proc.hasInput>Mockito.anyMap()</#if>)).thenThrow(new RuntimeException());
<#else>

        Mockito.doThrow(new RuntimeException()).when(<#if proc.function>function<#else>procedure</#if>.execute(<#if proc.hasInput>Mockito.anyMap()</#if>);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        repository.execute(<#if proc.hasInput>params</#if>);
    }
}
