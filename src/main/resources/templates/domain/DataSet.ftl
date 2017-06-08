<#if parameter.resultSet>
package ${javaPackage}.domain;

/**
 * Bean de cursor para parametro ${parameter.name} en ${proc.name}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public class ${proc.className}${parameter.propertyName}RS implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    <#list parameter.parameters as parameter2>
    /**
     * Nombre parametro: ${parameter2.fieldName}
     * Tipo: ${parameter2.javaTypeName}
     */
    private ${parameter2.javaTypeName} ${parameter2.fieldName} = null;

    </#list>    
    /**
     * Constructor de la clase ${proc.className}${parameter.propertyName}RS.
     */
    public ${proc.className}${parameter.propertyName}RS() {
    }

    /**
     * Constructor de la clase ${parameter.propertyName}Object.
     *
    <#list parameter.parameters as parameter2>
     * @param ${parameter2.fieldName} establecer el valor de ${parameter2.fieldName}
    </#list>
     */
    public ${proc.className}${parameter.propertyName}RS(<#list parameter.parameters as parameter2>${parameter2.javaTypeName} ${parameter2.fieldName}<#sep>, </#sep></#list>) {
        <#list parameter.parameters as parameter2>
        this.${parameter2.fieldName} = ${parameter2.fieldName};
        </#list>
    }

    <#list parameter.parameters as parameter2>
    /**
     * Getter para ${parameter2.fieldName}
     * @return ${parameter2.fieldName}
     */
    public ${parameter2.javaTypeName} get${parameter2.propertyName}() {
        return ${parameter2.fieldName};
    }
    
    /**
     * Setter para ${parameter2.fieldName}
     * @param ${parameter2.fieldName} ${parameter2.fieldName}
     */
    public void set${parameter2.propertyName}(${parameter2.javaTypeName} ${parameter2.fieldName}) {
        this.${parameter2.fieldName} = ${parameter2.fieldName};
    }
    
    </#list>
    /**
     * Obtener representacion del objeto
     * @return representacion del objeto
     */
    @Override
    public String toString() {
        StringBuilder str = new StringBuilder();

        str.append("[${proc.className}${parameter.propertyName}RS]");
        <#list parameter.parameters as parameter2>
        str.append(" ${parameter2.fieldName}=");
        str.append(${parameter2.fieldName});
        <#sep>str.append(", ");</#sep>
        </#list>
        return str.toString();
    }
}
</#if>

