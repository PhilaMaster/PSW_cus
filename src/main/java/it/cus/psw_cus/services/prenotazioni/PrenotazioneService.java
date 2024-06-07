package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.entities.Sala;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.prenotazioni.PrenotazioneRepository;
import it.cus.psw_cus.repositories.prenotazioni.SalaRepository;
import it.cus.psw_cus.support.exceptions.SalaFullException;
import it.cus.psw_cus.support.exceptions.SalaNotFoundException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class PrenotazioneService {
    private final PrenotazioneRepository prenotazioneRepository;
    private final UtenteRepository utenteRepository;
    private final SalaRepository salaRepository;

    @Autowired
    public PrenotazioneService(PrenotazioneRepository prenotazioneRepository, SalaRepository salaRepository, UtenteRepository utenteRepository) {
        this.prenotazioneRepository = prenotazioneRepository;
        this.salaRepository = salaRepository;
        this.utenteRepository = utenteRepository;
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> findAll() {
        return prenotazioneRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> getPrenotazioniUtente(int id) throws UserNotFoundException {
        Utente u = utenteRepository.findById(id).orElseThrow(UserNotFoundException::new);
        return prenotazioneRepository.findByUtente(u);
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> getPrenotazioniUtenteDopoData(int id, Date data) throws UserNotFoundException {
        Utente u = utenteRepository.findById(id).orElseThrow(UserNotFoundException::new);
        return prenotazioneRepository.findByUtenteAndDataAfter(u,data);
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> getPrenotazioniUtenteFuture(int id) throws UserNotFoundException {
        return getPrenotazioniUtenteDopoData(id, new Date());
    }

    @Transactional
    public Prenotazione create(Prenotazione p) throws SalaFullException, SalaNotFoundException {
//        if (salaService.isDisponibile(p.getSala().getId(), p.getData(), p.getFasciaOraria()))
//            return prenotazioneRepository.save(p);
        //TODO fare check prenotazione già esistente prima
        if (salaDisponibile(p))
            return prenotazioneRepository.save(p);
        throw new SalaFullException();
    }

    private boolean salaDisponibile(Prenotazione p) throws SalaNotFoundException {
        Sala sala = salaRepository.findById(p.getSala().getId()).orElseThrow(SalaNotFoundException::new);
        int c1 = sala.getCapienza();
        int c2 = prenotazioneRepository.countPrenotazioniByDataAndFasciaOrariaAndSala(p.getData(),p.getFasciaOraria(),p.getSala());
        return c1>c2;
    }
}
