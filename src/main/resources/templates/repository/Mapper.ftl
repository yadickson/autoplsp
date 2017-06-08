<#if parameter.resultSet>
package ${javaPackage}.repository.mapper;

import ${javaPackage}.domain.${proc.className}${parameter.propertyName}RS;

/**
 * Mapper para resultset de ${parameter.name}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class ${proc.className}${parameter.propertyName}RSRowMapper implements org.springframework.jdbc.core.RowMapper, java.io.Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * Mapea un registro del resultset a un bean
     * @param resultSet resultset
     * @param i numero de fila
     * @throws java.sql.SQLException en caso de error
     * @return el bean
     */
    @Override
    public Object mapRow (java.sql.ResultSet resultSet, int i) throws java.sql.SQLException
    {
        ${proc.className}${parameter.propertyName}RS result = new ${proc.className}${parameter.propertyName}RS();
        
        <#list parameter.parameters as paramrs>
        <#if paramrs.sqlTypeName == 'java.sql.Types.TIMESTAMP'>
        result.set${paramrs.propertyName} ((${paramrs.javaTypeName})resultSet.getTimestamp(${paramrs.position}));
        <#else>
        result.set${paramrs.propertyName} ((${paramrs.javaTypeName})resultSet.getObject(${paramrs.position}));
        </#if>
        </#list>

        return result;
    }
}
</#if>
