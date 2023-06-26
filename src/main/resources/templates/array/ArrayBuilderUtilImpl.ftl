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
package ${javaPackage}.${arrayFolderName};
<#assign importList = ["java.sql.Connection", "java.sql.SQLException", "org.springframework.stereotype.Component"]>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ArrayUtil"]>
</#if>
<#if parameter.parameters[parameter.parameters?size - 1].object>
<#assign importObjectBuilderUtil = 1>
<#if objectFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.parameters[parameter.parameters?size - 1].javaTypeName}"]>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.parameters[parameter.parameters?size - 1].javaTypeName}BuilderUtil"]>
</#if>
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
<#assign importDateUtil = 1>
<#assign importList = importList + ["java.util.Date"]>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}DateUtil"]>
</#if>
<#elseif parameter.parameters[parameter.parameters?size - 1].clob>
<#assign importClobUtil = 1>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ClobUtil"]>
</#if>
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
<#assign importBlobUtil = 1>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}BlobUtil"]>
</#if>
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
 * Builder class to make array for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
final class ${parameter.javaTypeName}BuilderUtilImpl${'\n'}        implements ${parameter.javaTypeName}BuilderUtil {

<#if documentation>
    /**
     * Array utility.
     */
</#if>
    private final ${prefixUtilityName}ArrayUtil arrayUtil;
<#if importObjectBuilderUtil??>

<#if documentation>
    /**
     * Object utility to build ${parameter.parameters[parameter.parameters?size - 1].realObjectName}.
     */
</#if>
    private final ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}BuilderUtil objectBuilderUtil;
<#elseif importDateUtil??>

<#if documentation>
    /**
     * Date utility.
     */
</#if>
    private final ${prefixUtilityName}DateUtil dateUtil;
<#elseif importBlobUtil??>

<#if documentation>
    /**
     * Blob utility.
     */
</#if>
    private final ${prefixUtilityName}BlobUtil blobUtil;
<#elseif importClobUtil??>

<#if documentation>
    /**
     * Clob utility.
     */
</#if>
    private final ${prefixUtilityName}ClobUtil clobUtil;
</#if>

<#if documentation>
    /**
     * Class constructor.
     *
     * ${parameter.javaTypeName}BuilderUtilImpl
     */
</#if>
    public ${parameter.javaTypeName}BuilderUtilImpl(${'\n'}            final ${prefixUtilityName}ArrayUtil arrayUtil<#if importObjectBuilderUtil??>,${'\n'}            final ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}BuilderUtil objectBuilderUtil</#if><#if importBlobUtil??>,${'\n'}            final ${prefixUtilityName}BlobUtil blobUtil</#if><#if importClobUtil??>,${'\n'}            final ${prefixUtilityName}ClobUtil clobUtil</#if><#if importDateUtil??>,${'\n'}            final ${prefixUtilityName}DateUtil dateUtil</#if>${'\n'}    ) {
        this.arrayUtil = arrayUtil;
<#if importObjectBuilderUtil??>
        this.objectBuilderUtil = objectBuilderUtil;
</#if>
<#if importBlobUtil??>
        this.blobUtil = blobUtil;
</#if>
<#if importClobUtil??>
        this.clobUtil = clobUtil;
</#if>
<#if importDateUtil??>
        this.dateUtil = dateUtil;
</#if>
    }

<#if documentation>
    /**
     * {@inheritDoc}
     */
</#if>
    @Override
    public Object process(
            final Connection connection,
            final ${parameter.javaTypeName} array
    ) throws SQLException {

        Object[] input = new Object[array.size()];

        int i = 0;

        for (${parameter.parameters[parameter.parameters?size - 1].javaTypeName} obj : array) {
<#if importObjectBuilderUtil??>
            input[i++] = objectBuilderUtil.process(connection, obj);
<#elseif importDateUtil??>
            input[i++] = dateUtil.process(obj);
<#elseif importBlobUtil??>
            input[i++] = blobUtil.process(connection, obj);
<#elseif importClobUtil??>
            input[i++] = clobUtil.process(connection, obj);
<#else>
            input[i++] = obj;
</#if>
        }

        return arrayUtil.process(
                connection,
                "${parameter.realObjectName}",
                input
        );
    }
}
