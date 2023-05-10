package ${javaPackage}.config;

import org.springframework.beans.factory.annotation.Qualifier;
<#if credentialsDataSource>
import org.springframework.beans.factory.annotation.Value;
</#if>
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

@Configuration
public class ${javaFileName} {

    @Bean
    @Qualifier("${dataSource}")
    public javax.sql.DataSource dataSource(<#if credentialsDataSource>@Value("spring.datasource.driver-class-name") final String driver, @Value("spring.datasource.url") final String url, @Value("spring.datasource.username") final String username, @Value("spring.datasource.password") final String password</#if>) {
<#if !credentialsDataSource>
        org.springframework.jndi.JndiObjectFactoryBean jndiBeanDataSource = new org.springframework.jndi.JndiObjectFactoryBean();
        jndiBeanDataSource.setJndiName("${jndi}");
        jndiBeanDataSource.setResourceRef(true);
        jndiBeanDataSource.setProxyInterface(javax.sql.DataSource.class);
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
    public org.springframework.jdbc.datasource.DataSourceTransactionManager transactionManager(@Qualifier("${dataSource}") javax.sql.DataSource dataSource) {
        return new org.springframework.jdbc.datasource.DataSourceTransactionManager(dataSource);
    }

    @Bean
    @Qualifier("${jdbcTemplate}")
    public JdbcTemplate jdbcTemplate(@Qualifier("${dataSource}") javax.sql.DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
<#list procedures as proc>

    @Bean
    @Qualifier("${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>")
    public ${javaPackage}.repository.sp.${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> bean${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>(@Qualifier("${jdbcTemplate}") JdbcTemplate jdbcTemplate) {
        return new ${javaPackage}.repository.sp.${proc.className}<#if !proc.functionInline>SPImpl<#else>SqlQueryImpl</#if>(jdbcTemplate);
    }
</#list>
}
