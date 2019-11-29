package ${javaPackage}.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
@SuppressWarnings({"rawtypes", "unchecked"})
public class CheckResultTest {

    @InjectMocks
    CheckResultImpl checkResult;

    @Test
    public void testInputNull() throws java.sql.SQLException {
        checkResult.check(null);
    }

    @Test(expected = java.sql.SQLException.class)
    public void testInputNotNullFail() throws java.sql.SQLException {
        java.util.Map map = new java.util.HashMap();
        checkResult.check(map);
    }

    @Test(expected = java.sql.SQLException.class)
    public void testInputResponseError() throws java.sql.SQLException {
        java.util.Map map = new java.util.HashMap();

        map.put("${outParameterCode}", 1${successCode}1);
        map.put("${outParameterMessage}", "ERROR");

        checkResult.check(map);
    }

    @Test
    public void testInputOk() throws java.sql.SQLException {
        java.util.Map map = new java.util.HashMap();

        map.put("${outParameterCode}", ${successCode});
        map.put("${outParameterMessage}", "OK");

        checkResult.check(map);
    }

}
