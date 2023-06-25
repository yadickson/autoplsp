<#if header>
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
</#if>
package ${javaPackage}.${repositoryFolderName};
<#assign importList = ["java.util.Map", "java.util.HashMap", "java.sql.SQLException", "org.springframework.stereotype.Repository"]>
<#list proc.parameters as parameter>
<#if parameter.object || parameter.array>
<#assign importConnectionUtils = 1>
<#assign importList = importList + ["java.sql.Connection"]>
<#if utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ConnectionUtil"]>
</#if>
</#if>
</#list>
<#list proc.outputParameters as parameter>
<#if parameter.date>
<#assign importList = importList + ["java.util.Date"]>
<#elseif parameter.clob>
<#assign importClobUtil = 1>
<#if utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ClobUtil"]>
</#if>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
<#if utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}BlobUtil"]>
</#if>
</#if>
</#list>
<#list proc.arrayImports as parameter>
<#if arrayFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${arrayFolderName}.${parameter.javaTypeName}Builder"]>
</#if>
</#list>
<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
<#if cursorFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${cursorFolderName}.${parameter.javaTypeName}"]>
</#if>
</#if>
</#list>
<#if proc.hasInput && domainFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${domainFolderName}.${proc.className}IN"]>
</#if>
<#if proc.hasOutput && domainFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${domainFolderName}.${proc.className}OUT", "${javaPackage}.${domainFolderName}.${proc.className}OUTImpl"]>
</#if>
<#if !proc.functionInline>
<#assign importList = importList + ["${javaPackage}.${repositoryFolderName}.sp.${proc.className}SP"]>
<#else>
<#assign importList = importList + ["${javaPackage}.${repositoryFolderName}.sp.${proc.className}SqlQuery"]>
</#if>
<#if proc.checkResult && utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}CheckResult"]>
</#if>
<#list proc.objectImports as parameter>
<#if objectFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.javaTypeName}Builder"]>
</#if>
</#list>
<#if proc.hasResultSet>
<#assign importList = importList + ["java.util.List"]>
</#if>
<#if logger>
<#assign importList = importList + ["org.slf4j.Logger", "org.slf4j.LoggerFactory"]>
</#if>

<#list importSort(importList) as import>
<#if previousImportMatch?? && !import?starts_with(previousImportMatch)>

</#if>
import ${import};
<#assign previousImportMatch = import?keep_before_last(".") >
</#list>
<#if importList?has_content>

</#if>
<#if documentation>
/**
 * DAO implementation for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Repository
@SuppressWarnings({"unchecked"})
public final class ${proc.className}DAOImpl${'\n'}        implements ${proc.className}DAO {

<#if logger>
<#if documentation>
    /**
     * Logger.
     */
</#if>
    private static final Logger LOGGER${'\n'}            = LoggerFactory.getLogger(${proc.className}DAOImpl.class);

</#if>
<#if documentation>
    /**
     * <#if proc.function>Function<#else>Stored procedure</#if>.
     *
     * ${proc.fullName}
     *
     */
</#if>
    private final ${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> <#if proc.function>function<#else>procedure</#if>;

<#if importConnectionUtils??>
<#if documentation>
    /**
     * The connection util.
     */
</#if>
    private final ${prefixUtilityName}ConnectionUtil connectionUtil;

</#if>
<#if importBlobUtil??>
<#if documentation>
    /**
     * Blob utility.
     */
</#if>
    private final ${prefixUtilityName}BlobUtil blobUtil;

</#if>
<#if importClobUtil??>
<#if documentation>
    /**
     * Clob utility.
     */
</#if>
    private final ${prefixUtilityName}ClobUtil clobUtil;

</#if>

<#list proc.arrayImports as parameter>
<#if documentation>
    /**
     * ${parameter.javaTypeName} builder utility.
     */
</#if>
    private final ${parameter.javaTypeName}Builder ${parameter.javaTypeFieldName}Builder;

</#list>
<#list proc.objectImports as parameter>
<#if documentation>
    /**
     * ${parameter.javaTypeName} builder utility.
     */
</#if>
    private final ${parameter.javaTypeName}Builder ${parameter.javaTypeFieldName}Builder;

</#list>

<#if proc.checkResult>
<#if documentation>
    /**
     * Check result utility.
     */
</#if>
    private final ${prefixUtilityName}CheckResult checkResult;

</#if>
<#if documentation>
    /**
     * Class constructor.
     *
     * ${proc.className}DAOImpl
     */
</#if>
    public ${proc.className}DAOImpl(${'\n'}            final ${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> <#if proc.function>function<#else>procedure</#if><#if importConnectionUtils??>,${'\n'}            final ${prefixUtilityName}ConnectionUtil connectionUtil</#if><#if importBlobUtil??>,${'\n'}            final ${prefixUtilityName}BlobUtil blobUtil</#if><#if importClobUtil??>,${'\n'}            final ${prefixUtilityName}ClobUtil clobUtil</#if><#list proc.objectImports as parameter>,${'\n'}            final ${parameter.javaTypeName}Builder ${parameter.javaTypeFieldName}Builder</#list><#list proc.arrayImports as parameter>,${'\n'}            final ${parameter.javaTypeName}Builder ${parameter.javaTypeFieldName}Builder</#list><#if proc.checkResult>,${'\n'}            final ${prefixUtilityName}CheckResult checkResult</#if>${'\n'}    ) {
        this.<#if proc.function>function<#else>procedure</#if> = <#if proc.function>function<#else>procedure</#if>;
<#if importConnectionUtils??>
        this.connectionUtil = connectionUtil;
</#if>
<#if importBlobUtil??>
        this.blobUtil = blobUtil;
</#if>
<#if importClobUtil??>
        this.clobUtil = clobUtil;
</#if>
<#list proc.objectImports as parameter>
        this.${parameter.javaTypeFieldName}Builder = ${parameter.javaTypeFieldName}Builder;
</#list>
<#list proc.arrayImports as parameter>
        this.${parameter.javaTypeFieldName}Builder = ${parameter.javaTypeFieldName}Builder;
</#list>
<#if proc.checkResult>
        this.checkResult = checkResult;
</#if>
    }

<#if documentation>
    /**
     * Execute <#if proc.function>function<#else>stored procedure</#if>.
     *
     * ${proc.fullName}
     *
<#if proc.hasInput>
     * @param params input parameters
</#if>
<#if proc.hasOutput>
     * @return output parameters
</#if>
     * @throws SQLException if error.
     */
</#if>
    @Override
    public <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute(<#if proc.hasInput>${'\n'}            final ${proc.className}IN params${'\n'}    </#if>) throws SQLException {

        Map<String, Object> in${proc.className} = new HashMap<<#if !diamond>String, Object</#if>>();
<#if proc.hasOutput>
        Map<String, Object> out${proc.className};
</#if>
<#if importConnectionUtils??>

        Connection connection = null;
</#if>

        try {
<#if importConnectionUtils??>

            connection = connectionUtil.process();

<#list proc.inputParameters as parameter>
<#if parameter.array || parameter.object>
            Object ${parameter.fieldName};
</#if>
</#list>
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>

            ${parameter.fieldName} = ${parameter.javaTypeFieldName}Builder.process(
                    connection,
                    params.get${parameter.propertyName}()
            );
</#if>
</#list>
</#if>

<#list proc.inputParameters as parameter>
<#if parameter.array || parameter.object>
            in${proc.className}.put("${parameter.prefix}${parameter.name}",
                    ${parameter.fieldName}
            );
<#else>
            in${proc.className}.put("${parameter.prefix}${parameter.name}",
                    params.get${parameter.propertyName}()
            );
</#if>
</#list>
<#if proc.hasInput>

</#if>
            <#if proc.hasOutput>out${proc.className} = </#if><#if proc.function>function<#else>procedure</#if>.execute(in${proc.className});

        } catch (Exception ex) {
<#if logger>
            LOGGER.error(ex.getMessage(), ex);
</#if>
            throw new SQLException(ex.getMessage(), "${successCode}", ex);
<#if importConnectionUtils??> 
        } finally {
            connectionUtil.release(connection);
        }
<#else>
        }
</#if>
<#if proc.hasOutput>
<#if proc.checkResult>

        checkResult.check(out${proc.className});
</#if>
<#if !fullConstructor>

        ${proc.className}OUTImpl result;
        result = new ${proc.className}OUTImpl();
</#if>

<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        List<${parameter.javaTypeName}> ${parameter.fieldName}${proc.className};
<#else>
        ${parameter.javaTypeName} ${parameter.fieldName}${proc.className};
</#if>
</#list>

<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        ${parameter.fieldName}${proc.className} = (List) out${proc.className}.get("${parameter.prefix}${parameter.name}");
<#elseif parameter.clob>
        ${parameter.fieldName}${proc.className} = clobUtil.process(out${proc.className}.get("${parameter.prefix}${parameter.name}"));
<#elseif parameter.blob>
        ${parameter.fieldName}${proc.className} = blobUtil.process(out${proc.className}.get("${parameter.prefix}${parameter.name}"));
<#else>
        ${parameter.fieldName}${proc.className} = (${parameter.javaTypeName}) out${proc.className}.get("${parameter.prefix}${parameter.name}");
</#if>
</#list>
<#if !fullConstructor>

<#list proc.outputParameters as parameter>
        result.set${parameter.propertyName}(${parameter.fieldName}${proc.className});
</#list>

        return result;
<#else>

        return new ${proc.className}OUTImpl(${'\n'}            <#list proc.outputParameters as parameter>${parameter.fieldName}${proc.className}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>
</#if>
    }

}
