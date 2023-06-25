package ${javaPackage}.${utilFolderName};
<#assign importList = ["java.util.Date", "com.github.javafaker.Faker"]>
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
class ${prefixUtilityName}DateUtilImplTest {

    private Faker faker;

    private ${prefixUtilityName}DateUtil dateUtil;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
        dateUtil = new ${prefixUtilityName}DateUtilImpl();
    }

    @Test
    void should_check_input_null() {
        Object result = dateUtil.process(null);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNull(result);
    }

    @Test
    void should_check_response() {
        Date date = faker.date().birthday();

        Object result = dateUtil.process(date);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
<#if driverName != 'oracle' >
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(result, date);
</#if>
    }
}
