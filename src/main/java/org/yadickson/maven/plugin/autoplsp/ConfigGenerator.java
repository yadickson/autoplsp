package org.yadickson.maven.plugin.autoplsp;

import org.yadickson.maven.plugin.autoplsp.logger.LoggerManager;
import java.io.File;

import java.util.HashMap;
import java.util.Map;

/**
 * Generador de archivos de configuracion
 *
 * @author Yadickson Soto
 */
public class ConfigGenerator extends TemplateGenerator {

    private final String fileName;
    private final String javaPackage;
    private final String dataSource;
    private final String jndi;

    /**
     *
     * @param outputDir Directorio de salida del archivo de configuracion
     * @param packageName Nombre del paquete de java
     * @param dataSource
     * @param jndi
     * @param outputFileName Nombre del archivo a generar
     */
    public ConfigGenerator(String outputDir,
            String packageName,
            String dataSource,
            String jndi,
            String outputFileName) {
        super(outputDir);
        this.fileName = outputFileName;
        this.javaPackage = packageName;
        this.dataSource = dataSource;
        this.jndi = jndi;
    }

    /**
     *
     * @throws Exception
     */
    public void process() throws Exception {
        LoggerManager.getInstance().info("[ConfigGenerator] Process spring template config");
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("javaPackage", javaPackage);
        input.put("dataSource", dataSource);
        input.put("jndi", jndi);

        createTemplate(input, "/config/Config.ftl", getFileNamePath("database", fileName));
    }

    @Override
    protected String getOutputPath(String path) {
        return super.getOutputPath("spring" + File.separatorChar + path);
    }

}
