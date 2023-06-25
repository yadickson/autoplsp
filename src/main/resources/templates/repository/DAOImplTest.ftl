package ${javaPackage}.${repositoryFolderName};
<#assign importList = ["java.sql.SQLException"]>
<#list proc.parameters as parameter>
<#if parameter.object || parameter.array>
<#assign importConnectionUtils = 1>
<#assign importList = importList + ["java.sql.Connection"]>
<#if utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ConnectionUtil"]>
</#if>
</#if>
<#if parameter.date>
<#assign importList = importList + ["java.util.Date"]>
</#if>
</#list>
<#list proc.outputParameters as parameter>
<#if parameter.clob>
<#assign importClobUtil = 1>
<#if utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ClobUtil"]>
</#if>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
<#if utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}BlobUtil"]>
</#if>
</#if>
</#list>
<#list proc.arrayImports as parameter>
<#if arrayFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${arrayFolderName}.${parameter.javaTypeName}", "${javaPackage}.${arrayFolderName}.${parameter.javaTypeName}BuilderUtil"]>
</#if>
</#list>
<#list proc.parameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
<#if cursorFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${cursorFolderName}.${parameter.javaTypeName}"]>
</#if>
</#if>
</#list>
<#if proc.hasInput && domainFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${domainFolderName}.${proc.className}IN", "${javaPackage}.${domainFolderName}.${proc.className}INBuilder"]>
</#if>
<#if proc.hasOutput && domainFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${domainFolderName}.${proc.className}OUT"]>
</#if>
<#if !proc.functionInline>
<#assign importList = importList + ["${javaPackage}.${repositoryFolderName}.sp.${proc.className}SP"]>
<#else>
<#assign importList = importList + ["${javaPackage}.${repositoryFolderName}.sp.${proc.className}SqlQuery"]>
</#if>
<#list proc.objectImports as parameter>
<#if objectFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.javaTypeName}", "${javaPackage}.${objectFolderName}.${parameter.javaTypeName}BuilderUtil"]>
</#if>
</#list>
<#if proc.checkResult && utilFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}CheckResult"]>
</#if>
<#if proc.hasInput>
<#assign importList = importList + ["org.mockito.ArgumentCaptor", "org.mockito.Captor"]>
</#if>
<#assign importList = importList + ["org.mockito.InOrder", "org.mockito.Mock", "org.mockito.Mockito"]>
<#if junit == 'junit5'>
<#if proc.hasInput || proc.hasOutput>
<#assign importList = importList + ["org.junit.jupiter.api.Assertions", "org.junit.jupiter.api.BeforeEach"]>
</#if>
<#assign importList = importList + ["org.junit.jupiter.api.Test", "org.junit.jupiter.api.extension.ExtendWith", "org.mockito.junit.jupiter.MockitoExtension"]>
<#else>
<#if proc.hasInput || proc.hasOutput>
<#assign importList = importList + ["org.junit.Assert", "org.junit.Before"]>
</#if>
<#assign importList = importList + ["org.junit.Test", "org.junit.runner.RunWith", "org.mockito.runners.MockitoJUnitRunner"]>
</#if>
<#if proc.hasInput || proc.hasOutput>
<#assign importList = importList + ["com.github.javafaker.Faker"]>
</#if>

<#list importSort(importList) as import>
<#if previousImportMatch?? && !import?starts_with(previousImportMatch)>

</#if>
import ${import};
<#assign previousImportMatch = import?keep_before_last(".") >
</#list>
<#if importList?has_content>

</#if>
<#if junit == 'junit5'>
@ExtendWith(MockitoExtension.class)
<#else>
@RunWith(MockitoJUnitRunner.class)
</#if>
@SuppressWarnings({"unchecked"})
class ${proc.className}DAOImplTest {

    @Mock
    private ${proc.className}<#if !proc.functionInline>SP<#else>SqlQuery</#if> <#if proc.function>function<#else>procedure</#if>Mock;
<#if importConnectionUtils??>

    @Mock
    private Connection connectionMock;

    @Mock
    private ${prefixUtilityName}ConnectionUtil connectionUtilMock;
</#if>
<#if importBlobUtil??>

    @Mock
    private ${prefixUtilityName}BlobUtil blobUtilMock;
</#if>
<#if importClobUtil??>

    @Mock
    private ${prefixUtilityName}ClobUtil clobUtilMock;
</#if>
<#list proc.arrayImports as parameter>

    @Mock
    private ${parameter.javaTypeName}BuilderUtil ${parameter.javaTypeFieldName}BuilderUtilMock;
</#list>
<#list proc.objectImports as parameter>

    @Mock
    private ${parameter.javaTypeName}BuilderUtil ${parameter.javaTypeFieldName}BuilderUtilMock;
</#list>
<#if proc.checkResult>

    @Mock
    private ${prefixUtilityName}CheckResult checkResult;
</#if>
<#if proc.hasInput>

    @Captor
    private ArgumentCaptor<java.util.Map<String, Object>> captorParameters;
</#if>
<#if proc.hasInput || proc.hasOutput>

    private Faker faker;
</#if>

    private ${proc.className}DAO repository;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
<#if proc.hasInput || proc.hasOutput>
        faker = new Faker();
</#if>
        repository = new ${proc.className}DAOImpl(${'\n'}            <#if proc.function>function<#else>procedure</#if>Mock<#if importConnectionUtils??>,${'\n'}            connectionUtilMock</#if><#if importBlobUtil??>,${'\n'}            blobUtilMock</#if><#if importClobUtil??>,${'\n'}            clobUtilMock</#if><#list proc.objectImports as parameter>,${'\n'}            ${parameter.javaTypeFieldName}BuilderUtilMock</#list><#list proc.arrayImports as parameter>,${'\n'}            ${parameter.javaTypeFieldName}BuilderUtilMock</#list><#if proc.checkResult>,${'\n'}            checkResultMock</#if>${'\n'}        );
    }

    @Test
    void should_check_${proc.constantFullName?lower_case}_dao_execute() throws SQLException {
<#if proc.hasInput>

        ${proc.className}IN params;

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.date().birthday();
<#elseif parameter.blob>
        byte[] ${parameter.fieldName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#elseif parameter.number>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.random().nextLong();
<#elseif parameter.array || parameter.object>
        ${parameter.javaTypeName} ${parameter.fieldName} = Mockito.mock(${parameter.javaTypeName}.class);
<#else>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.internet().uuid();
</#if>
</#list>

        params = new ${proc.className}INBuilder()<#list proc.inputParameters as parameter>${'\n'}            .${parameter.fieldName}(${parameter.fieldName})</#list>${'\n'}            .build();
<#if importConnectionUtils??>

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Object[] ${parameter.fieldName}Builder = new Object[0];
</#if>
</#list>
</#if>
</#if>

        java.util.Map<String, Object> mapResult = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

<#if proc.hasOutput>
<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        java.util.List<${parameter.javaTypeName}> obj${parameter.propertyName} = new java.util.ArrayList<<#if !diamond>${parameter.javaTypeName}</#if>>();
<#elseif parameter.clob>
        java.sql.Clob obj${parameter.propertyName} = Mockito.mock(java.sql.Clob.class);
<#elseif parameter.blob>
        java.sql.Blob obj${parameter.propertyName} = Mockito.mock(java.sql.Blob.class);
<#elseif parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#list proc.outputParameters as parameter>
        mapResult.put("${parameter.name}", obj${parameter.propertyName});
</#list>

</#if>
<#if importConnectionUtils??>

        Mockito.when(connectionUtilMock.process()).thenReturn(connectionMock);
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}BuilderUtilMock.process(Mockito.same(connectionMock), Mockito.same(${parameter.fieldName}))).thenReturn(${parameter.fieldName}Builder);
</#if>
</#list>
</#if>
<#if proc.hasInput || proc.hasOutput>
<#list proc.outputParameters as parameter>
<#if parameter.blob>
        Mockito.when(blobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn(new byte[0]);
<#elseif parameter.clob>
        Mockito.when(clobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn("${parameter.name}");
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>Mock.execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>)).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        repository.execute(<#if proc.hasInput>params</#if>);

        InOrder inOrder = Mockito.inOrder(<#if proc.function>function<#else>procedure</#if>Mock<#if proc.checkResult>, checkResult</#if><#if importConnectionUtils??>, connectionUtilMock</#if>);

<#if importConnectionUtils??>
        inOrder.verify(connectionUtilMock, Mockito.times(1)).process();
</#if>
        inOrder.verify(<#if proc.function>function<#else>procedure</#if>Mock, Mockito.times(1)).execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>);
<#if importConnectionUtils??>
        inOrder.verify(connectionUtilMock, Mockito.times(1)).release(Mockito.same(connectionMock));
</#if>
<#if importConnectionUtils?? || proc.checkResult>

</#if>
<#if proc.checkResult>
        Mockito.verify(checkResult, Mockito.never()).check(<#if proc.hasOutput>Mockito.any()</#if>);
</#if>
<#if importConnectionUtils??>
        Mockito.verify(connectionMock, Mockito.never()).close();
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.verify(${parameter.javaTypeFieldName}BuilderUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.same(${parameter.fieldName}));
</#if>
</#list>
</#if>
    }
<#list proc.inputParameters as parameterTest>

    @Test
    void should_check_${proc.constantFullName?lower_case}_dao_execute_with_check_input_parameter_${parameterTest.name?lower_case}_value() throws SQLException {

        ${proc.className}IN params;

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.date().birthday();
<#elseif parameter.blob>
        byte[] ${parameter.fieldName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#elseif parameter.number>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.random().nextLong();
<#elseif parameter.array || parameter.object>
        ${parameter.javaTypeName} ${parameter.fieldName} = Mockito.mock(${parameter.javaTypeName}.class);
<#else>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.internet().uuid();
</#if>
</#list>

        params = new ${proc.className}INBuilder()<#list proc.inputParameters as parameter>${'\n'}            .${parameter.fieldName}(${parameter.fieldName})</#list>${'\n'}            .build();
<#if importConnectionUtils??>

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Object[] ${parameter.fieldName}Builder = new Object[0];
</#if>
</#list>
</#if>

        java.util.Map<String, Object> mapResult = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

<#if proc.hasOutput>
<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        java.util.List<${parameter.javaTypeName}> obj${parameter.propertyName} = new java.util.ArrayList<<#if !diamond>${parameter.javaTypeName}</#if>>();
<#elseif parameter.clob>
        java.sql.Clob obj${parameter.propertyName} = Mockito.mock(java.sql.Clob.class);
<#elseif parameter.blob>
        java.sql.Blob obj${parameter.propertyName} = Mockito.mock(java.sql.Blob.class);
<#elseif parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#list proc.outputParameters as parameter>
        mapResult.put("${parameter.name}", obj${parameter.propertyName});
</#list>

</#if>
<#if importConnectionUtils??>
        Mockito.when(connectionUtilMock.process()).thenReturn(connectionMock);
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}BuilderUtilMock.process(Mockito.same(connectionMock), Mockito.same(${parameter.fieldName}))).thenReturn(${parameter.fieldName}Builder);
</#if>
</#list>
</#if>
<#if proc.hasInput || proc.hasOutput>
<#list proc.outputParameters as parameter>
<#if parameter.blob>
        Mockito.when(blobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn(new byte[0]);
<#elseif parameter.clob>
        Mockito.when(clobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn("${parameter.name}");
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>Mock.execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>)).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        repository.execute(<#if proc.hasInput>params</#if>);

        java.util.Map<String, Object> mapParamsResult = captorParameters.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(mapParamsResult);
<#if parameterTest.object || parameterTest.array>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameterTest.fieldName}Builder, mapParamsResult.get("${parameterTest.name}"));
<#elseif parameterTest.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameterTest.fieldName}, mapParamsResult.get("${parameterTest.name}"));
<#elseif parameterTest.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(${parameterTest.fieldName}, (byte[]) mapParamsResult.get("${parameterTest.name}"))<#else>assertTrue(java.util.Arrays.equals(${parameterTest.fieldName}, (byte[])mapParamsResult.get("${parameterTest.name}")))</#if>;
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameterTest.fieldName}, mapParamsResult.get("${parameterTest.name}"));
</#if>
    }
</#list>
<#list proc.inputParameters as parameterTest>

    @Test
    void should_check_${proc.constantFullName?lower_case}_dao_execute_with_check_input_parameter_${parameterTest.name?lower_case}_value_from_build() throws SQLException {

        ${proc.className}IN params;

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.date().birthday();
<#elseif parameter.blob>
        byte[] ${parameter.fieldName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#elseif parameter.number>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.random().nextLong();
<#elseif parameter.array || parameter.object>
        ${parameter.javaTypeName} ${parameter.fieldName} = Mockito.mock(${parameter.javaTypeName}.class);
<#else>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.internet().uuid();
</#if>
</#list>

        params = new ${proc.className}INBuilder()<#list proc.inputParameters as parameter>${'\n'}            .${parameter.fieldName}(${parameter.fieldName})</#list>${'\n'}            .build();
<#if importConnectionUtils??>

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Object[] ${parameter.fieldName}Builder = new Object[0];
</#if>
</#list>
</#if>

        java.util.Map<String, Object> mapResult = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

<#if proc.hasOutput>
<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        java.util.List<${parameter.javaTypeName}> obj${parameter.propertyName} = new java.util.ArrayList<<#if !diamond>${parameter.javaTypeName}</#if>>();
<#elseif parameter.clob>
        java.sql.Clob obj${parameter.propertyName} = Mockito.mock(java.sql.Clob.class);
<#elseif parameter.blob>
        java.sql.Blob obj${parameter.propertyName} = Mockito.mock(java.sql.Blob.class);
<#elseif parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#list proc.outputParameters as parameter>
        mapResult.put("${parameter.name}", obj${parameter.propertyName});
</#list>

</#if>
<#if importConnectionUtils??>

        Mockito.when(connectionUtilMock.process()).thenReturn(connectionMock);
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}BuilderUtilMock.process(Mockito.same(connectionMock), Mockito.same(${parameter.fieldName}))).thenReturn(${parameter.fieldName}Builder);
</#if>
</#list>
</#if>
<#if proc.hasInput || proc.hasOutput>
<#list proc.outputParameters as parameter>
<#if parameter.blob>
        Mockito.when(blobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn(new byte[0]);
<#elseif parameter.clob>
        Mockito.when(clobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn("${parameter.name}");
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>Mock.execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>)).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        repository.execute(<#if proc.hasInput>params</#if>);

        java.util.Map<String, Object> mapParamsResult = captorParameters.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(mapParamsResult);
<#if parameterTest.object || parameterTest.array>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameterTest.fieldName}Builder, mapParamsResult.get("${parameterTest.name}"));
<#elseif parameterTest.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameterTest.fieldName}, mapParamsResult.get("${parameterTest.name}"));
<#elseif parameterTest.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(${parameterTest.fieldName}, (byte[]) mapParamsResult.get("${parameterTest.name}"))<#else>assertTrue(java.util.Arrays.equals(${parameterTest.fieldName}, (byte[])mapParamsResult.get("${parameterTest.name}")))</#if>;
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameterTest.fieldName}, mapParamsResult.get("${parameterTest.name}"));
</#if>
    }
</#list>
<#list proc.outputParameters as parameterTest>

    @Test
    void should_check_${proc.constantFullName?lower_case}_dao_execute_with_output_parameters_check_parameter_${parameterTest.name?lower_case}_value() throws SQLException {
<#if proc.hasInput>

        ${proc.className}IN params;

<#list proc.inputParameters as parameter>
<#if parameter.date>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.date().birthday();
<#elseif parameter.blob>
        byte[] ${parameter.fieldName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#elseif parameter.number>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.random().nextLong();
<#elseif parameter.array || parameter.object>
        ${parameter.javaTypeName} ${parameter.fieldName} = Mockito.mock(${parameter.javaTypeName}.class);
<#else>
        ${parameter.javaTypeName} ${parameter.fieldName} = faker.internet().uuid();
</#if>
</#list>

        params = new ${proc.className}INBuilder()<#list proc.inputParameters as parameter>${'\n'}            .${parameter.fieldName}(${parameter.fieldName})</#list>${'\n'}            .build();
<#if importConnectionUtils??>

<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Object[] ${parameter.fieldName}Builder = new Object[0];
</#if>
</#list>
</#if>
</#if>

        java.util.Map<String, Object> mapResult = new java.util.HashMap<<#if !diamond>String, Object</#if>>();

<#if proc.hasOutput>
        ${proc.className}OUT out;

<#list proc.outputParameters as parameter>
<#if parameter.resultSet || parameter.returnResultSet>
        java.util.List<${parameter.javaTypeName}> obj${parameter.propertyName} = new java.util.ArrayList<<#if !diamond>${parameter.javaTypeName}</#if>>();
<#elseif parameter.clob>
        java.sql.Clob obj${parameter.propertyName} = Mockito.mock(java.sql.Clob.class);
<#elseif parameter.blob>
        java.sql.Blob obj${parameter.propertyName} = Mockito.mock(java.sql.Blob.class);
<#elseif parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#list proc.outputParameters as parameter>
        mapResult.put("${parameter.name}", obj${parameter.propertyName});
</#list>

</#if>
<#if importConnectionUtils??>

        Mockito.when(connectionUtilMock.process()).thenReturn(connectionMock);
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}BuilderUtilMock.process(Mockito.same(connectionMock), Mockito.same(${parameter.fieldName}))).thenReturn(${parameter.fieldName}Builder);
</#if>
</#list>
</#if>
<#if proc.hasInput || proc.hasOutput>
<#list proc.outputParameters as parameter>
<#if parameter.blob>
        Mockito.when(blobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn(new byte[0]);
<#elseif parameter.clob>
        Mockito.when(clobUtilMock.process(Mockito.same(obj${parameter.propertyName}))).thenReturn("${parameter.name}");
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>Mock.execute(<#if proc.hasInput>captorParameters.capture()<#else>Mockito.anyMap()</#if>)).thenReturn(mapResult);
</#if>
<#if proc.hasInput || proc.hasOutput>

</#if>
        <#if proc.hasOutput>out = </#if>repository.execute(<#if proc.hasInput>params</#if>);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(out);
<#if parameterTest.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(obj${parameterTest.propertyName}, out.get${parameterTest.propertyName}());
<#elseif parameterTest.clob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals("${parameterTest.name}", out.get${parameterTest.propertyName}());
<#elseif parameterTest.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(out.get${parameterTest.propertyName}());
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj${parameterTest.propertyName}, out.get${parameterTest.propertyName}());
</#if>
    }
</#list>

    @Test<#if junit != 'junit5'>(expected = SQLException.class)</#if>
    void should_check_${proc.constantFullName?lower_case}_dao_error()<#if importConnectionUtils?? || junit != 'junit5'> throws SQLException</#if> {
<#if proc.hasInput>
        ${proc.className}IN params = Mockito.mock(${proc.className}IN.class);

</#if>
<#if importConnectionUtils??>
        Mockito.when(connectionUtilMock.process()).thenReturn(connectionMock);
</#if>
<#list proc.inputParameters as parameter>
<#if parameter.object || parameter.array>
        Mockito.when(${parameter.javaTypeFieldName}BuilderUtilMock.process(Mockito.same(connectionMock), Mockito.any(${parameter.javaTypeName}.class))).thenReturn(null);
</#if>
</#list>
        Mockito.when(<#if proc.function>function<#else>procedure</#if>Mock.execute(Mockito.anyMap())).thenThrow(new RuntimeException());

        <#if junit == 'junit5'>Assertions.assertThrows(SQLException.class,() -> </#if>repository.execute(<#if proc.hasInput>params</#if>)<#if junit == 'junit5'>)</#if>;
    }
<#if proc.hasInput>

    @Test<#if junit != 'junit5'>(expected = SQLException.class)</#if>
    void should_check_${proc.constantFullName?lower_case}_dao_input_null_parameter_error()<#if importConnectionUtils?? || junit != 'junit5'> throws SQLException</#if> {
        ${proc.className}IN params = null;
<#if importConnectionUtils??>

        Mockito.when(connectionUtilMock.process()).thenReturn(connectionMock);

</#if>
        <#if junit == 'junit5'>Assertions.assertThrows(SQLException.class,() -> </#if>repository.execute(params)<#if junit == 'junit5'>)</#if>;
    }
</#if>
}
