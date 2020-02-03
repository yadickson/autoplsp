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
}
