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
class ${proc.className}SqlQueryTest {

    @Mock
    private javax.sql.DataSource dataSource;

    @Mock
    private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    @Test
    void should_check_${proc.constantFullName?lower_case}_sql_query_data_source() throws java.sql.SQLException {

        Mockito.when(jdbcTemplate.getDataSource()).thenReturn(dataSource);

        ${proc.className}SqlQueryImpl sp = new ${proc.className}SqlQueryImpl(jdbcTemplate);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(dataSource, sp.getJdbcTemplate().getDataSource());
    }
}
