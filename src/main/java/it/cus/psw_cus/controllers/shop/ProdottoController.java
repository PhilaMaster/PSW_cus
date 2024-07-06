package it.cus.psw_cus.controllers.shop;


import it.cus.psw_cus.entities.Prodotto;
import it.cus.psw_cus.services.shop.ProdottoService;
import it.cus.psw_cus.support.ResponseMessage;
import it.cus.psw_cus.support.exceptions.ProdottoEsistenteException;
import it.cus.psw_cus.support.exceptions.ProdottoNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/prodotti")
public class ProdottoController {

    private final ProdottoService prodottoService;

    public ProdottoController(ProdottoService prodottoService) {
        this.prodottoService = prodottoService;
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody @Valid Prodotto prodotto) {
        try {
            prodottoService.create(prodotto);
            return new ResponseEntity<>(new ResponseMessage("Prodotto creato"), HttpStatus.OK);
        } catch (ProdottoEsistenteException e) {
            return new ResponseEntity<>(new ResponseMessage("Prodotto già esistente"), HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProdotto(@PathVariable int id) {
        try {
            prodottoService.deleteProdotto(id);
            return new ResponseEntity<>(new ResponseMessage("Prodotto eliminato"), HttpStatus.OK);
        } catch (ProdottoNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("Product non trovato"), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> findById(@PathVariable int id) {
        try {
            Prodotto prodotto = prodottoService.findById(id);
            return new ResponseEntity<>(prodotto, HttpStatus.OK);
        } catch (ProdottoNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("Product non trovato"), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("/{nome}")
    public ResponseEntity<List<Prodotto>> findByNome(@PathVariable String nome) {
        List<Prodotto> prodotti = prodottoService.findByNome(nome);
        return new ResponseEntity<>(prodotti, HttpStatus.OK);
    }

    @GetMapping("/prezzo")
    public ResponseEntity<List<Prodotto>> findByPrezzoBetween(@RequestParam double prezzoMin, @RequestParam double prezzoMax) {
        List<Prodotto> prodotti = prodottoService.findByPrezzoBetween(prezzoMin, prezzoMax);
        return new ResponseEntity<>(prodotti, HttpStatus.OK);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateProdotto(@PathVariable int id, @RequestBody @Valid Prodotto prodottoDettagli) {
        try {
            Prodotto prodotto = prodottoService.updateProdotto(id, prodottoDettagli);
            return new ResponseEntity<>(prodotto, HttpStatus.OK);
        } catch (ProdottoNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("Prodotto non trovato"), HttpStatus.NOT_FOUND);
        }
    }

    @GetMapping("{categoria}")
    public ResponseEntity<List<Prodotto>> findByCategoria(@PathVariable String categoria) {
        List<Prodotto> prodotti = prodottoService.findByCategoria(categoria);
        return new ResponseEntity<>(prodotti, HttpStatus.OK);
    }

    @GetMapping("/{sesso}")
    public ResponseEntity<List<Prodotto>> findBySesso(@PathVariable Prodotto.Sesso sesso) {
        List<Prodotto> prodotti = prodottoService.findBySesso(sesso);
        return new ResponseEntity<>(prodotti, HttpStatus.OK);
    }

}
