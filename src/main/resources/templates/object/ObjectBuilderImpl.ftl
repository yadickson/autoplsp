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
package ${javaPackage}.object;
<#list parameter.parameters as parameter>
<#if parameter.clob>
<#assign importClobUtil = 1>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
<#elseif parameter.date>
<#assign importDateUtil = 1>
</#if>
</#list>

import java.sql.Connection;
import java.sql.SQLException;

<#if importBlobUtil??>
import ${javaPackage}.util.${prefixUtilityName}BlobUtil;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.${prefixUtilityName}ClobUtil;
</#if>
<#if importDateUtil??>
import ${javaPackage}.util.${prefixUtilityName}DateUtil;
</#if>
import ${javaPackage}.util.${prefixUtilityName}ObjectUtil;

import org.springframework.stereotype.Component;

<#if documentation>
/**
 * Bean object for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
</#if>
@Component
public final class ${parameter.javaTypeName}BuilderImpl
        implements ${parameter.javaTypeName}Builder {
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
<#if importDateUtil??>

<#if documentation>
    /**
     * Date utility.
     */
</#if>
    private final ${prefixUtilityName}DateUtil dateUtil;
</#if>

<#if documentation>
    /**
     * Object utility.
     */
</#if>
    private final ${prefixUtilityName}ObjectUtil objectUtil;

<#if documentation>
    /**
     * Class constructor.
     *
     * ${parameter.javaTypeName}BuilderImpl
     */
</#if>
    public ${parameter.javaTypeName}BuilderImpl(${'\n'}            final ${prefixUtilityName}ObjectUtil objectUtil<#if importBlobUtil??>,${'\n'}            final ${prefixUtilityName}BlobUtil blobUtil</#if><#if importClobUtil??>,${'\n'}            final ${prefixUtilityName}ClobUtil clobUtil</#if><#if importDateUtil??>,${'\n'}            final ${prefixUtilityName}DateUtil dateUtil</#if>${'\n'}    ) {
        this.objectUtil = objectUtil;
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
            final ${parameter.javaTypeName} object
    ) throws SQLException {

<#list parameter.parameters as parameter>
        Object ${parameter.fieldName}${parameter.javaTypeName};
</#list>

<#list parameter.parameters as parameter>
<#if parameter.clob>
        ${parameter.fieldName}${parameter.javaTypeName} = clobUtil.process(connection, object.get${parameter.propertyName}());
<#elseif parameter.blob>
        ${parameter.fieldName}${parameter.javaTypeName} = blobUtil.process(connection, object.get${parameter.propertyName}());
<#elseif parameter.date>
        ${parameter.fieldName}${parameter.javaTypeName} = dateUtil.process(object.get${parameter.propertyName}());
<#else>
        ${parameter.fieldName}${parameter.javaTypeName} = object.get${parameter.propertyName}();
</#if>
</#list>

        Object[] objs = new Object[]{
<#list parameter.parameters as parameter>            ${parameter.fieldName}${parameter.javaTypeName}<#sep>,</#sep>
</#list>        };

        return objectUtil.process(
                connection,
                "${parameter.realObjectName}",
                objs
        );
    }
}
