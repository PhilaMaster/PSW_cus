package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.entities.Sala;
import it.cus.psw_cus.repositories.prenotazioni.PrenotazioneRepository;
import it.cus.psw_cus.repositories.prenotazioni.SalaRepository;
import it.cus.psw_cus.support.exceptions.SalaFullException;
import it.cus.psw_cus.support.exceptions.SalaNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PrenotazioneService {
    private final PrenotazioneRepository prenotazioneRepository;
//    private final SalaService salaService;
    private final SalaRepository salaRepository;

    @Autowired
    public PrenotazioneService(PrenotazioneRepository prenotazioneRepository, SalaRepository salaRepository) {
        this.prenotazioneRepository = prenotazioneRepository;
        this.salaRepository = salaRepository;
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> findAll() {
        return prenotazioneRepository.findAll();
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
