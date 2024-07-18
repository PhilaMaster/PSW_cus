package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.shop.OrdineRepository;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.OrdineNotFoundException;
import it.cus.psw_cus.support.exceptions.UnauthorizedAccessException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class OrdineService {

    private final OrdineRepository ordineRepository;

    @Autowired
    public OrdineService(OrdineRepository ordineRepository) {
        this.ordineRepository = ordineRepository;
    }

    @PreAuthorize("hasRole('utente')")
    @Transactional
    public Ordine salvaOrdine(Ordine ordine) {return ordineRepository.save(ordine);}


    @PreAuthorize("hasRole('admin')")
    @Transactional
    public List<Ordine> trovaTuttiGliOrdini() {
        return ordineRepository.findAll();
    }

    @PreAuthorize("hasRole('utente')")
    @Transactional
    public List<Ordine> filtraPerData(Date inizio, Date fine){
        return ordineRepository.findByDataCreazioneBetween(inizio,fine);
    }

    @PreAuthorize("hasRole('utente')")
    @Transactional
    public void eliminaOrdine(int id) throws OrdineNotFoundException {
        Ordine ordine = ordineRepository.findById(id)
                .orElseThrow(OrdineNotFoundException::new);
        ordineRepository.delete(ordine);
    }

    @PreAuthorize("hasRole('admin')")
    @Transactional
    public Optional<Ordine> trovaOrdinePerUtente(Utente utente) throws OrdineNotFoundException, UnauthorizedAccessException {
        if (utente.getId() != Utils.getId()) throw new UnauthorizedAccessException();
        return ordineRepository.findByUtente(utente);
    }

}
