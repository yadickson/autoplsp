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

import org.yadickson.maven.plugin.autoplsp.logger.LoggerManager;
import java.io.File;

import java.util.HashMap;
import java.util.Map;

/**
 * Configuration spring file generator
 *
 * @author Yadickson Soto
 */
public class ConfigGenerator extends TemplateGenerator {

    private final String fileName;
    private final String javaPackage;
    private final String dataSource;
    private final String jndi;

    /**
     * Class constructor
     *
     * @param outputDir Output resource directory
     * @param packageName Java package name
     * @param dataSource Datasource name
     * @param jndi JNDI datasource name
     * @param outputFileName Spring configuration file name
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
     * Create spring configuration file from template
     *
     * @throws Exception Launch if the generation process throws an error
     */
    public void process() throws Exception {
        LoggerManager.getInstance().info("[ConfigGenerator] Process spring template config");
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("javaPackage", javaPackage);
        input.put("dataSource", dataSource);
        input.put("jndi", jndi);

        createTemplate(input, "/config/Config.ftl", getFileNamePath("database", fileName));
    }

    /**
     * Get output directory path
     * @param path path
     * @return full directory path
     */
    @Override
    protected String getOutputPath(String path) {
        return super.getOutputPath("spring" + File.separatorChar + path);
    }

}
