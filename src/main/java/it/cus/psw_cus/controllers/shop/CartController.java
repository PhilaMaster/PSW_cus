package it.cus.psw_cus.controllers.shop;

import it.cus.psw_cus.entities.Cart;
import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.ProdottoCarrello;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.services.UtenteService;
import it.cus.psw_cus.services.shop.CartService;
import it.cus.psw_cus.services.shop.ProdottoCarrelloDTO;
import it.cus.psw_cus.support.ResponseMessage;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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

    @PreAuthorize("hasRole('utente')")
    @GetMapping()
    public ResponseEntity<?> getCart(){
        try {
            Cart cart = cartService.carrelloUtente();
            return new ResponseEntity<>(cart, HttpStatus.OK);
        }  catch (Exception e) {
//            e.printStackTrace();
            return new ResponseEntity<>(new ResponseMessage("Errore generico"), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PreAuthorize("hasRole('utente')")
    @PostMapping("/add")
    public ResponseEntity<?> addProdotto(@RequestBody @Valid ProdottoCarrelloDTO prodottoCarrelloDTO) {
        try {
            Utente utente = utenteService.cercaUtente(Utils.getId());
            cartService.addProdotto(utente, prodottoCarrelloDTO);
            return new ResponseEntity<>(new ResponseMessage("Prodotto aggiunto al carrello"), HttpStatus.OK);
        } catch (ProdottoNotFoundException e) {
            return new ResponseEntity<>(new ResponseMessage("Prodotto non trovato"), HttpStatus.NOT_FOUND);
        }catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(new ResponseMessage("Errore nell'aggiunta del prodotto al carrello"), HttpStatus.BAD_REQUEST);
        }
    }

    @PreAuthorize("hasRole('utente')")
    @PostMapping("/remove")
    public ResponseEntity<?> rimuoviProdotto(@RequestBody @Valid ProdottoCarrelloDTO prodottoCarrello) {
        try {
            cartService.rimuoviProdotto(prodottoCarrello);
            return new ResponseEntity<>(new ResponseMessage("Prodotto rimosso dal carrello"), HttpStatus.OK);
        }
        catch (ProdottoNotFoundException e){
            return new ResponseEntity<>(new ResponseMessage("Prodotto non trovato"), HttpStatus.NOT_FOUND);
        }
        catch (Exception e ) {
            return new ResponseEntity<>(new ResponseMessage("Errore nella rimozione del prodotto dal carrello"), HttpStatus.BAD_REQUEST);
        }
    }

    @PreAuthorize("hasRole('utente')")
    @PostMapping("/checkout")
    public ResponseEntity<?> checkout(@RequestBody @Valid Cart cart) {
        try {
            Utente utente = utenteService.cercaUtente(Utils.getId());
            Cart c = cartService.carrelloUtente();
            Ordine ordine = cartService.checkout(c);
            if (ordine != null) {
                return new ResponseEntity<>(ordine, HttpStatus.OK);
            } else {
                return new ResponseEntity<>(new ResponseMessage("Errore nel checkout"), HttpStatus.BAD_REQUEST);
            }
        }
        catch(QuantitaErrata q){
            return new ResponseEntity<>(new ResponseMessage("Quantita errata"), HttpStatus.BAD_REQUEST);
        }
        catch(EmptyCart ep){
            return new ResponseEntity<>(new ResponseMessage("Carrello vuoto"), HttpStatus.BAD_REQUEST);
        }
        catch (Exception e) {
            return new ResponseEntity<>(new ResponseMessage("Errore nel checkout"), HttpStatus.BAD_REQUEST);
        }
    }
}
