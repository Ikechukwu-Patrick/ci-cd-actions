//package com.newuser.userService;
//
//import com.newuser.dtos.request.RegisterUserRequests;
//import com.newuser.dtos.response.RegisterUserResponses;
//import com.newuser.dtos.service.UserService;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//
//import static org.junit.jupiter.api.Assertions.assertEquals;
//import static org.junit.jupiter.api.Assertions.assertNotNull;
//
//@SpringBootTest
//public class UserServiceTest {
//
//    @Autowired
//    private UserService userService;
//
//    @Test
//    @DisplayName("test that user can be registered")
//    public void registerUserTest(){
//        RegisterUserRequests userRequests = new RegisterUserRequests();
//        userRequests.setFirstName("Patricial");
//        userRequests.setLastName("Benjamin");
//        userRequests.setEmail("ike2er0743er@gmail.com");
//        userRequests.setPassword("passWord");
//        userRequests.setPhoneNumber("09078480056");
//        RegisterUserResponses responses = userService.registerUser(userRequests);
//        assertNotNull(responses);
//        assertEquals("Your account has been created successfully", responses.getMessage());
//
//    }
//
//
//
//
//}
