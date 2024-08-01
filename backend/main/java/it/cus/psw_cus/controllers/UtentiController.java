package it.cus.psw_cus.controllers;

import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.services.UtenteService;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.UnauthorizedAccessException;
import it.cus.psw_cus.support.exceptions.UserAlreadyExistsException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/utenti")
public class UtentiController {
    private final UtenteService userService;

    @Autowired
    public UtentiController(UtenteService userService) {
        this.userService = userService;
    }

    @GetMapping("/all")
    public List<Utente> getAllUsers() {
        return userService.cercaTutti();
    }

    @GetMapping
    public ResponseEntity<?> getUser() throws UserNotFoundException {
        return new ResponseEntity<>(userService.cercaUtente(Utils.getId()), HttpStatus.OK);
    }

    @GetMapping("/ingressi")
    public ResponseEntity<?> getUserIngressiRimanenti() throws UserNotFoundException {
        return new ResponseEntity<>(userService.ingressiUtente(), HttpStatus.OK);

    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<String> handleUserNotFoundException(UserNotFoundException e) {
        return new ResponseEntity<>("Utente non trovato", HttpStatus.NOT_FOUND);
    }

    @PostMapping
    public ResponseEntity<?> addUser(@RequestBody @Valid Utente utente) {
        try{
            return new ResponseEntity<>(userService.creaUtente(utente), HttpStatus.CREATED);
        } catch (UserAlreadyExistsException e) {
            return new ResponseEntity<>("Utente già esistente", HttpStatus.CONFLICT);
        }
    }

    @PreAuthorize("hasRole('admin')")
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteUser(@PathVariable int id) throws UserNotFoundException {
        userService.eliminaUtente();
        return new ResponseEntity<>("Utente eliminato con successo", HttpStatus.OK);
    }

}
