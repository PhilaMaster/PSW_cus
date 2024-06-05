package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.repositories.prenotazioni.PrenotazioneRepository;
import it.cus.psw_cus.support.exceptions.SalaFullException;
import it.cus.psw_cus.support.exceptions.SalaNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PrenotazioneService {
    private final PrenotazioneRepository prenotazioneRepository;
    private final SalaService salaService;

    @Autowired
    public PrenotazioneService(PrenotazioneRepository prenotazioneRepository, SalaService salaService) {
        this.prenotazioneRepository = prenotazioneRepository;
        this.salaService = salaService;
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> findAll() {
        return prenotazioneRepository.findAll();
    }

    @Transactional
    public Prenotazione create(Prenotazione p) throws SalaFullException, SalaNotFoundException {
        if (salaService.isDisponibile(p.getSala().getId(), p.getData(), p.getFasciaOraria()))
            return prenotazioneRepository.save(p);
        throw new SalaFullException();
    }
}
