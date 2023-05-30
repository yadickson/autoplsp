package ${javaPackage}.util;

import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;

<#if junit == 'junit5'>
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
<#else>
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
</#if>

<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
class ${prefixUtilityName}CheckResultTest {

    @InjectMocks
    ${prefixUtilityName}CheckResultImpl checkResult;

    @Test
    void testInputNull() throws java.sql.SQLException {
        checkResult.check(null);
    }

    @Test
    void testInputNotNullFail() throws java.sql.SQLException {
        java.util.Map<String, Object> map = new java.util.HashMap<<#if !diamond>String, Object</#if>>();
        checkResult.check(map);
    }

    @Test<#if junit != 'junit5'>(expected = java.sql.SQLException.class)</#if>
    void testInputResponseError() throws java.sql.SQLException {
        java.util.Map<String, Object> map = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

        map.put("${outParameterCode}", 1${successCode}1);
        map.put("${outParameterMessage}", "ERROR");

        <#if junit == 'junit5'>Assertions.assertThrows(java.sql.SQLException.class,() -> </#if>checkResult.check(map)<#if junit == 'junit5'>)</#if>;
    }

    @Test
    void testInputOk() throws java.sql.SQLException {
        java.util.Map<String, Object> map = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

        map.put("${outParameterCode}", ${successCode});
        map.put("${outParameterMessage}", "OK");

        checkResult.check(map);
    }

}
