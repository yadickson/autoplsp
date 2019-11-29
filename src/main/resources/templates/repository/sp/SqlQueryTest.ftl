package ${javaPackage}.repository.sp;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
@SuppressWarnings({"rawtypes", "unchecked"})
public class ${proc.className}SqlQueryTest {

    @Mock
    private javax.sql.DataSource dataSource;

    @Mock
    private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    @Test
    public void testDataSource() throws java.sql.SQLException {

        Mockito.when(jdbcTemplate.getDataSource()).thenReturn(dataSource);

        ${proc.className}SP sp = new ${proc.className}SP(jdbcTemplate);

        Assert.assertSame(dataSource, sp.getJdbcTemplate().getDataSource());
    }
}
