/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.parameter;

import com.github.yadickson.autoplsp.db.common.Direction;
import com.github.yadickson.autoplsp.db.common.Procedure;
import com.github.yadickson.autoplsp.handler.BusinessException;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

/**
 *
 * @author debian
 */
@SuppressWarnings({"serial"})
public class DataSetParameterTest {

    private DataSetParameter parameter;

    @Before
    public void setup() {
        parameter = new DataSetParameter(0, "DataSet", Direction.INPUT, "", new Procedure(true, "", "", "", "")) {

            @Override
            public String getJavaTypeName() {
                return "JavaTypeName";
            }

            @Override
            public int getSqlType() {
                return 1;
            }

            @Override
            public String getSqlTypeName() {
                return "SqlTypeName";
            }
        };
    }

    @Test
    public void testResultSetByDefault() throws BusinessException {
        Assert.assertTrue(parameter.isResultSet());
    }

    @Test
    public void testSelectJavaTypeNameByDefault() throws BusinessException {
        Assert.assertEquals("JavaTypeName", parameter.getJavaTypeName());
    }

}
