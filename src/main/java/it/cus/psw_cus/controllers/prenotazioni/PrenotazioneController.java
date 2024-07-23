package it.cus.psw_cus.controllers.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.services.prenotazioni.PrenotazioneService;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("api/prenotazioni")
public class PrenotazioneController {
    private final PrenotazioneService prenotazioneService;

    @Autowired
    public PrenotazioneController(PrenotazioneService prenotazioneService) {
        this.prenotazioneService = prenotazioneService;
    }

    @PreAuthorize("hasRole('utente')")
    @PostMapping
    public ResponseEntity<?> create(@RequestBody @Valid Prenotazione prenotazione) {
        try{
            Prenotazione ret = prenotazioneService.create(prenotazione);
            return new ResponseEntity<>(ret, HttpStatus.CREATED);
        } catch (SalaFullException e) {
            return new ResponseEntity<>("Sala al completo", HttpStatus.BAD_REQUEST);
        } catch (SalaNotFoundException e) {
            return new ResponseEntity<>("Sala non trovata", HttpStatus.NOT_FOUND);
        } catch (PrenotazioneAlreadyExistsException e) {
            return new ResponseEntity<>("Prenotazione già esistente", HttpStatus.CONFLICT);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>("Utente non trovato", HttpStatus.NOT_FOUND);
        } catch (InsufficientEntriesException e) {
            return new ResponseEntity<>("Ingressi insufficienti", HttpStatus.PRECONDITION_FAILED);
        } catch (PrenotazioneNotValidException e) {
//            if (e.getMessage().contains("Impossibile prenotare per una data passata"))
            return new ResponseEntity<>("Impossibile prenotare per una data passata", HttpStatus.BAD_REQUEST);
        } catch (Exception e){
            e.printStackTrace();//stampo errore ma è visibile solo da backend, lo uso per debug
            return new ResponseEntity<>("Errore generico", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    @PreAuthorize("hasRole('utente')")
    @GetMapping("/utente/future")
    public ResponseEntity<?> getFutureUtente(){
        try{
            return new ResponseEntity<>(prenotazioneService.getPrenotazioniUtenteFuture(),HttpStatus.OK);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>("Utente non trovato",HttpStatus.NOT_FOUND);
        }
    }

    @PreAuthorize("hasRole('utente')")
    @GetMapping("/utente")
    public ResponseEntity<?> getAllUtente(){
        try{
            return new ResponseEntity<>(prenotazioneService.getPrenotazioniUtente(),HttpStatus.OK);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>("Utente non trovato",HttpStatus.NOT_FOUND);
        }
    }

    @PreAuthorize("hasRole('admin')")
    @GetMapping
    public List<Prenotazione> getAll() {
        return prenotazioneService.findAll();
    }

}
