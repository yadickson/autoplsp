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

import com.github.yadickson.autoplsp.db.common.Parameter;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.db.common.Table;
import com.github.yadickson.autoplsp.db.common.TableField;
import com.github.yadickson.autoplsp.db.parameter.DataSetParameter;
import com.github.yadickson.autoplsp.handler.BusinessException;
import com.github.yadickson.autoplsp.logger.LoggerManager;

/**
 * Java classes generator
 *
 * @author Yadickson Soto
 */
public final class JavaGenerator extends TemplateGenerator {

    private final String javaPackage;
    private final Boolean test;
    private final String folderNameGenerator;

    private final Map<String, String> mappers;

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
    private static final String LOMBOK = "lombok";
    private static final String HEADER = "header";
    private static final String SERIALIZATION = "serialization";
    private static final String POSITION = "position";
    private static final String DIAMOND = "diamond";
    private static final String LOGGER = "logger";
    private static final String FULL_CONSTRUCTOR = "fullConstructor";
    private static final String OUT_CODE_NAME = "outParameterCode";
    private static final String OUT_MESSAGE_NAME = "outParameterMessage";
    private static final String SUCCESS_CODE = "successCode";
    private static final String EXT_FILE = ".java";

    private static final String REPOSITORY_PATH = File.separatorChar + "repository" + File.separatorChar;
    private static final String DOMAIN_PATH = File.separatorChar + "domain" + File.separatorChar;
    private static final String UTIL_PATH = File.separatorChar + "util" + File.separatorChar;

    private static final String TABLE_PATH = File.separatorChar + TABLE_NAME + File.separatorChar;
    private static final String TABLE_COLUMN_PATH = TABLE_PATH + COLUMN_NAME + File.separatorChar;
    private static final String TYPE_PATH = TABLE_COLUMN_PATH + "type" + File.separatorChar;
    private static final String MAPPER_PATH = File.separatorChar + FOLDER_MAPPER_NAME + File.separatorChar;

    private static final String DRIVER_NAME = "driverName";
    private static final String DRIVER_VERSION = "driverVersion";

    private boolean checkResult;
    private boolean processClob;
    private boolean processBlob;
    private boolean addTypeTable;
    private boolean addDateUtil;

    private static final Map<String, Object> INPUT_MAP = new HashMap<String, Object>();

    /**
     * Class constructor
     *
     * @param outputDir Output source directory
     * @param outputTestDir Output test directory
     * @param folderNameGenerator folder name generator
     * @param javaPackage Java package name
     * @param dataSource Datasource name
     * @param jdbcTemplate JdbcTemplate name
     * @param encode encode data base.
     * @param jsonNonNull json non null support.
     * @param lombok lombok support.
     * @param header The header support.
     * @param serialization The serialization support.
     * @param test The test support.
     * @param position The support position.
     * @param diamond The diamond style.
     * @param logger The logger support.
     * @param fullConstructor The full constructor support.
     * @param outParameterCode Output parameter code to evaluate process
     * @param outParameterMessage Output parameter message
     * @param successCode Output success code value.
     * @param mappers The mappers.
     * @param driverName driver name
     * @param driverVersion driver version
     */
    public JavaGenerator(
            final String outputDir,
            final String outputTestDir,
            final String folderNameGenerator,
            final String javaPackage,
            final String dataSource,
            final String jdbcTemplate,
            final String encode,
            final Boolean jsonNonNull,
            final Boolean lombok,
            final Boolean header,
            final Boolean serialization,
            final Boolean test,
            final Boolean position,
            final Boolean diamond,
            final Boolean logger,
            final Boolean fullConstructor,
            final String outParameterCode,
            final String outParameterMessage,
            final String successCode,
            final Map<String, String> mappers,
            final String driverName,
            final String driverVersion) {

        super(outputDir, outputTestDir);

        this.javaPackage = javaPackage;
        this.folderNameGenerator = folderNameGenerator;
        this.test = test;
        this.mappers = mappers;

        INPUT_MAP.put(JAVA_PACKAGE_NAME, javaPackage);
        INPUT_MAP.put(DRIVER_NAME, driverName);
        INPUT_MAP.put(DRIVER_VERSION, driverVersion);
        INPUT_MAP.put(DATA_SOURCE_NAME, dataSource);
        INPUT_MAP.put(JDBC_TEMPLATE_NAME, jdbcTemplate);
        INPUT_MAP.put(ENCODE, encode);
        INPUT_MAP.put(JSON_NON_NULL, jsonNonNull);
        INPUT_MAP.put(LOMBOK, lombok);
        INPUT_MAP.put(HEADER, header);
        INPUT_MAP.put(SERIALIZATION, serialization);
        INPUT_MAP.put(POSITION, position);
        INPUT_MAP.put(DIAMOND, diamond);
        INPUT_MAP.put(LOGGER, logger);
        INPUT_MAP.put(FULL_CONSTRUCTOR, fullConstructor);
        INPUT_MAP.put(SUCCESS_CODE, successCode);
        INPUT_MAP.put(OUT_CODE_NAME, outParameterCode);
        INPUT_MAP.put(OUT_MESSAGE_NAME, outParameterMessage);
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

        checkResult = false;
        processClob = false;
        processBlob = false;
        addTypeTable = false;
        addDateUtil = false;

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

        INPUT_MAP.put(PROCEDURE_NAME, procedure);

        if (procedure.isCheckResult() && !checkResult) {
            checkResult = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "CheckResult.ftl", getUtilOutputFilePath("CheckResult.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "CheckResultImpl.ftl", getUtilOutputFilePath("CheckResultImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "CheckResultTest.ftl", getUtilOutputFileTestPath("CheckResultTest.java"));
            }
        }

        if (procedure.getHasDate() && !addDateUtil) {
            addDateUtil = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "DateUtil.ftl", getUtilOutputFilePath("DateUtil.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "DateUtilTest.ftl", getUtilOutputFileTestPath("DateUtilTest.java"));
            }
        }

        if (procedure.getHasOutputClob() && !processClob) {
            processClob = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtil.ftl", getUtilOutputFilePath("ClobUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtilImpl.ftl", getUtilOutputFilePath("ClobUtilImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtilTest.ftl", getUtilOutputFileTestPath("ClobUtilTest.java"));
            }
        }

        if (procedure.getHasOutputBlob() && !processBlob) {
            processBlob = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtil.ftl", getUtilOutputFilePath("BlobUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtilImpl.ftl", getUtilOutputFilePath("BlobUtilImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtilTest.ftl", getUtilOutputFileTestPath("BlobUtilTest.java"));
            }
        }

        if (!procedure.isFunctionInline()) {

            createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "package-info.ftl", getRepositorySpOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "Procedure.ftl", getFileNamePath(getRepositoryOutputPath(FOLDER_SP_NAME), procedure, "SP"));
            createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "ProcedureImpl.ftl", getFileNamePath(getRepositoryOutputPath(FOLDER_SP_NAME), procedure, "SPImpl"));

            if (test) {
                createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "ProcedureTest.ftl", getFileNamePath(getRepositoryOutputTestPath(FOLDER_SP_NAME), procedure, "SPTest"));
            }

        } else {

            createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "package-info.ftl", getRepositorySpOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "SqlQuery.ftl", getFileNamePath(getRepositoryOutputPath(FOLDER_SP_NAME), procedure, "SqlQuery"));
            createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "SqlQueryImpl.ftl", getFileNamePath(getRepositoryOutputPath(FOLDER_SP_NAME), procedure, "SqlQueryImpl"));

            if (test) {
                createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_SP_NAME + File.separator + "SqlQueryTest.ftl", getFileNamePath(getRepositoryOutputTestPath(FOLDER_SP_NAME), procedure, "SqlQueryTest"));
            }
        }
    }

    private void processStoredProcedureService(Procedure procedure) throws BusinessException {

        INPUT_MAP.put(PROCEDURE_NAME, procedure);

        String procedurePath = getRepositoryOutputPath("");

        createTemplate(INPUT_MAP, REPOSITORY_PATH + "package-info.ftl", getRepositoryOutputFilePath("package-info.java"));
        createTemplate(INPUT_MAP, REPOSITORY_PATH + "DAO.ftl", getFileNamePath(procedurePath, procedure, "DAO"));
        createTemplate(INPUT_MAP, REPOSITORY_PATH + "DAOImpl.ftl", getFileNamePath(procedurePath, procedure, "DAOImpl"));

        if (test) {
            createTemplate(INPUT_MAP, REPOSITORY_PATH + "DAOTest.ftl", getFileNamePath(getRepositoryOutputTestPath(""), procedure, "DAOTest"));
        }
    }

    private void processStoredProcedureParameter(Procedure procedure) throws BusinessException {

        INPUT_MAP.put(PROCEDURE_NAME, procedure);

        if (!procedure.getHasInput() && !procedure.getHasOutput()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        if (procedure.getHasInput()) {
            createTemplate(INPUT_MAP, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, DOMAIN_PATH + "IN.ftl", getFileNamePath(parameterPath, procedure, "IN"));
        }

        if (procedure.getHasOutput()) {
            createTemplate(INPUT_MAP, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, DOMAIN_PATH + "OUT.ftl", getFileNamePath(parameterPath, procedure, "OUT"));
        }
    }

    private void processStoredProcedureParameterRS(Procedure procedure) throws BusinessException {

        INPUT_MAP.put(PROCEDURE_NAME, procedure);

        if (!procedure.getHasResultSet() && !procedure.getReturnResultSet()) {
            return;
        }

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : procedure.getParameters()) {
            if (param.isResultSet() || param.isReturnResultSet()) {
                INPUT_MAP.put(PARAMETER_NAME, param);
                createTemplate(INPUT_MAP, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
                createTemplate(INPUT_MAP, DOMAIN_PATH + "DataSet.ftl", getFileNamePath(parameterPath, procedure, param, "RS"));
            }
        }
    }

    private void processStoredProcedureMapperRS(Procedure procedure) throws BusinessException {

        INPUT_MAP.put(PROCEDURE_NAME, procedure);

        if (!procedure.getHasResultSet() && !procedure.getReturnResultSet()) {
            return;
        }

        String parameterPath = getRepositoryOutputPath(FOLDER_MAPPER_NAME);

        for (Parameter param : procedure.getParameters()) {
            if (param.isResultSet() || param.isReturnResultSet()) {

                DataSetParameter dataSetParameter = (DataSetParameter) param;
                INPUT_MAP.put(PARAMETER_NAME, dataSetParameter);
                String fileName = getFileNamePath(parameterPath, procedure, param, "RSRowMapper");

                createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_MAPPER_NAME + File.separator + "package-info.ftl", getRepositoryMapperOutputFilePath("package-info.java"));
                createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_MAPPER_NAME + File.separator + "RowMapper.ftl", fileName);

                if (test) {
                    String parameterTestPath = getRepositoryOutputTestPath(FOLDER_MAPPER_NAME);
                    String fileNameTest = getFileNamePath(parameterTestPath, procedure, param, "RSRowMapperTest");
                    createTemplate(INPUT_MAP, REPOSITORY_PATH + FOLDER_MAPPER_NAME + File.separator + "RowMapperTest.ftl", fileNameTest);
                }
            }
        }
    }

    public void processObjects(List<Parameter> objects) throws BusinessException {

        String parameterPath = getDomainOutputPath("");

        for (Parameter param : objects) {
            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + param.getName());

            if (param.isObject()) {
                INPUT_MAP.put(PARAMETER_NAME, param);
                createTemplate(INPUT_MAP, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
                createTemplate(INPUT_MAP, DOMAIN_PATH + "Object.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));
            }

            if (param.isArray()) {
                INPUT_MAP.put(PARAMETER_NAME, param);
                createTemplate(INPUT_MAP, DOMAIN_PATH + "package-info.ftl", getDomainOutputFilePath("package-info.java"));
                createTemplate(INPUT_MAP, DOMAIN_PATH + "Array.ftl", getFileNameObjectPath(parameterPath, param.getJavaTypeName()));
            }
        }
    }

    public void processTables(final List<Table> tables) throws BusinessException {

        if (tables.isEmpty()) {
            return;
        }

        if (!addTypeTable) {

            addTypeTable = true;
            String typePath = getTypeOutputPath("");

            createTemplate(INPUT_MAP, TYPE_PATH + "FieldType.ftl", getFileNameTypePath(typePath, "FieldType"));
            createTemplate(INPUT_MAP, TYPE_PATH + "BinaryField.ftl", getFileNameTypePath(typePath, "BinaryField"));
            createTemplate(INPUT_MAP, TYPE_PATH + "CharacterField.ftl", getFileNameTypePath(typePath, "CharacterField"));
            createTemplate(INPUT_MAP, TYPE_PATH + "NumericField.ftl", getFileNameTypePath(typePath, "NumericField"));
            createTemplate(INPUT_MAP, TYPE_PATH + "DateField.ftl", getFileNameTypePath(typePath, "DateField"));
        }

        String tablePath = getTableOutputPath("");
        String tableFieldPath = getTableOutputPath(COLUMN_NAME);

        for (Table table : tables) {
            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + table.getName());

            INPUT_MAP.put(TABLE_NAME, table);

            createTemplate(INPUT_MAP, TABLE_PATH + "Table.ftl", getFileNameTablePath(tablePath, table, ""));
            createTemplate(INPUT_MAP, TABLE_PATH + "TableImpl.ftl", getFileNameTablePath(tablePath, table, "Impl"));

            for (TableField field : table.getFields()) {

                INPUT_MAP.put(TABLE_FIELD_NAME, field);

                createTemplate(INPUT_MAP, TABLE_COLUMN_PATH + "TableField.ftl", getFileNameTableFieldPath(tableFieldPath, table, field, ""));
                createTemplate(INPUT_MAP, TABLE_COLUMN_PATH + "TableFieldImpl.ftl", getFileNameTableFieldPath(tableFieldPath, table, field, "Impl"));
            }

        }
    }

    public void processMappers(final List<Parameter> mappers) throws BusinessException {

        String parameterPath = getMapperOutputPath("");

        for (Parameter param : mappers) {
            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + param.getName());

            INPUT_MAP.put(FOLDER_MAPPER_NAME, param);

            createTemplate(INPUT_MAP, MAPPER_PATH + "Mapper.ftl", getFileNameMapperPath(parameterPath, param));
            createTemplate(INPUT_MAP, MAPPER_PATH + "MapperImpl.ftl", getFileNameMapperPath(parameterPath, param));
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

    /**
     * Get output directory test path
     *
     * @param path path
     * @return full directory path
     * @exception BusinessException if error
     */
    @Override
    protected String getOutputTestPath(String path) throws BusinessException {
        return super.getOutputTestPath(File.separatorChar + folderNameGenerator + File.separatorChar + getDirectoryPackage() + File.separatorChar + path);
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

    private String getRepositoryOutputTestPath(String path) throws BusinessException {
        return this.getOutputTestPath(REPOSITORY_PATH + path);
    }

    private String getRepositoryOutputFilePath(String file) throws BusinessException {
        return this.getRepositoryOutputPath("") + File.separatorChar + file;
    }

    private String getRepositorySpOutputFilePath(String file) throws BusinessException {
        return this.getRepositoryOutputPath(FOLDER_SP_NAME) + File.separatorChar + file;
    }

    private String getUtilOutputPath(String path) throws BusinessException {
        return this.getOutputPath(UTIL_PATH + path);
    }

    private String getUtilOutputTestPath(String path) throws BusinessException {
        return this.getOutputTestPath(UTIL_PATH + path);
    }

    private String getUtilOutputFilePath(String file) throws BusinessException {
        return this.getUtilOutputPath("") + File.separatorChar + file;
    }

    private String getUtilOutputFileTestPath(String file) throws BusinessException {
        return this.getUtilOutputTestPath("") + File.separatorChar + file;
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
