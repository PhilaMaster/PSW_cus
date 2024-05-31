package it.cus.psw_cus.home.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class MyController {

    @GetMapping("/hello")
    public ResponseEntity<String> sayHello() {
        return ResponseEntity.ok("Hello from Spring Boot");
    }

    @PostMapping("/data")
    public ResponseEntity<MyResponse> receiveData(@RequestBody MyRequest request) {
        MyResponse response = new MyResponse();
        response.setMessage("Data received");
        return ResponseEntity.ok(response);
    }
}