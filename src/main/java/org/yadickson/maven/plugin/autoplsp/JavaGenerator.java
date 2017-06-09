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

import org.yadickson.maven.plugin.autoplsp.db.common.Parameter;
import org.yadickson.maven.plugin.autoplsp.db.common.Procedure;
import org.yadickson.maven.plugin.autoplsp.logger.LoggerManager;
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
    private final String outParameterCode;
    private final String outParameterMessage;

    /**
     * Class constructor
     *
     * @param outputDir Output resource directory
     * @param packageName Java package name
     * @param dataSource Datasource name
     * @param outParameterCode Output parameter code to evaluate process
     * @param outParameterMessage Output parameter message
     */
    public JavaGenerator(String outputDir,
            String packageName,
            String dataSource,
            String outParameterCode,
            String outParameterMessage) {

        super(outputDir);
        this.javaPackage = packageName;
        this.dataSource = dataSource;
        this.outParameterCode = outParameterCode;
        this.outParameterMessage = outParameterMessage;
    }

    /**
     * Java classes generator from template
     *
     * @param procedures The procedures to generate
     * @throws Exception Launch if the generation process throws an error
     */
    public void process(List<Procedure> procedures) throws Exception {
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

    private void processStoredProcedure(Procedure procedure) throws Exception {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("proc", procedure);
        input.put("javaPackage", javaPackage);

        createTemplate(input, "/repository/Procedure.ftl", getFileNamePath(getRepositoryOutputPath("sp"), procedure, "SP"));
    }

    private void processStoredProcedureService(Procedure procedure) throws Exception {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("proc", procedure);
        input.put("javaPackage", javaPackage);
        input.put("dataSource", dataSource);
        input.put("outParameterCode", outParameterCode);
        input.put("outParameterMessage", outParameterMessage);

        String procedurePath = getRepositoryOutputPath("");

        createTemplate(input, "/repository/DAO.ftl", getFileNamePath(procedurePath, procedure, "DAO"));
        createTemplate(input, "/repository/DAOImpl.ftl", getFileNamePath(procedurePath, procedure, "DAOImpl"));
    }

    private void processStoredProcedureParameter(Procedure procedure) throws Exception {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("proc", procedure);
        input.put("javaPackage", javaPackage);

        if (!procedure.getHasInput() && !procedure.getHasOutput()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        if (procedure.getHasInput()) {
            createTemplate(input, "/domain/IN.ftl", getFileNamePath(parameterPath, procedure, "IN"));
        }

        if (procedure.getHasOutput()) {
            createTemplate(input, "/domain/OUT.ftl", getFileNamePath(parameterPath, procedure, "OUT"));
        }
    }

    private void processStoredProcedureParameterRS(Procedure procedure) throws Exception {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("proc", procedure);
        input.put("javaPackage", javaPackage);

        if (!procedure.getHasResultSet()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isOutput() && param.isResultSet()) {
                input.put("parameter", param);
                createTemplate(input, "/domain/DataSet.ftl", getFileNamePath(parameterPath, procedure, param, "RS"));
            }
        }
    }

    private void processStoredProcedureMapperRS(Procedure procedure) throws Exception {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("proc", procedure);
        input.put("javaPackage", javaPackage);

        if (!procedure.getHasResultSet()) {
            return;
        }

        String parameterPath = getRepositoryOutputPath("mapper");

        for (Parameter param : procedure.getParameters()) {
            if (param.isOutput() && param.isResultSet()) {
                input.put("parameter", param);
                createTemplate(input, "/repository/Mapper.ftl", getFileNamePath(parameterPath, procedure, param, "RSRowMapper"));
            }
        }
    }

    private void processStoredProcedureParameterObject(Procedure procedure) throws Exception {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("proc", procedure);
        input.put("javaPackage", javaPackage);

        if (!procedure.getHasObject()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isObject()) {
                input.put("parameter", param);
                createTemplate(input, "/domain/Object.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));
            }
        }
    }

    private void processStoredProcedureParameterArray(Procedure procedure) throws Exception {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put("proc", procedure);
        input.put("javaPackage", javaPackage);

        if (!procedure.getHasArray()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isArray()) {
                input.put("parameter", param);
                createTemplate(input, "/domain/Table.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));

                for (Parameter p : param.getParameters()) {
                    if (p.isObject()) {
                        input.put("parameter", p);
                        createTemplate(input, "/domain/Object.ftl", getFileNameObjectPath(parameterPath, p.getJavaTypeName()));
                    }
                }
            }
        }
    }

    @Override
    protected String getOutputPath(String path) {
        return super.getOutputPath(File.separatorChar + "autosp-generator" + File.separatorChar + getDirectoryPackage() + File.separatorChar + path);
    }

    protected String getRepositoryOutputPath(String path) {
        return this.getOutputPath(File.separatorChar + "repository" + File.separatorChar + path);
    }

    protected String getDomainOutputPath(String path) {
        return this.getOutputPath(File.separatorChar + "domain" + File.separatorChar + path);
    }

    protected String getFileNameObjectPath(String path, String name) {
        return path + File.separatorChar + name + ".java";
    }

    private String getFileNamePath(String path, Procedure procedure, String type) {
        return path + File.separatorChar + procedure.getClassName() + type + ".java";
    }

    private String getFileNamePath(String path, Procedure procedure, Parameter param, String type) {
        return path + File.separatorChar + procedure.getClassName() + param.getPropertyName() + type + ".java";
    }

    private String getDirectoryPackage() {
        return this.javaPackage.replace('.', File.separatorChar);
    }

}
