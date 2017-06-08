package org.yadickson.maven.plugins.generator;

import org.yadickson.maven.plugins.generator.db.common.Procedure;
import org.yadickson.maven.plugins.generator.db.DriverConnection;
import org.yadickson.maven.plugins.generator.db.SPGeneratorFactory;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.project.MavenProject;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.lang.StringUtils;
import org.yadickson.maven.plugins.generator.db.SPGenerator;
import org.yadickson.maven.plugins.generator.logger.LoggerManager;
import java.sql.Connection;
import java.util.regex.Pattern;
import org.apache.maven.model.Resource;

/**
 * Objetivo para generar clases java a partir de la conexion a Base de Datos
 *
 * @goal generator
 *
 * @phase generate-sources
 */
public class AutoGenerator extends AbstractMojo {

    /**
     * Proyecto maven para dar soporte a compilacion de codigo generado
     *
     * @parameter default-value="${project}"
     */
    private MavenProject project;

    /**
     * Driver a usar por el generador para la conexion a base de datos
     *
     * @parameter property="generator.driver"
     * @required
     */
    private String driver;

    /**
     * String de conexion a la base de datos
     *
     * @parameter property="generator.connectionString"
     * @required
     */
    private String connectionString;

    /**
     * Usuario de autenticacion a la base de datos
     *
     * @parameter property="generator.user"
     * @required
     */
    private String user;

    /**
     * Contrasena de autenticacion a la base de datos
     *
     * @parameter property="generator.pass"
     * @required
     */
    private String pass;

    /**
     * Directorio de salida de las clases generadas
     *
     * @parameter property="generator.outputDirectory"
     * default-value="${project.build.directory}/generated-sources"
     */
    private File outputDirectory;

    /**
     * Directorio de salida para la configuracion
     *
     * @parameter property="generator.outputDirectoryResource"
     * default-value="${project.build.directory}/generated-resources"
     */
    private File outputDirectoryResource;

    /**
     * Archivo de configuracion de salida para spring
     *
     * @parameter property="generator.outputConfigFileName"
     * default-value="${project.artifactId}.xml"
     */
    private String outputConfigFileName;

    /**
     * Nombre del paquete resultante de clases
     *
     * @parameter property="generator.javaPackageName"
     * @required
     */
    private String javaPackageName;

    /**
     * Nombre del datasource a usar en la generacion de clases
     *
     * @parameter property="generator.javaDataSourceName"
     * @required
     */
    private String javaDataSourceName;

    /**
     * Nombre del JNDI datasource a usar en ejecucion
     *
     * @parameter property="generator.jndiDataSourceName"
     * @required
     */
    private String jndiDataSourceName;

    /**
     * Expresiones para incluir en la generacion.
     *
     * @parameter alias="includes"
     */
    private String[] mIncludes;

    /**
     * Expresiones para excluir en la generacion.
     *
     * @parameter alias="excludes"
     */
    private String[] mExcludes;

    /**
     * Codigo de salida del procedimiento a buscar para evaluar
     *
     * @parameter property="generator.outParameterCode"
     * default-value="OUT_RETURN_CODE"
     */
    private String outParameterCode;

    /**
     * Mensaje de salida del procedimiento a buscar en la evaluacion
     *
     * @parameter property="generator.outParameterMessage"
     * default-value="OUT_RETURN_MSG"
     */
    private String outParameterMessage;

    /**
     * Metodo de generacion de clases para SP
     *
     * @throws MojoExecutionException Excepcion de error generica
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
     *
     * @param includes
     */
    public void setIncludes(String[] includes) {
        mIncludes = includes;
    }

    /**
     *
     * @param excludes
     */
    public void setExcludes(String[] excludes) {
        mExcludes = excludes;
    }
}
