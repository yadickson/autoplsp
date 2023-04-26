# Maven Auto PLSQL/SP Generator Plugin

[![TravisCI Status][travis-image]][travis-url]
[![Codecov Status][codecov-image]][codecov-url]
[![Central OSSRH][oss-nexus-image]][oss-nexus-url]
[![Central Maven][central-image]][central-url]


Maven plugin to generate Java classes from StoredProcedure and Functions in Database

## Support

- Oracle DataBase 11g and 12c
- Basic PostgresSQL
- Basic SQL Server (Tested 2017, Driver jTDS)
- Java >= 8
- Spring Framework >= 4
- Auto package name detection
- Configuration file generation for Spring
- Use output parameters to evaluate process
- Transaction annotation
- Command line for all parameters
- JsonNonNull support
- Parameter IN builder support
- Disable documentation generation
- JUnit5 support

[Examples](https://github.com/yadickson/autoplsp-examples)

## Oracle

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

## PostgresSQL

- Procedures
- Functions
- Numerics (INTEGER, REAL)
- Texts (TEXT, CHARACTER)
- Working in progress

## SQL Server

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
    <maven.compiler.source>1.7</maven.compiler.source>
    <maven.compiler.target>1.7</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

## POM dependencies

```xml

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
    <version>5.3.26</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.3.26</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>5.3.26</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>log4j-over-slf4j</artifactId>
    <version>1.7.36</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>javax.annotation</groupId>
    <artifactId>javax.annotation-api</artifactId>
    <version>1.3.2</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>commons-lang</groupId>
    <artifactId>commons-lang</artifactId>
    <version>2.6</version>
    <scope>provided</scope>
</dependency>

<!-- Unit Testing -->
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <version>5.8.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <version>5.8.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.junit.vintage</groupId>
    <artifactId>junit-vintage-engine</artifactId>
    <version>5.8.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-params</artifactId>
    <version>5.8.2</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>4.6.1</version>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-junit-jupiter</artifactId>
    <version>4.6.1</version>
    <scope>test</scope>
</dependency>
```
## Oracle
```xml
<dependency>
    <groupId>com.oracle.database.jdbc</groupId>
    <artifactId>ojdbc8</artifactId>
    <version>23.2.0.0</version>
    <scope>provided</scope>
</dependency>
```
## PostgreSQL
```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.1.4</version>
    <scope>provided</scope>
</dependency>
```
## SQL Server
```xml
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
        </execution>
    </executions>
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
        <outputDirectory>...</outputDirectory>
        <outputDirectoryResource>...</outputDirectoryResource>
        <folderNameGenerator>...</folderNameGenerator>
        <folderNameResourceGenerator>...</folderNameResourceGenerator>
        <outputConfigFileName>...</outputConfigFileName>
        <outParameterCode>...</outParameterCode>
        <outParameterMessage>...</outParameterMessage>
        <javaPackageName>...</javaPackageName>
        <jsonNonNull>...</jsonNonNull>
        <lombok>true/false</lombok>
        <header>true/false</header>
        <builder>true/false</builder>
        <serialization>true/false</serialization>
        <test>true/false</test>
        <junit>junit4/junit5</junit>
        <position>true/false</position>
        <diamond>true/false</diamond>
        <documentation>true/false</documentation>
        <logger>true/false</logger>
        <fullConstructor>true/false</fullConstructor>
        <includes>
            <param>...</param>
            <param>...</param>
        </includes>
        <excludes>
            <param>...</param>
            <param>...</param>
        </excludes>
        <mappers>
            <param>...</param>
            <param>...</param>
        </mappers>
        <resultset>
            <param>...</param>
            <param>...</param>
        </resultset>
        <tables>
            <param>...</param>
            <param>...</param>
        </tables>
    </configuration>
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

```
oracle.jdbc.driver.OracleDriver
```
```
org.postgresql.Driver
```
```
net.sourceforge.jtds.jdbc.Driver
```

### connectionString (required)

Database connection string, examples:

```
jdbc:oracle:thin:@${host}:${port}:${db}
```
```
jdbc:postgresql://${host}:${port}/${db}
```
```
jdbc:jtds:sqlserver://${host}:${port}/${db}
```

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

Default value **${project.artifactId}-context.xml**

### outParameterCode (optional - default value OUT_RETURN_CODE)

Output parameter code to evaluate process.

If code is Zero (O), **OK**

If code is not Zero (0), **throw SQLException (OUT_RETURN_MSG, null, OUT_RETURN_CODE)**

### outParameterMessage (optional - default value OUT_RETURN_MSG)

Output parameter message.

### javaPackageName (required)

Package name for Java classes

### jsonNonNull (optional - default value false) (since 1.7.12)

Add @JsonInclude(JsonInclude.Include.NON_NULL) annotation.

### includes -> include sp (optional, default .*)

Regular expression to include procedure and functions names, example SP_YES.*

### excludes -> exclude sp (optional, default none)

Regular expression to exclude procedure and functions names, example SP_NOT.*

### resultset -> resultset (optional, default .*)

Regular expression to find resultset on procedure and functions names, example SP_YES.*

### test (true/false) (default false)

Include test folder and test classes

### junit (junit4/junit5) (default junit5)

Include junit configuration

### header (true/false) (default true)

Add header documentation class

### documentation (true/false) (default true)

Add documentation classes

### builder (true/false) (default false)

Include builder parameters only for IN

### lombok (true/false) (default false)

Include lombok definitions

### serialization (true/false)

Add serialization class support


# Command line support

> mvn clean package -Dautoplsp.driver=... -Dautoplsp.connectionString=... -Dautoplsp.user=... -Dautoplsp.pass=... -Dautoplsp.<others>=...

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
                    <param>SP_ADD_VALUES</param>
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
                    <param>SP_ADD_VALUES</param>
                    <param>SP_SUB_VALUES</param>
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

# Example with unit test and persistence into src folder 

```
            <plugin>
                <groupId>com.github.yadickson</groupId>
                <artifactId>autoplsp</artifactId>
                <version>1.8.0</version>
                <configuration>
                    <driver>oracle.jdbc.driver.OracleDriver</driver>
                    <javaDataSourceName>...</javaDataSourceName>
                    <jndiDataSourceName>...</jndiDataSourceName>
                    <outParameterCode>...</outParameterCode>
                    <outParameterMessage>...</outParameterMessage>
                    <javaPackageName>plsql</javaPackageName>
                    <outputDirectory>src/main/java</outputDirectory>
                    <outputDirectoryResource>src/main/resources</outputDirectoryResource>
                    <folderNameGenerator>.</folderNameGenerator>
                    <folderNameResourceGenerator>.</folderNameResourceGenerator>
                    <jsonNonNull>false</jsonNonNull>
                    <lombok>false</lombok>
                    <header>false</header>
                    <builder>true</builder>
                    <serialization>false</serialization>
                    <test>true</test>
                    <junit>junit5</junit>
                    <position>true</position>
                    <diamond>true</diamond>
                    <documentation>false</documentation>
                    <logger>false</logger>
                    <fullConstructor>true</fullConstructor>
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>...</groupId>
                        <artifactId>...</artifactId>
                        <version>...</version>
                    </dependency>
                </dependencies>
            </plugin>
```

# Run command line to persistence into src folder

```
$ mvn clean autoplsp:generator -Dautoplsp.user=... -Dautoplsp.pass=... -Dautoplsp.connectionString=jdbc:oracle:thin:@...:...:...
```

# Run test

```
$ mvn test
```


[travis-image]: https://travis-ci.org/yadickson/autoplsp.svg?branch=master
[travis-url]: https://travis-ci.org/yadickson/autoplsp

[codecov-image]: https://codecov.io/gh/yadickson/autoplsp/branch/master/graph/badge.svg?branch=master
[codecov-url]: https://codecov.io/gh/yadickson/autoplsp

[oss-nexus-image]: https://img.shields.io/nexus/r/https/oss.sonatype.org/com.github.yadickson/autoplsp.svg
[oss-nexus-url]: https://oss.sonatype.org/#nexus-search;quick~autoplsp

[central-image]: https://maven-badges.herokuapp.com/maven-central/com.github.yadickson/autoplsp/badge.svg
[central-url]: https://maven-badges.herokuapp.com/maven-central/com.github.yadickson/autoplsp
