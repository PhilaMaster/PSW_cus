package it.cus.psw_cus.home.services;

import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.home.repositories.UtenteRepository;
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
}
