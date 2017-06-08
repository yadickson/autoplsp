package ${javaPackage}.repository;

<#if proc.hasInput>
import ${javaPackage}.domain.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.domain.${proc.className}OUT;
</#if>

/**
 * DAO para stored procedure ${proc.name}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public interface ${proc.className}DAO {
    /**
     * Ejecuta el stored procedure
     * <#if proc.hasInput>@param params parametros de entrada stored procedure</#if>
     * <#if proc.hasOutput>@return parametros de salida del stored procedure</#if>
     * @throws java.sql.SQLException
     */
    <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute(<#if proc.hasInput>${proc.className}IN params</#if>) throws java.sql.SQLException;
}
