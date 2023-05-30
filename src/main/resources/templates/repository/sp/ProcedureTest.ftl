package ${javaPackage}.repository.sp;

import org.mockito.Mock;
import org.mockito.Mockito;

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
class ${proc.className}SPTest {

    @Mock
    private javax.sql.DataSource dataSource;

    @Mock
    private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    @Test
    void test${proc.className}SPDataSource() throws java.sql.SQLException {

        Mockito.when(jdbcTemplate.getDataSource()).thenReturn(dataSource);

        ${proc.className}SPImpl sp = new ${proc.className}SPImpl(jdbcTemplate);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(dataSource, sp.getJdbcTemplate().getDataSource());

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals("{<#if proc.function>? = </#if>call ${proc.fullName}(<#list proc.parameters as parameter><#if parameter.position != 0>?<#sep>, </#sep></#if></#list>)}", sp.getCallString());
    }
}
