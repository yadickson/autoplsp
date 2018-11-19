# Maven Auto PLSQL/SP Generator Plugin

[![TravisCI Status][travis-image]][travis-url]
[![Quality Gate][sonar-status-image]][sonar-url]
[![Codecov Status][codecov-image]][codecov-url]
[![Dependency Status][versioneye-image]][versioneye-url]
[![Central OSSRH][oss-nexus-image]][oss-nexus-url]
[![Central Maven][central-image]][central-url]


Maven plugin to generate Java classes from StoredProcedure and Functions in Database

## Support

- Oracle DataBase 11g and 12c
- Basic PostgresSQL
- Basic SQL Server (Tested 2017, Driver jTDS)
- Java >= 1.6
- Spring Framework 4
- Auto package name detection
- Configuration file generation for Spring
- Use output parameters to evaluate process
- Transaction annotation
- Command line for driver, user, pass and connectionString parameters

[Examples](https://github.com/yadickson/autoplsp-examples)

# Oracle

- Procedures
- Functions
- Numerics (NUMBER, DECIMAL, INTEGER, FLOAT, REAL, DEC, INT, SMALLINT, BINARY_DOUBLE, BINARY_FLOAT)
- Texts (CHAR, NCHAR, VARCHAR, VARCHAR2, NVARCHAR2)
- Lobs (CLOB, NCLOB, BLOB)
- Time (DATE, TIMESTAMP)
- ROWID and UROWID
- REF CURSOR (only output)
- TYPE OBJECT (only input)
- TYPE TABLE [NATIVE] (only input)
- TYPE TABLE [TYPE OBJECT] (only input)

# PostgresSQL

- Procedures
- Functions
- Numerics (INTEGER, REAL)
- Texts (TEXT, CHARACTER)
- Working in progress

# SQL Server

- Procedures
- Functions
- Numerics (INT, BIGINT, SMALLINT, TINYINT, DECIMAL, NUMERIC, FLOAT, REAL, BIT, MONEY, SMALLMONEY)
- Texts (CHAR, NCHAR, VARCHAR, NVARCHAR, TEXT, NTEXT)
- Binaries (BINARY, VARBINARY, IMAGE)
- Time (DATE, TIME, DATETIME, DATETIME2, DATETIMEOFFSET, SMALLDATETIME)
- REF CURSOR (Not supported)
- Working in progress

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
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.5</version>
    <scope>provided</scope>
</dependency>
```
## Oracle
```
<dependency>
    <groupId>com.jslsolucoes</groupId>
    <artifactId>ojdbc6</artifactId>
    <version>11.2.0.1.0</version>
    <scope>provided</scope>
</dependency>
```
## PostgreSQL
```
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.1.4</version>
    <scope>provided</scope>
</dependency>
```
## SQL Server
```
<dependency>
    <groupId>net.sourceforge.jtds</groupId>
    <artifactId>jtds</artifactId>
    <version>1.3.1</version>
    <scope>provided</scope>
</dependency>
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
                <objectSuffix>Object</objectSuffix>
                <arraySuffix>Array</arraySuffix>
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
            <groupId>...driver..</groupId>
            <artifactId>..driver..</artifactId>
            <version>..version..</version>
        </dependency>
    </dependencies>
</plugin>
```

### driver (required)

JDBC Driver class name, examples:

> oracle.jdbc.driver.OracleDriver
> org.postgresql.Driver
> net.sourceforge.jtds.jdbc.Driver

### connectionString (required)

Database connection string, examples:

> jdbc:oracle:thin:@${host}:${port}:${db}
> jdbc:postgresql://${host}:${port}/${db}
> jdbc:jtds:sqlserver://${host}:${port}/${db}

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


# Command line support

> mvn clean package -Dautoplsp.driver=... -Dautoplsp.connectionString=... -Dautoplsp.user=... -Dautoplsp.pass=...

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
            <groupId>...driver..</groupId>
            <artifactId>..driver..</artifactId>
            <version>..version..</version>
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
            <groupId>...driver..</groupId>
            <artifactId>..driver..</artifactId>
            <version>..version..</version>
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
            <groupId>...driver..</groupId>
            <artifactId>..driver..</artifactId>
            <version>..version..</version>
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
            <groupId>...driver..</groupId>
            <artifactId>..driver..</artifactId>
            <version>..version..</version>
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

[versioneye-image]: https://www.versioneye.com/user/projects/5a1b294d0fb24f0354ff94b2/badge.svg
[versioneye-url]: https://www.versioneye.com/user/projects/5a1b294d0fb24f0354ff94b2

[vulnerabilities-image]: https://snyk.io/test/github/yadickson/autoplsp/badge.svg
[vulnerabilities-url]: https://snyk.io/test/github/yadickson/autoplsp

[jitpack-image]: https://jitpack.io/v/yadickson/autoplsp.svg
[jitpack-url]: https://jitpack.io/#yadickson/autoplsp

[oss-nexus-image]: https://img.shields.io/nexus/r/https/oss.sonatype.org/com.github.yadickson/autoplsp.svg
[oss-nexus-url]: https://oss.sonatype.org/#nexus-search;quick~autoplsp

[central-image]: https://maven-badges.herokuapp.com/maven-central/com.github.yadickson/autoplsp/badge.svg
[central-url]: https://maven-badges.herokuapp.com/maven-central/com.github.yadickson/autoplsp

[sonar-status-image]: https://sonarcloud.io/api/badges/gate?key=com.github.yadickson:autoplsp
[sonar-lines-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=ncloc
[sonar-duplicate-lines-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=duplicated_lines_density
[sonar-coverage-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=coverage
[sonar-bugs-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=bugs
[sonar-vulnerabilities-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=vulnerabilities
[sonar-code-smells-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=code_smells
[sonar-blocker-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=blocker_violations
[sonar-critical-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=critical_violations
[sonar-major-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=major_violations
[sonar-minor-image]: https://sonarcloud.io/api/badges/measure?key=com.github.yadickson:autoplsp&metric=minor_violations


[sonar-url]: https://sonarcloud.io/dashboard/index/com.github.yadickson:autoplsp
