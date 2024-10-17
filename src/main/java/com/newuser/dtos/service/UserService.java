package com.newuser.dtos.service;

import com.newuser.dtos.request.RegisterUserRequests;
import com.newuser.dtos.response.RegisterUserResponses;

public interface UserService {
    RegisterUserResponses registerUser(RegisterUserRequests requests);

}
