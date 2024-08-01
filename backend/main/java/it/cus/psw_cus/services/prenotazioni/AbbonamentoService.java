package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Abbonamento;
import it.cus.psw_cus.entities.Pacchetto;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.prenotazioni.AbbonamentoRepository;
import it.cus.psw_cus.repositories.prenotazioni.PacchettoRepository;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.*;
import jakarta.persistence.OptimisticLockException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class AbbonamentoService {

    private final AbbonamentoRepository abbonamentoRepository;
    private final UtenteRepository utenteRepository;
    private final PacchettoRepository pacchettoRepository;

    @Autowired
    public AbbonamentoService(AbbonamentoRepository abbonamentoRepository, UtenteRepository utenteRepository, PacchettoRepository pacchettoRepository) {
        this.abbonamentoRepository = abbonamentoRepository;
        this.utenteRepository = utenteRepository;
        this.pacchettoRepository = pacchettoRepository;
    }

    @Transactional(readOnly = true)
    public List<Abbonamento> getAllAbbonamenti() {
        return abbonamentoRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Abbonamento getAbbonamentoById(int id) throws AbbonamentoNotFoundException {
        return abbonamentoRepository.findById(id).orElseThrow(AbbonamentoNotFoundException::new);
    }

    @Transactional
    public Abbonamento createAbbonamento(Abbonamento abbonamento) throws UserNotFoundException, PackageNotFoundException {
        Abbonamento ret = new Abbonamento();
        ret.setUtente(utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new));
        Pacchetto p = pacchettoRepository.findById(abbonamento.getPacchetto().getIngressi()).orElseThrow(PackageNotFoundException::new);
        ret.setPacchetto(p);
        ret.setRimanenti(p.getIngressi());
        ret.setDataAcquisto(new Date());


//        if(abbonamento.getRimanenti() != abbonamento.getPacchetto().getIngressi()) throw new AbbonamentoMalformatoException();
//        //setto come utente quello che attualmente è loggato, in modo che non possa creare abbonamenti a di altri utenti
//        Utente u = utenteRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
//        abbonamento.setUtente(u);
        return abbonamentoRepository.save(abbonamento);
    }

    @Transactional
    public void deleteAbbonamento(int id) {
        abbonamentoRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public List<Abbonamento> getAbbonamentiByUtente(Utente utente) {
        return abbonamentoRepository.findByUtente(utente);
    }

    @Transactional(readOnly = true)
    public List<Abbonamento> getAbbonamentiUtenteConIngressi(Utente utente) {
        return abbonamentoRepository.findByUtenteAndRimanentiGreaterThanZero(utente);
    }

    @Transactional(rollbackFor = OptimisticLockException.class)
    public void scalaIngresso(int id) throws UserNotFoundException, InsufficientEntriesException {
        Utente u = utenteRepository.findById(id).orElseThrow(UserNotFoundException::new);
        List<Abbonamento> abbonamentiAttivi = abbonamentoRepository.findByUtenteAndRimanentiGreaterThanZero(u);
        if (abbonamentiAttivi.isEmpty()) throw new InsufficientEntriesException();

        Abbonamento daScalare = abbonamentiAttivi.get(0);
        daScalare.setRimanenti(daScalare.getRimanenti()-1);
        abbonamentoRepository.save(daScalare);
    }
}