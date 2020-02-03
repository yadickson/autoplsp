package ${javaPackage}.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class ${prefixUtilityName}SafeDateTest {

    @Test
    public void testCreate() {
        Assert.assertNotNull(new ${prefixUtilityName}SafeDate());
    }

    @Test
    public void testInputNull() {
        Assert.assertNull(${prefixUtilityName}SafeDate.process(null));
    }

    @Test
    public void testInputNotNull() {
        java.util.Date date = new java.util.Date();
        java.util.Date result = ${prefixUtilityName}SafeDate.process(date);
        Assert.assertNotNull(result);
        Assert.assertNotSame(date, result);
        Assert.assertEquals(date, result);
    }
}
