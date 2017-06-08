<#if proc.hasInput>
package ${javaPackage}.domain;

/**
 * Bean de entrada para stored procedure ${proc.name}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public class ${proc.className}IN implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    <#list proc.inputParameters as parameter>
    /**
     * Nombre parametro: ${parameter.fieldName}
     * Tipo: ${parameter.javaTypeName}
     */
    private ${parameter.javaTypeName} ${parameter.fieldName} = null;

    </#list>
    /**
     * Constructor de la clase ${proc.className}IN.
     */
    public ${proc.className}IN() {
    }

    /**
     * Constructor de la clase ${proc.className}IN.
     *
    <#list proc.inputParameters as parameter>
     * @param ${parameter.fieldName} establecer el valor de ${parameter.fieldName}
    </#list>
     */
    public ${proc.className}IN(<#list proc.inputParameters as parameter>${parameter.javaTypeName} ${parameter.fieldName}<#sep>, </#sep></#list>) {
        <#list proc.inputParameters as parameter>
        this.${parameter.fieldName} = ${parameter.fieldName};
        </#list>
    }

    <#list proc.inputParameters as parameter>
    /**
     * Getter para ${parameter.fieldName}
     * @return ${parameter.fieldName}
     */
    public ${parameter.javaTypeName} get${parameter.propertyName}() {
        return ${parameter.fieldName};
    }
    
    /**
     * Setter para ${parameter.fieldName}
     * @param ${parameter.fieldName} ${parameter.fieldName}
     */
    public void set${parameter.propertyName}(${parameter.javaTypeName} ${parameter.fieldName}) {
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

        str.append("[${proc.className}IN]");
        <#list proc.inputParameters as parameter>
        str.append(" ${parameter.fieldName}=");
        str.append(${parameter.fieldName});
        <#sep>str.append(", ");</#sep>
        </#list>
        return str.toString();
    }
}
</#if>
