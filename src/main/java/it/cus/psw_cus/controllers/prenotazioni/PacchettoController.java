package it.cus.psw_cus.controllers.prenotazioni;

import it.cus.psw_cus.controllers.MyResponse;
import it.cus.psw_cus.entities.Pacchetto;
import it.cus.psw_cus.services.prenotazioni.PacchettoService;
import it.cus.psw_cus.support.exceptions.PackageNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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

    /**
     * Per aggiungere o aggiornare un pacchetto esistente con altro prezzo
     */
    @PostMapping
    public ResponseEntity<MyResponse> create(@RequestBody @Valid Pacchetto pacchetto) {
        pacchettoService.createPacchetto(pacchetto);
        return ResponseEntity.ok(new MyResponse("Pacchetto creato con successo"));
    }

    @GetMapping
    public ResponseEntity<List<Pacchetto>> getAll() {
        return ResponseEntity.ok(pacchettoService.getAllPacchetti());
    }

    @DeleteMapping("/{ingressi}")
    public ResponseEntity<MyResponse> delete(@PathVariable int ingressi) {
        try {
            pacchettoService.deletePacchetto(ingressi);
        } catch (PackageNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(new MyResponse("Pacchetto eliminato con successo"));
    }
}
