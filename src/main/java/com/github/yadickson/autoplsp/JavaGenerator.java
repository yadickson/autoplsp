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
    private final String prefixUtilityName;

    private final Map<String, String> mappers;

    private static final String PROCEDURE_NAME = "proc";
    private static final String PARAMETER_NAME = "parameter";
    private static final String TABLE_NAME = "table";
    private static final String TABLE_FIELD_NAME = "field";
    private static final String COLUMN_NAME = "column";

    private static final String FOLDER_MAPPER_NAME = "mapper";
    private static final String FOLDER_SP_NAME = "sp";

    private static final String JAVA_PACKAGE_NAME = "javaPackage";
    private static final String TRANSACTION_NAME = "transactionName";
    private static final String TRANSACTION_QUALITY_NAME = "transactionQualityName";

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
    private static final String INTERFACE_PATH = File.separatorChar + "interfaces" + File.separatorChar;
    private static final String ARRAY_PATH = File.separatorChar + "array" + File.separatorChar;
    private static final String OBJECT_PATH = File.separatorChar + "object" + File.separatorChar;
    private static final String CURSOR_PATH = File.separatorChar + "cursor" + File.separatorChar;
    private static final String UTIL_PATH = File.separatorChar + "util" + File.separatorChar;

    private static final String TABLE_PATH = File.separatorChar + TABLE_NAME + File.separatorChar;
    private static final String TABLE_COLUMN_PATH = TABLE_PATH + COLUMN_NAME + File.separatorChar;
    private static final String TYPE_PATH = TABLE_COLUMN_PATH + "type" + File.separatorChar;
    private static final String MAPPER_PATH = File.separatorChar + FOLDER_MAPPER_NAME + File.separatorChar;

    private static final String DRIVER_NAME = "driverName";
    private static final String DRIVER_VERSION = "driverVersion";
    private static final String DRIVER_VERSION_NAME = "driverVersionName";
    private static final String PREFIX_UTILITY_NAME = "prefixUtilityName";
    private static final String JAVA_8 = "java8";
    private static final String BUILDER = "builder";
    private static final String DOCUMENTATION = "documentation";
    private static final String JUNIT = "junit";

    private boolean checkResult;
    private boolean processClob;
    private boolean processBlob;
    private boolean processConnection;
    private boolean addTypeTable;
    private boolean addSafeDate;
    private boolean addSafeByteArray;
    private boolean addObjectUtil;
    private boolean addArrayUtil;
    private boolean addDateUtil;

    private static final Map<String, Object> INPUT_MAP = new HashMap<String, Object>();

    /**
     * Class constructor
     *
     * @param outputDir Output source directory
     * @param outputTestDir Output test directory
     * @param folderNameGenerator folder name generator
     * @param transactionName transaction name
     * @param transactionQualityName transaction quality name
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
     * @param driverVersionName driver version name.
     * @param prefixUtilityName prefix utility name.
     * @param java8 Java 8 flag compatibility.
     * @param builder Builder support.
     * @param documentation Documentation support.
     */
    public JavaGenerator(
            final String outputDir,
            final String outputTestDir,
            final String folderNameGenerator,
            final String transactionName,
            final Boolean transactionQualityName,
            final String javaPackage,
            final String dataSource,
            final String jdbcTemplate,
            final String encode,
            final Boolean jsonNonNull,
            final Boolean lombok,
            final Boolean header,
            final Boolean serialization,
            final Boolean test,
            final String junit,
            final Boolean position,
            final Boolean diamond,
            final Boolean logger,
            final Boolean fullConstructor,
            final String outParameterCode,
            final String outParameterMessage,
            final String successCode,
            final Map<String, String> mappers,
            final String driverName,
            final String driverVersion,
            final String driverVersionName,
            final String prefixUtilityName,
            final Boolean java8,
            final Boolean builder,
            final Boolean documentation
    ) {

        super(outputDir, outputTestDir);

        this.javaPackage = javaPackage;
        this.folderNameGenerator = folderNameGenerator;
        this.prefixUtilityName = prefixUtilityName;

        this.test = test;
        this.mappers = mappers;

        INPUT_MAP.put(JAVA_PACKAGE_NAME, javaPackage);
        INPUT_MAP.put(TRANSACTION_NAME, transactionName);
        INPUT_MAP.put(TRANSACTION_QUALITY_NAME, transactionQualityName);
        INPUT_MAP.put(DRIVER_NAME, driverName);
        INPUT_MAP.put(DRIVER_VERSION, driverVersion);
        INPUT_MAP.put(DRIVER_VERSION_NAME, driverVersionName);
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
        INPUT_MAP.put(PREFIX_UTILITY_NAME, prefixUtilityName);
        INPUT_MAP.put(JAVA_8, java8);
        INPUT_MAP.put(BUILDER, builder);
        INPUT_MAP.put(DOCUMENTATION, documentation);
        INPUT_MAP.put(JUNIT, junit);
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
        processConnection = false;
        addTypeTable = false;
        addSafeDate = false;
        addSafeByteArray = false;
        addObjectUtil = false;
        addArrayUtil = false;
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
            createTemplate(INPUT_MAP, UTIL_PATH + "CheckResult.ftl", getUtilOutputFilePath(this.prefixUtilityName + "CheckResult.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "CheckResultImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "CheckResultImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "CheckResultTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "CheckResultTest.java"));
            }
        }

        if (procedure.getHasDate() && !addSafeDate) {
            addSafeDate = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "SafeByteArray.ftl", getUtilOutputFilePath(this.prefixUtilityName + "SafeByteArray.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "SafeByteArrayTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "SafeByteArrayTest.java"));
            }
        }

        if (procedure.getHasBlob() && !addSafeByteArray) {
            addSafeByteArray = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "SafeDate.ftl", getUtilOutputFilePath(this.prefixUtilityName + "SafeDate.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "SafeDateTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "SafeDateTest.java"));
            }
        }

        if ((procedure.getHasInputClob() || procedure.getHasOutputClob()) && !processClob) {
            processClob = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ClobUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ClobUtilImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtilTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "ClobUtilTest.java"));
            }
        }

        if ((procedure.getHasInputBlob() || procedure.getHasOutputBlob()) && !processBlob) {
            processBlob = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "BlobUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "BlobUtilImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtilTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "BlobUtilTest.java"));
            }
        }

        if ((procedure.getHasObject() || procedure.getHasArray()) && !processConnection) {
            processConnection = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));

            createTemplate(INPUT_MAP, UTIL_PATH + "ConnectionUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ConnectionUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "ConnectionUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ConnectionUtilImpl.java"));

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

        makeInterfaces(procedure.getParameters());
    }

    private void processStoredProcedureParameterRS(Procedure procedure) throws BusinessException {

        INPUT_MAP.put(PROCEDURE_NAME, procedure);

        if (!procedure.getHasResultSet() && !procedure.getReturnResultSet()) {
            return;
        }

        for (Parameter param : procedure.getParameters()) {
            if (param.isResultSet() || param.isReturnResultSet()) {
                INPUT_MAP.put(PARAMETER_NAME, param);
                createTemplate(INPUT_MAP, CURSOR_PATH + "package-info.ftl", getCursorOutputFilePath("package-info.java"));
                createTemplate(INPUT_MAP, CURSOR_PATH + "DataSet.ftl", getFileNamePath(getCursorOutputPath(""), procedure, param, "RS"));
                makeInterfaces(param.getParameters());
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

        for (Parameter param : objects) {
            LoggerManager.getInstance().info("[JavaGenerator] Process template for " + param.getName());

            if (param.isObject()) {
                INPUT_MAP.put(PARAMETER_NAME, param);
                createTemplate(INPUT_MAP, OBJECT_PATH + "package-info.ftl", getObjectOutputFilePath("package-info.java"));
                createTemplate(INPUT_MAP, OBJECT_PATH + "Object.ftl", getFileNameObjectPath(getObjectOutputPath(""), param.getJavaTypeName()));
                createTemplate(INPUT_MAP, OBJECT_PATH + "ObjectBuilder.ftl", getFileNameObjectPath(getObjectOutputPath(""), param.getJavaTypeName() + "Builder"));
                createTemplate(INPUT_MAP, OBJECT_PATH + "ObjectBuilderImpl.ftl", getFileNameObjectPath(getObjectOutputPath(""), param.getJavaTypeName() + "BuilderImpl"));

                if (test) {
                    createTemplate(INPUT_MAP, OBJECT_PATH + "ObjectBuilderTest.ftl", getFileNameObjectPath(getObjectOutputTestPath(""), param.getJavaTypeName() + "BuilderTest"));
                }

                if (!addObjectUtil) {
                    addObjectUtil = true;
                    createTemplate(INPUT_MAP, UTIL_PATH + "ObjectUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ObjectUtil.java"));
                    createTemplate(INPUT_MAP, UTIL_PATH + "ObjectUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ObjectUtilImpl.java"));

                    if (test) {
                        createTemplate(INPUT_MAP, UTIL_PATH + "ObjectUtilTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "ObjectUtilTest.java"));
                    }
                }

                checkDateUtil(param);
                checkBlodUtil(param);
                checkClodUtil(param);
            }

            if (param.isArray()) {
                INPUT_MAP.put(PARAMETER_NAME, param);
                createTemplate(INPUT_MAP, ARRAY_PATH + "package-info.ftl", getArrayOutputFilePath("package-info.java"));
                createTemplate(INPUT_MAP, ARRAY_PATH + "Array.ftl", getFileNameObjectPath(getArrayOutputPath(""), param.getJavaTypeName()));
                createTemplate(INPUT_MAP, ARRAY_PATH + "ArrayBuilder.ftl", getFileNameObjectPath(getArrayOutputPath(""), param.getJavaTypeName() + "Builder"));
                createTemplate(INPUT_MAP, ARRAY_PATH + "ArrayBuilderImpl.ftl", getFileNameObjectPath(getArrayOutputPath(""), param.getJavaTypeName() + "BuilderImpl"));

                if (test) {
                    createTemplate(INPUT_MAP, ARRAY_PATH + "ArrayBuilderTest.ftl", getFileNameObjectPath(getArrayOutputTestPath(""), param.getJavaTypeName() + "BuilderTest"));
                }

                if (!addArrayUtil) {
                    addArrayUtil = true;
                    createTemplate(INPUT_MAP, UTIL_PATH + "ArrayUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ArrayUtil.java"));
                    createTemplate(INPUT_MAP, UTIL_PATH + "ArrayUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ArrayUtilImpl.java"));

                    if (test) {
                        createTemplate(INPUT_MAP, UTIL_PATH + "ArrayUtilTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "ArrayUtilTest.java"));
                    }
                }

                checkDateUtil(param);
                checkBlodUtil(param);
                checkClodUtil(param);
            }
        }
    }

    private void checkDateUtil(final Parameter parameter) throws BusinessException {
        if (parameter.hasDate() && !addDateUtil) {
            addDateUtil = true;

            createTemplate(INPUT_MAP, UTIL_PATH + "DateUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "DateUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "DateUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "DateUtilImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "DateUtilTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "DateUtilTest.java"));
            }
        }
    }

    private void checkClodUtil(final Parameter parameter) throws BusinessException {
        if (parameter.hasClob() && !processClob) {
            processClob = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ClobUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "ClobUtilImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "ClobUtilTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "ClobUtilTest.java"));
            }
        }
    }

    private void checkBlodUtil(final Parameter parameter) throws BusinessException {
        if (parameter.hasBlob() && !processBlob) {
            processBlob = true;
            createTemplate(INPUT_MAP, UTIL_PATH + "package-info.ftl", getUtilOutputFilePath("package-info.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtil.ftl", getUtilOutputFilePath(this.prefixUtilityName + "BlobUtil.java"));
            createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtilImpl.ftl", getUtilOutputFilePath(this.prefixUtilityName + "BlobUtilImpl.java"));

            if (test) {
                createTemplate(INPUT_MAP, UTIL_PATH + "BlobUtilTest.ftl", getUtilOutputFileTestPath(this.prefixUtilityName + "BlobUtilTest.java"));
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

    private String getArrayOutputTestPath(String path) throws BusinessException {
        return this.getOutputTestPath(ARRAY_PATH + path);
    }

    private String getObjectOutputTestPath(String path) throws BusinessException {
        return this.getOutputTestPath(OBJECT_PATH + path);
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

    private String getArrayOutputPath(String path) throws BusinessException {
        return this.getOutputPath(ARRAY_PATH + path);
    }

    private String getInterfaceOutputPath(String path) throws BusinessException {
        return this.getOutputPath(INTERFACE_PATH + path);
    }

    private String getCursorOutputPath(String path) throws BusinessException {
        return this.getOutputPath(CURSOR_PATH + path);
    }

    private String getCursorOutputFilePath(String file) throws BusinessException {
        return this.getCursorOutputPath("") + File.separatorChar + file;
    }

    private String getObjectOutputPath(String path) throws BusinessException {
        return this.getOutputPath(OBJECT_PATH + path);
    }

    private String getDomainOutputFilePath(String file) throws BusinessException {
        return this.getDomainOutputPath("") + File.separatorChar + file;
    }

    private String getArrayOutputFilePath(String file) throws BusinessException {
        return this.getArrayOutputPath("") + File.separatorChar + file;
    }

    private String getObjectOutputFilePath(String file) throws BusinessException {
        return this.getObjectOutputPath("") + File.separatorChar + file;
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

    private String getInterfaceFileNamePath(String path, Parameter param) {
        return path + File.separatorChar + param.getJavaFileNameInterface() + "Interface" + EXT_FILE;
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

    private void makeInterfaces(List<Parameter> parameters) throws BusinessException {
//        for(Parameter param : parameters) {
//            if (param.isInterface()) {
//                INPUT_MAP.put(PARAMETER_NAME, param);
//                createTemplate(INPUT_MAP, INTERFACE_PATH + "Interface.ftl", getInterfaceFileNamePath(getInterfaceOutputPath(""), param));
//            }
//        }
    }
}
