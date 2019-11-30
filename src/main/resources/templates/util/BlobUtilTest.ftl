package ${javaPackage}.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class BlobUtilTest {

    @InjectMocks
    BlobUtilImpl blobUtil;

    @Test
    public void testInputNull() {
        Assert.assertNull(blobUtil.process(null));
    }
}
