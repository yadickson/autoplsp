/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.util;

import com.github.yadickson.autoplsp.db.common.Parameter;
import java.io.Serializable;
import java.util.Comparator;

/**
 * The parameter sort class.
 *
 * @author Yadickson Soto
 */
public class ParameterSort implements Comparator<Parameter>, Serializable {

    static final long serialVersionUID = 1;

    @Override
    public int compare(Parameter a, Parameter b) {
        return a.getPosition().compareTo(b.getPosition());
    }
}
