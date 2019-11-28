package ${javaPackage}.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
@SuppressWarnings({"rawtypes", "unchecked"})
public class CheckResultTest {

    @Test
    public void testCreate() throws java.sql.SQLException {
        Assert.assertNotNull(new CheckResult());
    }

    @Test
    public void testInputNull() throws java.sql.SQLException {
        Assert.assertNull(CheckResult.check(null));
    }

    @Test(expected = java.sql.SQLException.class)
    public void testInputNotNullFail() throws java.sql.SQLException {
        java.util.Map map = new java.util.HashMap();
        CheckResult.check(map);
    }

    @Test(expected = java.sql.SQLException.class)
    public void testInputResponseError() throws java.sql.SQLException {
        java.util.Map map = new java.util.HashMap();

        map.put("${outParameterCode}", 1);
        map.put("${outParameterMessage}", "ERROR");

        CheckResult.check(map);
    }

    @Test
    public void testInputOk() throws java.sql.SQLException {
        java.util.Map map = new java.util.HashMap();

        map.put("${outParameterCode}", 0);
        map.put("${outParameterMessage}", "OK");

        java.util.Map result = CheckResult.check(map);
        Assert.assertNotNull(result);
        Assert.assertSame(map, result);
    }

}
