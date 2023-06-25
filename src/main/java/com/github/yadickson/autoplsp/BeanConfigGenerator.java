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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;

/**
 * Java Configuration file generator.
 *
 * @author Yadickson Soto
 */
public final class BeanConfigGenerator extends TemplateGenerator {

    private final String javaPackage;
    private final String fileName;
    private final String folderNameGenerator;
    private final String configFolderName;

    private final Boolean credentialsDataSource;

    private static final String JAVA_PACKAGE_NAME = "javaPackage";
    private static final String CREDENTIALS_DATA_SOURCE = "credentialsDataSource";
    private static final String JAVA_FILE_NAME = "javaFileName";
    private static final String TRANSACTION_NAME = "transactionName";
    private static final String TRANSACTION_QUALITY_NAME = "transactionQualityName";
    private static final String CONFIG_FOLDER_NAME = "configFolderName";

    private static final Map<String, Object> INPUT_MAP = new HashMap<String, Object>();

    /**
     * Class constructor
     *
     * @param outputDir Output resource directory
     * @param javaPackage Java package name
     * @param transactionName transaction name
     * @param transactionQualityName transaction quality name
     * @param dataSource Datasource name
     * @param jdbcTemplate JdbcTemplate name
     * @param jndi JNDI datasource name
     * @param folderNameGenerator folder name spring resource directory
     * @param outputFileName Spring configuration file name
     * @param procedures procedure list
     */
    public BeanConfigGenerator(String outputDir,
                               final String javaPackage,
                               final String transactionName,
                               final Boolean transactionQualityName,
                               final String dataSource,
                               final String jdbcTemplate,
                               final String jndi,
                               final Boolean credentialsDataSource,
                               final String folderNameGenerator,
                               final String outputFileName,
                               final String configFolderName,
                               final List<Procedure> procedures) {
        super(outputDir, null);
        this.javaPackage = javaPackage;
        this.fileName = outputFileName;
        this.folderNameGenerator = folderNameGenerator;
        this.credentialsDataSource = credentialsDataSource;
        this.configFolderName = configFolderName;

        INPUT_MAP.put(JAVA_PACKAGE_NAME, javaPackage);
        INPUT_MAP.put(CREDENTIALS_DATA_SOURCE, credentialsDataSource);
        INPUT_MAP.put(JAVA_FILE_NAME, fileName);
        INPUT_MAP.put(TRANSACTION_NAME, transactionName);
        INPUT_MAP.put(TRANSACTION_QUALITY_NAME, transactionQualityName);
        INPUT_MAP.put("dataSource", dataSource);
        INPUT_MAP.put("jdbcTemplate", jdbcTemplate);
        INPUT_MAP.put("jndi", jndi);
        INPUT_MAP.put("procedures", procedures);
        INPUT_MAP.put(CONFIG_FOLDER_NAME, configFolderName);
    }

    /**
     * Create spring configuration file from template
     *
     * @throws BusinessException Launch if the generation process throws an
     * error
     */
    public void process() throws BusinessException {
        LoggerManager.getInstance().info("[BeanConfigGenerator] Process spring template config");
        createTemplate(INPUT_MAP, File.separatorChar + "config" + File.separatorChar + "BeanConfig.ftl", getFileNamePath(folderNameGenerator + File.separatorChar + configFolderName, fileName + ".java"));
    }

    /**
     * Get output directory path
     *
     * @param path path
     * @return full directory path
     * @exception BusinessException if error
     */
    @Override
    protected String getOutputPath(String path) throws BusinessException {
        return super.getOutputPath(File.separatorChar + folderNameGenerator + File.separatorChar + getDirectoryPackage() + File.separatorChar + path);
    }

    private String getDirectoryPackage() {
        return this.javaPackage.replace('.', File.separatorChar);
    }

}
