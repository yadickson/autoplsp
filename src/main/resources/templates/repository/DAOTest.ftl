package ${javaPackage}.repository;
<#list proc.parameters as parameter>
<#if parameter.object || parameter.array>
<#assign importConnectionUtils = 1>
</#if>
<#if parameter.object>
<#assign importObjectUtil = 1>
</#if>
<#if parameter.date>
<#assign importDate = 1>
</#if>
</#list>
<#list proc.outputParameters as parameter>
<#if parameter.clob>
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
import ${javaPackage}.cursor.${parameter.javaTypeName};
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
import ${javaPackage}.util.${prefixUtilityName}BlobUtil;
</#if>
<#if proc.checkResult>
import ${javaPackage}.util.${prefixUtilityName}CheckResult;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.${prefixUtilityName}ClobUtil;
</#if>
<#if importConnectionUtils??>
import ${javaPackage}.util.${prefixUtilityName}ConnectionUtil;
</#if>

<#if importDate??>
import java.util.Date;

</#if>

<#if proc.hasInput>
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
</#if>
import org.mockito.InOrder;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;

<#if junit == 'junit5'>
<#if proc.hasInput || proc.hasOutput>
import org.junit.jupiter.api.Assertions;
</#if>
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
<#else>
<#if proc.hasInput || proc.hasOutput>
import org.junit.Assert;
</#if>
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
</#if>

<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
@SuppressWarnings({"unchecked"})
public class ${proc.className}DAOTest {

    @InjectMocks
    ${proc.className}DAOImpl repository;
<#if importBlobUtil??>

    @Mock
    private ${prefixUtilityName}BlobUtil blobUtil;
</#if>
<#if proc.checkResult>

    @Mock
    private ${prefixUtilityName}CheckResult checkResult;
</#if>
<#if importClobUtil??>

    @Mock
    private ${prefixUtilityName}ClobUtil clobUtil;
</#if>
<#if importConnectionUtils??>

    @Mock
    private Connection connection;

    @Mock
    private ${prefixUtilityName}ConnectionUtil connectionUtil;
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
<#if proc.hasInput>

    @Captor
    private ArgumentCaptor<java.util.Map<String, Object>> captorParameters;
</#if>
<#if proc.hasInput>

    @Test
    public void should_check_${proc.className}_dao_execute_with_input_parameters() throws java.sql.SQLException {
<#if proc.hasInput>

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = new ${parameter.javaTypeName}(${parameter.position});
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

<#if importConnectionUtils??>

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Object[] ${parameter.fieldName}Builder = new Object[0];
</#if>
</#list>
</#if>

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
        ${parameter.javaTypeName} obj${parameter.propertyName} = new ${parameter.javaTypeName}(${parameter.javaTypeName});
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
        Mockito.when(${parameter.javaTypeFieldName}Builder.process(Mockito.same(connection), Mockito.same(${parameter.fieldName}))).thenReturn(${parameter.fieldName}Builder);
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
        Mockito.when(<#if proc.function>function<#else>procedure</#if>.execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>)).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        <#if proc.hasOutput>out = </#if>repository.execute(<#if proc.hasInput>${'\n'}            <#list proc.inputParameters as parameter>${parameter.fieldName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        </#if>);
<#if proc.hasOutput>

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(out);

<#list proc.outputParameters as parameter>
<#if parameter.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(obj${parameter.propertyName}, out.get${parameter.propertyName}());
<#elseif parameter.clob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals("${parameter.name}", out.get${parameter.propertyName}());
<#elseif parameter.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(out.get${parameter.propertyName}());
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj${parameter.propertyName}, out.get${parameter.propertyName}());
</#if>
</#list>
</#if>

        InOrder inOrder = Mockito.inOrder(<#if proc.function>function<#else>procedure</#if><#if proc.checkResult>, checkResult</#if><#if importConnectionUtils??>, connectionUtil</#if>);

<#if importConnectionUtils??>
        inOrder.verify(connectionUtil, Mockito.times(1)).process();
</#if>
        inOrder.verify(<#if proc.function>function<#else>procedure</#if>, Mockito.times(1)).execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>);
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
<#if proc.hasInput>

        java.util.Map<String, Object> mapParamsResult = captorParameters.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(mapParamsResult);

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameter.fieldName}Builder, mapParamsResult.get("${parameter.name}"));
<#elseif parameter.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameter.fieldName}, mapParamsResult.get("${parameter.name}"));
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameter.fieldName}, mapParamsResult.get("${parameter.name}"));
</#if>
</#list>
</#if>
    }
</#if>

    @Test
    public void test${proc.className}DAOExecute() throws java.sql.SQLException {
<#if proc.hasInput>

        ${proc.className}IN params = new ${proc.className}IN();

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = new ${parameter.javaTypeName}(${parameter.position});
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
<#if importConnectionUtils??>

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Object[] ${parameter.fieldName}Builder = new Object[0];
</#if>
</#list>
</#if>

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
        ${parameter.javaTypeName} obj${parameter.propertyName} = new ${parameter.javaTypeName}(${parameter.javaTypeName});
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
        Mockito.when(${parameter.javaTypeFieldName}Builder.process(Mockito.same(connection), Mockito.same(${parameter.fieldName}))).thenReturn(${parameter.fieldName}Builder);
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
        Mockito.when(<#if proc.function>function<#else>procedure</#if>.execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>)).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        <#if proc.hasOutput>out = </#if>repository.execute(<#if proc.hasInput>params</#if>);
<#if proc.hasOutput>

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(out);

<#list proc.outputParameters as parameter>
<#if parameter.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(obj${parameter.propertyName}, out.get${parameter.propertyName}());
<#elseif parameter.clob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals("${parameter.name}", out.get${parameter.propertyName}());
<#elseif parameter.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(out.get${parameter.propertyName}());
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj${parameter.propertyName}, out.get${parameter.propertyName}());
</#if>
</#list>
</#if>

        InOrder inOrder = Mockito.inOrder(<#if proc.function>function<#else>procedure</#if><#if proc.checkResult>, checkResult</#if><#if importConnectionUtils??>, connectionUtil</#if>);

<#if importConnectionUtils??>
        inOrder.verify(connectionUtil, Mockito.times(1)).process();
</#if>
        inOrder.verify(<#if proc.function>function<#else>procedure</#if>, Mockito.times(1)).execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>);
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
<#if proc.hasInput>

        java.util.Map<String, Object> mapParamsResult = captorParameters.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(mapParamsResult);

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameter.fieldName}Builder, mapParamsResult.get("${parameter.name}"));
<#elseif parameter.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameter.fieldName}, mapParamsResult.get("${parameter.name}"));
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameter.fieldName}, mapParamsResult.get("${parameter.name}"));
</#if>
</#list>
</#if>
    }

    @Test<#if junit != 'junit5'>(expected = java.sql.SQLException.class)</#if>
    public void testExecute${proc.className}DAOError() throws java.sql.SQLException {
<#if proc.hasInput>
        ${proc.className}IN params = new ${proc.className}IN();

<#list proc.inputParameters as parameter>
        params.set${parameter.propertyName}(null);
</#list>

</#if>
<#if importConnectionUtils??>
        Mockito.when(connectionUtil.process()).thenReturn(connection);
</#if>
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}Builder.process(Mockito.same(connection), Mockito.any(${parameter.javaTypeName}.class))).thenReturn(null);
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>.execute(Mockito.anyMap())).thenThrow(new RuntimeException());

        <#if junit == 'junit5'>Assertions.assertThrows(java.sql.SQLException.class,() -> </#if>repository.execute(<#if proc.hasInput>params</#if>)<#if junit == 'junit5'>)</#if>;
    }
<#if proc.hasInput>

    @Test<#if junit != 'junit5'>(expected = java.sql.SQLException.class)</#if>
    public void testExecute${proc.className}DAOInputNullParameterError() throws java.sql.SQLException {
        ${proc.className}IN params = null;
<#if importConnectionUtils??>

        Mockito.when(connectionUtil.process()).thenReturn(connection);

</#if>
        <#if junit == 'junit5'>Assertions.assertThrows(java.sql.SQLException.class,() -> </#if>repository.execute(params)<#if junit == 'junit5'>)</#if>;
    }
</#if>
}
