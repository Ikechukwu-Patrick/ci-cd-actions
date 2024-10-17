package com.newuser;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class NewUserApplication {
    @GetMapping("/welcome")
    public String helloWorld() {
        return "Hello, New User!";
    }

//    echo "# ci-cd-actions" >> README.md
//    git init
//    git add README.md
//    git commit -m "first commit"
//    git branch -M main
//    git remote add origin https://github.com/Ikechukwu-Patrick/ci-cd-actions.git
//    git push -u origin main

    public static void main(String[] args) {
        SpringApplication.run(NewUserApplication.class, args);
    }

}
