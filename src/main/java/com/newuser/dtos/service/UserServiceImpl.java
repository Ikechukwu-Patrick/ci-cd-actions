package com.newuser.dtos.service;

import com.newuser.data.model.User;
import com.newuser.data.repository.UserRepository;
import com.newuser.dtos.exception.EmailAlreadyExistException;
import com.newuser.dtos.request.RegisterUserRequests;
import com.newuser.dtos.response.RegisterUserResponses;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    private final ModelMapper modelMapper;

    public UserServiceImpl(UserRepository userRepository,
                           ModelMapper modelMapper) {
        this.userRepository = userRepository;
        this.modelMapper = modelMapper;
    }

    @Override
    public RegisterUserResponses registerUser(RegisterUserRequests requests) {
        if (userRepository.existsByEmail(requests.getEmail().toLowerCase().strip())) {
            throw new EmailAlreadyExistException("Email already exists, use another email address to sign up");
        }

        User user = modelMapper.map(requests, User.class);
        user.setFirstName(requests.getFirstName().toLowerCase().strip());
        user.setLastName(requests.getLastName().toLowerCase().strip());
        user.setPassword(requests.getPassword());
        user.setPassword(requests.getPassword());
        user.setPhoneNumber(requests.getPhoneNumber());
        userRepository.save(user);
        RegisterUserResponses responses = modelMapper.map(user, RegisterUserResponses.class);
        responses.setMessage("Your account has been created successfully");
        return responses;
    }
}
