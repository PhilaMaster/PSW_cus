package it.cus.psw_cus.controllers.prenotazioni;

import it.cus.psw_cus.entities.Abbonamento;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.services.prenotazioni.AbbonamentoService;
import it.cus.psw_cus.services.UtenteService;
import it.cus.psw_cus.support.exceptions.AbbonamentoNotFoundException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/abbonamenti")
public class AbbonamentoController {

    private final AbbonamentoService abbonamentoService;
    private final UtenteService utenteService;

    @Autowired
    public AbbonamentoController(AbbonamentoService abbonamentoService, UtenteService utenteService) {
        this.abbonamentoService = abbonamentoService;
        this.utenteService = utenteService;
    }

    @GetMapping
    public List<Abbonamento> getAllAbbonamenti() {
        return abbonamentoService.getAllAbbonamenti();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Abbonamento> getAbbonamentoById(@PathVariable int id) throws AbbonamentoNotFoundException {
        return new ResponseEntity<>(abbonamentoService.getAbbonamentoById(id), HttpStatus.OK);
    }

    @ExceptionHandler(AbbonamentoNotFoundException.class)
    public ResponseEntity<String> handleAbbonamentoNotFoundException(AbbonamentoNotFoundException e) {
        return new ResponseEntity<>("Abbonamento non trovato",HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<String> handleUserNotFoundException(UserNotFoundException e) {
        return new ResponseEntity<>("Utente non trovato",HttpStatus.NOT_FOUND);
    }

    @PostMapping
    public Abbonamento createAbbonamento(@RequestBody Abbonamento abbonamento) {
        return abbonamentoService.createAbbonamento(abbonamento);
    }

//    @PutMapping("/{id}")
//    public ResponseEntity<Abbonamento> updateAbbonamento(@PathVariable int id, @RequestBody Abbonamento newAbbonamento) {
//        return ResponseEntity.ok(abbonamentoService.updateAbbonamento(id, newAbbonamento));
//    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAbbonamento(@PathVariable int id) {
        abbonamentoService.deleteAbbonamento(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/utente/{utenteId}")
    public ResponseEntity<List<Abbonamento>> getAbbonamentiByUtente(@PathVariable int utenteId) throws UserNotFoundException {
        Utente utente = utenteService.cercaUtente(utenteId);
        return new ResponseEntity<>(abbonamentoService.getAbbonamentiByUtente(utente), HttpStatus.OK);
    }

    @GetMapping("/utente/{utenteId}/coningressi")
    public ResponseEntity<List<Abbonamento>> getAbbonamentiByUtenteWithPositiveRimanenti(@PathVariable int utenteId) throws UserNotFoundException {
        Utente utente = utenteService.cercaUtente(utenteId);
        return new ResponseEntity<>(abbonamentoService.getAbbonamentiUtenteConIngressi(utente), HttpStatus.OK);
    }
}
