package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.shop.OrdineRepository;
import it.cus.psw_cus.services.UtenteService;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.OrdineNotFoundException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class OrdineService {

    private final OrdineRepository ordineRepository;
    private final UtenteRepository utenteRepository;

    @Autowired
    public OrdineService(OrdineRepository ordineRepository, UtenteRepository utenteRepository) {
        this.ordineRepository = ordineRepository;
        this.utenteRepository = utenteRepository;
    }

    @Transactional
    public Ordine salvaOrdine(Ordine ordine) {return ordineRepository.save(ordine);}


    @Transactional
    public List<Ordine> trovaTuttiGliOrdini() {
        return ordineRepository.findAll();
    }

    @Transactional
    public List<Ordine> filtraPerData(Date inizio, Date fine){
        return ordineRepository.findByDataCreazioneBetween(inizio,fine);
    }

    @Transactional
    public void eliminaOrdine(int id) throws OrdineNotFoundException {
        Ordine ordine = ordineRepository.findById(id)
                .orElseThrow(OrdineNotFoundException::new);
        ordineRepository.delete(ordine);
    }


    @Transactional
    public Optional<Ordine> trovaOrdinePerUtente(int id) throws OrdineNotFoundException, UserNotFoundException {
        Utente u = utenteRepository.findById(id).orElseThrow(UserNotFoundException::new);
        return ordineRepository.findByUtente(u);
    }

}
