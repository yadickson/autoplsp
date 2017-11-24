# Maven Auto PLSQL/SP Generator Plugin

[![TravisCI Status][travis-image]][travis-url]
[![Codecov Status][codecov-image]][codecov-url]
[![Release][jitpack-image]][jitpack-url]
[![Central OSSRH][oss-nexus-image]][oss-nexus-url]

Maven plugin to generate Java classes from StoredProcedure and Functions in Database

## Support

- Oracle DataBase 11g and 12c
- Java >= 1.6
- Spring Framework 4
- Auto package name detection
- Configuration file generation for Spring
- Use output parameters to evaluate process
- Transaction annotation

## Native type support

- NUMERIC
- DECIMAL
- FLOAT
- CHAR
- VARCHAR2
- CLOB
- BLOB
- DATE
- TIMESTAMP
- ROWID

## Complex type support

- REF CURSOR (only output)
- TYPE OBJECT (only input)
- TYPE TABLE [NATIVO] (only input)
- TYPE TABLE [TYPE OBJECT] (only input)


## POM properties

```xml
<properties>
    <maven.compiler.source>1.6</maven.compiler.source>
    <maven.compiler.target>1.6</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

## POM dependencies

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>4.x.x.RELEASE</version>
    <scope>provided</scope>
</dependency> 

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>4.x.x.RELEASE</version>
    <scope>provided</scope>
</dependency> 

<dependency>
    <groupId>commons-lang</groupId>
    <artifactId>commons-lang</artifactId>
    <version>2.6</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>com.jslsolucoes</groupId>
    <artifactId>ojdbc6</artifactId>
    <version>11.2.0.1.0</version>
    <scope>provided</scope>
</dependency>
```

## Repository for Maven Plugin on JitPack

```xml
<pluginRepositories>
    <pluginRepository>
        <id>jitpack.io</id>
        <url>http://jitpack.io</url>
    </pluginRepository>
</pluginRepositories>
```

## Repository for Maven Plugin on OSS Sonatype

```
<pluginRepositories>
    <pluginRepository>
        <id>oss.sonatype.org</id>
        <name>OSS Sonatype Release Repository</name>
        <url>https://oss.sonatype.org/content/repositories/releases</url>
    </pluginRepository>
</pluginRepositories>
```

## POM plugin config

```xml
<plugin>
    <groupId>com.github.yadickson</groupId>
    <artifactId>autoplsp</artifactId>
    <version>...</version>
    <executions>
        <execution>
            <goals>
                <goal>generator</goal>
            </goals>
            <configuration>
                <driver>...</driver>
                <connectionString>...</connectionString>
                <user>...</user>
                <pass>...</pass>
                <javaDataSourceName>...DataSource</javaDataSourceName>
                <javaJdbcTemplateName>...JdbcTemplate</javaJdbcTemplateName>
                <jndiDataSourceName>JDBC/...</jndiDataSourceName>
                <outputConfigFileName>...</outputConfigFileName>
                <outParameterCode>...</outParameterCode>
                <outParameterMessage>...</outParameterMessage>
                <javaPackageName>...</javaPackageName>
                <includes>
                    <include>...</include>
                    <include>...</include>
                </includes>
                <excludes>
                    <exculde>...</exculde>
                    <exculde>...</exculde>
                </excludes>
            </configuration>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.jslsolucoes</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>11.2.0.1.0</version>
        </dependency>
    </dependencies>
</plugin>
```

### driver (required)

JDBC Driver class name, example **oracle.jdbc.driver.OracleDriver**

### connectionString (required)

Database connection string, example **jdbc:oracle:thin:@host:port:service**

### user (required)

Database username

### pass (required)

Database password

### javaDataSourceName (required)

Datasource stereotype name

### javaJdbcTemplateName (optional, default jdbcTemplate)

JdbcTemplate stereotype name

### jndiDataSourceName (required)

Datasource JNDI name

### outputConfigFileName (optional)

Default value **${project.artifactId}.xml**

### outParameterCode (optional - default value OUT_RETURN_CODE)

Output parameter code to evaluate process.

If code is Zero (O), **OK**

If code is not Zero (0), **throw SQLException (OUT_RETURN_MSG, null, OUT_RETURN_CODE)**

### outParameterMessage (optional - default value OUT_RETURN_MSG)

Output parameter message.

### javaPackageName (required)

Package name for Java classes

### includes -> include (optional)

Regular expression to include procedure and functions names, example SP_YES.*

### excludes -> exclude (optional)

Regular expression to exclude procedure and functions names, example SP_NOT.*


## POM Basic Configuration (include all procedure and function)

```xml
<plugin>
    <groupId>com.github.yadickson</groupId>
    <artifactId>autoplsp</artifactId>
    <version>...</version>
    <executions>
        <execution>
            <goals>
                <goal>generator</goal>
            </goals>
            <configuration>
                <driver>...</driver>
                <connectionString>...</connectionString>
                <user>...</user>
                <pass>...</pass>
                <javaDataSourceName>...DataSource</javaDataSourceName>
                <jndiDataSourceName>JDBC/...</jndiDataSourceName>
                <javaPackageName>...</javaPackageName>
            </configuration>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.jslsolucoes</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>11.2.0.1.0</version>
        </dependency>
    </dependencies>
</plugin>
```

## POM Basic Configuration (include one procedure)

```xml
<plugin>
    <groupId>com.github.yadickson</groupId>
    <artifactId>autoplsp</artifactId>
    <version>...</version>
    <executions>
        <execution>
            <goals>
                <goal>generator</goal>
            </goals>
            <configuration>
                <driver>...</driver>
                <connectionString>...</connectionString>
                <user>...</user>
                <pass>...</pass>
                <javaDataSourceName>...DataSource</javaDataSourceName>
                <jndiDataSourceName>JDBC/...</jndiDataSourceName>
                <outputDirectory>...</outputDirectory>
                <javaPackageName>...</javaPackageName>
                <includes>
                    <include>SP_ADD_VALUES</include>
                </includes>
            </configuration>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.jslsolucoes</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>11.2.0.1.0</version>
        </dependency>
    </dependencies>
</plugin>
```

## POM Basic Configuration (include two procedures)

```xml
<plugin>
    <groupId>com.github.yadickson</groupId>
    <artifactId>autoplsp</artifactId>
    <version>...</version>
    <executions>
        <execution>
            <goals>
                <goal>generator</goal>
            </goals>
            <configuration>
                <driver>...</driver>
                <connectionString>...</connectionString>
                <user>...</user>
                <pass>...</pass>
                <javaDataSourceName>...DataSource</javaDataSourceName>
                <jndiDataSourceName>JDBC/...</jndiDataSourceName>
                <outputDirectory>...</outputDirectory>
                <javaPackageName>...</javaPackageName>
                <includes>
                    <include>SP_ADD_VALUES</include>
                    <include>SP_SUB_VALUES</include>
                </includes>
            </configuration>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.jslsolucoes</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>11.2.0.1.0</version>
        </dependency>
    </dependencies>
</plugin>
```

## POM Basic Configuration (exclude one procedure)

```xml
<plugin>
    <groupId>com.github.yadickson</groupId>
    <artifactId>autoplsp</artifactId>
    <version>...</version>
    <executions>
        <execution>
            <goals>
                <goal>generator</goal>
            </goals>
            <configuration>
                <driver>...</driver>
                <connectionString>...</connectionString>
                <user>...</user>
                <pass>...</pass>
                <javaDataSourceName>...DataSource</javaDataSourceName>
                <jndiDataSourceName>JDBC/...</jndiDataSourceName>
                <outputDirectory>...</outputDirectory>
                <javaPackageName>...</javaPackageName>
                <excludes>
                    <exculde>SP_DIV_VALUES</exculde>
                </excludes>
            </configuration>
        </execution>
    </executions>
    <dependencies>
        <dependency>
            <groupId>com.jslsolucoes</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>11.2.0.1.0</version>
        </dependency>
    </dependencies>
</plugin>
```

# How to evaluate result code

**Examples**

```sql
CREATE OR REPLACE PROCEDURE SP_PROCEDURE
(
    OUT_P_CODE OUT NUMBER,
    OUR_P_MSG OUT VARCHAR2
)
AS
BEGIN

    NULL;

END SP_PROCEDURE;
```
```sql
CREATE OR REPLACE FUNCTION FN_FUNCTION
(
    OUT_P_CODE OUT NUMBER,
    OUR_P_MSG OUT VARCHAR2
)
RETURN NUMBER
AS
BEGIN

    RETURN 0;

END FN_FUNCTION;
```

# Build project

```bash
mvn clean package install
```

# Configuration file generated

**spring/database/[outputConfigFileName]**

```xml
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

    <bean id="..." name="dataSource" class="org.springframework.jndi.JndiObjectFactoryBean" >
        <property name="jndiName" value="..." />
        <property name="resourceRef" value="true" />
        <property name="proxyInterface" value="javax.sql.DataSource" />
    </bean>
    
    <tx:annotation-driven transaction-manager="transactionManager"/>

    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="..."/>
    </bean>

    <bean id="..." name="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate" >
        <property name="dataSource" ref="..." />
    </bean>

    <context:component-scan base-package="....repository"/>

</beans>
```

# Configuration in the parent project

Add import resource in *root-context.xml*

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    ...

    <import resource="classpath*:spring/database/[outputConfigFileName]" />

</beans>
```

# Transaction annotation example

```Java
@Service
public class CustomServiceImpl implements CustomService {

...

    @Transactional(rollbackFor = CustomException.class)
    @Override
    public Long customMethod() throws CustomException {
        dao1.execute(...);
        dao2.execute(...);
    }
}
```

[travis-image]: https://travis-ci.org/yadickson/autoplsp.svg
[travis-url]: https://travis-ci.org/yadickson/autoplsp

[codecov-image]: https://codecov.io/gh/yadickson/autoplsp/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/yadickson/autoplsp

[jitpack-image]: https://jitpack.io/v/yadickson/autoplsp.svg
[jitpack-url]: https://jitpack.io/#yadickson/autoplsp

[oss-nexus-image]: https://img.shields.io/nexus/r/https/oss.sonatype.org/com.github.yadickson/autoplsp.svg
[oss-nexus-url]: https://oss.sonatype.org/#nexus-search;quick~autoplsp

