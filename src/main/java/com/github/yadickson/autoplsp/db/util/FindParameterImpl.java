/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.util;

import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

/**
 *
 * @author Yadickson Soto
 */
public class FindParameterImpl implements FindParameter {

    @Override
    public List<ParameterBean> getParameters(Connection connection, String sql, Object ... parameters) throws BusinessException {

        if (connection == null) {
            return new ArrayList<ParameterBean>();
        }

        List<ParameterBean> list = null;

        QueryRunner run = new QueryRunner();
        ResultSetHandler<List<ParameterBean>> h = new BeanListHandler<ParameterBean>(ParameterBean.class);

        try {
            list = run.query(connection, sql, h, parameters);
        } catch (SQLException ex) {
            throw new BusinessException("[FindParameterImpl] Error find attributes", ex);
        }

        return list;
    }

}
