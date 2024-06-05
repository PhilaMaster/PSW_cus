package it.cus.psw_cus.controllers.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.services.prenotazioni.PrenotazioneService;
import it.cus.psw_cus.support.exceptions.SalaFullException;
import it.cus.psw_cus.support.exceptions.SalaNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@RestController
@RequestMapping("api/prenotazioni")
public class PrenotazioneController {
    private final PrenotazioneService prenotazioneService;

    @Autowired
    public PrenotazioneController(PrenotazioneService prenotazioneService) {
        this.prenotazioneService = prenotazioneService;
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody @Valid Prenotazione prenotazione) {
        try{
            Prenotazione ret = prenotazioneService.create(prenotazione);
            return new ResponseEntity<>(ret, HttpStatus.CREATED);
        } catch (SalaFullException e) {
            return new ResponseEntity<>("Sala al completo", HttpStatus.BAD_REQUEST);
        } catch (SalaNotFoundException e) {
            return new ResponseEntity<>("Sala non trovata", HttpStatus.BAD_REQUEST);
        }
    }
}
