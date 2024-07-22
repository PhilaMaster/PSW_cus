package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.*;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.shop.CartRepository;
import it.cus.psw_cus.repositories.shop.OrdineRepository;
import it.cus.psw_cus.repositories.shop.ProdottoRepository;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.EmptyCart;
import it.cus.psw_cus.support.exceptions.QuantitaErrata;
import it.cus.psw_cus.support.exceptions.SessionError;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.task.TaskExecutionAutoConfiguration;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

@Service
public class CartService {

    private final CartRepository cartRepository;
    private final OrdineRepository ordineRepository;
    private final ProdottoRepository prodottoRepository;
    private final UtenteRepository utenteRepository;

    @Autowired
    public CartService(CartRepository cartRepository, OrdineRepository ordineRepository, ProdottoRepository prodottoRepository, TaskExecutionAutoConfiguration taskExecutionAutoConfiguration, UtenteRepository utenteRepository) {
        this.cartRepository = cartRepository;
        this.ordineRepository = ordineRepository;
        this.prodottoRepository = prodottoRepository;
        this.utenteRepository = utenteRepository;
    }

    @Transactional
    public Cart carrelloUtente() throws UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        return cartRepository.findByUtente(u);
    }

    @Transactional
    public void addProdotto(Utente utente, ProdottoCarrello prodottoCarrello) throws QuantitaErrata, UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        if (prodottoCarrello.getQuantita() <= 0) throw new QuantitaErrata("Quantità non valida");

        Cart cart = cartRepository.findByUtente(u);
        if (cart == null) {
            cart = new Cart();
            cart.setUtente(utente);
        }

        prodottoCarrello.setCart(cart);
        cart.getProdotti().add(prodottoCarrello);
        cartRepository.save(cart);
    }

    @Transactional
    public void rimuoviProdotto(ProdottoCarrello prodottoCarrello) throws UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        Cart cart = cartRepository.findByUtente(u);
        if (cart != null) {
            cart.getProdotti().remove(prodottoCarrello);
            cartRepository.save(cart);
        }
    }

    @Transactional(rollbackOn = {QuantitaErrata.class})
    public Ordine checkout(Cart c) throws QuantitaErrata, EmptyCart, SessionError, UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        Cart cart = cartRepository.findByUtente(u);
        if (cart == null || cart.getProdotti().isEmpty()) throw new EmptyCart("Il carrello è vuoto");

        if(!cart.getProdotti().equals(c.getProdotti()))
            throw new SessionError("Errore: refreshare la pagina");

        Ordine ordine = new Ordine();

        ordine.setDataCreazione(new Date());
        ordine.setUtente(u);

        double prezzoTotale = 0.0;

        Set<ProdottoOrdine> prodottiOrdine = new HashSet<>();
        for (ProdottoCarrello prodottoCarrello : cart.getProdotti()) {
                Prodotto prodotto = prodottoCarrello.getProdotto();
                if (prodottoCarrello.getQuantita() <= 0)
                    throw new QuantitaErrata("Quantità non valida");
                if (prodottoCarrello.getQuantita() > prodotto.getDisponibilita()) {
                    throw new QuantitaErrata("Quantità richiesta superiore alla disponibilità del prodotto: " + prodotto.getNome());
                }
                ProdottoOrdine p = new ProdottoOrdine();
                p.setProdottoCarrello(prodottoCarrello);
                p.setOrdine(ordine);
                prodottiOrdine.add(p);
                prezzoTotale += prodottoCarrello.getQuantita() * prodotto.getPrezzo();

                prodotto.setDisponibilita(prodotto.getDisponibilita() - prodottoCarrello.getQuantita());
                prodottoRepository.save(prodotto);

        }
        ordine.setProdotti(prodottiOrdine);
        ordine.setPrezzoTotale(prezzoTotale);

        ordineRepository.save(ordine);

        cart.setProdotti(new HashSet<ProdottoCarrello>());
        cart.getProdotti().clear();
        cartRepository.save(cart);

        System.out.println("Svuotato");

        return ordine;
    }
}
