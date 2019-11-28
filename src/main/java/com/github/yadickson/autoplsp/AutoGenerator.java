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

import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.DriverConnection;
import com.github.yadickson.autoplsp.db.GeneratorFactory;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.project.MavenProject;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import com.github.yadickson.autoplsp.db.Generator;
import com.github.yadickson.autoplsp.db.common.Table;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import com.github.yadickson.autoplsp.util.ProcedureSort;
import java.sql.Connection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;
import org.apache.maven.model.Resource;

import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

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
            required = true)
    private String driver;

    /**
     * Database url connection string.
     */
    @Parameter(
            property = "autoplsp.connectionString",
            required = true)
    private String connectionString;

    /**
     * Database username.
     */
    @Parameter(
            property = "autoplsp.user",
            required = true)
    private String user;

    /**
     * Database password.
     */
    @Parameter(
            property = "autoplsp.pass",
            required = true)
    private String pass;

    /**
     * Output source directory.
     */
    @Parameter(
            defaultValue = "${project.build.directory}/generated-sources",
            readonly = true,
            required = false)
    private File outputDirectory;

    /**
     * Output resource directory.
     */
    @Parameter(
            defaultValue = "${project.build.directory}/generated-resources",
            readonly = true,
            required = false)
    private File outputDirectoryResource;

    /**
     * Output folder name directory.
     */
    @Parameter(
            defaultValue = "autosp-generator",
            readonly = true,
            required = false)
    private String folderNameGenerator;

    /**
     * Output folder name spring resource directory.
     */
    @Parameter(
            defaultValue = "database",
            readonly = true,
            required = false)
    private String folderNameResourceGenerator;

    /**
     * Spring configuration file name.
     */
    @Parameter(
            defaultValue = "${project.artifactId}-context.xml",
            readonly = true,
            required = false)
    private String outputConfigFileName;

    /**
     * Java package name.
     */
    @Parameter(
            readonly = true,
            required = true)
    private String javaPackageName;

    /**
     * Datasource name.
     */
    @Parameter(
            property = "autoplsp.javaDataSourceName",
            readonly = true,
            required = true)
    private String javaDataSourceName;

    /**
     * JdbcTemplate name.
     */
    @Parameter(
            property = "autoplsp.javaJdbcTemplateName",
            defaultValue = "jdbcTemplate",
            readonly = true,
            required = false)
    private String javaJdbcTemplateName;

    /**
     * Array suffix name.
     */
    @Parameter(
            property = "autoplsp.arraySuffix",
            defaultValue = "Table",
            readonly = true,
            required = false)
    private String arraySuffix;

    /**
     * Object suffix name.
     */
    @Parameter(
            property = "autoplsp.objectSuffix",
            defaultValue = "Object",
            readonly = true,
            required = false)
    private String objectSuffix;

    /**
     * Table definition suffix name.
     */
    @Parameter(
            property = "autoplsp.tableSuffix",
            defaultValue = "Td",
            readonly = true,
            required = false)
    private String tableSuffix;

    /**
     * JNDI datasource name.
     */
    @Parameter(
            property = "autoplsp.jndiDataSourceName",
            readonly = true,
            required = true)
    private String jndiDataSourceName;

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
            defaultValue = "OUT_RETURN_CODE",
            readonly = true,
            required = false)
    private String outParameterCode;

    /**
     * Output parameter message.
     */
    @Parameter(
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
            defaultValue = "UTF-8",
            readonly = true,
            required = false)
    private String encode;

    /**
     * Json non-null support.
     */
    @Parameter(
            property = "autoplsp.jsonNonNull",
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
            defaultValue = "true",
            readonly = true,
            required = false)
    private String addPackagename;

    /**
     * Add lombok support.
     */
    @Parameter(
            property = "autoplsp.lombok",
            defaultValue = "false",
            readonly = true,
            required = false)
    private String lombok;

    /**
     * Add header support.
     */
    @Parameter(
            property = "autoplsp.header",
            defaultValue = "true",
            readonly = true,
            required = false)
    private String header;

    /**
     * Add serialization support.
     */
    @Parameter(
            property = "autoplsp.serialization",
            defaultValue = "true",
            readonly = true,
            required = false)
    private String serialization;

    /**
     * Maven execute method.
     *
     * @throws MojoExecutionException Launch if the generation process throws an
     * error
     */
    @Override
    public void execute() throws MojoExecutionException {

        getLog().info("[AutoGenerator] Driver: " + driver);
        getLog().info("[AutoGenerator] ConnectionString: " + connectionString);
        getLog().info("[AutoGenerator] User: " + user);
        getLog().info("[AutoGenerator] Pass: ****");
        getLog().info("[AutoGenerator] FolderNameGenerator: " + folderNameGenerator);
        getLog().info("[AutoGenerator] FolderNameResourceGenerator: " + folderNameResourceGenerator);
        getLog().info("[AutoGenerator] OutputDirectory: " + outputDirectory.getPath());
        getLog().info("[AutoGenerator] OutputDirectoryResource: " + outputDirectoryResource.getPath());
        getLog().info("[AutoGenerator] OutputConfigFileName: " + outputConfigFileName);
        getLog().info("[AutoGenerator] JavaPackageName: " + javaPackageName);
        getLog().info("[AutoGenerator] JavaDataSourceName: " + javaDataSourceName);
        getLog().info("[AutoGenerator] JavaJdbcTemplateName: " + javaJdbcTemplateName);
        getLog().info("[AutoGenerator] JNDIDataSourceName: " + jndiDataSourceName);
        getLog().info("[AutoGenerator] ArraySuffix: " + arraySuffix);
        getLog().info("[AutoGenerator] ObjectSuffix: " + objectSuffix);
        getLog().info("[AutoGenerator] TableSuffix: " + tableSuffix);
        getLog().info("[AutoGenerator] Encode: " + encode);
        getLog().info("[AutoGenerator] JsonNonNull: " + jsonNonNull);
        getLog().info("[AutoGenerator] AddPackagename: " + addPackagename);
        getLog().info("[AutoGenerator] Lombok: " + lombok);
        getLog().info("[AutoGenerator] Header: " + header);
        getLog().info("[AutoGenerator] Serialization: " + serialization);
        getLog().info("[AutoGenerator] OutParameterCode: " + outParameterCode);
        getLog().info("[AutoGenerator] OutParameterMessage: " + outParameterMessage);

        if (!outputDirectory.exists() && !outputDirectory.mkdirs()) {
            throw new MojoExecutionException("Fail make " + outputDirectory + " directory.");
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

        Map<String, ConfigMapper> mappers = new HashMap<String, ConfigMapper>();

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
                String[] parts = StringUtils.split(mapper, ",");

                if (parts.length < 3) {
                    continue;
                }

                int i = 0;
                ConfigMapper objMapper = new ConfigMapper();

                for (String part : parts) {
                    switch (i++) {
                        case 0:
                            objMapper.setProcedureName(part.toUpperCase().trim());
                            break;
                        case 1:
                            objMapper.setCursorName(part.toUpperCase().trim());
                            break;
                        default:
                            objMapper.getKeys().add(part.toUpperCase().trim());
                            break;
                    }
                }

                mappers.put(
                        objMapper.getProcedureName()
                        + ":"
                        + objMapper.getCursorName(),
                        objMapper
                );
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
                    folderNameGenerator,
                    javaPackageName,
                    javaDataSourceName,
                    javaJdbcTemplateName,
                    encode,
                    jsonNonNull.equalsIgnoreCase("true"),
                    lombok.equalsIgnoreCase("true"),
                    header.equalsIgnoreCase("true"),
                    serialization.equalsIgnoreCase("true"),
                    outParameterCode,
                    outParameterMessage,
                    generator.getName(),
                    connManager.getVersion()
            );

            List<Table> tables = generator.findTables(connection, tableSuffix);
            List<Table> fullTables = new ArrayList<Table>();

            for (Table table : tables) {

                String name = table.getName();

                boolean match = patternT.matcher(name).matches();

                if (match) {
                    LoggerManager.getInstance().info("[AutoGenerator] Process table name: " + table.getName());
                    fullTables.add(table);
                }
            }

            //List<com.github.yadickson.autoplsp.db.common.Parameter> mList;
            //mList = generator.processMapper(spList, mappers);
            template.processProcedures(spList);
            template.processObjects(objects);
            template.processTables(fullTables);
            //template.processMappers(mList);

            ConfigGenerator config;
            config = new ConfigGenerator(
                    outputDirectoryResource.getPath(),
                    javaPackageName,
                    javaDataSourceName,
                    javaJdbcTemplateName,
                    jndiDataSourceName,
                    folderNameResourceGenerator,
                    outputConfigFileName
            );

            config.process();

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
