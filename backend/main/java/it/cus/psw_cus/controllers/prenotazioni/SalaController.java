package it.cus.psw_cus.controllers.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.entities.Sala;
import it.cus.psw_cus.services.prenotazioni.PrenotazioneService;
import it.cus.psw_cus.services.prenotazioni.SalaService;
import it.cus.psw_cus.support.exceptions.SalaAlreadyExistsException;
import it.cus.psw_cus.support.exceptions.SalaNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api/sale")
public class    SalaController {
    private final SalaService salaService;
    private final PrenotazioneService prenotazioneService;

    @Autowired
    public SalaController(SalaService salaService, PrenotazioneService prenotazioneService) {
        this.salaService = salaService;
        this.prenotazioneService = prenotazioneService;
    }

    @ExceptionHandler(SalaNotFoundException.class)
    public ResponseEntity<String> handlePackageNotFoundException(SalaNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Pacchetto non trovato");
    }

    @GetMapping
    public ResponseEntity<List<Sala>> getAll() {
        return new ResponseEntity<>(salaService.getAllSale(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Sala> getById(@PathVariable int id) throws SalaNotFoundException {
        return new ResponseEntity<>(salaService.getSalaById(id), HttpStatus.OK);
    }

    @GetMapping("/{id}/postiOccupati")
    public ResponseEntity<Integer> getPostiOccupati(@PathVariable int id,
                                                    @RequestParam Prenotazione.FasciaOraria fasciaOraria,
                                                    @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date data) throws SalaNotFoundException {
        Prenotazione p = new Prenotazione();
        Sala s = new Sala();
        s.setId(id);
        p.setSala(s);
        p.setFasciaOraria(fasciaOraria);
        p.setData(data);
        return new ResponseEntity<>(prenotazioneService.postiOccupati(p), HttpStatus.OK);
    }

    @PreAuthorize("hasRole('admin')")
    @PostMapping
    public ResponseEntity<?> create(@RequestBody @Valid Sala sala) {
        try{
            Sala ret = salaService.createSala(sala);
            return new ResponseEntity<>(ret, HttpStatus.CREATED);
        } catch (SalaAlreadyExistsException e) {
            return new ResponseEntity<>("La sala già esiste", HttpStatus.BAD_REQUEST);
        }
    }

    @PreAuthorize("hasRole('admin')")
    @PutMapping
    public ResponseEntity<String> update(@RequestBody @Valid Sala sala) throws SalaNotFoundException {
        salaService.updateSala(sala.getId(),sala);
        return new ResponseEntity<>("Sala aggiornata con successo", HttpStatus.OK);
    }

    @PreAuthorize("hasRole('admin')")
    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable int id) throws SalaNotFoundException {
        salaService.deleteSala(id);
        return new ResponseEntity<>("Sala eliminata con successo", HttpStatus.OK);
    }
}
