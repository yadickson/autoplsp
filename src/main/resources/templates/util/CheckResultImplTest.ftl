package ${javaPackage}.${utilFolderName};
<#assign importList = ["java.sql.SQLException", "java.util.Map", "java.util.HashMap"]>
<#assign importList = importList + ["org.mockito.Mock", "org.mockito.Mockito"]>
<#if junit == 'junit5'>
<#assign importList = importList + ["org.junit.jupiter.api.extension.ExtendWith", "org.mockito.junit.jupiter.MockitoExtension", "org.junit.jupiter.api.Assertions", "org.junit.jupiter.api.BeforeEach", "org.junit.jupiter.api.Test"]>
<#else>
<#assign importList = importList + ["org.junit.runner.RunWith", "org.mockito.runners.MockitoJUnitRunner", "org.junit.Assert", "org.junit.Before", "org.junit.Test"]>
</#if>
<#assign importList = importList + ["org.mockito.ArgumentCaptor", "org.mockito.Captor", "org.mockito.Mock", "org.mockito.Mockito"]>

<#list importSort(importList) as import>
<#if previousImportMatch?? && !import?starts_with(previousImportMatch)>

</#if>
import ${import};
<#assign previousImportMatch = import?keep_before_last(".") >
</#list>
<#if importList?has_content>

</#if>
<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
class ${prefixUtilityName}CheckResultImplTest {

    private ${prefixUtilityName}CheckResult checkResult;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        checkResult = new ${prefixUtilityName}CheckResultImpl();
    }

    @Test
    void testInputNull() throws SQLException {
        checkResult.check(null);
    }

    @Test
    void testInputNotNullFail() throws SQLException {
        Map<String, Object> map = new HashMap<<#if !diamond>String, Object</#if>>();
        checkResult.check(map);
    }

    @Test<#if junit != 'junit5'>(expected = SQLException.class)</#if>
    void testInputResponseError()<#if junit != 'junit5'> throws SQLException</#if> {
        Map<String, Object> map = new HashMap<<#if !diamond>String, Object</#if>>();

        map.put("${outParameterCode}", 1${successCode}1);
        map.put("${outParameterMessage}", "ERROR");

        <#if junit == 'junit5'>Assertions.assertThrows(SQLException.class,() -> </#if>checkResult.check(map)<#if junit == 'junit5'>)</#if>;
    }

    @Test
    void testInputOk() throws SQLException {
        Map<String, Object> map = new HashMap<<#if !diamond>String, Object</#if>>();

        map.put("${outParameterCode}", ${successCode});
        map.put("${outParameterMessage}", "OK");

        checkResult.check(map);
    }

}
