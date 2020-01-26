package ${javaPackage}.object;
<#list parameter.parameters as parameter>
<#if parameter.clob>
<#assign importClobUtil = 1>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
</#if>
</#list>

import java.sql.Connection;
import java.sql.SQLException;

<#if importBlobUtil??>
import ${javaPackage}.util.BlobUtil;
</#if>
<#if importClobUtil??>
import ${javaPackage}.util.ClobUtil;
</#if>
import ${javaPackage}.util.ObjectUtil;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
@SuppressWarnings({"rawtypes", "unchecked"})
public class ${parameter.javaTypeName}BuilderTest {

    @InjectMocks
    ${parameter.javaTypeName}BuilderImpl builder;
<#if importBlobUtil??>

    @Mock
    private BlobUtil blobUtil;
</#if>
<#if importClobUtil??>

    @Mock
    private ClobUtil clobUtil;
</#if>

    @Mock
    private ObjectUtil objectUtil;

    @Mock
    private Connection connection;

    @Test
    public void testProcess() throws SQLException {

        ${parameter.javaTypeName} object = new ${parameter.javaTypeName}();

        Object obj = new Object();

        Mockito.when(objectUtil.process(Mockito.same(connection), Mockito.eq("${parameter.realObjectName}"), Mockito.isNotNull(Object[].class))).thenReturn(obj);

        Object result = builder.process(connection, object);

        Assert.assertNotNull(result);
        Assert.assertSame(obj, result);
    }
}
