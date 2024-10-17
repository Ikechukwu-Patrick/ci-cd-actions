package com.newuser.dtos.request;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class RegisterUserRequests {
    private Long userId;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String phoneNumber;

}
