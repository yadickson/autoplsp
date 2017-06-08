package ${javaPackage}.repository;

<#if proc.hasInput>
import ${javaPackage}.domain.${proc.className}IN;
</#if>
<#if proc.hasOutput>
import ${javaPackage}.domain.${proc.className}OUT;
</#if>
<#list proc.parameters as parameter>
<#if parameter.resultSet>
import ${javaPackage}.domain.${proc.className}${parameter.propertyName}RS;
</#if>
</#list>
import ${javaPackage}.repository.sp.${proc.className}SP;
import javax.annotation.Resource;
import org.springframework.stereotype.Repository;

/**
 * Implementacion JDBCTemplate para stored procedure ${proc.fullName}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
@Repository
@SuppressWarnings({"rawtypes","unchecked"})
public class ${proc.className}DAOImpl implements ${proc.className}DAO {

    <#if proc.hasObject || proc.hasArray>
    /**
     * Data Source
     */
    private javax.sql.DataSource dataSource;

    </#if>
    /**
     * StoredProcedure
     */
    ${proc.className}SP sp = null;

    /**
     * Setter para datasource
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
     * Ejecuta el stored procedure
     * <#if proc.hasInput>@param params Entrada de parametros del procedimiento</#if>
     * <#if proc.hasOutput>@return parametros de salida del stored procedure</#if>
     * @throws java.sql.SQLException
     */
    @Override
    public <#if proc.hasOutput>${proc.className}OUT<#else>void</#if> execute (<#if proc.hasInput>${proc.className}IN params</#if>)throws java.sql.SQLException {
        String id = "${proc.className}SP ";
        <#if proc.hasInput>
        id += params.hashCode();
        </#if>

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

        java.util.Map m = evaluateResult(id, r);

        ${proc.className}OUT result = new ${proc.className}OUT();

        try {
        <#list proc.outputParameters as parameter>
        <#if parameter.sqlTypeName != 'java.sql.Types.CLOB'>
        <#if parameter.resultSet >
            result.set${parameter.propertyName}((java.util.List<${proc.className}${parameter.propertyName}RS>)m.get("${parameter.name}"));
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
     * Evalua el resultado del servicio y gatilla una exception en 
     * caso de ser necesario
     * @param plName : nombre sp
     * @param result : mapa con el resultado de la ejecucion
     * @throws java.sql.SQLException
     */
    private java.util.Map evaluateResult(String plName, java.util.Map result) throws java.sql.SQLException {

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
            throw new java.sql.SQLException(val + ":" + description);
        }
        </#if>

        return result;
    }
    </#if>
}
