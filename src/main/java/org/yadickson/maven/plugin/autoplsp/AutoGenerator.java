/*
 * Copyright (C) 2017 Yadickson Soto
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
package org.yadickson.maven.plugin.autoplsp;

import org.yadickson.maven.plugin.autoplsp.db.common.Procedure;
import org.yadickson.maven.plugin.autoplsp.db.DriverConnection;
import org.yadickson.maven.plugin.autoplsp.db.SPGeneratorFactory;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.project.MavenProject;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.yadickson.maven.plugin.autoplsp.db.SPGenerator;
import org.yadickson.maven.plugin.autoplsp.logger.LoggerManager;
import java.sql.Connection;
import java.util.regex.Pattern;
import org.apache.maven.model.Resource;

/**
 * Maven plugin to java classes and config spring file generator from database
 *
 * @goal generator
 *
 * @phase generate-sources
 */
public class AutoGenerator extends AbstractMojo {

    /**
     * Maven projeck link
     *
     * @parameter default-value="${project}"
     */
    private MavenProject project;

    /**
     * Driver to use in database connection
     *
     * @parameter property="generator.driver"
     * @required
     */
    private String driver;

    /**
     * Database connection string
     *
     * @parameter property="generator.connectionString"
     * @required
     */
    private String connectionString;

    /**
     * Database username
     *
     * @parameter property="generator.user"
     * @required
     */
    private String user;

    /**
     * Database password
     *
     * @parameter property="generator.pass"
     * @required
     */
    private String pass;

    /**
     * Output source directory
     *
     * @parameter property="generator.outputDirectory"
     * default-value="${project.build.directory}/generated-sources"
     */
    private File outputDirectory;

    /**
     * Output resource directory
     *
     * @parameter property="generator.outputDirectoryResource"
     * default-value="${project.build.directory}/generated-resources"
     */
    private File outputDirectoryResource;

    /**
     * Spring configuration file name
     *
     * @parameter property="generator.outputConfigFileName"
     * default-value="${project.artifactId}.xml"
     */
    private String outputConfigFileName;

    /**
     * Java package name
     *
     * @parameter property="generator.javaPackageName"
     * @required
     */
    private String javaPackageName;

    /**
     * Datasource name
     *
     * @parameter property="generator.javaDataSourceName"
     * @required
     */
    private String javaDataSourceName;

    /**
     * JNDI datasource name
     *
     * @parameter property="generator.jndiDataSourceName"
     * @required
     */
    private String jndiDataSourceName;

    /**
     * Regular expression to include procedure names
     *
     * @parameter alias="includes"
     */
    private String[] mIncludes;

    /**
     * Regular expression to exclude procedure names
     *
     * @parameter alias="excludes"
     */
    private String[] mExcludes;

    /**
     * Output parameter code to evaluate process
     *
     * @parameter property="generator.outParameterCode"
     * default-value="OUT_RETURN_CODE"
     */
    private String outParameterCode;

    /**
     * Output parameter message
     *
     * @parameter property="generator.outParameterMessage"
     * default-value="OUT_RETURN_MSG"
     */
    private String outParameterMessage;

    /**
     * Maven execute method
     *
     * @throws MojoExecutionException Launch if the generation process throws an
     * error
     */
    @Override
    public void execute() throws MojoExecutionException {

        getLog().info("Driver: " + driver);
        getLog().info("ConnectionString: " + connectionString);
        getLog().info("User: " + user);
        getLog().info("Pass: " + pass);
        getLog().info("OutputDirectory: " + outputDirectory.getPath());
        getLog().info("OutputDirectoryResource: " + outputDirectoryResource.getPath());
        getLog().info("OutputConfigFileName: " + outputConfigFileName);
        getLog().info("JavaPackageName: " + javaPackageName);
        getLog().info("JavaDataSourceName: " + javaDataSourceName);
        getLog().info("JNDIDataSourceName: " + jndiDataSourceName);
        getLog().info("OutParameterCode: " + outParameterCode);
        getLog().info("OutParameterMessage: " + outParameterMessage);

        outputDirectory.mkdirs();
        outputDirectoryResource.mkdirs();

        project.addCompileSourceRoot(outputDirectory.getPath());

        Resource resource = new Resource();
        resource.setDirectory(outputDirectoryResource.getPath());
        project.addResource(resource);

        List<String> includes = new ArrayList<String>();
        List<String> excludes = new ArrayList<String>();

        String regexInclude = ".*";
        String regexExclude = "";

        if (mIncludes != null) {
            for (String include : mIncludes) {
                includes.add("(" + include.toUpperCase() + ")");
            }
        }

        if (mExcludes != null) {
            for (String exclude : mExcludes) {
                excludes.add("(" + exclude.toUpperCase() + ")");
            }
        }

        if (!includes.isEmpty()) {
            regexInclude = StringUtils.join(includes, "|");
        }

        if (!excludes.isEmpty()) {
            regexExclude = StringUtils.join(excludes, "|");
        }

        LoggerManager.getInstance().Configure(getLog());

        LoggerManager.getInstance().info("[Generator] RegexInclude: " + regexInclude);
        LoggerManager.getInstance().info("[Generator] RegexExclude: " + regexExclude);

        DriverConnection connManager = new DriverConnection(driver, connectionString, user, pass);

        try {

            SPGenerator generator = SPGeneratorFactory.getGenaratorConnection(driver);
            Connection connection = connManager.getConnection();

            List<Procedure> list = generator.findProcedures(connection);
            List<Procedure> spList = new ArrayList<Procedure>();

            for (Procedure procedure : list) {
                Pattern patternI = Pattern.compile(regexInclude, Pattern.CASE_INSENSITIVE);
                Pattern patternE = Pattern.compile(regexExclude, Pattern.CASE_INSENSITIVE);

                String name = procedure.getName();

                boolean match = patternI.matcher(name).matches() && !patternE.matcher(name).matches();

                try {
                    if (match) {
                        LoggerManager.getInstance().info("[Generator] Process store procedure name: " + procedure.getFullName());
                        generator.fillProcedure(connection, procedure);
                        spList.add(procedure);
                        LoggerManager.getInstance().info("[Generator] Process procedure success");
                    }
                } catch (Exception ex) {
                    LoggerManager.getInstance().info("[Generator] Stop process procedure name: " + procedure.getFullName());
                    throw ex;
                }
            }

            JavaGenerator template = new JavaGenerator(outputDirectory.getPath(),
                    javaPackageName, javaDataSourceName,
                    outParameterCode, outParameterMessage);

            template.process(spList);

            ConfigGenerator config = new ConfigGenerator(outputDirectoryResource.getPath(), javaPackageName, javaDataSourceName, jndiDataSourceName, outputConfigFileName);
            config.process();

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
        mIncludes = includes;
    }

    /**
     * Setter the excludes from configuracion
     *
     * @param excludes The excludes from configuracion
     */
    public void setExcludes(String[] excludes) {
        mExcludes = excludes;
    }
}
