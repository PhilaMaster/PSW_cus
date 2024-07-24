package it.cus.psw_cus.services;

import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.prenotazioni.AbbonamentoRepository;
import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.UnauthorizedAccessException;
import it.cus.psw_cus.support.exceptions.UserAlreadyExistsException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UtenteService {
    private final UtenteRepository userRepository;
    private final AbbonamentoRepository abbonamentoRepository;

    @Autowired
    public UtenteService(UtenteRepository userRepository, AbbonamentoRepository abbonamentoRepository) {
        this.userRepository = userRepository;
        this.abbonamentoRepository = abbonamentoRepository;
    }

    public List<Utente> cercaTutti(){
        return userRepository.findAll();
    }

    public Utente cercaUtente(int id) throws UserNotFoundException {
        return userRepository.findById(Utils.getId()).orElseThrow(UserNotFoundException::new);
    }

    public Utente creaUtente(Utente utente) throws UserAlreadyExistsException{
        if(userRepository.existsById(utente.getId()))
            throw new UserAlreadyExistsException();
        return userRepository.save(utente);
    }

    public void eliminaUtente() throws UserNotFoundException {
        userRepository.delete(cercaUtente(Utils.getId()));
    }

    public int ingressiUtente() throws UserNotFoundException {
        return abbonamentoRepository.contaIngressiRimanentiUtente(cercaUtente(Utils.getId()));
    }

}
