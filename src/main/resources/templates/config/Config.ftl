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
    
    <tx:annotation-driven transaction-manager="transactionManager"/>

    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="${dataSource}"/>
    </bean>

    <bean id="${jdbcTemplate}" name="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate" >
        <property name="dataSource" ref="${dataSource}" />
    </bean>

    <context:component-scan base-package="${javaPackage}.repository, ${javaPackage}.table, ${javaPackage}.table.column, ${javaPackage}.mapper"/>

</beans>
