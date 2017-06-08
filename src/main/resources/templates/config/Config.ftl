<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    <bean id="${dataSource}" name="dataSource" class="org.springframework.jndi.JndiObjectFactoryBean" >
        <property name="jndiName" value="${jndi}" />
        <property name="resourceRef" value="true" />
    </bean>

    <context:component-scan base-package="${javaPackage}"/>

</beans>
