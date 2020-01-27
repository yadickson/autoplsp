<#if objects?size != 0>
# object definitions

</#if>
<#if driverName == 'oracle' >
<#list objects as parameter>
<#if parameter.object>
```sql
CREATE OR REPLACE TYPE ${parameter.realObjectName} AS OBJECT
(
<#list parameter.parameters as param>
    ${param.name} ${param.sqlNativeTypeName}<#if param.string>(100 CHAR)</#if><#sep>,</#sep>
</#list>
)
```
<#elseif parameter.array>
```sql
CREATE OR REPLACE TYPE ${parameter.realObjectName} AS TABLE OF ${parameter.parameters[parameter.parameters?size - 1].realObjectName};
```
</#if>

</#list>
<#if procedures?size != 0>
# Procedure definitions

</#if>
<#list procedures as proc>
```sql
CREATE OR REPLACE <#if proc.function>FUNCTION<#else>PROCEDURE</#if> ${proc.name}
<#if proc.hasInput || proc.hasOutput >
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
<#if proc.hasInput || proc.hasOutput >
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
        <#if pcursor.string>' <#elseif pcursor.clob>TO_CLOB(' <#elseif pcursor.blob>TO_BLOB(0<#elseif pcursor.date>SYSDATE<#else>0</#if><#if pcursor.string>'<#elseif pcursor.clob>')<#elseif pcursor.blob>)</#if> AS ${pcursor.name}<#sep>,</#sep>
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
```

</#list>
</#if>