package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.*;
import it.cus.psw_cus.repositories.shop.CartRepository;
import it.cus.psw_cus.repositories.shop.OrdineRepository;
import it.cus.psw_cus.repositories.shop.ProdottoRepository;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.EmptyCart;
import it.cus.psw_cus.support.exceptions.QuantitaErrata;
import it.cus.psw_cus.support.exceptions.UnauthorizedAccessException;
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
    private final ProdottoRepository prodottoRepository;

    @Autowired
    public CartService(CartRepository cartRepository, OrdineRepository ordineRepository, ProdottoRepository prodottoRepository) {
        this.cartRepository = cartRepository;
        this.ordineRepository = ordineRepository;
        this.prodottoRepository = prodottoRepository;
    }

    @Transactional
    public Cart carrelloUtente(Utente u) throws UnauthorizedAccessException {
        if (u.getId() != Utils.getId()) throw new UnauthorizedAccessException();
        return cartRepository.findByUtente(u);
    }

    @Transactional
    public void addProdotto(Utente utente, ProdottoCarrello prodottoCarrello) throws UnauthorizedAccessException,QuantitaErrata {
        if (utente.getId() != Utils.getId()) throw new UnauthorizedAccessException();
        if (prodottoCarrello.getQuantita() <= 0) throw new QuantitaErrata("Quantità non valida");

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
    public void rimuoviProdotto(Utente utente, ProdottoCarrello prodottoCarrello) throws UnauthorizedAccessException {
        if (utente.getId() != Utils.getId()) throw new UnauthorizedAccessException();
        Cart cart = cartRepository.findByUtente(utente);
        if (cart != null) {
            cart.getProdotti().remove(prodottoCarrello);
            cartRepository.save(cart);
        }
    }

    @Transactional(rollbackOn = {QuantitaErrata.class})
    public Ordine checkout(Utente utente) throws UnauthorizedAccessException,QuantitaErrata, EmptyCart {
        if (utente.getId() != Utils.getId()) throw new UnauthorizedAccessException();
        Cart cart = cartRepository.findByUtente(utente);
        if (cart == null || cart.getProdotti().isEmpty()) throw new EmptyCart("Il carrello è vuoto");

        Ordine ordine = new Ordine();
        ordine.setDataCreazione(new Date());
        ordine.setUtente(utente);

        double prezzoTotale = 0.0;

        Set<ProdottoCarrello> prodottiOrdine = new HashSet<>();
        for (ProdottoCarrello prodottoCarrello : cart.getProdotti()) {
            Prodotto prodotto = prodottoCarrello.getProdotto();
            if (prodottoCarrello.getQuantita() <= 0) throw new QuantitaErrata("Quantità non valida");
            if (prodottoCarrello.getQuantita() > prodotto.getDisponibilita()) {
                throw new QuantitaErrata("Quantità richiesta superiore alla disponibilità del prodotto: " + prodotto.getNome());
            }
            prodottiOrdine.add(prodottoCarrello);
            prezzoTotale += prodottoCarrello.getQuantita() * prodotto.getPrezzo();

            prodotto.setDisponibilita(prodotto.getDisponibilita() - prodottoCarrello.getQuantita());
            prodottoRepository.save(prodotto);
        }

        ordine.setProdotti(prodottiOrdine);
        ordine.setPrezzoTotale(prezzoTotale);

        ordineRepository.save(ordine);

        cart.getProdotti().clear();
        cartRepository.save(cart);

        return ordine;
    }

}
