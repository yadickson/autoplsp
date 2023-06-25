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

<#if !credentialsDataSource>
    <bean id="${dataSource}" name="dataSource" class="org.springframework.jndi.JndiObjectFactoryBean" >
        <property name="jndiName" value="${jndi}" />
        <property name="resourceRef" value="true" />
        <property name="proxyInterface" value="javax.sql.DataSource" />
    </bean>
<#else>
	<bean id="${dataSource}" name="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
		<property name="driverClassName" value="${r"${spring.datasource.driver-class-name}"}" />
		<property name="url" value="${r"${spring.datasource.url}"}" />
		<property name="username" value="${r"${spring.datasource.username}"}" />
		<property name="password" value="${r"${spring.datasource.password}"}" />
	</bean>
</#if>

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

    <context:component-scan base-package="${javaPackage}.**"/>

</beans>
