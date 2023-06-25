package ${javaPackage}.${repositoryFolderName}.sp;
<#assign importList = ["org.springframework.jdbc.core.JdbcTemplate", "javax.sql.DataSource"]>
<#if junit == 'junit5'>
<#assign importList = importList + ["org.junit.jupiter.api.extension.ExtendWith", "org.mockito.junit.jupiter.MockitoExtension", "org.junit.jupiter.api.Assertions", "org.junit.jupiter.api.Test"]>
<#else>
<#assign importList = importList + ["org.junit.runner.RunWith", "org.mockito.runners.MockitoJUnitRunner", "org.junit.Assert", "org.junit.Test"]>
</#if>
<#assign importList = importList + ["org.mockito.Mock", "org.mockito.Mockito"]>

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
class ${proc.className}SqlQueryImplTest {

    @Mock
    private DataSource dataSourceMock;

    @Mock
    private JdbcTemplate jdbcTemplateMock;

    @Test
    void should_check_${proc.constantFullName?lower_case}_sql_query_data_source() {

        Mockito.when(jdbcTemplateMock.getDataSource()).thenReturn(dataSourceMock);

        ${proc.className}SqlQueryImpl sp = new ${proc.className}SqlQueryImpl(jdbcTemplateMock);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(dataSourceMock, sp.getJdbcTemplate().getDataSource());
    }
}
