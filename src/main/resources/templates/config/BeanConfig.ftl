package ${javaPackage}.config;

import org.springframework.beans.factory.annotation.Qualifier;
<#if credentialsDataSource>
import org.springframework.beans.factory.annotation.Value;
</#if>
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
public class ${javaFileName} {

    @Bean
    @Qualifier("${dataSource}")
    public javax.sql.DataSource dataSource(<#if credentialsDataSource>@Value("spring.datasource.driver-class-name") final String driver, @Value("spring.datasource.url") final String url, @Value("spring.datasource.username") final String username, @Value("spring.datasource.password") final String password</#if>)<#if !credentialsDataSource> throws javax.naming.NamingException</#if> {
<#if !credentialsDataSource>
        org.springframework.jndi.JndiObjectFactoryBean jndiBeanDataSource = new org.springframework.jndi.JndiObjectFactoryBean();
        jndiBeanDataSource.setJndiName("${jndi}");
        jndiBeanDataSource.setResourceRef(true);
        jndiBeanDataSource.setExpectedType(javax.sql.DataSource.class);
        jndiBeanDataSource.setProxyInterface(javax.sql.DataSource.class);
        jndiBeanDataSource.afterPropertiesSet();
        return (javax.sql.DataSource) jndiBeanDataSource.getObject();
<#else>
        org.springframework.jdbc.datasource.DriverManagerDataSource driverManagerDataSource = new org.springframework.jdbc.datasource.DriverManagerDataSource();
        driverManagerDataSource.setDriverClassName(driver);
        driverManagerDataSource.setUrl(url);
        driverManagerDataSource.setUsername(username);
        driverManagerDataSource.setPassword(password);
        return driverManagerDataSource;
</#if>
    }

    @Bean
    @Qualifier("${transactionName}")
    public org.springframework.jdbc.datasource.DataSourceTransactionManager transactionManager(@Qualifier("${dataSource}") final javax.sql.DataSource dataSource) {
        return new org.springframework.jdbc.datasource.DataSourceTransactionManager(dataSource);
    }

    @Bean
    @Qualifier("${jdbcTemplate}")
    public JdbcTemplate jdbcTemplate(@Qualifier("${dataSource}") final javax.sql.DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}
