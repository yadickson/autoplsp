# Maven Auto PLSQL/SP Generator Plugin

Maven plugin for generate Java classes from StoredProcedure and Functions of Database

## Support

- Oracle DataBase
- Java >= 1.6
- Spring Framework 4
- Auto package name detection
- Configuration file generation for Spring
- Use output parameters to evaluate process

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

```
<properties>
    <maven.compiler.source>1.6</maven.compiler.source>
    <maven.compiler.target>1.6</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

## POM dependencies

```
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
    <groupId>com.oracle</groupId>
    <artifactId>ojdbc6</artifactId>
    <version>12.1.0.2</version>
    <scope>provided</scope>
</dependency>
```

## Repository for Oracle JDBC driver and Plugin

```
    <repositories>
        <repository>
            <id>jahia</id>
            <url>http://maven.jahia.org/maven2/</url>
        </repository>
    </repositories>

    <pluginRepositories>
        <pluginRepository>
            <id>jitpack.io</id>
            <url>http://jitpack.io</url>
        </pluginRepository>
    </pluginRepositories>
```

## POM plugin config

```
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
            <groupId>com.oracle</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>12.1.0.2</version>
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

```
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
            <groupId>com.oracle</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>12.1.0.2</version>
        </dependency>
    </dependencies>
</plugin>
```

## POM Basic Configuration (include one procedure)

```
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
            <groupId>com.oracle</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>12.1.0.2</version>
        </dependency>
    </dependencies>
</plugin>
```

## POM Basic Configuration (include two procedures)

```
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
            <groupId>com.oracle</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>12.1.0.2</version>
        </dependency>
    </dependencies>
</plugin>
```

## POM Basic Configuration (exclude one procedure)

```
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
            <groupId>com.oracle</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>12.1.0.2</version>
        </dependency>
    </dependencies>
</plugin>
```

# How to evaluate result code

**Examples**

```
CREATE OR REPLACE PROCEDURE SP_...
(
    ...

    [outParameterCode] OUT NUMBER,
    [outParameterMessage] OUT VARCHAR2
)
AS
BEGIN

    ...

END SP_...;
```
```
CREATE OR REPLACE FUNCTION FN_...
(
    ...

    [outParameterCode] OUT NUMBER,
    [outParameterMessage] OUT VARCHAR2
)
RETURN NUMBER
AS
BEGIN

    ...
    
    RETURN ...;

END FN_...;
```

# Build project

```
mvn clean package install
```

# Configuration file generated

**spring/database/[outputConfigFileName]**

```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">

    <bean id="..." name="dataSource" class="org.springframework.jndi.JndiObjectFactoryBean" >
        <property name="jndiName" value="..." />
        <property name="resourceRef" value="true" />
    </bean>

    <context:component-scan base-package="..."/>

</beans>
```

# Configuration in the parent project

Add import resource in *root-context.xml*

```
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

