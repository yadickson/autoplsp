package ${javaPackage}.config;

<#if transactionQualityName >
    <tx:annotation-driven />
<#else>
    <tx:annotation-driven transaction-manager="${transactionName}" />
</#if>

    <bean id="${transactionName}" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
<#if transactionQualityName >
        <qualifier value="${transactionName}"/>
</#if>
        <property name="dataSource" ref="${dataSource}"/>
    </bean>

    <bean id="${jdbcTemplate}" name="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate" >
        <property name="dataSource" ref="${dataSource}" />
    </bean>
<#list procedures as proc>

    <bean id="${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>" name="${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if>" class="${javaPackage}.repository.sp.${proc.className}<#if !proc.functionInline>SPImpl<#else>SqlQueryImpl</#if>" >
        <constructor-arg index="0" ref="${jdbcTemplate}" />
    </bean>
</#list>
