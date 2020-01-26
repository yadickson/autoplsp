package ${javaPackage}.repository;
<#list proc.parameters as parameter>
<#if parameter.object || parameter.array>
<#assign importConnectionUtils = 1>
</#if>
<#if parameter.object>
<#assign importObjectUtil = 1>
</#if>
</#list>
<#list proc.outputParameters as parameter>
<#if parameter.date>
<#assign importDate = 1>
<#elseif parameter.clob>
<#assign importClobUtil = 1>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
</#if>
</#list>

<#if importConnectionUtils??>
import java.sql.Connection;

</#if>
<#list proc.arrayImports as parameter>
import ${javaPackage}.array.${parameter.javaTypeName};
import ${javaPackage}.array.${parameter.javaTypeName}Builder;
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
<#list proc.objectImports as parameter>
import ${javaPackage}.object.${parameter.javaTypeName};
import ${javaPackage}.object.${parameter.javaTypeName}Builder;
</#list>
<#if importBlobUtil??>
import ${javaPackage}.util.BlobUtil;
</#if>
<#if proc.checkResult>
import ${javaPackage}.util.CheckResult;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.ClobUtil;
</#if>
<#if importConnectionUtils??>
import ${javaPackage}.util.ConnectionUtil;
</#if>
<#if importDate??>

import java.util.Date;
<#else>

</#if>
<#if proc.hasOutput>
import org.junit.Assert;
</#if>
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
<#if importConnectionUtils??>

    @Mock
    private Connection connection;

    @Mock
    private ConnectionUtil connectionUtil;
<#list proc.arrayImports as parameter>

    @Mock
    private ${parameter.javaTypeName}Builder ${parameter.javaTypeFieldName}Builder;
</#list>
<#list proc.objectImports as parameter>

    @Mock
    private ${parameter.javaTypeName}Builder ${parameter.javaTypeFieldName}Builder;
</#list>
</#if>

    @Mock(name = "${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>")
    private ${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> <#if proc.function>function<#else>procedure</#if>;

    @Test
    public void testExecute() throws java.sql.SQLException {
<#if proc.hasInput>

        ${proc.className}IN params = new ${proc.className}IN();

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = new java.util.Date();
<#elseif parameter.blob>
        byte[] ${parameter.fieldName} = new byte[0];
<#elseif parameter.number>
        ${parameter.javaTypeName} ${parameter.fieldName} = ${parameter.position};
<#elseif parameter.array || parameter.object>
        ${parameter.javaTypeName} ${parameter.fieldName} = new ${parameter.javaTypeName}();
<#else>
        ${parameter.javaTypeName} ${parameter.fieldName} = "${parameter.name}";
</#if>
</#list>

<#list proc.inputParameters as parameter>
        params.set${parameter.propertyName}(${parameter.fieldName});
</#list>

</#if>
<#if proc.hasOutput>
        ${proc.className}OUT out;

        java.util.Map<String, Object> mapResult = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        java.util.List<${parameter.javaTypeName}> obj${parameter.propertyName} = new java.util.ArrayList<<#if !diamond>${parameter.javaTypeName}</#if>>();
<#elseif parameter.clob>
        java.sql.Clob obj${parameter.propertyName} = Mockito.mock(java.sql.Clob.class);
<#elseif parameter.blob>
        java.sql.Blob obj${parameter.propertyName} = Mockito.mock(java.sql.Blob.class);
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
<#if importConnectionUtils??>
        Mockito.when(connectionUtil.process()).thenReturn(connection);
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}Builder.process(Mockito.same(connection), Mockito.same(${parameter.fieldName}))).thenReturn(null);
</#if>
</#list>
</#if>
<#if proc.hasOutput>

<#list proc.outputParameters as parameter>
<#if parameter.blob>
        Mockito.when(blobUtil.process(Mockito.same(obj${parameter.propertyName}))).thenReturn(new byte[0]);
<#elseif parameter.clob>
        Mockito.when(clobUtil.process(Mockito.same(obj${parameter.propertyName}))).thenReturn("${parameter.name}");
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>.execute(Mockito.anyMap())).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        <#if proc.hasOutput>out = </#if>repository.execute(<#if proc.hasInput>params</#if>);
<#if proc.hasOutput>

        Assert.assertNotNull(out);

<#list proc.outputParameters as parameter>
<#if parameter.date>
        Assert.assertEquals(obj${parameter.propertyName}, out.get${parameter.propertyName}());
<#elseif parameter.clob>
        Assert.assertEquals("${parameter.name}", out.get${parameter.propertyName}());
<#elseif parameter.blob>
        Assert.assertNotNull(out.get${parameter.propertyName}());
<#else>
        Assert.assertSame(obj${parameter.propertyName}, out.get${parameter.propertyName}());
</#if>
</#list>
</#if>

        InOrder inOrder = Mockito.inOrder(<#if proc.function>function<#else>procedure</#if><#if proc.checkResult>, checkResult</#if><#if importConnectionUtils??>, connectionUtil</#if>);

<#if importConnectionUtils??>
        inOrder.verify(connectionUtil, Mockito.times(1)).process();
</#if>
        inOrder.verify(<#if proc.function>function<#else>procedure</#if>, Mockito.times(1)).execute(Mockito.anyMap());
<#if importConnectionUtils??>
        inOrder.verify(connectionUtil, Mockito.times(1)).release(Mockito.same(connection));
</#if>
<#if proc.checkResult>
        inOrder.verify(checkResult, Mockito.times(1)).check(<#if proc.hasOutput>Mockito.same(mapResult)</#if>);
</#if>

<#if importConnectionUtils??>
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.verify(${parameter.javaTypeFieldName}Builder, Mockito.times(1)).process(Mockito.same(connection), Mockito.same(${parameter.fieldName}));
</#if>
</#list>
</#if>
    }

    @Test(expected = java.sql.SQLException.class)
    public void testExecuteError() throws java.sql.SQLException {
<#if proc.hasInput>
        ${proc.className}IN params = new ${proc.className}IN();

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = new java.util.Date();
<#elseif parameter.blob>
        byte[] ${parameter.fieldName} = new byte[0];
<#elseif parameter.number>
        ${parameter.javaTypeName} ${parameter.fieldName} = ${parameter.position};
<#elseif parameter.array || parameter.object>
        ${parameter.javaTypeName} ${parameter.fieldName} = new ${parameter.javaTypeName}();
<#else>
        ${parameter.javaTypeName} ${parameter.fieldName} = "${parameter.name}";
</#if>
</#list>

<#list proc.inputParameters as parameter>
        params.set${parameter.propertyName}(${parameter.fieldName});
</#list>

</#if>
<#if importConnectionUtils??>
        Mockito.when(connectionUtil.process()).thenReturn(connection);
</#if>
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}Builder.process(Mockito.same(connection), Mockito.same(${parameter.fieldName}))).thenReturn(null);
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>.execute(Mockito.anyMap())).thenThrow(new RuntimeException());

        repository.execute(<#if proc.hasInput>params</#if>);
    }
<#if proc.hasInput>

    @Test(expected = java.sql.SQLException.class)
    public void testExecuteInputNullParameterError() throws java.sql.SQLException {
        ${proc.className}IN params = null;
<#if importConnectionUtils??>

        Mockito.when(connectionUtil.process()).thenReturn(connection);

</#if>
        repository.execute(params);
    }
</#if>
}
