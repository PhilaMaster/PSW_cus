package it.cus.psw_cus.controllers;

import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.services.UtenteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UtentiController {
    private final UtenteService userService;

    @Autowired
    public UtentiController(UtenteService userService) {
        this.userService = userService;
    }
//    @GetMapping
//    public String getUtenti() {
//        List<it.cus.pswprogetto.entities.Utente> utenti = utenteService.cercaTutti();
//        StringBuilder builder = new StringBuilder();
//        for (it.cus.pswprogetto.entities.Utente utente : utenti) {
//            builder.append(utente.toString());
//        }
//        System.out.println("Sustest");
//        return builder.toString();
//    }
    @GetMapping
    public List<Utente> getAllUsers() {
        return userService.cercaTutti();
    }
}
