package it.cus.psw_cus.controllers.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.services.prenotazioni.PrenotazioneService;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.SalaFullException;
import it.cus.psw_cus.support.exceptions.SalaNotFoundException;
import it.cus.psw_cus.support.exceptions.UnauthorizedAccessException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
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
            //TODO check su ingressi che l'utente ha
            Prenotazione ret = prenotazioneService.create(prenotazione);
            return new ResponseEntity<>(ret, HttpStatus.CREATED);
        } catch (SalaFullException e) {
            return new ResponseEntity<>("Sala al completo", HttpStatus.BAD_REQUEST);
        } catch (SalaNotFoundException e) {
            return new ResponseEntity<>("Sala non trovata", HttpStatus.BAD_REQUEST);
        }
    }

    @PreAuthorize("hasRole('admin')")
    @GetMapping
    public List<Prenotazione> getAll() {
        return prenotazioneService.findAll();
    }

    @PreAuthorize("hasRole('utente')")
    @GetMapping("/utente/future/{idUtente}")
    public ResponseEntity<?> getFutureUtente(@PathVariable int idUtente){
        try{
            return new ResponseEntity<>(prenotazioneService.getPrenotazioniUtenteFuture(idUtente),HttpStatus.OK);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>("Utente non trovato",HttpStatus.NOT_FOUND);
        } catch (UnauthorizedAccessException e) {
            return new ResponseEntity<>("Accesso non autorizzato", HttpStatus.UNAUTHORIZED);
        }
    }

    @PreAuthorize("hasRole('utente')")
    @GetMapping("/utente/{idUtente}")
    public ResponseEntity<?> getAllUtente(@PathVariable int idUtente){
        try{
            return new ResponseEntity<>(prenotazioneService.getPrenotazioniUtente(idUtente),HttpStatus.OK);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>("Utente non trovato",HttpStatus.NOT_FOUND);
        }catch (UnauthorizedAccessException e) {
            return new ResponseEntity<>("Accesso non autorizzato", HttpStatus.UNAUTHORIZED);
        }
    }
}
