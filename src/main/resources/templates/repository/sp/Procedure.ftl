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
package ${javaPackage}.repository.sp;

import java.util.Map;

/**
 * DAO interface for <#if proc.function>function<#else>stored procedure</#if>.
 *
 * ${proc.fullName}
 *
 * @author @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public interface ${proc.className}SP {
<#if driverName == 'oracle' >

    /*
     CREATE OR REPLACE <#if proc.function>FUNCTION<#else>PROCEDURE</#if> ${proc.name}
<#if proc.hasInput>
     (
</#if>
<#assign nameLength = 0>
<#assign directionLength = 0>
<#list proc.parameters as parameter>
<#if !(parameter.name?length < nameLength)>
<#assign nameLength = parameter.name?length>
</#if>
<#if !(parameter.sqlNativeDirection?length < directionLength)>
<#assign directionLength = parameter.sqlNativeDirection?length>
</#if>
</#list>
<#list proc.parameters as parameter>
         ${parameter.name}<#list parameter.name?length..nameLength as i> </#list>    ${parameter.sqlNativeDirection} <#list parameter.sqlNativeDirection?length..directionLength as i> </#list>${parameter.sqlNativeTypeName}<#sep>,</#sep>
</#list>
<#if proc.hasInput>
     )
</#if>
     AS
     BEGIN

<#if proc.checkResult>
         ${outParameterCode} := ${successCode};
         ${outParameterMessage} := 'OK';

</#if>
<#if proc.hasResultSet>
<#list proc.parameters as parameter>
<#if parameter.resultSet>
         OPEN ${parameter.name} FOR
         SELECT
<#list parameter.parameters as pcursor>
             <#if pcursor.string>' <#elseif pcursor.clob>TO_CLOB(' <#elseif pcursor.blob>TO_BLOB(0<#else>0</#if><#if pcursor.string>'<#elseif pcursor.clob>')<#elseif pcursor.blob>)</#if> AS ${pcursor.name}<#sep>,</#sep>
</#list>
         FROM DUAL;
</#if>
</#list>
</#if>
<#if !proc.checkResult && !proc.hasResultSet>
         NULL;
</#if>

     EXCEPTION            
        WHEN OTHERS
        THEN
<#if proc.checkResult>
              ${outParameterCode} := 1${successCode};
              ${outParameterMessage} := 'NOK';
<#else>
              NULL;
</#if>
     END;
    */
</#if>
    /**
     * Execute the function or stored procedure.
     *
     * @return response.
     * @param params input parameters.
     */
    Map<String, Object> execute(Map<String, ?> params);
}
