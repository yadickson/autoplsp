package ${javaPackage}.${utilFolderName};
<#assign importList = ["java.sql.Connection", "java.sql.SQLException", "com.github.javafaker.Faker"]>
<#if driverName == 'oracle'>
<#assign importList = importList + ["oracle.jdbc.OracleConnection"]>
<#if driverVersionName != 'ojdbc6' >
<#assign importList = importList + ["java.sql.Struct"]>
</#if>
</#if>
<#assign importList = importList + ["org.mockito.Mock", "org.mockito.Mockito"]>
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
class ${prefixUtilityName}ObjectUtilImplTest {

<#if driverName == 'oracle'>

    @Mock
    private OracleConnection oracleConnectionMock;
<#if driverVersionName != 'ojdbc6' >

    @Mock
    private Struct structMock;
</#if>
</#if>

    @Mock
    private Connection connectionMock;

    Faker faker;

    private ${prefixUtilityName}ObjectUtil objectUtil;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
        objectUtil = new ${prefixUtilityName}ObjectUtilImpl();
    }
<#if driverName == 'oracle' && driverVersionName != 'ojdbc6' >

    @Test
    void testProcessObject() throws SQLException {
        Object[] objects = new Object[0];
        String nameValue = faker.internet().uuid();

        Mockito.when(connectionMock.unwrap(OracleConnection.class)).thenReturn(oracleConnectionMock);
        Mockito.when(oracleConnectionMock.createStruct(Mockito.anyString(), Mockito.same(objects))).thenReturn(structMock);

        Object result = objectUtil.process(connectionMock, nameValue, objects);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(structMock, result);

        Mockito.verify(oracleConnectionMock).<#if driverVersionName == 'ojdbc6' >createARRAY<#else>createOracleArray</#if>(Mockito.eq(nameValue), Mockito.same(objects));
    }
</#if>

    @Test<#if junit != 'junit5'>(expected = SQLException.class)</#if>
    void testProcessObjectError()<#if junit != 'junit5'> throws SQLException</#if> {
        Object[] objects = new Object[0];
        String nameValue = faker.internet().uuid();
<#if driverName == 'oracle' >

        Mockito.when(connectionMock.unwrap(OracleConnection.class)).thenReturn(oracleConnectionMock);
<#if driverVersionName != 'ojdbc6' >
        Mockito.when(oracleConnectionMock.createStruct(Mockito.anyString(), Mockito.same(objects))).thenThrow(new RuntimeException());
</#if>
</#if>

        <#if junit == 'junit5'>Assertions.assertThrows(SQLException.class,() -> </#if>objectUtil.process(connectionMock, nameValue, objects)<#if junit == 'junit5'>)</#if>;
    }
<#if driverName != 'oracle' >

    @Test<#if junit != 'junit5'>(expected = SQLException.class)</#if>
    void should_check_struct_not_supported()<#if junit != 'junit5'> throws SQLException</#if> {
        Object[] objects = new Object[0];
        String nameValue = faker.internet().uuid();
        <#if junit == 'junit5'>Assertions.assertThrows(SQLException.class,() -> </#if>objectUtil.process(connectionMock, nameValue, objects)<#if junit == 'junit5'>)</#if>;
    }
</#if>
}
