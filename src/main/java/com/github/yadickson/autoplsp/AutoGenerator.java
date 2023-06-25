/*
 * Copyright (C) 2019 Yadickson Soto
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.github.yadickson.autoplsp;

import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.apache.maven.model.Resource;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;

import com.github.yadickson.autoplsp.db.DriverConnection;
import com.github.yadickson.autoplsp.db.Generator;
import com.github.yadickson.autoplsp.db.GeneratorFactory;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.common.Table;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import com.github.yadickson.autoplsp.util.ProcedureSort;

/**
 * Maven plugin to java classes and config spring file generator from database.
 *
 * @author Yadickson Soto
 */
@Mojo(name = "generator",
        threadSafe = true,
        defaultPhase = LifecyclePhase.GENERATE_SOURCES,
        requiresProject = true)
public class AutoGenerator extends AbstractMojo {

    /**
     * Maven projeck link.
     */
    @Parameter(defaultValue = "${project}", readonly = true)
    private MavenProject project;

    /**
     * Database driver.
     */
    @Parameter(
            property = "autoplsp.driver",
            alias = "driver",
            required = true)
    private String driver;

    /**
     * Database url connection string.
     */
    @Parameter(
            property = "autoplsp.connectionString",
            alias = "connectionString",
            required = true)
    private String connectionString;

    /**
     * Database username.
     */
    @Parameter(
            property = "autoplsp.user",
            alias = "user",
            required = true)
    private String user;

    /**
     * Database password.
     */
    @Parameter(
            property = "autoplsp.pass",
            alias = "pass",
            required = true)
    private String pass;

    /**
     * Output source directory.
     */
    @Parameter(
            property = "autoplsp.outputDirectory",
            defaultValue = "${project.build.directory}/generated-sources",
            alias = "outputDirectory",
            readonly = true,
            required = false)
    private File outputDirectory;

    /**
     * Output test directory.
     */
    @Parameter(
            property = "autoplsp.outputTestDirectory",
            alias = "outputTestDirectory",
            defaultValue = "./src/test/java",
            readonly = true,
            required = false)
    private File outputTestDirectory;

    /**
     * Output resource directory.
     */
    @Parameter(
            property = "autoplsp.outputDirectoryResource",
            alias = "outputDirectoryResource",
            defaultValue = "${project.build.directory}/generated-resources",
            readonly = true,
            required = false)
    private File outputDirectoryResource;

    /**
     * Output folder name directory.
     */
    @Parameter(
            property = "autoplsp.folderNameGenerator",
            alias = "folderNameGenerator",
            defaultValue = "autosp-generator",
            readonly = true,
            required = false)
    private String folderNameGenerator;

    /**
     * Output folder name spring resource directory.
     */
    @Parameter(
            property = "autoplsp.folderNameResourceGenerator",
            alias = "folderNameResourceGenerator",
            defaultValue = "database",
            readonly = true,
            required = false)
    private String folderNameResourceGenerator;

    /**
     * Spring configuration file name.
     */
    @Parameter(
            property = "autoplsp.outputConfigFileName",
            alias = "outputConfigFileName",
            defaultValue = "${project.artifactId}-context.xml",
            readonly = true,
            required = false)
    private String outputConfigFileName;

    /**
     * Java configuration file name.
     */
    @Parameter(
            property = "autoplsp.outputBeanConfigFileName",
            alias = "outputBeanConfigFileName",
            defaultValue = "SqlConfiguration",
            readonly = true,
            required = false)
    private String outputBeanConfigFileName;

    /**
     * SQL readme definition file name.
     */
    @Parameter(
            property = "autoplsp.outputDefinitionFileName",
            alias = "outputDefinitionFileName",
            defaultValue = "SQL.md",
            readonly = true,
            required = false)
    private String outputDefinitionFileName;
    /**
     * Java package name.
     */
    @Parameter(
            property = "autoplsp.javaPackageName",
            alias = "javaPackageName",
            defaultValue = "plsql",
            readonly = true,
            required = true)
    private String javaPackageName;

    /**
     * Transaction manager name.
     */
    @Parameter(
            property = "autoplsp.transactionName",
            alias = "transactionName",
            defaultValue = "transactionManager",
            readonly = true,
            required = false)
    private String transactionName;

    /**
     * Transaction quality name.
     */
    @Parameter(
            property = "autoplsp.transactionQualityName",
            alias = "transactionQualityName",
            defaultValue = "false",
            readonly = true,
            required = false)
    private String transactionQualityName;

    /**
     * Datasource name.
     */
    @Parameter(
            property = "autoplsp.javaDataSourceName",
            alias = "javaDataSourceName",
            defaultValue = "jdbcDataSource",
            readonly = true,
            required = true)
    private String javaDataSourceName;

    /**
     * JdbcTemplate name.
     */
    @Parameter(
            property = "autoplsp.javaJdbcTemplateName",
            alias = "javaJdbcTemplateName",
            defaultValue = "jdbcTemplate",
            readonly = true,
            required = false)
    private String javaJdbcTemplateName;

    /**
     * Array suffix name.
     */
    @Parameter(
            property = "autoplsp.arraySuffix",
            alias = "arraySuffix",
            defaultValue = "Array",
            readonly = true,
            required = false)
    private String arraySuffix;

    /**
     * Object suffix name.
     */
    @Parameter(
            property = "autoplsp.objectSuffix",
            alias = "objectSuffix",
            defaultValue = "Object",
            readonly = true,
            required = false)
    private String objectSuffix;

    /**
     * Table definition suffix name.
     */
    @Parameter(
            property = "autoplsp.tableSuffix",
            alias = "tableSuffix",
            defaultValue = "Table",
            readonly = true,
            required = false)
    private String tableSuffix;

    /**
     * JNDI datasource name.
     */
    @Parameter(
            property = "autoplsp.jndiDataSourceName",
            alias = "jndiDataSourceName",
            defaultValue = "jndiDataSource",
            readonly = true,
            required = true)
    private String jndiDataSourceName;

    /**
     * JNDI datasource name.
     */
    @Parameter(
            property = "autoplsp.credentialsDataSource",
            alias = "credentialsDataSource",
            defaultValue = "false",
            readonly = true,
            required = true)
    private String credentialsDataSource;

    /**
     * Regular expression to include procedure names.
     */
    @Parameter(
            alias = "includes",
            readonly = true,
            required = false)
    private String[] mIncludes;

    /**
     * Regular expression to exclude procedure names.
     */
    @Parameter(
            alias = "excludes",
            readonly = true,
            required = false)
    private String[] mExcludes;

    /**
     * Output parameter code to evaluate process.
     */
    @Parameter(
            property = "autoplsp.outParameterCode",
            alias = "outParameterCode",
            defaultValue = "OUT_RETURN_CODE",
            readonly = true,
            required = false)
    private String outParameterCode;

    /**
     * Output parameter value success code.
     */
    @Parameter(
            property = "autoplsp.successCode",
            alias = "successCode",
            defaultValue = "0",
            readonly = true,
            required = true)
    private String successCode;

    /**
     * Output parameter message.
     */
    @Parameter(
            property = "autoplsp.outParameterMessage",
            alias = "outParameterMessage",
            defaultValue = "OUT_RETURN_MSG",
            readonly = true,
            required = false)
    private String outParameterMessage;

    /**
     * List sp and ids to mapper.
     */
    @Parameter(
            alias = "mappers",
            readonly = true,
            required = false)
    private String[] mMappers;

    /**
     * Encode.
     */
    @Parameter(
            property = "autoplsp.encode",
            alias = "encode",
            defaultValue = "UTF-8",
            readonly = true,
            required = false)
    private String encode;

    /**
     * Json non-null support.
     */
    @Parameter(
            property = "autoplsp.jsonNonNull",
            alias = "jsonNonNull",
            defaultValue = "false",
            readonly = true,
            required = true)
    private String jsonNonNull;

    /**
     * List sp and resultset.
     */
    @Parameter(
            alias = "resultset",
            readonly = true,
            required = false)
    private String[] mResultSet;

    /**
     * List tables to build.
     */
    @Parameter(
            alias = "tables",
            readonly = true,
            required = false)
    private String[] mTables;

    /**
     * Add package name support.
     */
    @Parameter(
            property = "autoplsp.addPackagename",
            alias = "addPackagename",
            defaultValue = "true",
            readonly = true,
            required = false)
    private String addPackagename;

    /**
     * Add header support.
     */
    @Parameter(
            property = "autoplsp.header",
            alias = "header",
            defaultValue = "true",
            readonly = true,
            required = false)
    private String header;

    /**
     * Add serialization support.
     */
    @Parameter(
            property = "autoplsp.serialization",
            alias = "serialization",
            defaultValue = "false",
            readonly = true,
            required = false)
    private String serialization;

    /**
     * Add test support.
     */
    @Parameter(
            property = "autoplsp.test",
            alias = "test",
            defaultValue = "false",
            readonly = true,
            required = false)
    private String test;

    /**
     * Add junit test support.
     */
    @Parameter(
            property = "autoplsp.junit",
            alias = "junit",
            defaultValue = "junit5",
            readonly = true,
            required = false)
    private String junit;

    /**
     * Use position instance name support.
     */
    @Parameter(
            property = "autoplsp.position",
            alias = "position",
            defaultValue = "true",
            readonly = true,
            required = false)
    private String position;

    /**
     * Use diamond style.
     */
    @Parameter(
            property = "autoplsp.diamond",
            alias = "diamond",
            defaultValue = "true",
            readonly = true,
            required = false)
    private String diamond;

    /**
     * Logger support.
     */
    @Parameter(
            property = "autoplsp.logger",
            alias = "logger",
            defaultValue = "false",
            readonly = true,
            required = false)
    private String logger;

    /**
     * Full constructor support.
     */
    @Parameter(
            property = "autoplsp.fullConstructor",
            alias = "fullConstructor",
            defaultValue = "true",
            readonly = true,
            required = false)
    private String fullConstructor;

    /**
     * Driver name.
     */
    @Parameter(
            property = "autoplsp.driverVersionName",
            alias = "driverVersionName",
            defaultValue = "ojdbc6",
            readonly = true,
            required = false)
    private String driverVersionName;

    /**
     * Prefix utility name.
     */
    @Parameter(
            property = "autoplsp.prefixUtilityName",
            alias = "prefixUtilityName",
            defaultValue = "Util",
            readonly = true,
            required = false)
    private String prefixUtilityName;

    /**
     * Java 8 compatibility.
     */
    @Parameter(
            property = "autoplsp.java8",
            alias = "java8",
            defaultValue = "false",
            readonly = true,
            required = false)
    private String java8;

    /**
     * Documentation.
     */
    @Parameter(
            property = "autoplsp.documentation",
            alias = "documentation",
            defaultValue = "false",
            readonly = true,
            required = false)
    private String documentation;

    /**
     * Config folder name.
     */
    @Parameter(
            property = "autoplsp.configFolderName",
            alias = "configFolderName",
            defaultValue = "config",
            readonly = true,
            required = false)
    private String configFolderName;

    /**
     * Domain folder name.
     */
    @Parameter(
            property = "autoplsp.domainFolderName",
            alias = "domainFolderName",
            defaultValue = "domain",
            readonly = true,
            required = false)
    private String domainFolderName;

    /**
     * Cursor folder name.
     */
    @Parameter(
            property = "autoplsp.cursorFolderName",
            alias = "cursorFolderName",
            defaultValue = "cursor",
            readonly = true,
            required = false)
    private String cursorFolderName;

    /**
     * Array folder name.
     */
    @Parameter(
            property = "autoplsp.arrayFolderName",
            alias = "arrayFolderName",
            defaultValue = "array",
            readonly = true,
            required = false)
    private String arrayFolderName;

    /**
     * Object folder name.
     */
    @Parameter(
            property = "autoplsp.objectFolderName",
            alias = "objectFolderName",
            defaultValue = "config",
            readonly = true,
            required = false)
    private String objectFolderName;

    /**
     * Repository folder name.
     */
    @Parameter(
            property = "autoplsp.repositoryFolderName",
            alias = "repositoryFolderName",
            defaultValue = "repository",
            readonly = true,
            required = false)
    private String repositoryFolderName;

    /**
     * Interfaces folder name.
     */
    @Parameter(
            property = "autoplsp.interfaceFolderName",
            alias = "interfaceFolderName",
            defaultValue = "interfaces",
            readonly = true,
            required = false)
    private String interfaceFolderName;

    /**
     * Util folder name.
     */
    @Parameter(
            property = "autoplsp.utilFolderName",
            alias = "utilFolderName",
            defaultValue = "util",
            readonly = true,
            required = false)
    private String utilFolderName;

    /**
     * Util folder name.
     */
    @Parameter(
            property = "autoplsp.tableFolderName",
            alias = "tableFolderName",
            defaultValue = "table",
            readonly = true,
            required = false)
    private String tableFolderName;

    /**
     * Maven execute method.
     *
     * @throws MojoExecutionException Launch if the generation process throws an
     * error
     */
    @Override
    public void execute() throws MojoExecutionException {

        getLog().info("[AutoGenerator] Driver: " + driver);
        getLog().info("[AutoGenerator] DriverVersionName (ojdbc6/ojdbc8): " + driverVersionName);
        getLog().info("[AutoGenerator] ConnectionString: " + connectionString);
        getLog().info("[AutoGenerator] User: " + user);
        getLog().info("[AutoGenerator] Pass: ****");
        getLog().info("[AutoGenerator] FolderNameGenerator: " + folderNameGenerator);
        getLog().info("[AutoGenerator] FolderNameResourceGenerator: " + folderNameResourceGenerator);
        getLog().info("[AutoGenerator] OutputDirectory: " + outputDirectory.getPath());
        getLog().info("[AutoGenerator] OutputTestDirectory: " + outputTestDirectory.getPath());
        getLog().info("[AutoGenerator] OutputDirectoryResource: " + outputDirectoryResource.getPath());
        getLog().info("[AutoGenerator] OutputConfigFileName: " + outputConfigFileName);
        getLog().info("[AutoGenerator] OutputBeanConfigFileName: " + outputBeanConfigFileName);
        getLog().info("[AutoGenerator] OutputDefinitionFileName: " + outputDefinitionFileName);
        getLog().info("[AutoGenerator] TransactionName: " + transactionName);
        getLog().info("[AutoGenerator] TransactionQualityName: " + transactionQualityName);
        getLog().info("[AutoGenerator] JavaPackageName: " + javaPackageName);
        getLog().info("[AutoGenerator] JavaDataSourceName: " + javaDataSourceName);
        getLog().info("[AutoGenerator] JavaJdbcTemplateName: " + javaJdbcTemplateName);
        getLog().info("[AutoGenerator] JNDIDataSourceName: " + jndiDataSourceName);
        getLog().info("[AutoGenerator] CredentialsDataSource: " + credentialsDataSource);
        getLog().info("[AutoGenerator] ArraySuffix: " + arraySuffix);
        getLog().info("[AutoGenerator] ObjectSuffix: " + objectSuffix);
        getLog().info("[AutoGenerator] TableSuffix: " + tableSuffix);
        getLog().info("[AutoGenerator] Encode: " + encode);
        getLog().info("[AutoGenerator] JsonNonNull: " + jsonNonNull);
        getLog().info("[AutoGenerator] AddPackagename: " + addPackagename);
        getLog().info("[AutoGenerator] Header: " + header);
        getLog().info("[AutoGenerator] Serialization: " + serialization);
        getLog().info("[AutoGenerator] Diamond: " + diamond);
        getLog().info("[AutoGenerator] Logger: " + logger);
        getLog().info("[AutoGenerator] FullConstructor: " + fullConstructor);
        getLog().info("[AutoGenerator] Test: " + test);
        getLog().info("[AutoGenerator] JUnit (junit4/junit5): " + junit);
        getLog().info("[AutoGenerator] SuccessCode: " + successCode);
        getLog().info("[AutoGenerator] OutParameterCode: " + outParameterCode);
        getLog().info("[AutoGenerator] OutParameterMessage: " + outParameterMessage);
        getLog().info("[AutoGenerator] PrefixUtilityName: " + prefixUtilityName);
        getLog().info("[AutoGenerator] Java8: " + java8);
        getLog().info("[AutoGenerator] Documentation: " + documentation);
        getLog().info("[AutoGenerator] Config folder name: " + configFolderName);
        getLog().info("[AutoGenerator] Repository folder name: " + repositoryFolderName);
        getLog().info("[AutoGenerator] Domain folder name: " + domainFolderName);
        getLog().info("[AutoGenerator] Interfaces folder name: " + interfaceFolderName);
        getLog().info("[AutoGenerator] Object folder name: " + objectFolderName);
        getLog().info("[AutoGenerator] Array folder name: " + arrayFolderName);
        getLog().info("[AutoGenerator] Cursor folder name: " + cursorFolderName);
        getLog().info("[AutoGenerator] Util folder name: " + utilFolderName);
        getLog().info("[AutoGenerator] Table folder name: " + tableFolderName);

        if (!outputDirectory.exists() && !outputDirectory.mkdirs()) {
            throw new MojoExecutionException("Fail make " + outputDirectory + " directory.");
        }

        if (test.equalsIgnoreCase("true") && !outputTestDirectory.exists() && !outputTestDirectory.mkdirs()) {
            throw new MojoExecutionException("Fail make " + outputTestDirectory + " directory.");
        }

        if (!outputDirectoryResource.exists() && !outputDirectoryResource.mkdirs()) {
            throw new MojoExecutionException("Fail make " + outputDirectoryResource + " directory.");
        }

        project.addCompileSourceRoot(outputDirectory.getPath());

        Resource resource = new Resource();
        resource.setDirectory(outputDirectoryResource.getPath());
        project.addResource(resource);

        List<String> fillIncludes = new ArrayList<String>();
        List<String> fillExcludes = new ArrayList<String>();
        List<String> fillResultset = new ArrayList<String>();
        List<String> fillTables = new ArrayList<String>();

        Map<String, String> mappers = new HashMap<String, String>();

        String regexInclude = ".*";
        String regexExclude = "";
        String regexResultSet = "";
        String regexTable = "";

        if (mIncludes != null) {
            for (String include : mIncludes) {
                if (include != null) {
                    fillIncludes.add("(" + include.toUpperCase(Locale.ENGLISH) + ")");
                }
            }
        }

        if (mExcludes != null) {
            for (String exclude : mExcludes) {
                if (exclude != null) {
                    fillExcludes.add("(" + exclude.toUpperCase(Locale.ENGLISH) + ")");
                }
            }
        }

        if (mMappers != null) {
            for (String mapper : mMappers) {
                String[] parts = StringUtils.split(mapper, ":");

                if (parts.length < 2) {
                    continue;
                }

                mappers.put(parts[0], parts[1]);
            }
        }

        if (mResultSet != null) {
            for (String rs : mResultSet) {
                if (rs != null) {
                    fillResultset.add("(" + rs.toUpperCase(Locale.ENGLISH) + ")");
                }
            }
        }

        if (mTables != null) {
            for (String table : mTables) {
                if (table != null) {
                    fillTables.add("(" + table.toUpperCase(Locale.ENGLISH) + ")");
                }
            }
        }

        if (!fillIncludes.isEmpty()) {
            regexInclude = StringUtils.join(fillIncludes, "|");
        }

        if (!fillExcludes.isEmpty()) {
            regexExclude = StringUtils.join(fillExcludes, "|");
        }

        if (!fillResultset.isEmpty()) {
            regexResultSet = StringUtils.join(fillResultset, "|");
        }

        if (!fillTables.isEmpty()) {
            regexTable = StringUtils.join(fillTables, "|");
        }

        LoggerManager.getInstance().configure(getLog());

        LoggerManager.getInstance().info("[AutoGenerator] RegexInclude: " + regexInclude);
        LoggerManager.getInstance().info("[AutoGenerator] RegexExclude: " + regexExclude);
        LoggerManager.getInstance().info("[AutoGenerator] RegexResultSet: " + regexResultSet);
        LoggerManager.getInstance().info("[AutoGenerator] RegexTable: " + regexTable);
        LoggerManager.getInstance().info("[AutoGenerator] Mapper: " + mappers);

        DriverConnection connManager = new DriverConnection(driver, connectionString, user, pass);

        try {

            Generator generator = GeneratorFactory.getGenarator(driver);
            Connection connection = connManager.getConnection();

            List<com.github.yadickson.autoplsp.db.common.Parameter> objects;
            objects = generator.findObjects(connection, objectSuffix, arraySuffix);

            List<Procedure> list = generator.findProcedures(
                    addPackagename.equalsIgnoreCase("true"),
                    outParameterCode,
                    outParameterMessage,
                    connection);
            List<Procedure> spList = new ArrayList<Procedure>();

            Pattern patternI = Pattern.compile(regexInclude, Pattern.CASE_INSENSITIVE);
            Pattern patternE = Pattern.compile(regexExclude, Pattern.CASE_INSENSITIVE);
            Pattern patternRs = Pattern.compile(regexResultSet, Pattern.CASE_INSENSITIVE);
            Pattern patternT = Pattern.compile(regexTable, Pattern.CASE_INSENSITIVE);

            for (Procedure procedure : list) {

                String name = procedure.getName();

                boolean match = patternI.matcher(name).matches() && !patternE.matcher(name).matches();

                if (match) {
                    LoggerManager.getInstance().info("[AutoGenerator] Process store procedure name: " + procedure.getFullName());
                    generator.fillProcedure(connection, procedure, patternRs, objectSuffix, arraySuffix);
                    spList.add(procedure);
                    LoggerManager.getInstance().info("[AutoGenerator] Process procedure success");
                }
            }

            Collections.sort(spList, new ProcedureSort());

            JavaGenerator template;
            template = new JavaGenerator(
                    outputDirectory.getPath(),
                    outputTestDirectory.getPath(),
                    folderNameGenerator,
                    transactionName,
                    transactionQualityName.equalsIgnoreCase("true"),
                    javaPackageName,
                    javaDataSourceName,
                    javaJdbcTemplateName,
                    encode,
                    jsonNonNull.equalsIgnoreCase("true"),
                    header.equalsIgnoreCase("true"),
                    serialization.equalsIgnoreCase("true"),
                    test.equalsIgnoreCase("true"),
                    junit,
                    position.equalsIgnoreCase("true"),
                    diamond.equalsIgnoreCase("true"),
                    logger.equalsIgnoreCase("true"),
                    fullConstructor.equalsIgnoreCase("true"),
                    outParameterCode,
                    outParameterMessage,
                    successCode,
                    mappers,
                    generator.getName(),
                    connManager.getVersion(),
                    driverVersionName,
                    prefixUtilityName,
                    java8.equalsIgnoreCase("true"),
                    documentation.equalsIgnoreCase("true"),
                    domainFolderName,
                    repositoryFolderName,
                    interfaceFolderName,
                    objectFolderName,
                    arrayFolderName,
                    cursorFolderName,
                    utilFolderName,
                    tableFolderName
            );

            List<Table> fullTables = new ArrayList<Table>();

            if (!fillTables.isEmpty()) {

                List<Table> tables = generator.findTables(connection, tableSuffix);

                for (Table table : tables) {

                    String name = table.getName();

                    boolean match = patternT.matcher(name).matches();

                    if (match) {
                        LoggerManager.getInstance().info("[AutoGenerator] Process table name: " + table.getName());
                        fullTables.add(table);
                    }
                }
            }

            template.processProcedures(spList);
            template.processObjects(objects);
            template.processTables(fullTables);

            ConfigGenerator config;
            config = new ConfigGenerator(
                    outputDirectoryResource.getPath(),
                    javaPackageName,
                    transactionName,
                    transactionQualityName.equalsIgnoreCase("true"),
                    javaDataSourceName,
                    javaJdbcTemplateName,
                    jndiDataSourceName,
                    credentialsDataSource.equalsIgnoreCase("true"),
                    folderNameResourceGenerator,
                    outputConfigFileName,
                    spList
            );

            config.process();

            BeanConfigGenerator beanConfig;
            beanConfig = new BeanConfigGenerator(
                    outputDirectory.getPath(),
                    javaPackageName,
                    transactionName,
                    transactionQualityName.equalsIgnoreCase("true"),
                    javaDataSourceName,
                    javaJdbcTemplateName,
                    jndiDataSourceName,
                    credentialsDataSource.equalsIgnoreCase("true"),
                    folderNameGenerator,
                    outputBeanConfigFileName,
                    configFolderName,
                    spList
            );

            beanConfig.process();

            DefinitionGenerator definition;
            definition = new DefinitionGenerator(
                    outputDirectoryResource.getPath(),
                    folderNameResourceGenerator,
                    outputDefinitionFileName,
                    spList,
                    objects,
                    outParameterCode,
                    outParameterMessage,
                    successCode,
                    generator.getName(),
                    connManager.getVersion()
            );

            definition.process();

        } catch (RuntimeException ex) {
            getLog().error(ex.getMessage(), ex);
            throw new MojoExecutionException("Fail sp generator");
        } catch (Exception ex) {
            getLog().error(ex.getMessage(), ex);
            throw new MojoExecutionException("Fail sp generator");
        } finally {
            connManager.closeConnection();
        }
    }

    /**
     * Setter the includes from configuracion
     *
     * @param includes the includes from configuracion
     */
    public void setIncludes(String[] includes) {
        mIncludes = includes == null ? null : includes.clone();
    }

    /**
     * Setter the excludes from configuracion
     *
     * @param excludes The excludes from configuracion
     */
    public void setExcludes(String[] excludes) {
        mExcludes = excludes == null ? null : excludes.clone();
    }

    /**
     * Setter the mappers from configuracion
     *
     * @param mappers The mapper from configuracion
     */
    public void setMappers(String[] mappers) {
        mMappers = mappers == null ? null : mappers.clone();
    }

    /**
     * Setter the resultset from configuracion.
     *
     * @param resultset The resultset from configuracion
     */
    public void setResultset(String[] resultset) {
        mResultSet = resultset == null ? null : resultset.clone();
    }

    /**
     * Setter the tables from configuracion
     *
     * @param tables the tables to include from configuracion
     */
    public void setTables(String[] tables) {
        mTables = tables == null ? null : tables.clone();
    }
}
