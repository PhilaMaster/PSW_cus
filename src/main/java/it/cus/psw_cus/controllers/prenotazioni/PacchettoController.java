package it.cus.psw_cus.controllers.prenotazioni;

import it.cus.psw_cus.entities.Pacchetto;
import it.cus.psw_cus.services.prenotazioni.PacchettoService;
import it.cus.psw_cus.support.exceptions.PackageAlreadyExistsException;
import it.cus.psw_cus.support.exceptions.PackageNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/pacchetti")
public class PacchettoController {
    private final PacchettoService pacchettoService;

    @Autowired
    public PacchettoController(PacchettoService pacchettoService) {
        this.pacchettoService = pacchettoService;
    }

    @PostMapping
    public ResponseEntity<String> create(@RequestBody @Valid Pacchetto pacchetto) {
        try {
            pacchettoService.createPacchetto(pacchetto);
        } catch (PackageAlreadyExistsException e) {
            return new ResponseEntity<>("Pacchetto già esistente", HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>("Pacchetto creato con successo", HttpStatus.OK);
    }

    @PutMapping
    public ResponseEntity<String> update(@RequestBody @Valid Pacchetto pacchetto) throws PackageNotFoundException {
        pacchettoService.updatePacchetto(pacchetto.getIngressi(),pacchetto);
        return new ResponseEntity<>("Pacchetto aggiornato con successo", HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<List<Pacchetto>> getAll() {
        return new ResponseEntity<>(pacchettoService.getAllPacchetti(),HttpStatus.OK);
    }

    @GetMapping("/{ingressi}")
    public ResponseEntity<Pacchetto> getByIngressi(@PathVariable int ingressi) throws PackageNotFoundException {
        Pacchetto ret = pacchettoService.getPacchettoByIngressi(ingressi);
        return new ResponseEntity<>(ret,HttpStatus.OK);
    }

    @ExceptionHandler(PackageNotFoundException.class)
    public ResponseEntity<String> handlePackageNotFoundException(PackageNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Pacchetto non trovato");
    }

    @GetMapping("/priceSearch")
    public ResponseEntity<List<Pacchetto>> getByPriceRange(@RequestParam(value = "min", defaultValue = "0", required = false) int minPrice,
                                                  @RequestParam(value = "max", defaultValue = "1000") int maxPrice) {
        List<Pacchetto> ret = pacchettoService.getPacchettiByPriceRange(minPrice, maxPrice);//se vuota è una lista vuota
        return new ResponseEntity<>(ret, HttpStatus.OK);
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    ResponseEntity<String> handleException(MissingServletRequestParameterException exception) {
        return ResponseEntity.badRequest().body("Parametro richiesto non fornito");
    }

    @DeleteMapping("/{ingressi}")
    public ResponseEntity<String> delete(@PathVariable int ingressi) {
        try {
            pacchettoService.deletePacchetto(ingressi);
        } catch (PackageNotFoundException e) {
            return new ResponseEntity<>("Pacchetto non trovato", HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>("Pacchetto eliminato con successo", HttpStatus.OK);
    }
}
