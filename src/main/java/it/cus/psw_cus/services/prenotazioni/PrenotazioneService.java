package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.entities.Sala;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.prenotazioni.PrenotazioneRepository;
import it.cus.psw_cus.repositories.prenotazioni.SalaRepository;
import it.cus.psw_cus.services.UtenteService;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Service
public class PrenotazioneService {
    private final PrenotazioneRepository prenotazioneRepository;
    private final UtenteRepository utenteRepository;
    private final SalaRepository salaRepository;
    private final UtenteService utenteService;
    private final AbbonamentoService abbonamentoService;

    @Autowired
    public PrenotazioneService(PrenotazioneRepository prenotazioneRepository, SalaRepository salaRepository, UtenteRepository utenteRepository, UtenteService utenteService, AbbonamentoService abbonamentoService) {
        this.prenotazioneRepository = prenotazioneRepository;
        this.salaRepository = salaRepository;
        this.utenteRepository = utenteRepository;
        this.utenteService = utenteService;
        this.abbonamentoService = abbonamentoService;
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> findAll() {
        return prenotazioneRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> getPrenotazioniUtente() throws UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        return prenotazioneRepository.findByUtente(u);
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> getPrenotazioniUtenteDopoData(Date data) throws UserNotFoundException {
        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
        return prenotazioneRepository.findByUtenteAndDataAfter(u,data);
    }

    @Transactional(readOnly = true)
    public List<Prenotazione> getPrenotazioniUtenteFuture() throws UserNotFoundException {
        LocalDate localDate = LocalDate.now().minusDays(1);//mostro tutte le prenotazioni comprese quelle della giornata odierna
        Date data = Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        return getPrenotazioniUtenteDopoData(data);
    }

    @Transactional(rollbackFor = Exception.class, noRollbackFor = {
            UnauthorizedAccessException.class,
            PrenotazioneAlreadyExistsException.class,
            InsufficientEntriesException.class,
            SalaFullException.class})
    public Prenotazione create(Prenotazione p) throws SalaFullException, SalaNotFoundException, PrenotazioneAlreadyExistsException,
            UserNotFoundException, UnauthorizedAccessException, InsufficientEntriesException {
        if(p.getUtente().getId() != Utils.getId()) throw new UnauthorizedAccessException();
        if (prenotazioneRepository.existsPrenotazioneByUtenteAndDataAndFasciaOrariaAndSala(p.getUtente(),p.getData(),p.getFasciaOraria(),p.getSala()))
            throw new PrenotazioneAlreadyExistsException();
        if (utenteService.ingressiUtente(p.getUtente().getId()) <= 0)
            throw new InsufficientEntriesException();
        if (!salaDisponibile(p))
            throw new SalaFullException();
        abbonamentoService.scalaIngresso(p.getUtente().getId());
        return prenotazioneRepository.save(p);
    }

    private boolean salaDisponibile(Prenotazione p) throws SalaNotFoundException {
        Sala sala = salaRepository.findById(p.getSala().getId()).orElseThrow(SalaNotFoundException::new);
        int c1 = sala.getCapienza();
        int c2 = prenotazioneRepository.countPrenotazioniByDataAndFasciaOrariaAndSala(p.getData(),p.getFasciaOraria(),sala);
        return c1>c2;
    }

    @Transactional(readOnly = true)
    public int postiOccupati(Prenotazione p) throws SalaNotFoundException {
        Sala sala = salaRepository.findById(p.getSala().getId()).orElseThrow(SalaNotFoundException::new);
        return prenotazioneRepository.countPrenotazioniByDataAndFasciaOrariaAndSala(p.getData(),p.getFasciaOraria(),sala);
    }
}
