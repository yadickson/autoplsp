/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import com.github.yadickson.autoplsp.db.bean.TableBean;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 *
 * @author Yadickson Soto
 */
public class FindTableImpl implements FindTable {

    @Override
    public List<TableBean> getTables(Connection connection, String sql) throws BusinessException {

        List<TableBean> list = new ArrayList<TableBean>();

        if (connection == null) {
            return list;
        }

        QueryRunner run = new QueryRunner();
        ResultSetHandler<List<TableBean>> h = new BeanListHandler<TableBean>(TableBean.class);

        try {
            list = run.query(connection, sql, h);
        } catch (SQLException ex) {
            throw new BusinessException("[FindTableImpl] Error find attributes", ex);
        }

        return list;
    }

}
