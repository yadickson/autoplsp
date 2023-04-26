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

import com.github.yadickson.autoplsp.db.bean.ProcedureBean;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 *
 * @author Yadickson Soto
 */
public class FindProcedureImpl implements FindProcedure {

    @Override
    public List<ProcedureBean> getProcedures(Connection connection, String sql) throws BusinessException {

        if (connection == null) {
            return new ArrayList<ProcedureBean>();
        }

        List<ProcedureBean> procedures = null;

        QueryRunner run = new QueryRunner();
        ResultSetHandler<List<ProcedureBean>> h = new BeanListHandler<ProcedureBean>(ProcedureBean.class);

        try {
            procedures = run.query(connection, sql, h);
        } catch (SQLException ex) {
            throw new BusinessException("[FindProcedureImpl] Error find procedures", ex);
        }

        return procedures;
    }

}
