package ${javaPackage}.util;

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
public class ${prefixUtilityName}SafeDateTest {

    @Test
    public void testCreate() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(new ${prefixUtilityName}SafeDate());
    }

    @Test
    public void testInputNull() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNull(${prefixUtilityName}SafeDate.process(null));
    }

    @Test
    public void testInputNotNull() {
        java.util.Date date = new java.util.Date();
        java.util.Date result = ${prefixUtilityName}SafeDate.process(date);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotSame(date, result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(date, result);
    }
}
