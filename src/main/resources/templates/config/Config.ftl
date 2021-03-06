<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="
            http://www.springframework.org/schema/beans
            http://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/context
            http://www.springframework.org/schema/context/spring-context-4.0.xsd
            http://www.springframework.org/schema/tx
            http://www.springframework.org/schema/tx/spring-tx.xsd">

    <bean id="${dataSource}" name="dataSource" class="org.springframework.jndi.JndiObjectFactoryBean" >
        <property name="jndiName" value="${jndi}" />
        <property name="resourceRef" value="true" />
        <property name="proxyInterface" value="javax.sql.DataSource" />
    </bean>

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

    <context:component-scan base-package="${javaPackage}.**"/>

</beans>
