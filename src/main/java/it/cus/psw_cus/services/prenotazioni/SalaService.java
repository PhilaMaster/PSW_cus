package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Sala;
import it.cus.psw_cus.repositories.prenotazioni.AbbonamentoRepository;
import it.cus.psw_cus.repositories.prenotazioni.SalaRepository;
import it.cus.psw_cus.support.exceptions.SalaAlreadyExistsException;
import it.cus.psw_cus.support.exceptions.SalaNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class SalaService {
    private final SalaRepository salaRepository;

    public SalaService(SalaRepository salaRepository, AbbonamentoRepository abbonamentoRepository) {
        this.salaRepository = salaRepository;
    }

    @Transactional(readOnly = true)
    public List<Sala> getAllSale() {
        return salaRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Sala getSalaById(int id) throws SalaNotFoundException{
        return salaRepository.findById(id).orElseThrow(SalaNotFoundException::new);
    }

    @Transactional(readOnly = true)
    public Sala getSalaByNome(String nome) throws SalaNotFoundException{
        return salaRepository.findByNome(nome).orElseThrow(SalaNotFoundException::new);
    }

    @Transactional(readOnly = true)
    public List<Sala> getSaleContainingNome(String nome){
        return salaRepository.findByNomeContainingIgnoreCase(nome).orElse(new ArrayList<>());
    }

    @Transactional
    public Sala createSala(Sala s) throws SalaAlreadyExistsException {
        if(salaRepository.existsById(s.getId()))
            throw new SalaAlreadyExistsException();
        return salaRepository.save(s);
    }

    @Transactional
    public void deleteSala(int id) throws SalaNotFoundException{
        Sala s = getSalaById(id);
        salaRepository.delete(s);
    }

    @Transactional
    public void updateSala(int id, Sala sala) throws SalaNotFoundException{
        Sala s = getSalaById(id);
        s.setNome(sala.getNome());
        s.setCapienza(sala.getCapienza());
        s.setIndirizzo(sala.getIndirizzo());
        salaRepository.save(s);
    }
}
