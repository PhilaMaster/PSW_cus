package it.cus.psw_cus.controllers.shop;

import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.services.UtenteService;
import it.cus.psw_cus.services.shop.OrdineService;
import it.cus.psw_cus.support.ResponseMessage;
import it.cus.psw_cus.support.exceptions.OrdineNotFoundException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/ordini")
public class OrdineController {

    private final OrdineService ordineService;
    private final UtenteService utenteService;

    public OrdineController(OrdineService ordineService, UtenteService utenteService) {
        this.ordineService = ordineService;
        this.utenteService = utenteService;
    }

    @PostMapping
    public ResponseEntity<?> salvaOrdine(@RequestBody @Valid Ordine ordine) {
        Ordine savedOrdine = ordineService.salvaOrdine(ordine);
        return new ResponseEntity<>(savedOrdine, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<Ordine>> trovaTuttiGliOrdini() {
        List<Ordine> ordini = ordineService.trovaTuttiGliOrdini();
        return new ResponseEntity<>(ordini, HttpStatus.OK);
    }

    @GetMapping("/data")
    public ResponseEntity<List<Ordine>> filtraPerData(@RequestParam Date inizio, @RequestParam Date fine) {
        List<Ordine> ordini = ordineService.filtraPerData(inizio, fine);
        return new ResponseEntity<>(ordini, HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> eliminaOrdine(@PathVariable int id) {
        try {
            ordineService.eliminaOrdine(id);
            return new ResponseEntity<>(new ResponseMessage("Ordine eliminato"), HttpStatus.OK);
        } catch (OrdineNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("Ordine non trovato"), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/{utenteId}")
    public ResponseEntity<?> trovaOrdinePerUtente(@PathVariable int utenteId) {
        try {
            Utente utente = utenteService.cercaUtente(utenteId);
            Optional<Ordine> ordine = ordineService.trovaOrdinePerUtente(utente);
            if (ordine.isPresent()) {
                return new ResponseEntity<>(ordine.get(), HttpStatus.OK);
            } else {
                return new ResponseEntity<>(new ResponseMessage("Ordine non trovato per l'utente"), HttpStatus.NOT_FOUND);
            }
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("Utente non trovato"), HttpStatus.NOT_FOUND);
        }
    }

}
