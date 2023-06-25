package ${javaPackage}.${arrayFolderName};
<#assign importList = ["java.sql.Connection", "java.sql.SQLException"]>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ArrayUtil"]>
</#if>
<#if parameter.parameters[parameter.parameters?size - 1].object>
<#assign importObjectBuilder = 1>
<#if objectFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.parameters[parameter.parameters?size - 1].javaTypeName}"]>
<#assign importList = importList + ["${javaPackage}.${objectFolderName}.${parameter.parameters[parameter.parameters?size - 1].javaTypeName}Builder"]>
</#if>
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
<#assign importDateUtil = 1>
<#assign importList = importList + ["java.util.Date"]>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}DateUtil"]>
</#if>
<#elseif parameter.parameters[parameter.parameters?size - 1].clob>
<#assign importClobUtil = 1>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}ClobUtil"]>
</#if>
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
<#assign importBlobUtil = 1>
<#if utilFolderName != arrayFolderName>
<#assign importList = importList + ["${javaPackage}.${utilFolderName}.${prefixUtilityName}BlobUtil"]>
</#if>
</#if>
<#if parameter.parameters[parameter.parameters?size - 1].string || parameter.parameters[parameter.parameters?size - 1].number || parameter.parameters[parameter.parameters?size - 1].date || parameter.parameters[parameter.parameters?size - 1].blob>
<#assign importFaker = 1>
<#assign importList = importList + ["com.github.javafaker.Faker"]>
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

    @Mock
    private ${prefixUtilityName}ArrayUtil arrayUtilMock;
<#if importObjectBuilder??>

    @Mock
    private ${parameter.parameters[parameter.parameters?size - 1].javaTypeName}Builder objectBuilderMock;
<#elseif importDateUtil??>

    @Mock
    private ${prefixUtilityName}DateUtil dateUtilMock;
<#elseif importBlobUtil??>

    @Mock
    private ${prefixUtilityName}BlobUtil blobUtilMock;
<#elseif importClobUtil??>

    @Mock
    private ${prefixUtilityName}ClobUtil clobUtilMock;
</#if>

    @Mock
    private Connection connectionMock;

    @Captor
    private ArgumentCaptor<Object[]> captorObjects;
<#if importFaker??>

    private Faker faker;
</#if>

    private ${parameter.javaTypeName}Builder builder;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
<#if importFaker??>
        faker = new Faker();
</#if>
        builder = new ${parameter.javaTypeName}BuilderImpl(${'\n'}            arrayUtilMock<#if importObjectBuilder??>,${'\n'}            objectBuilderMock</#if><#if importBlobUtil??>,${'\n'}            blobUtilMock</#if><#if importClobUtil??>,${'\n'}            clobUtilMock</#if><#if importDateUtil??>,${'\n'}            dateUtilMock</#if>${'\n'}        );
    }
<#if importObjectBuilder??>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_object_builder_process() throws SQLException {

        ${parameter.javaTypeName} array = new ${parameter.javaTypeName}();

<#if parameter.parameters[parameter.parameters?size - 1].string>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.internet().uuid();
<#elseif parameter.parameters[parameter.parameters?size - 1].number>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.random().nextLong();
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.date().birthday();
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new byte[faker.random().nextInt(${parameter.parameters[parameter.parameters?size - 1].position} * 100)];
<#else>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = Mockito.mock(${parameter.parameters[parameter.parameters?size - 1].javaTypeName}.class);
</#if>

        array.add(object);

        Mockito.when(objectBuilderMock.process(Mockito.any(), Mockito.any())).thenReturn(object);

        builder.process(connectionMock, array);

        Mockito.verify(objectBuilderMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.same(object));
    }
</#if>
<#if importDateUtil??>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_with_date_util_builder_process() throws SQLException {

        ${parameter.javaTypeName} array = new ${parameter.javaTypeName}();

<#if parameter.parameters[parameter.parameters?size - 1].string>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.internet().uuid();
<#elseif parameter.parameters[parameter.parameters?size - 1].number>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.random().nextLong();
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.date().birthday();
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new byte[faker.random().nextInt(${parameter.parameters[parameter.parameters?size - 1].position} * 100)];
<#else>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = Mockito.mock(${parameter.parameters[parameter.parameters?size - 1].javaTypeName}.class);
</#if>

        array.add(object);

        Mockito.when(objectBuilderMock.process(Mockito.any(), Mockito.any())).thenReturn(object);

        builder.process(connectionMock, array);

        Mockito.verify(dateUtilMock, Mockito.times(1)).process(Mockito.same(object));
    }
</#if>
<#if importBlobUtil??>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_with_blob_util_builder_process() throws SQLException {

        ${parameter.javaTypeName} array = new ${parameter.javaTypeName}();

<#if parameter.parameters[parameter.parameters?size - 1].string>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.internet().uuid();
<#elseif parameter.parameters[parameter.parameters?size - 1].number>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.random().nextLong();
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.date().birthday();
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new byte[faker.random().nextInt(${parameter.parameters[parameter.parameters?size - 1].position} * 100)];
<#else>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = Mockito.mock(${parameter.parameters[parameter.parameters?size - 1].javaTypeName}.class);
</#if>

        array.add(object);

        Mockito.when(blobUtilMock.process(Mockito.any(), Mockito.any())).thenReturn(object);

        builder.process(connectionMock, array);

        Mockito.verify(blobUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.same(object));
    }
</#if>
<#if importClobUtil??>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_with_clob_util_builder_process() throws SQLException {

        ${parameter.javaTypeName} array = new ${parameter.javaTypeName}();

<#if parameter.parameters[parameter.parameters?size - 1].string>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.internet().uuid();
<#elseif parameter.parameters[parameter.parameters?size - 1].number>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.random().nextLong();
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.date().birthday();
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new byte[faker.random().nextInt(${parameter.parameters[parameter.parameters?size - 1].position} * 100)];
<#else>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = Mockito.mock(${parameter.parameters[parameter.parameters?size - 1].javaTypeName}.class);
</#if>

        array.add(object);

        Mockito.when(clobUtilMock.process(Mockito.any(), Mockito.any())).thenReturn(object);

        builder.process(connectionMock, array);

        Mockito.verify(clobUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.same(object));
    }
</#if>

    @Test
    void should_check_${parameter.realObjectName?lower_case}_builder_process_response() throws SQLException {

        ${parameter.javaTypeName} array = new ${parameter.javaTypeName}();

<#if parameter.parameters[parameter.parameters?size - 1].string>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.internet().uuid();
<#elseif parameter.parameters[parameter.parameters?size - 1].number>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.random().nextLong();
<#elseif parameter.parameters[parameter.parameters?size - 1].date>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = faker.date().birthday();
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = new byte[faker.random().nextInt(${parameter.parameters[parameter.parameters?size - 1].position} * 100)];
<#else>
        ${parameter.parameters[parameter.parameters?size - 1].javaTypeName} object = Mockito.mock(${parameter.parameters[parameter.parameters?size - 1].javaTypeName}.class);
</#if>

        array.add(object);

        Object obj = new Object();

        Mockito.when(arrayUtilMock.process(Mockito.any(), Mockito.any(), Mockito.any())).thenReturn(obj);

        Object result = builder.process(connectionMock, array);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(obj, result);

        Mockito.verify(arrayUtilMock, Mockito.times(1)).process(Mockito.same(connectionMock), Mockito.eq("${parameter.realObjectName}"), captorObjects.capture());

        Object[] objParamsResult = captorObjects.getValue();

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(objParamsResult);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameter.parameters?size}, objParamsResult.length);

<#if parameter.parameters[parameter.parameters?size - 1].date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(object, objParamsResult[0]);
<#elseif parameter.parameters[parameter.parameters?size - 1].blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals((byte[]) object, (byte[]) objParamsResult[0])<#else>assertTrue(java.util.Arrays.equals((byte[]) object, (byte[]) objParamsResult[0]))</#if>;
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(object, objParamsResult[0]);
</#if>
    }
}
