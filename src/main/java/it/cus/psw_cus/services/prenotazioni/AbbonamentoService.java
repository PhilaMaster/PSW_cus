package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Abbonamento;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.prenotazioni.AbbonamentoRepository;
import it.cus.psw_cus.support.exceptions.AbbonamentoNotFoundException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class AbbonamentoService {

    private final AbbonamentoRepository abbonamentoRepository;

    @Autowired
    public AbbonamentoService(AbbonamentoRepository abbonamentoRepository) {
        this.abbonamentoRepository = abbonamentoRepository;
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
    public Abbonamento createAbbonamento(Abbonamento abbonamento) {
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

//    public Abbonamento updateAbbonamento(int id, Abbonamento newAbbonamento) {
//        return abbonamentoRepository.findById(id)
//                .map(abbonamento -> {
//                    abbonamento.setRimanenti(newAbbonamento.getRimanenti());
//                    abbonamento.setDataAcquisto(newAbbonamento.getDataAcquisto());
//                    abbonamento.setUtente(newAbbonamento.getUtente());
//                    abbonamento.setPacchetto(newAbbonamento.getPacchetto());
//                    return abbonamentoRepository.save(abbonamento);
//                })
//                .orElseGet(() -> {
//                    newAbbonamento.setId(id);
//                    return abbonamentoRepository.save(newAbbonamento);
//                });
//    }
}