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

import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.common.Table;
import com.github.yadickson.autoplsp.db.common.TableField;
import com.github.yadickson.autoplsp.db.parameter.DataSetParameter;
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
    private final String encode;
    private final Boolean jsonNonNull;
    private final String outParameterCode;
    private final String outParameterMessage;
    private final String folderNameGenerator;
    private final String driverName;
    private final String driverVersion;

    private static final String PROCEDURE_NAME = "proc";
    private static final String PARAMETER_NAME = "parameter";
    private static final String TABLE_NAME = "table";
    private static final String TABLE_FIELD_NAME = "field";
    private static final String COLUMN_NAME = "column";

    private static final String FOLDER_MAPPER_NAME = "mapper";
    private static final String FOLDER_SP_NAME = "sp";

    private static final String JAVA_PACKAGE_NAME = "javaPackage";
    private static final String DATA_SOURCE_NAME = "dataSource";
    private static final String JDBC_TEMPLATE_NAME = "jdbcTemplate";
    private static final String ENCODE = "encode";
    private static final String JSON_NON_NULL = "jsonNonNull";
    private static final String OUT_CODE_NAME = "outParameterCode";
    private static final String OUT_MESSAGE_NAME = "outParameterMessage";
    private static final String EXT_FILE = ".java";

    private static final String REPOSITORY_PATH = File.separatorChar + "repository" + File.separatorChar;
    private static final String DOMAIN_PATH = File.separatorChar + "domain" + File.separatorChar;
    private static final String TABLE_PATH = File.separatorChar + TABLE_NAME + File.separatorChar;
    private static final String TABLE_COLUMN_PATH = TABLE_PATH + COLUMN_NAME + File.separatorChar;
    private static final String TYPE_PATH = TABLE_COLUMN_PATH + "type" + File.separatorChar;
    private static final String MAPPER_PATH = File.separatorChar + FOLDER_MAPPER_NAME + File.separatorChar;

    private static final String DRIVER_NAME = "driverName";
    private static final String DRIVER_VERSION = "driverVersion";

    /**
     * Class constructor
     *
     * @param outputDir Output resource directory
     * @param folderNameGenerator folder name generator
     * @param packageName Java package name
     * @param dataSource Datasource name
     * @param jdbcTemplate JdbcTemplate name
     * @param encode encode data base.
     * @param jsonNonNull json non null support.
     * @param outParameterCode Output parameter code to evaluate process
     * @param outParameterMessage Output parameter message
     * @param driverName driver name
     * @param driverVersion driver version
     */
    public JavaGenerator(String outputDir,
            final String folderNameGenerator,
            final String packageName,
            final String dataSource,
            final String jdbcTemplate,
            final String encode,
            final Boolean jsonNonNull,
            final String outParameterCode,
            final String outParameterMessage,
            final String driverName,
            final String driverVersion) {

        super(outputDir);
        this.folderNameGenerator = folderNameGenerator;
        this.javaPackage = packageName;
        this.dataSource = dataSource;
        this.jdbcTemplate = jdbcTemplate;
        this.encode = encode;
        this.jsonNonNull = jsonNonNull;
        this.outParameterCode = outParameterCode;
        this.outParameterMessage = outParameterMessage;
        this.driverName = driverName;
        this.driverVersion = driverVersion;
    }

    /**
     * Java classes generator from template
     *
     * @param procedures The procedures to generate
     * @throws BusinessException Launch if the generation process throws an
     * error
     */
    public void processProcedures(List<Procedure> procedures) throws BusinessException {
        LoggerManager.getInstance().info("[JavaGenerator] Process template for " + procedures.size() + " procedures");

        for (Procedure procedure : procedures) {

            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + procedure.getFullName());

            processStoredProcedureParameterRS(procedure);
            processStoredProcedureMapperRS(procedure);
            processStoredProcedureParameter(procedure);
            processStoredProcedure(procedure);
            processStoredProcedureService(procedure);
        }
    }

    private void processStoredProcedure(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);

        createTemplate(input, REPOSITORY_PATH + "package-info-procedure.ftl", getRepositorySpOutputFilePath("package-info.java"));
        createTemplate(input, REPOSITORY_PATH + "Procedure.ftl", getFileNamePath(getRepositoryOutputPath(FOLDER_SP_NAME), procedure, "SP"));
    }

    private void processStoredProcedureService(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(DATA_SOURCE_NAME, dataSource);
        input.put(JDBC_TEMPLATE_NAME, jdbcTemplate);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);
        input.put(OUT_CODE_NAME, outParameterCode);
        input.put(OUT_MESSAGE_NAME, outParameterMessage);

        String procedurePath = getRepositoryOutputPath("");

        createTemplate(input, REPOSITORY_PATH + "package-info-repository.ftl", getRepositoryOutputFilePath("package-info.java"));
        createTemplate(input, REPOSITORY_PATH + "DAO.ftl", getFileNamePath(procedurePath, procedure, "DAO"));
        createTemplate(input, REPOSITORY_PATH + "DAOImpl.ftl", getFileNamePath(procedurePath, procedure, "DAOImpl"));
    }

    private void processStoredProcedureParameter(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);

        if (!procedure.getHasInput() && !procedure.getHasOutput()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        if (procedure.getHasInput()) {
            createTemplate(input, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
            createTemplate(input, DOMAIN_PATH + "IN.ftl", getFileNamePath(parameterPath, procedure, "IN"));
        }

        if (procedure.getHasOutput()) {
            createTemplate(input, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
            createTemplate(input, DOMAIN_PATH + "OUT.ftl", getFileNamePath(parameterPath, procedure, "OUT"));
        }
    }

    private void processStoredProcedureParameterRS(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);

        if (!procedure.getHasResultSet() && !procedure.getReturnResultSet()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isResultSet() || param.isReturnResultSet()) {
                input.put(PARAMETER_NAME, param);
                createTemplate(input, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
                createTemplate(input, DOMAIN_PATH + "DataSet.ftl", getFileNamePath(parameterPath, procedure, param, "RS"));
            }
        }
    }

    private void processStoredProcedureMapperRS(Procedure procedure) throws BusinessException {
        Map<String, Object> input = new HashMap<String, Object>();

        input.put(PROCEDURE_NAME, procedure);
        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);

        if (!procedure.getHasResultSet() && !procedure.getReturnResultSet()) {
            return;
        }

        String parameterPath = getRepositoryOutputPath(FOLDER_MAPPER_NAME);

        for (Parameter param : procedure.getParameters()) {
            if (param.isResultSet() || param.isReturnResultSet()) {

                DataSetParameter dataSetParameter = (DataSetParameter) param;
                input.put(PARAMETER_NAME, dataSetParameter);
                String fileName = getFileNamePath(parameterPath, procedure, param, "RSRowMapper");

                createTemplate(input, REPOSITORY_PATH + "package-info-mapper.ftl", getRepositoryMapperOutputFilePath("package-info.java"));
                createTemplate(input, REPOSITORY_PATH + "Mapper.ftl", fileName);
            }
        }
    }

    public void processObjects(List<Parameter> objects) throws BusinessException {

        Map<String, Object> input = new HashMap<String, Object>();

        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(DRIVER_NAME, driverName);
        input.put(DRIVER_VERSION, driverVersion);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : objects) {
            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + param.getName());

            if (param.isObject()) {
                input.put(PARAMETER_NAME, param);
                createTemplate(input, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
                createTemplate(input, DOMAIN_PATH + "Object.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));
            }

            if (param.isArray()) {
                input.put(PARAMETER_NAME, param);
                createTemplate(input, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
                createTemplate(input, DOMAIN_PATH + "Table.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));
            }
        }
    }

    public void processTables(final List<Table> tables) throws BusinessException {

        if (tables.isEmpty()) {
            return;
        }

        Map<String, Object> input = new HashMap<String, Object>();

        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(DRIVER_NAME, driverName);
        input.put(DRIVER_VERSION, driverVersion);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);

        String typePath = getTypeOutputPath("");

        createTemplate(input, TYPE_PATH + "FieldType.ftl", getFileNameTypePath(typePath, "FieldType"));
        createTemplate(input, TYPE_PATH + "BinaryField.ftl", getFileNameTypePath(typePath, "BinaryField"));
        createTemplate(input, TYPE_PATH + "CharacterField.ftl", getFileNameTypePath(typePath, "CharacterField"));
        createTemplate(input, TYPE_PATH + "NumericField.ftl", getFileNameTypePath(typePath, "NumericField"));
        createTemplate(input, TYPE_PATH + "DateField.ftl", getFileNameTypePath(typePath, "DateField"));

        String tablePath = getTableOutputPath("");
        String tableFieldPath = getTableOutputPath(COLUMN_NAME);

        for (Table table : tables) {
            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + table.getName());

            input.put(TABLE_NAME, table);

            createTemplate(input, TABLE_PATH + "Table.ftl", getFileNameTablePath(tablePath, table, ""));
            createTemplate(input, TABLE_PATH + "TableImpl.ftl", getFileNameTablePath(tablePath, table, "Impl"));

            for (TableField field : table.getFields()) {

                input.put(TABLE_FIELD_NAME, field);

                createTemplate(input, TABLE_COLUMN_PATH + "TableField.ftl", getFileNameTableFieldPath(tableFieldPath, table, field, ""));
                createTemplate(input, TABLE_COLUMN_PATH + "TableFieldImpl.ftl", getFileNameTableFieldPath(tableFieldPath, table, field, "Impl"));
            }

        }
    }

    public void processMappers(final List<Parameter> mappers) throws BusinessException {

        Map<String, Object> input = new HashMap<String, Object>();

        input.put(JAVA_PACKAGE_NAME, javaPackage);
        input.put(DRIVER_NAME, driverName);
        input.put(DRIVER_VERSION, driverVersion);
        input.put(ENCODE, encode);
        input.put(JSON_NON_NULL, jsonNonNull);

        String parameterPath = getMapperOutputPath("");

        for (Parameter param : mappers) {
            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + param.getName());

            input.put(FOLDER_MAPPER_NAME, param);

            createTemplate(input, MAPPER_PATH + "Mapper.ftl", getFileNameMapperPath(parameterPath, param));
            createTemplate(input, MAPPER_PATH + "MapperImpl.ftl", getFileNameMapperPath(parameterPath, param));
        }

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

    private String getTableOutputPath(String path) throws BusinessException {
        return this.getOutputPath(TABLE_PATH + path);
    }

    private String getTypeOutputPath(String path) throws BusinessException {
        return this.getOutputPath(TYPE_PATH + path);
    }

    private String getMapperOutputPath(String path) throws BusinessException {
        return this.getOutputPath(MAPPER_PATH + path);
    }

    private String getRepositoryOutputPath(String path) throws BusinessException {
        return this.getOutputPath(REPOSITORY_PATH + path);
    }

    private String getRepositoryOutputFilePath(String file) throws BusinessException {
        return this.getRepositoryOutputPath("") + File.separatorChar + file;
    }

    private String getRepositorySpOutputFilePath(String file) throws BusinessException {
        return this.getRepositoryOutputPath(FOLDER_SP_NAME) + File.separatorChar + file;
    }

    private String getRepositoryMapperOutputFilePath(String file) throws BusinessException {
        return this.getRepositoryOutputPath(FOLDER_MAPPER_NAME) + File.separatorChar + file;
    }

    private String getDomainOutputPath(String path) throws BusinessException {
        return this.getOutputPath(DOMAIN_PATH + path);
    }

    private String getDomainOutputFilePath(String file) throws BusinessException {
        return this.getDomainOutputPath("") + File.separatorChar + file;
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

    private String getFileNameTablePath(String path, Table table, String type) {
        return path + File.separatorChar + table.getPropertyName() + type + EXT_FILE;
    }

    private String getFileNameTableFieldPath(String path, Table table, TableField field, String type) {
        return path + File.separatorChar + table.getPropertyName() + field.getPropertyName() + type + EXT_FILE;
    }

    private String getFileNameTypePath(String path, String file) {
        return path + File.separatorChar + file + EXT_FILE;
    }

    private String getFileNameMapperPath(String path, Parameter param) {
        return path + File.separatorChar + param.getPropertyName() + EXT_FILE;
    }

    private String getDirectoryPackage() {
        return this.javaPackage.replace('.', File.separatorChar);
    }

}
