package ${javaPackage}.${objectFolderName};
<#assign importList = ["java.sql.Connection", "java.sql.SQLException", "com.github.javafaker.Faker"]>
<#list parameter.parameters as parameter>
<#if parameter.clob>
<#assign importClobUtil = 1>
<#if utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ClobUtil"]>
</#if>
<#elseif parameter.blob>
<#assign importBlobUtil = 1>
<#if utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}BlobUtil"]>
</#if>
<#elseif parameter.date>
<#assign importDateUtil = 1>
<#if utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}DateUtil"]>
</#if>
</#if>
<#if parameter.date>
<#assign importDate = 1>
<#assign importList = importList + ["java.util.Date"]>
</#if>
</#list>
<#if utilFolderName != objectFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ObjectUtil"]>
</#if>
<#if junit == 'junit5'>
<#assign importList = importList + ["org.junit.jupiter.api.extension.ExtendWith", "org.mockito.junit.jupiter.MockitoExtension", "org.junit.jupiter.api.Assertions", "org.junit.jupiter.api.BeforeEach", "org.junit.jupiter.api.Test"]>
<#else>
<#assign importList = importList + ["org.junit.runner.RunWith", "org.mockito.runners.MockitoJUnitRunner", "org.junit.Assert", "org.junit.Before", "org.junit.Test"]>
</#if>
<#assign importList = importList + ["org.mockito.ArgumentCaptor", "org.mockito.Captor", "org.mockito.Mock", "org.mockito.Mockito"]>

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
@SuppressWarnings({"rawtypes", "unchecked"})
class ${parameter.javaTypeName}BuilderImplTest {
<#if importBlobUtil??>

    @Mock
    private ${prefixUtilityName}BlobUtil blobUtilMock;
</#if>
<#if importClobUtil??>

    @Mock
    private ${prefixUtilityName}ClobUtil clobUtilMock;
</#if>
<#if importDateUtil??>

    @Mock
    private ${prefixUtilityName}DateUtil dateUtilMock;
</#if>

    @Mock
    private ${prefixUtilityName}ObjectUtil objectUtilMock;

    @Mock
    private Connection connectionMock;

    @Captor
    private ArgumentCaptor<Object[]> captorObjects;

    private Faker faker;

    private ${parameter.javaTypeName}Builder builder;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
        builder = new ${parameter.javaTypeName}BuilderImpl(${'\n'}            objectUtilMock<#if importBlobUtil??>,${'\n'}            blobUtilMock</#if><#if importClobUtil??>,${'\n'}            clobUtilMock</#if><#if importDateUtil??>,${'\n'}            dateUtilMock</#if>${'\n'}        );
    }
<#if importBlobUtil??>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_builder_process_check_parameters_with_blob_util() throws SQLException {
        ${parameter.javaTypeName}Impl object;
<#if !fullConstructor>
        object = new ${parameter.javaTypeName}Impl();
</#if>

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#if !fullConstructor>
<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>
<#else>
        object = new ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter>obj${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>

        Object[] obj = new Object[0];

        builder.process(connectionMock, object);

<#list parameter.parameters as parameterTest>
<#if parameterTest.blob>
        Mockito.verify(blobUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.same(obj${parameterTest.propertyName}));
</#if>
</#list>
    }
</#if>
<#if importClobUtil??>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_builder_process_check_parameters_with_clob_util() throws SQLException {
        ${parameter.javaTypeName}Impl object;
<#if !fullConstructor>
        object = new ${parameter.javaTypeName}Impl();
</#if>

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#if !fullConstructor>
<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>
<#else>
        object = new ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter>obj${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>

        Object[] obj = new Object[0];

        builder.process(connectionMock, object);

<#list parameter.parameters as parameterTest>
<#if parameterTest.clob>
        Mockito.verify(clobUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.same(obj${parameterTest.propertyName}));
</#if>
</#list>
    }
</#if>
<#if importDateUtil??>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_builder_process_check_parameters_with_date_util() throws SQLException {
        ${parameter.javaTypeName}Impl object;
<#if !fullConstructor>
        object = new ${parameter.javaTypeName}Impl();
</#if>

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#if !fullConstructor>
<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>
<#else>
        object = new ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter>obj${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>

        Object[] obj = new Object[0];

        builder.process(connectionMock, object);

<#list parameter.parameters as parameterTest>
<#if parameterTest.date>
        Mockito.verify(dateUtilMock, Mockito.times(1)).process(Mockito.eq(obj${parameterTest.propertyName}));
</#if>
</#list>
    }
</#if>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_builder_process_response() throws SQLException {
        ${parameter.javaTypeName}Impl object;
<#if !fullConstructor>
        object = new ${parameter.javaTypeName}Impl();
</#if>

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#if !fullConstructor>
<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>
<#else>
        object = new ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter>obj${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>

        Object[] obj = new Object[0];

        Mockito.when(objectUtilMock.process(Mockito.any(), Mockito.anyString(), Mockito.any())).thenReturn(obj);

        Object result = builder.process(connectionMock, object);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj, result);

        Mockito.verify(objectUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture());

        Object[] objParamsResult = captorObjects.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(objParamsResult);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameter.parameters?size}, objParamsResult.length);
    }
<#list parameter.parameters as parameterTest>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_builder_process_check_parameter_${parameterTest.name?lower_case}_value() throws SQLException {
        ${parameter.javaTypeName}Impl object;
<#if !fullConstructor>
        object = new ${parameter.javaTypeName}Impl();
</#if>

<#list parameter.parameters as parameter>
<#if parameter.number>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.random().nextLong();
<#elseif parameter.date>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.date().birthday();
<#elseif parameter.blob>
        ${parameter.javaTypeName} obj${parameter.propertyName} = new byte[faker.random().nextInt(${parameter.position} * 100)];
<#else>
        ${parameter.javaTypeName} obj${parameter.propertyName} = faker.internet().uuid();
</#if>
</#list>

<#if !fullConstructor>
<#list parameter.parameters as parameter>
        object.set${parameter.propertyName}(obj${parameter.propertyName});
</#list>
<#else>
        object = new ${parameter.javaTypeName}Impl(${'\n'}            <#list parameter.parameters as parameter>obj${parameter.propertyName}<#sep>,${'\n'}            </#sep></#list>${'\n'}        );
</#if>

        Object[] obj = new Object[0];

<#list parameter.parameters as parameter>
<#if parameter.date>
        Mockito.when(dateUtilMock.process(obj${parameter.propertyName})).thenReturn(obj${parameter.propertyName});
<#elseif parameter.blob>
        Mockito.when(blobUtilMock.process(Mockito.same(connectionMock), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
<#elseif parameter.clob>
        Mockito.when(clobUtilMock.process(Mockito.same(connectionMock), Mockito.same(obj${parameter.propertyName}))).thenReturn(obj${parameter.propertyName});
</#if>
</#list>
        Mockito.when(objectUtilMock.process(Mockito.any(), Mockito.anyString(), Mockito.any())).thenReturn(obj);

        builder.process(connectionMock, object);

        Mockito.verify(objectUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture());

        Object[] objParamsResult = captorObjects.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(objParamsResult);
<#if parameterTest.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(obj${parameterTest.propertyName}, objParamsResult[${parameterTest.position - 1}]);
<#elseif parameterTest.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(obj${parameterTest.propertyName}, result.get${parameterTest.propertyName}())<#else>assertTrue(java.util.Arrays.equals(obj${parameter.propertyName}, result.get${parameter.propertyName}()))</#if>;
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj${parameterTest.propertyName}, objParamsResult[${parameterTest.position - 1}]);
</#if>
    }
</#list>
}
