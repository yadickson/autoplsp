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
package com.github.yadickson.autoplsp;

import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;
import java.io.File;
import java.util.List;

import java.util.HashMap;
import java.util.Map;

/**
 * Java classes generator
 *
 * @author Yadickson Soto
 */
public class JavaGenerator extends TemplateGenerator {

    private final String javaPackage;
    private final String dataSource;
    private final String jdbcTemplate;
    private final String outParameterCode;
    private final String outParameterMessage;

    private static final String PROCEDURE_NAME = "proc";
    private static final String PARAMETER_NAME = "parameter";
    private static final String JAVA_PACKAGE_NAME = "javaPackage";
    private static final String DATA_SOURCE_NAME = "dataSource";
    private static final String JDBC_TEMPLATE_NAME = "jdbcTemplate";
    private static final String OUT_CODE_NAME = "outParameterCode";
    private static final String OUT_MESSAGE_NAME = "outParameterMessage";
    private static final String EXT_FILE = ".java";

    private static final String SOURCE_GENERATOR_PATH = File.separatorChar + "autosp-generator" + File.separatorChar;
    private static final String REPOSITORY_PATH = File.separatorChar + "repository" + File.separatorChar;
    private static final String DOMAIN_PATH = File.separatorChar + "domain" + File.separatorChar;

    /**
     * Class constructor
     *
     * @param outputDir Output resource directory
     * @param packageName Java package name
     * @param dataSource Datasource name
     * @param jdbcTemplate JdbcTemplate name
     * @param outParameterCode Output parameter code to evaluate process
     * @param outParameterMessage Output parameter message
     */
    public JavaGenerator(String outputDir,
            String packageName,
            String dataSource,
            String jdbcTemplate,
            String outParameterCode,
            String outParameterMessage) {

        super(outputDir);
        this.javaPackage = packageName;
        this.dataSource = dataSource;
        this.jdbcTemplate = jdbcTemplate;
        this.outParameterCode = outParameterCode;
        this.outParameterMessage = outParameterMessage;
    }

    /**
     * Java classes generator from template
     *
     * @param procedures The procedures to generate
     * @throws BusinessException Launch if the generation process throws an
     * error
     */
    public void process(List<Procedure> procedures) throws BusinessException {
        LoggerManager.getInstance().info("[JavaGenerator] Process template for " + procedures.size() + " procedures");

        for (Procedure procedure : procedures) {

            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + procedure.getFullName());

            processStoredProcedure(procedure);
            processStoredProcedureService(procedure);
            processStoredProcedureParameter(procedure);
            processStoredProcedureParameterRS(procedure);
            processStoredProcedureMapperRS(procedure);
            processStoredProcedureParameterObject(procedure);
            processStoredProcedureParameterArray(procedure);
        }
    }

    private void processStoredProcedure(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);

        createTemplate(input, REPOSITORY_PATH + "Procedure.ftl", getFileNamePath(getRepositoryOutputPath("sp"), procedure, "SP"));
    }

    private void processStoredProcedureService(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(DATA_SOURCE_NAME, dataSource);
        input.put(JDBC_TEMPLATE_NAME, jdbcTemplate);
        input.put(OUT_CODE_NAME, outParameterCode);
        input.put(OUT_MESSAGE_NAME, outParameterMessage);

        String procedurePath = getRepositoryOutputPath("");

        createTemplate(input, REPOSITORY_PATH + "DAO.ftl", getFileNamePath(procedurePath, procedure, "DAO"));
        createTemplate(input, REPOSITORY_PATH + "DAOImpl.ftl", getFileNamePath(procedurePath, procedure, "DAOImpl"));
    }

    private void processStoredProcedureParameter(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);

        if (!procedure.getHasInput() && !procedure.getHasOutput()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        if (procedure.getHasInput()) {
            createTemplate(input, DOMAIN_PATH + "IN.ftl", getFileNamePath(parameterPath, procedure, "IN"));
        }

        if (procedure.getHasOutput()) {
            createTemplate(input, DOMAIN_PATH + "OUT.ftl", getFileNamePath(parameterPath, procedure, "OUT"));
        }
    }

    private void processStoredProcedureParameterRS(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);

        if (!procedure.getHasResultSet()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isOutput() && param.isResultSet()) {
                input.put(PARAMETER_NAME, param);
                createTemplate(input, DOMAIN_PATH + "DataSet.ftl", getFileNamePath(parameterPath, procedure, param, "RS"));
            }
        }
    }

    private void processStoredProcedureMapperRS(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);

        if (!procedure.getHasResultSet()) {
            return;
        }

        String parameterPath = getRepositoryOutputPath("mapper");

        for (Parameter param : procedure.getParameters()) {
            if (param.isOutput() && param.isResultSet()) {
                input.put(PARAMETER_NAME, param);
                createTemplate(input, REPOSITORY_PATH + "Mapper.ftl", getFileNamePath(parameterPath, procedure, param, "RSRowMapper"));
            }
        }
    }

    private void processStoredProcedureParameterObject(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);

        if (!procedure.getHasObject()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isObject()) {
                input.put(PARAMETER_NAME, param);
                createTemplate(input, DOMAIN_PATH + "Object.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));
            }
        }
    }

    private void processStoredProcedureParameterArray(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);

        if (!procedure.getHasArray()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isArray()) {
                input.put(PARAMETER_NAME, param);
                createTemplate(input, DOMAIN_PATH + "Table.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));

                for (Parameter p : param.getParameters()) {
                    if (p.isObject()) {
                        input.put(PARAMETER_NAME, p);
                        createTemplate(input, DOMAIN_PATH + "Object.ftl", getFileNameObjectPath(parameterPath, p.getJavaTypeName()));
                    }
                }
            }
        }
    }

    /**
     * Get output directory path
     *
     * @param path path
     * @return full directory path
     */
    @Override
    protected String getOutputPath(String path) {
        return super.getOutputPath(SOURCE_GENERATOR_PATH + getDirectoryPackage() + File.separatorChar + path);
    }

    private String getRepositoryOutputPath(String path) {
        return this.getOutputPath(REPOSITORY_PATH + path);
    }

    private String getDomainOutputPath(String path) {
        return this.getOutputPath(DOMAIN_PATH + path);
    }

    private String getFileNameObjectPath(String path, String name) {
        return path + File.separatorChar + name + EXT_FILE;
    }

    private String getFileNamePath(String path, Procedure procedure, String type) {
        return path + File.separatorChar + procedure.getClassName() + type + EXT_FILE;
    }

    private String getFileNamePath(String path, Procedure procedure, Parameter param, String type) {
        return path + File.separatorChar + procedure.getClassName() + param.getPropertyName() + type + EXT_FILE;
    }

    private String getDirectoryPackage() {
        return this.javaPackage.replace('.', File.separatorChar);
    }

}
