package com.newuser.controller;

import com.newuser.dtos.exception.UserBaseException;
import com.newuser.dtos.request.RegisterUserRequests;
import com.newuser.dtos.response.RegisterUserResponses;
import com.newuser.dtos.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/registerUser")
    public ResponseEntity<RegisterUserResponses> registerUser(@RequestBody RegisterUserRequests requests){
        try {
            RegisterUserResponses response = userService.registerUser(requests);
            return new  ResponseEntity<>(response, HttpStatus.OK);
        }catch (UserBaseException e) {
            RegisterUserResponses responses = new RegisterUserResponses();
            responses.setMessage(e.getMessage());
            return new ResponseEntity<>(responses, HttpStatus.BAD_REQUEST);

        }

    }
}
