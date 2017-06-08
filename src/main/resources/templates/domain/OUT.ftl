package ${javaPackage}.domain;

/**
 * Bean de salida para stored procedure ${proc.name}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public class ${proc.className}OUT implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    <#list proc.outputParameters as parameter>
    /**
     * Nombre parametro: ${parameter.fieldName}
     * Tipo: <#if parameter.resultSet>java.util.List<${proc.className}${parameter.propertyName}RS> <#else>${parameter.javaTypeName}</#if>
     */
    private <#if parameter.resultSet>java.util.List<${proc.className}${parameter.propertyName}RS> <#else>${parameter.javaTypeName}</#if> ${parameter.fieldName} = null;

    </#list>
    /**
     * Constructor de la clase ${proc.className}IN.
     */
    public ${proc.className}OUT() {
    }

    /**
     * Constructor de la clase ${proc.className}OUT.
     *
    <#list proc.outputParameters as parameter>
     * @param ${parameter.fieldName} establecer el valor de ${parameter.fieldName}
    </#list>
     */
    public ${proc.className}OUT(<#list proc.outputParameters as parameter><#if parameter.resultSet>java.util.List<${proc.className}${parameter.propertyName}RS><#else>${parameter.javaTypeName}</#if> ${parameter.fieldName}<#sep>, </#sep></#list>) {
        <#list proc.outputParameters as parameter>
        this.${parameter.fieldName} = ${parameter.fieldName};
        </#list>
    }
    <#list proc.outputParameters as parameter>
    /**
     * Getter para ${parameter.fieldName}
     * @return ${parameter.fieldName}
     */
    public <#if parameter.resultSet>java.util.List<${proc.className}${parameter.propertyName}RS><#else>${parameter.javaTypeName}</#if> get${parameter.propertyName}() {
        return this.${parameter.fieldName};
    }

    /**
     * Setter para ${parameter.fieldName}
     * @param ${parameter.fieldName} ${parameter.fieldName}
     */
    public void set${parameter.propertyName}(<#if parameter.resultSet>java.util.List<${proc.className}${parameter.propertyName}RS><#else>${parameter.javaTypeName}</#if> ${parameter.fieldName}) {
        this.${parameter.fieldName} = ${parameter.fieldName};
    }

    </#list>
    /**
     * Obtener representacion del objeto
     * @return representacion del objeto
     */
    @Override
    public String toString() {
        StringBuilder str = new StringBuilder();

        str.append("[${proc.className}OUT]");
        <#list proc.outputParameters as parameter>
        str.append(" ${parameter.fieldName}=");
        str.append(${parameter.fieldName});
        <#sep>str.append(", ");</#sep>
        </#list>
        return str.toString();
    }
}
