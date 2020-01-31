package ${javaPackage}.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class ${prefixUtilityName}DateUtilTest {

    @Test
    public void testCreate() {
        Assert.assertNotNull(new ${prefixUtilityName}DateUtil());
    }

    @Test
    public void testInputNull() {
        Assert.assertNull(${prefixUtilityName}DateUtil.process(null));
    }

    @Test
    public void testInputNotNull() {
        java.util.Date date = new java.util.Date();
        java.util.Date result = ${prefixUtilityName}DateUtil.process(date);
        Assert.assertNotNull(result);
        Assert.assertNotSame(date, result);
        Assert.assertEquals(date, result);
    }
}
