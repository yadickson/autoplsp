package ${javaPackage}.util;

import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;

<#if junit == 'junit5'>
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
<#else>
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;
</#if>

<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
public class ${prefixUtilityName}BlobUtilTest {

    @InjectMocks
    ${prefixUtilityName}BlobUtilImpl blobUtil;

    @Test
    public void testInputNull() {
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNull(blobUtil.process(null));
    }
}
