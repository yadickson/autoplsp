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
class ${prefixUtilityName}SafeByteArrayTest {

    @Test
    void testCreate() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(new ${prefixUtilityName}SafeByteArray());
    }

    @Test
    void testInputNull() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNull(${prefixUtilityName}SafeByteArray.process(null));
    }

    @Test
    void testInputNotNull() {
        byte[] byteArray = new byte[10];
        byte[] result = ${prefixUtilityName}SafeByteArray.process(byteArray);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotSame(byteArray, result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(byteArray, result)<#else>assertTrue(java.util.Arrays.equals(byteArray, result))</#if>;
    }
}
