package ${javaPackage}.repository.sp;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class ${proc.className}SPTest {

    @Mock
    private javax.sql.DataSource dataSource;

    @Mock
    private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    @Test
    public void testDataSource() throws java.sql.SQLException {

        Mockito.when(jdbcTemplate.getDataSource()).thenReturn(dataSource);

        ${proc.className}SPImpl sp = new ${proc.className}SPImpl(jdbcTemplate);

        Assert.assertSame(dataSource, sp.getJdbcTemplate().getDataSource());

        Assert.assertEquals("{<#if proc.function>? = </#if>call ${proc.fullName}(<#list proc.parameters as parameter><#if parameter.position != 0>?<#sep>, </#sep></#if></#list>)}", sp.getCallString());
    }
}
