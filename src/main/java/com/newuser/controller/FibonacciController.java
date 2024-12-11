package com.newuser.controller;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
public class FibonacciController {

    @GetMapping("/fibonacci/{number}")
    public String fibonacciCalculation(@PathVariable int number) {
        if (number <= 0) {
            throw new InvalidFibonacciInputException("Fibonacci number cannot be calculated for negative input or zero: " + number);
        }
        return "Fibonacci number at position " + number + " is " + fibonacci(number);
    }

    private long fibonacci(int number) {
        if (number <= 1) return number;
        long a = 0, b = 1;
        for (int i = 2; i <= number; i++) {
            long temp = a + b;
            a = b;
            b = temp;
        }
        return b;
    }

    @ExceptionHandler(InvalidFibonacciInputException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleInvalidInputException(InvalidFibonacciInputException e) {
        return e.getMessage();
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public static class InvalidFibonacciInputException extends RuntimeException {
        public InvalidFibonacciInputException(String message) {
            super(message);
        }
    }
}
