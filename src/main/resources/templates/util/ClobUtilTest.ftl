package ${javaPackage}.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class ${prefixUtilityName}ClobUtilTest {

    @InjectMocks
    ${prefixUtilityName}ClobUtilImpl clobUtil;

    @Test
    public void testInputNull() {
        Assert.assertNull(clobUtil.process(null));
    }
/*
    @Test
    public void testInputNotNullFail() {
        java.util.Map<String, Object> map = new java.util.HashMap<<#if !diamond>String, Object</#if>>();
        clobUtil.process(map);
    }

    @Test(expected = java.sql.SQLException.class)
    public void testInputResponseError() {
        java.util.Map<String, Object> map = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

        map.put("${outParameterCode}", 1${successCode}1);
        map.put("${outParameterMessage}", "ERROR");

        clobUtil.process(map);
    }

    @Test
    public void testInputOk() {
        java.util.Map<String, Object> map = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

        map.put("${outParameterCode}", ${successCode});
        map.put("${outParameterMessage}", "OK");

        clobUtil.process(map);
    }
*/
}
