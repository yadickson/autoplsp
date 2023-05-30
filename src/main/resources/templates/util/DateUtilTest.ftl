package ${javaPackage}.util;

import org.mockito.InjectMocks;

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
class ${prefixUtilityName}DateUtilTest {

    @InjectMocks
    ${prefixUtilityName}DateUtilImpl dateUtil;

    @Test
    void testInputNull() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNull(dateUtil.process(null));
    }

    @Test
    void testInputNotNull() {
        java.util.Date date = new java.util.Date();
        Object result = dateUtil.process(date);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
    }
}
