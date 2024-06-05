package it.cus.psw_cus.services;

import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.support.exceptions.UserAlreadyExistsException;
import it.cus.psw_cus.support.exceptions.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UtenteService {
    private final UtenteRepository userRepository;

    @Autowired
    public UtenteService(UtenteRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<Utente> cercaTutti(){
        return userRepository.findAll();
    }

    public Utente cercaUtente(int id) throws UserNotFoundException {
        return userRepository.findById(id).orElseThrow(UserNotFoundException::new);
    }

    public Utente creaUtente(Utente utente) throws UserAlreadyExistsException{
        if(userRepository.existsById(utente.getId()))
            throw new UserAlreadyExistsException();
        return userRepository.save(utente);
    }

    public void eliminaUtente(int id) throws UserNotFoundException {
        Utente utente = cercaUtente(id);
        userRepository.delete(utente);
    }
}
