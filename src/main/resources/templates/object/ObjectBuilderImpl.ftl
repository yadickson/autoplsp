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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Bean object for datatype ${parameter.realObjectName}.
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Component
public final class ${parameter.javaTypeName}BuilderImpl
        implements ${parameter.javaTypeName}Builder {
<#if importBlobUtil??>

    /**
     * Blob utility.
     */
    @Autowired
    private ${prefixUtilityName}BlobUtil blobUtil;
</#if>
<#if importClobUtil??>

    /**
     * Clob utility.
     */
    @Autowired
    private ${prefixUtilityName}ClobUtil clobUtil;
</#if>
<#if importDateUtil??>

    /**
     * Date utility.
     */
    @Autowired
    private ${prefixUtilityName}DateUtil dateUtil;
</#if>

    /**
     * Object utility.
     */
    @Autowired
    private ${prefixUtilityName}ObjectUtil objectUtil;

    /**
     * {@inheritDoc}
     */
    @Override
    public Object process(
            final Connection connection,
            final ${parameter.javaTypeName} object
    ) throws SQLException {

<#list parameter.parameters as parameter>
        Object ${parameter.fieldName};
</#list>

<#list parameter.parameters as parameter>
<#if parameter.clob>
        ${parameter.fieldName} = clobUtil.process(connection, object.get${parameter.propertyName}());
<#elseif parameter.blob>
        ${parameter.fieldName} = blobUtil.process(connection, object.get${parameter.propertyName}());
<#elseif parameter.date>
        ${parameter.fieldName} = dateUtil.process(object.get${parameter.propertyName}());
<#else>
        ${parameter.fieldName} = object.get${parameter.propertyName}();
</#if>
</#list>

        Object[] objs = new Object[]{
<#list parameter.parameters as parameter>            ${parameter.fieldName}<#sep>,</#sep>
</#list>        };

        return objectUtil.process(
                connection,
                "${parameter.realObjectName}",
                objs
        );
    }
}
