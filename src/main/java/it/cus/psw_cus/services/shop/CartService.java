package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.Cart;
import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.ProdottoCarrello;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.shop.CartRepository;
import it.cus.psw_cus.repositories.shop.OrdineRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Service
public class CartService {

    private final CartRepository cartRepository;
    private final OrdineRepository ordineRepository;

    @Autowired
    public CartService(CartRepository cartRepository, OrdineRepository ordineRepository) {
        this.cartRepository = cartRepository;
        this.ordineRepository = ordineRepository;
    }

    @Transactional
    public Cart carrelloUtente(Utente u){
        return cartRepository.findByUtente(u);
    }

    @Transactional
    public void addProdotto(Utente utente, ProdottoCarrello prodottoCarrello) {
        Cart cart = cartRepository.findByUtente(utente);
        if (cart == null) {
            cart = new Cart();
            cart.setUtente(utente);
        }

        prodottoCarrello.setCart(cart);
        cart.getProdotti().add(prodottoCarrello);
        cartRepository.save(cart);
    }

    @Transactional
    public void rimuoviProdotto(Utente utente, ProdottoCarrello prodottoCarrello) {
        Cart cart = cartRepository.findByUtente(utente);
        if (cart != null) {
            cart.getProdotti().remove(prodottoCarrello);
            cartRepository.save(cart);
        }
    }

    @Transactional
    public Ordine checkout(Utente utente) {
        Cart cart = cartRepository.findByUtente(utente);
        if (cart != null && !cart.getProdotti().isEmpty()) {
            Ordine ordine = new Ordine();
            ordine.setDataCreazione(new Date());
            ordine.setUtente(utente);

            double prezzoTotale = 0.0;

            Set<ProdottoCarrello> prodottiOrdine = new HashSet<>();
            for (ProdottoCarrello prodottoCarrello : cart.getProdotti()) {
                prodottiOrdine.add(prodottoCarrello);
                prezzoTotale += prodottoCarrello.getQuantita() * prodottoCarrello.getProdotto().getPrezzo();
            }

            ordine.setProdotti(prodottiOrdine);
            ordine.setPrezzoTotale(prezzoTotale);

            ordineRepository.save(ordine);

            cart.getProdotti().clear();
            cartRepository.save(cart);

            return ordine;
        }
        return null;
    }

}
