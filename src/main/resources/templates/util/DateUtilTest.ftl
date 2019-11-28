package ${javaPackage}.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class DateUtilTest {

    @Test
    public void testCreate() throws java.sql.SQLException {
        Assert.assertNotNull(new DateUtil());
    }

    @Test
    public void testInputNull() throws java.sql.SQLException {
        Assert.assertNull(DateUtil.process(null));
    }

    @Test
    public void testInputNotNull() throws java.sql.SQLException {
        java.util.Date date = new java.util.Date();
        java.util.Date result = DateUtil.process(date);
        Assert.assertNotNull(result);
        Assert.assertNotSame(date, result);
        Assert.assertEquals(date, result);
    }
}
