package ${javaPackage}.${utilFolderName};
<#assign importList = ["com.github.javafaker.Faker", "org.mockito.Mock", "org.mockito.Mockito"]>
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
class ${prefixUtilityName}SafeByteArrayTest {

    private Faker faker;

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
