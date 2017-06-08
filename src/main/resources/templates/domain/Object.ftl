<#if parameter.object>
package ${javaPackage}.domain;

/**
 * Bean de objeto para ${parameter.objectName}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public class ${parameter.javaTypeName} implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    <#list parameter.parameters as parameter2>
    /**
     * Nombre parametro: ${parameter2.fieldName}
     * Tipo: ${parameter2.javaTypeName}
     */
    private ${parameter2.javaTypeName} ${parameter2.fieldName} = null;

    </#list>
    /**
     * Constructor de la clase ${parameter.propertyName}Object.
     */
    public ${parameter.javaTypeName}() {
    }

    /**
     * Constructor de la clase ${parameter.propertyName}Object.
     *
    <#list parameter.parameters as parameter2>
     * @param ${parameter2.fieldName} establecer el valor de ${parameter2.fieldName}
    </#list>
     */
    public ${parameter.javaTypeName}(<#list parameter.parameters as parameter2>${parameter2.javaTypeName} ${parameter2.fieldName}<#sep>, </#sep></#list>) {
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
     * Permite obtener el Objeto de Oracle
     * @param connection Conexion a base de datos
     * @return struct Object
     * @throws Exception Excepcion si error
     */
    public Object getObject(java.sql.Connection connection) throws Exception {
        oracle.sql.StructDescriptor descriptor = oracle.sql.StructDescriptor.createDescriptor("${parameter.realObjectName}", connection);
        return new oracle.sql.STRUCT(descriptor, connection, new Object[]{<#list parameter.parameters as parameter>get${parameter.propertyName}()<#sep>, </#sep></#list>});
    }

    /**
     * Obtener representacion del objeto
     * @return representacion del objeto
     */
    @Override
    public String toString() {
        StringBuilder str = new StringBuilder();

        str.append("[${parameter.javaTypeName}]");
        <#list parameter.parameters as parameter2>
        str.append(" ${parameter2.fieldName}=");
        str.append(${parameter2.fieldName});
        <#sep>str.append(", ");</#sep>
        </#list>
        return str.toString();
    }
}
</#if>
