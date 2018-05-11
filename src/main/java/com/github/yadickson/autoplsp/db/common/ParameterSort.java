/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.db.common;

import java.util.Comparator;

/**
 * The parameter sort class.
 *
 * @author Yadickson Soto
 */
public class ParameterSort implements Comparator<Parameter> {

    @Override
    public int compare(Parameter a, Parameter b) {
        return a.getName().compareToIgnoreCase(b.getName());
    }
}
