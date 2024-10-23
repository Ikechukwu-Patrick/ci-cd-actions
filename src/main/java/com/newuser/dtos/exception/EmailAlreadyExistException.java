package com.newuser.dtos.exception;

public class EmailAlreadyExistException extends UserBaseException {
    public EmailAlreadyExistException(String message) {
        super(message);
    }

}
