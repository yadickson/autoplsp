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
package ${javaPackage}.repository;

<#if proc.hasInput>
import ${javaPackage}.domain.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.domain.${proc.className}OUT;
</#if>
<#list proc.parameters as parameter>
<#if parameter.resultSet>
import ${javaPackage}.domain.${parameter.javaTypeName};
</#if>
</#list>
import ${javaPackage}.repository.sp.${proc.className}SP;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

/**
 * JDBCTemplate implementation for stored procedure ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Repository
@SuppressWarnings({"rawtypes","unchecked"})
public class ${proc.className}DAOImpl implements ${proc.className}DAO {

    <#if proc.hasObject || proc.hasArray>
    private javax.sql.DataSource dataSource;
    </#if>
    private ${proc.className}SP sp = null;

    /**
     * Setter for datasource
     * @param dataSource dataSource
     */
    @Resource(name="${dataSource}")
    public void setDataSource(javax.sql.DataSource dataSource) {
        <#if proc.hasObject || proc.hasArray>
        this.dataSource = dataSource;
        </#if>
        this.sp = new ${proc.className}SP(dataSource);
    }

    /**
     * Execute stored procedure
     *
     * <#if proc.hasInput>@param params input parameters</#if>
     * <#if proc.hasOutput>@return output parameters</#if>
     * @throws java.sql.SQLException
     */
    @Override
    public <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute(<#if proc.hasInput>${proc.className}IN params</#if>) throws java.sql.SQLException {

        java.util.Map mparams = new java.util.HashMap();
        <#if proc.hasOutput>
        java.util.Map r;
        </#if>

        try {
        <#list proc.inputParameters as parameter>
        <#if parameter.object || parameter.array>
            mparams.put("${parameter.name}", params.get${parameter.propertyName}().getObject(dataSource.getConnection()));
        <#else>
            mparams.put("${parameter.name}", params.get${parameter.propertyName} ());
        </#if>
        </#list>
        <#if !proc.hasOutput>
            this.sp.execute(mparams);
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }
        </#if>
        <#if proc.hasOutput>
            r = this.sp.execute(mparams);
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }

        java.util.Map m = evaluateResult(r);

        ${proc.className}OUT result = new ${proc.className}OUT();

        try {
        <#list proc.outputParameters as parameter>
        <#if parameter.sqlTypeName != 'java.sql.Types.CLOB'>
        <#if parameter.resultSet >
            result.set${parameter.propertyName}((java.util.List<${parameter.javaTypeName}>)m.get("${parameter.name}"));
        <#else>
            result.set${parameter.propertyName}((${parameter.javaTypeName})m.get("${parameter.name}"));
        </#if>
        <#else>
            java.sql.Clob clob${parameter.name} = ( java.sql.Clob ) m.get("${parameter.name}");
            String string${parameter.name};
            string${parameter.name} = clob${parameter.name} == null ? null : clob${parameter.name}.getSubString( 1 , (int) clob${parameter.name}.length() );
            result.set${parameter.propertyName}( string${parameter.name} );
        </#if>
        </#list>
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }

        return result;
        </#if>
    }
    <#if proc.hasOutput>

    /**
     * Evaluate output parameters fron database
     *
     * @param result map to evaluate
     * @throws java.sql.SQLException
     */
    private java.util.Map evaluateResult(java.util.Map result) throws java.sql.SQLException {

        if (result == null) {
            return null;
        }
        <#list proc.outputParameters as parameter>
          <#if parameter.number && (parameter.position > 0) && parameter.name == outParameterCode >
          <#assign pCode="${parameter.name}">
          </#if>
        </#list>
        <#list proc.outputParameters as parameter>
          <#if parameter.string && (parameter.position > 0) && parameter.name == outParameterMessage >
          <#assign pMessage="${parameter.name}">
          </#if>
        </#list>
        <#if pCode?? && pMessage?? >

        Number code;
        String description;
        int val;

        try {
            code = (Number) result.get("${pCode}");
            description = (String) result.get("${pMessage}");
            val = code.intValue();
        } catch ( Exception ex ) {
            throw new java.sql.SQLException(ex);
        }

        if (val != 0) {
            throw new java.sql.SQLException(description, null, val);
        }
        </#if>

        return result;
    }
    </#if>
}
