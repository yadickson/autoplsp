package ${javaPackage}.${repositoryFolderName}.mapper;
<#assign importList = ["java.sql.SQLException", "com.github.javafaker.Faker", "java.sql.ResultSet"]>
<#list parameter.parameters as paramrs>
<#if paramrs.date>
<#assign importList = importList + ["java.util.Date"]>
</#if>
</#list>
<#if cursorFolderName != repositoryFolderName>
<#assign importList = importList + ["${javaPackage}.${cursorFolderName}.${parameter.javaTypeName}"]>
</#if>
<#if junit == 'junit5'>
<#assign importList = importList + ["org.junit.jupiter.api.extension.ExtendWith", "org.mockito.junit.jupiter.MockitoExtension", "org.junit.jupiter.api.Assertions", "org.junit.jupiter.api.BeforeEach", "org.junit.jupiter.api.Test"]>
<#else>
<#assign importList = importList + ["org.junit.runner.RunWith", "org.mockito.runners.MockitoJUnitRunner", "org.junit.Assert", "org.junit.Before", "org.junit.Test"]>
</#if>
<#assign importList = importList + ["org.mockito.Mock", "org.mockito.Mockito"]>

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
class ${parameter.javaTypeName}RowMapperImplTest {

    @Mock
    private ResultSet resultSetMock;

    private Faker faker;

    private ${parameter.javaTypeName}RowMapper mapper;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
        mapper = new ${parameter.javaTypeName}RowMapperImpl();
    }
<#list parameter.parameters as parameterTest>

    @Test
    void should_check_${proc.constantFullName?lower_case}_row_mapper_check_${parameterTest.name?lower_case}_value() throws SQLException {

<#if parameterTest.date>
        ${parameterTest.javaTypeName} ${parameterTest.fieldName} = faker.date().birthday();
<#elseif parameterTest.blob>
        byte[] ${paramrs.fieldName} = new byte[faker.random().nextInt(${parameterTest.position} * 100)];
<#elseif parameterTest.number>
        ${parameterTest.javaTypeName} ${parameterTest.fieldName} = faker.random().nextLong();
<#else>
        ${parameterTest.javaTypeName} ${parameterTest.fieldName} = faker.internet().uuid();
</#if>

<#if parameterTest.date>
        Mockito.when(resultSetMock.getTimestamp(<#if position>${parameterTest.position}<#else>"${parameterTest.name}"</#if>)).thenReturn(new java.sql.Timestamp(${parameterTest.fieldName}.getTime()));
<#elseif parameterTest.clob>
        Mockito.when(resultSetMock.getString(<#if position>${parameterTest.position}<#else>"${parameterTest.name}"</#if>)).thenReturn(${parameterTest.fieldName});
<#elseif parameterTest.blob>
        Mockito.when(resultSetMock.getBytes(<#if position>${parameterTest.position}<#else>"${parameterTest.name}"</#if>)).thenReturn(${parameterTest.fieldName});
<#elseif parameterTest.string>
        Mockito.when(resultSetMock.getString(<#if position>${parameterTest.position}<#else>"${parameterTest.name}"</#if>)).thenReturn(${parameterTest.fieldName});
<#else>
        Mockito.when(resultSetMock.getObject(<#if position>${parameterTest.position}<#else>"${parameterTest.name}"</#if>)).thenReturn(${parameterTest.fieldName});
</#if>

        ${parameter.javaTypeName} result = mapper.mapRow(resultSetMock, 0);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
<#if parameterTest.date>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertEquals(${parameterTest.fieldName}, result.get${parameterTest.propertyName}());
<#elseif parameterTest.blob>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.<#if junit == 'junit5'>assertArrayEquals(${parameterTest.fieldName}, result.get${parameterTest.propertyName}())<#else>assertTrue(java.util.Arrays.equals(${parameterTest.fieldName}, result.get${parameterTest.propertyName}()))</#if>;
<#else>
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(${parameterTest.fieldName}, result.get${parameterTest.propertyName}());
</#if>
    }
</#list>
}
