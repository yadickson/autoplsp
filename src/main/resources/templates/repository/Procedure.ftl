package ${javaPackage}.repository.sp;

<#list proc.parameters as parameter>
<#if parameter.resultSet>
import ${javaPackage}.repository.mapper.${proc.className}${parameter.propertyName}RSRowMapper;
</#if>
</#list>

/**
 * Clase que implementa el Stored Procedure ${proc.fullName}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class ${proc.className}SP extends org.springframework.jdbc.object.StoredProcedure implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * Nombre del stored procedure
     */
    public static final String SPROC_NAME = "${proc.fullName}";
    
    /**
     * Construye un storedprocedure a partir de un dataSource
     * @param dataSource dataSource
     */
    public ${proc.className}SP(javax.sql.DataSource dataSource) {
        super(dataSource, SPROC_NAME);
        <#if proc.function>
        setFunction(true);
        <#else>
        setFunction(false);
        </#if>
        <#list proc.parameters as parameter>
        declareParameter(new org.springframework.jdbc.core.Sql<#if parameter.output>Out<#elseif !parameter.input>InOut</#if>Parameter ("${parameter.name}", ${parameter.sqlTypeName}<#if parameter.resultSet>, new ${proc.className}${parameter.propertyName}RSRowMapper ()</#if>));
        </#list>
        compile();
    }
    
    /**
     * Ejecuta el storedprocedure
     * @return respuesta del storedprocedure
     * @param params parametros
     */
    @Override
    public java.util.Map execute(java.util.Map params) {
        return super.execute(params);
    }
}
