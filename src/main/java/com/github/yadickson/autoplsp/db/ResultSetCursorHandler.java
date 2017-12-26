/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import org.apache.commons.dbutils.ResultSetHandler;

/**
 *
 * @author Yadickson Soto
 */
public class ResultSetCursorHandler implements ResultSetHandler<Object[]> {

    @Override
    public Object[] handle(ResultSet rs) throws SQLException {

        if (!rs.next()) {
            return null;
        }

        ResultSetMetaData meta = rs.getMetaData();
        int cols = meta.getColumnCount();
        Object[] result = new Object[cols];

        for (int i = 0; i < cols; i++) {
            result[i] = rs.getObject(i + 1);
        }

        return result;
    }
}
