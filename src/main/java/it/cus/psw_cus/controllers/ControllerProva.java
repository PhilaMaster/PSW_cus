package it.cus.psw_cus.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ControllerProva {

    @GetMapping("/")
    public String home() {
        //System.out.println("provaHome");
        return "Benvenuto nel sito prenotazioni Cus";
    }
}