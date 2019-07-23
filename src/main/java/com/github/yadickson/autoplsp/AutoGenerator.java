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
     * Spring configuration file name.
     */
    @Parameter(
            defaultValue = "${project.artifactId}.xml",
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

        List<String> includes = new ArrayList<String>();
        List<String> excludes = new ArrayList<String>();
        Map<String, ConfigMapper> mappers = new HashMap<String, ConfigMapper>();

        String regexInclude = ".*";
        String regexExclude = "";

        if (mIncludes != null) {
            for (String include : mIncludes) {
                if (include != null) {
                    includes.add("(" + include.toUpperCase(Locale.ENGLISH) + ")");
                }
            }
        }

        if (mExcludes != null) {
            for (String exclude : mExcludes) {
                if (exclude != null) {
                    excludes.add("(" + exclude.toUpperCase(Locale.ENGLISH) + ")");
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

        if (!includes.isEmpty()) {
            regexInclude = StringUtils.join(includes, "|");
        }

        if (!excludes.isEmpty()) {
            regexExclude = StringUtils.join(excludes, "|");
        }

        LoggerManager.getInstance().configure(getLog());

        LoggerManager.getInstance().info("[AutoGenerator] RegexInclude: " + regexInclude);
        LoggerManager.getInstance().info("[AutoGenerator] RegexExclude: " + regexExclude);

        DriverConnection connManager = new DriverConnection(driver, connectionString, user, pass);

        try {

            Generator generator = GeneratorFactory.getGenarator(driver);
            Connection connection = connManager.getConnection();

            List<com.github.yadickson.autoplsp.db.common.Parameter> objects;
            objects = generator.findObjects(connection, objectSuffix, arraySuffix);

            List<Table> tables = generator.findTables(connection, tableSuffix);

            List<Procedure> list = generator.findProcedures(connection);
            List<Procedure> spList = new ArrayList<Procedure>();

            for (Procedure procedure : list) {
                Pattern patternI = Pattern.compile(regexInclude, Pattern.CASE_INSENSITIVE);
                Pattern patternE = Pattern.compile(regexExclude, Pattern.CASE_INSENSITIVE);

                String name = procedure.getName();

                boolean match = patternI.matcher(name).matches() && !patternE.matcher(name).matches();

                if (match) {
                    LoggerManager.getInstance().info("[AutoGenerator] Process store procedure name: " + procedure.getFullName());
                    generator.fillProcedure(connection, procedure, objectSuffix, arraySuffix);
                    spList.add(procedure);
                    LoggerManager.getInstance().info("[AutoGenerator] Process procedure success");
                }
            }

            Collections.sort(spList, new ProcedureSort());

            JavaGenerator template;
            template = new JavaGenerator(
                    outputDirectory.getPath(),
                    javaPackageName,
                    javaDataSourceName,
                    javaJdbcTemplateName,
                    outParameterCode,
                    outParameterMessage,
                    generator.getName(),
                    connManager.getVersion()
            );

            //List<com.github.yadickson.autoplsp.db.common.Parameter> mList;
            //mList = generator.processMapper(spList, mappers);

            template.processObjects(objects);
            template.processTables(tables);
            template.processProcedures(spList);
            //template.processMappers(mList);

            ConfigGenerator config;
            config = new ConfigGenerator(
                    outputDirectoryResource.getPath(),
                    javaPackageName,
                    javaDataSourceName,
                    javaJdbcTemplateName,
                    jndiDataSourceName,
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
}
