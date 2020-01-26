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
</#if>
</#list>

import java.sql.Connection;
import java.sql.SQLException;

<#if importBlobUtil??>
import ${javaPackage}.util.BlobUtil;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.ClobUtil;
</#if>
import ${javaPackage}.util.ObjectUtil;

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
    private BlobUtil blobUtil;
</#if>
<#if importClobUtil??>

    /**
     * Clob utility.
     */
    @Autowired
    private ClobUtil clobUtil;
</#if>

    /**
     * Object utility.
     */
    @Autowired
    private ObjectUtil objectUtil;

    /**
     * {@inheritDoc}
     */
    @Override
    public Object process(
            final Connection connection,
            final ${parameter.javaTypeName} object
    ) throws SQLException {

<#list parameter.parameters as parameter>
<#if parameter.clob>
        oracle.sql.CLOB clob${parameter.propertyName} = oracle.sql.CLOB.createTemporary(connection, false, oracle.sql.CLOB.DURATION_SESSION);
        java.io.Writer clobWriter${parameter.propertyName} = clob${parameter.propertyName}.getCharacterOutputStream();

        if (get${parameter.propertyName}() != null) {
            clobWriter${parameter.propertyName}.write(get${parameter.propertyName}().toCharArray());
        }

        clobWriter${parameter.propertyName}.flush();
        clobWriter${parameter.propertyName}.close();

<#elseif parameter.blob>
        oracle.sql.BLOB blob${parameter.propertyName} = oracle.sql.BLOB.createTemporary(connection, false, oracle.sql.BLOB.DURATION_SESSION);
        blob${parameter.propertyName}.getBinaryOutputStream().write(get${parameter.propertyName}());

<#elseif parameter.date>
        oracle.sql.DATE date${parameter.propertyName} = get${parameter.propertyName}() == null ? null : new oracle.sql.DATE(new java.sql.Date(get${parameter.propertyName}().getTime()));

</#if>
</#list>
        Object[] objs = new Object[]{
<#list parameter.parameters as parameter>            <#if parameter.clob>clob${parameter.propertyName}<#elseif parameter.blob>blob${parameter.propertyName}<#elseif parameter.date>date${parameter.propertyName}<#else>object.get${parameter.propertyName}()</#if><#sep>,</#sep>
</#list>        };

        return objectUtil.process(
                connection,
                "${parameter.realObjectName}",
                objs
        );
    }
}
