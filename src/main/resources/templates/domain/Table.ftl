<#if parameter.array>
package ${javaPackage}.domain;

/**
 * Bean de array para ${parameter.objectName}
 * @author Generado por @GENERATOR.NAME@
 * @version @GENERATOR.VERSION@
 */
public class ${parameter.javaTypeName} extends java.util.ArrayList<${parameter.parameters[parameter.parameters?size - 1].javaTypeName}> implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * Permite obtener el Array de Oracle
     * @param connection Conexion a base de datos
     * @return array Object
     * @throws Exception Excepcion si error
     */
    public Object getObject(java.sql.Connection connection) throws Exception {

        oracle.sql.ArrayDescriptor descriptor = oracle.sql.ArrayDescriptor.createDescriptor("${parameter.realObjectName}", connection);
        Object[] input = new Object[size()];

        int i = 0;

        for (${parameter.parameters[parameter.parameters?size - 1].javaTypeName} obj : this) {
            <#if parameter.parameters[parameter.parameters?size - 1].object>
            input[i++] = obj.getObject(connection);
            <#else>
            input[i++] = obj;
            </#if>
        }

        return new oracle.sql.ARRAY(descriptor, connection, input);
    }

    /**
     * Obtener representacion del objeto
     * @return representacion del objeto
     */
    @Override
    public String toString() {
        return org.apache.commons.lang.builder.ToStringBuilder.reflectionToString(this);
    }
}
</#if>
