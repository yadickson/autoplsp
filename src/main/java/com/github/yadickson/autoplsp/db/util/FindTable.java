/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.util;

import java.sql.Connection;
import java.util.List;

import com.github.yadickson.autoplsp.db.bean.TableBean;
import com.github.yadickson.autoplsp.handler.BusinessException;

/**
 *
 * @author Yadickson Soto
 */
public interface FindTable {

    List<TableBean> getTables(Connection connection, String sql) throws BusinessException;

}
