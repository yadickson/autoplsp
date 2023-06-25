package ${javaPackage}.${utilFolderName};
<#assign importList = ["java.sql.Connection", "java.sql.SQLException", "com.github.javafaker.Faker"]>
<#if driverName == 'oracle'>
<#assign importList = importList + ["oracle.jdbc.OracleConnection"]>
<#if driverVersionName == 'ojdbc6' >
<#assign importList = importList + ["oracle.sql.ARRAY"]>
<#else>
<#assign importList = importList + ["java.sql.Array"]>
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
class ${prefixUtilityName}ArrayUtilImplTest {
<#if driverName == 'oracle'>

    @Mock
    private OracleConnection oracleConnectionMock;
</#if>

    @Mock
    private <#if driverVersionName == 'ojdbc6' >ARRAY<#else>Array</#if> arrayMock;

    @Mock
    private Connection connectionMock;

    private Faker faker;

    private ${prefixUtilityName}ArrayUtil arrayUtil;

    @<#if junit == 'junit5'>BeforeEach<#else>Before</#if>
    void setUp() {
        faker = new Faker();
        arrayUtil = new ${prefixUtilityName}ArrayUtilImpl();
    }
<#if driverName == 'oracle' >

    @Test
    void testProcessArray() throws SQLException {
        Object[] objects = new Object[0];
        String nameValue = faker.internet().uuid();

        Mockito.when(connectionMock.unwrap(OracleConnection.class)).thenReturn(oracleConnectionMock);
        Mockito.when(oracleConnectionMock.<#if driverVersionName == 'ojdbc6' >createARRAY<#else>createOracleArray</#if>(Mockito.anyString(), Mockito.same(objects))).thenReturn(arrayMock);

        Object result = arrayUtil.process(connectionMock, nameValue, objects);

        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertNotNull(result);
        <#if junit == 'junit5'>Assertions<#else>Assert</#if>.assertSame(arrayMock, result);

        Mockito.verify(oracleConnectionMock).<#if driverVersionName == 'ojdbc6' >createARRAY<#else>createOracleArray</#if>(Mockito.eq(nameValue), Mockito.same(objects));
    }
</#if>

    @Test<#if junit != 'junit5'>(expected = SQLException.class)</#if>
    void testProcessArrayError()<#if driverName == 'oracle'> throws SQLException</#if> {
        Object[] objects = new Object[0];
        String nameValue = faker.internet().uuid();
<#if driverName == 'oracle' >

        Mockito.when(connectionMock.unwrap(OracleConnection.class)).thenReturn(oracleConnectionMock);
        Mockito.when(oracleConnectionMock.<#if driverVersionName == 'ojdbc6' >createARRAY<#else>createOracleArray</#if>(Mockito.anyString(), Mockito.same(objects))).thenThrow(new RuntimeException());

</#if>
        <#if junit == 'junit5'>Assertions.assertThrows(SQLException.class,() -> </#if>arrayUtil.process(connectionMock, nameValue, objects)<#if junit == 'junit5'>)</#if>;
    }
}
