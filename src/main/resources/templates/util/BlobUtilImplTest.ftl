package ${javaPackage}.${utilFolderName};
<#assign importList = []>
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
class ${prefixUtilityName}BlobUtilImplTest {

    private ${prefixUtilityName}BlobUtil blobUtil;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        blobUtil = new ${prefixUtilityName}BlobUtilImpl();
    }

    @Test
    void testInputNull() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(blobUtil.process(null));
    }
}
