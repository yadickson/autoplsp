/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.github.yadickson.autoplsp.handler;

import java.io.Serializable;

/**
 *
 * @author Yadickson Soto
 */
@SuppressWarnings("serial")
public class BusinessException extends Exception implements Serializable {

    public BusinessException(String message) {
        super(message);
    }

    public BusinessException(String message, Throwable ex) {
        super(message, ex);
    }
}
