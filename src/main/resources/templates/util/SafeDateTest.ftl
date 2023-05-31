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
class ${prefixUtilityName}SafeDateTest {

    Faker faker;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
    }

    @Test
    void testCreate() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(new ${prefixUtilityName}SafeDate());
    }

    @Test
    void testInputNull() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNull(${prefixUtilityName}SafeDate.process(null));
    }

    @Test
    void testInputNotNull() {
        java.util.Date date = faker.date().birthday();
        java.util.Date result = ${prefixUtilityName}SafeDate.process(date);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotSame(date, result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(date, result);
    }
}
