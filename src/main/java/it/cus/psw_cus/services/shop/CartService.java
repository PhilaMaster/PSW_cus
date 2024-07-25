package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.*;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.shop.*;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.task.TaskExecutionAutoConfiguration;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class CartService {

    private final CartRepository cartRepository;
    private final OrdineRepository ordineRepository;
    private final ProdottoRepository prodottoRepository;
    private final UtenteRepository utenteRepository;
    private final ProdottoCarrelloRepository prodottoCarrelloRepository;

    @Autowired
    public CartService(CartRepository cartRepository, OrdineRepository ordineRepository, ProdottoRepository prodottoRepository, UtenteRepository utenteRepository, ProdottoCarrelloRepository prodottoCarrelloRepository) {
        this.cartRepository = cartRepository;
        this.ordineRepository = ordineRepository;
        this.prodottoRepository = prodottoRepository;
        this.utenteRepository = utenteRepository;
        this.prodottoCarrelloRepository = prodottoCarrelloRepository;
    }

    @Transactional
    public Cart carrelloUtente() throws UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        Cart carrello = cartRepository.findByUtente(u);
        carrello.setProdotti(new HashSet<>(prodottoCarrelloRepository.findByCartAndInCarrello(carrello,true)));
        return carrello;
    }

    @Transactional
    public void addProdotto(ProdottoCarrelloDTO prodottoCarrelloDTO) throws QuantitaErrata, UserNotFoundException, ProdottoNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        if (prodottoCarrelloDTO.quantita() <= 0) throw new QuantitaErrata("Quantità non valida");

        Cart cart = cartRepository.findByUtente(u);
        if (cart == null) {
            cart = new Cart();
            cart.setUtente(u);
        }

        Prodotto pr = prodottoRepository.findById(prodottoCarrelloDTO.idProdotto()).orElseThrow(ProdottoNotFoundException::new);
        boolean presente = false;
        Set<ProdottoCarrello> prodottiCarrello =  cart.getProdotti();
        for(ProdottoCarrello pc : prodottiCarrello){
            Prodotto p = pc.getProdotto();
            if(p.equals(pr)){
                if(pc.isInCarrello()){
                    pc.setQuantita(pc.getQuantita() + prodottoCarrelloDTO.quantita());
                    presente = true;
                    break;
                }else
                    if(pc.getQuantita() == prodottoCarrelloDTO.quantita()){
                        pc.setInCarrello(true);
                        break;
                    }
            }
        }
        if(!presente){
            ProdottoCarrello prodottoCarrello = new ProdottoCarrello();
            prodottoCarrello.setCart(cart);
            prodottoCarrello.setProdotto(pr);
            prodottoCarrello.setQuantita(prodottoCarrelloDTO.quantita());
            prodottoCarrello.setInCarrello(true);
            prodottiCarrello.add(prodottoCarrello);
        }

        cartRepository.save(cart);
    }

    @Transactional
    public void rimuoviProdotto(ProdottoCarrelloDTO prodottoCarrelloDTO) throws UserNotFoundException, ProdottoNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        Cart cart = cartRepository.findByUtente(u);
        Set<ProdottoCarrello> prodottiCarrello = cart.getProdotti();
        Prodotto p = prodottoRepository.findById(prodottoCarrelloDTO.idProdotto()).orElseThrow(ProdottoNotFoundException::new);

        System.out.println(prodottiCarrello);
        for(ProdottoCarrello pc : prodottiCarrello){
            if(pc.getProdotto().equals(p) && pc.isInCarrello()){
                System.out.println(pc.getProdotto().equals(p));
                pc.setInCarrello(false);
                return;
            }
        }
        throw new IllegalStateException("Carrello in stato inconsistente");
    }


    @Transactional(rollbackOn = Exception.class)
    public Ordine checkout(Cart c) throws QuantitaErrata, EmptyCart, SessionError, UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        Cart cart = cartRepository.findByUtente(u);
        Set<ProdottoCarrello> prodottiCarrello = new HashSet<>(prodottoCarrelloRepository.findByCartAndInCarrello(cart,true));
        if (cart == null || prodottiCarrello.isEmpty()) throw new EmptyCart("Il carrello è vuoto");

        if(!prodottiCarrello.equals(c.getProdotti()))
            throw new SessionError("Errore: refreshare la pagina");

        Ordine ordine = new Ordine();

        ordine.setDataCreazione(new Date());
        ordine.setUtente(u);

        double prezzoTotale = 0.0;

        Set<ProdottoOrdine> prodottiOrdine = new HashSet<>();
        for (ProdottoCarrello prodottoCarrello : prodottoCarrelloRepository.findByCartAndInCarrello(cart, true)) {
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
            prodottoCarrello.setInCarrello(false);
            prodottoCarrelloRepository.save(prodottoCarrello);
        }
        ordine.setProdotti(prodottiOrdine);
        ordine.setPrezzoTotale(prezzoTotale);
        ordineRepository.save(ordine);

        cartRepository.save(cart);

        return ordine;
    }

}
