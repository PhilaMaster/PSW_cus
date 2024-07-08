package it.cus.psw_cus.controllers.shop;

import it.cus.psw_cus.entities.Cart;
import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.ProdottoCarrello;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.services.UtenteService;
import it.cus.psw_cus.services.shop.CartService;
import it.cus.psw_cus.support.ResponseMessage;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    private final CartService cartService;
    private final UtenteService utenteService;

    public CartController(CartService cartService, UtenteService utenteService) {
        this.cartService = cartService;
        this.utenteService = utenteService;
    }

    @GetMapping("/{utenteId}")
    public ResponseEntity<?> getCart(@PathVariable int utenteId) {
        try {
            Utente utente = utenteService.cercaUtente(utenteId);
            Cart cart = cartService.carrelloUtente(utente);
            return new ResponseEntity<>(cart, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(new ResponseMessage("Carrello non trovato"), HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/{utenteId}/add")
    public ResponseEntity<?> addProdotto(@PathVariable int utenteId, @RequestBody @Valid ProdottoCarrello prodottoCarrello) {
        try {
            Utente utente = utenteService.cercaUtente(utenteId);
            cartService.addProdotto(utente, prodottoCarrello);
            return new ResponseEntity<>(new ResponseMessage("Prodotto aggiunto al carrello"), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(new ResponseMessage("Errore nell'aggiunta del prodotto al carrello"), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/{utenteId}/remove")
    public ResponseEntity<?> rimuoviProdotto(@PathVariable int utenteId, @RequestBody @Valid ProdottoCarrello prodottoCarrello) {
        try {
            Utente utente = utenteService.cercaUtente(utenteId);
            cartService.rimuoviProdotto(utente, prodottoCarrello);
            return new ResponseEntity<>(new ResponseMessage("Prodotto rimosso dal carrello"), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(new ResponseMessage("Errore nella rimozione del prodotto dal carrello"), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/{utenteId}/checkout")
    public ResponseEntity<?> checkout(@PathVariable int utenteId) {
        try {
            Utente utente = utenteService.cercaUtente(utenteId);
            Ordine ordine = cartService.checkout(utente);
            if (ordine != null) {
                return new ResponseEntity<>(ordine, HttpStatus.OK);
            } else {
                return new ResponseEntity<>(new ResponseMessage("Carrello vuoto o errore nel checkout"), HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(new ResponseMessage("Errore nel checkout"), HttpStatus.BAD_REQUEST);
        }
    }
}
