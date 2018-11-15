/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.util;

import com.github.yadickson.autoplsp.db.bean.ParameterBean;
import com.github.yadickson.autoplsp.handler.BusinessException;
import java.sql.Connection;
import java.util.List;

/**
 *
 * @author Yadickson Soto
 */
public interface FindParameter {

    List<ParameterBean> getParameters(Connection connection, String sql, Object[] parameters) throws BusinessException;

}
