//package com.newuser.userService;
//
//import com.newuser.data.model.User;
//import com.newuser.data.repository.UserRepository;
//import com.newuser.dtos.request.RegisterUserRequests;
//import com.newuser.dtos.response.RegisterUserResponses;
//import com.newuser.dtos.service.UserService;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.mockito.Mockito;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.boot.test.mock.mockito.MockBean;
//
//import static org.junit.jupiter.api.Assertions.assertEquals;
//import static org.junit.jupiter.api.Assertions.assertNotNull;
//import static org.mockito.ArgumentMatchers.any;
//
//@SpringBootTest
//public class UserServiceTest {
//
//    @Autowired
//    private UserService userService;
//
//    @MockBean
//    private UserRepository userRepository;
//
//    @Test
//    @DisplayName("test that user can be registered")
//    public void registerUserTest() {
//        User mockUser = new User();
//        mockUser.setFirstName("John");
//        mockUser.setLastName("Doe");
//        mockUser.setEmail("johndoe@example.com");
//
//        Mockito.when(userRepository.save(any(User.class))).thenReturn(mockUser);
//
//        RegisterUserRequests requests = new RegisterUserRequests();
//        requests.setFirstName("John");
//        requests.setLastName("Doe");
//        requests.setEmail("johndoe@example.com");
//        requests.setPassword("password");
//        requests.setPhoneNumber("09078480000");
//
//        RegisterUserResponses responses = userService.registerUser(requests);
//
//        assertNotNull(responses);
//        assertEquals("Your account has been created successfully", responses.getMessage());
//
//        Mockito.verify(userRepository, Mockito.times(1)).save(any(User.class));
//    }
//}
