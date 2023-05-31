package ${javaPackage}.util;

<#if junit == 'junit5'>
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
<#else>
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
</#if>

import com.github.javafaker.Faker;

<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
class ${prefixUtilityName}SafeByteArrayTest {

    Faker faker;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
    }

    @Test
    void testCreate() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(new ${prefixUtilityName}SafeByteArray());
    }

    @Test
    void testInputNull() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(${prefixUtilityName}SafeByteArray.process(null));
    }

    @Test
    void testInputNotNull() {
        byte[] byteArray = new byte[faker.random().nextInt(100)];
        byte[] result = ${prefixUtilityName}SafeByteArray.process(byteArray);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotSame(byteArray, result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(byteArray, result)<#else>assertTrue(java.util.Arrays.equals(byteArray, result))</#if>;
    }
}
