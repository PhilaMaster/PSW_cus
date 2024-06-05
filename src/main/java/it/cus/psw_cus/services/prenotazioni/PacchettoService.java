package it.cus.psw_cus.services.prenotazioni;

import it.cus.psw_cus.entities.Pacchetto;
import it.cus.psw_cus.repositories.prenotazioni.PacchettoRepository;
import it.cus.psw_cus.support.exceptions.PackageAlreadyExistsException;
import it.cus.psw_cus.support.exceptions.PackageNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class PacchettoService {
    private final PacchettoRepository pacchettoRepository;

    public PacchettoService(PacchettoRepository pacchettoRepository) {
        this.pacchettoRepository = pacchettoRepository;
    }

    @Transactional(readOnly = true)
    public List<Pacchetto> getAllPacchetti(){
        return pacchettoRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Pacchetto getPacchettoByIngressi(int ingressi) throws PackageNotFoundException {
        return pacchettoRepository.findByIngressi(ingressi).orElseThrow(PackageNotFoundException::new);
    }

    @Transactional(readOnly = true)
    public List<Pacchetto> getPacchettiByPriceRange(float min, float max){
        return pacchettoRepository.findByPrezzoBetween(min,max).orElse(new ArrayList<>());
    }

    @Transactional
    public void createPacchetto(Pacchetto p) throws PackageAlreadyExistsException {
        if(pacchettoRepository.existsById(p.getIngressi()))
            throw new PackageAlreadyExistsException();
        pacchettoRepository.save(p);
    }

    @Transactional
    public void deletePacchetto(int ingressi) throws PackageNotFoundException {
        Pacchetto p = getPacchettoByIngressi(ingressi);
        pacchettoRepository.delete(p);
    }

    @Transactional
    public void updatePacchetto(int ingressi, Pacchetto dettagli) throws PackageNotFoundException {
        Pacchetto pacchetto = getPacchettoByIngressi(ingressi);
        pacchetto.setIngressi(dettagli.getIngressi());
        pacchetto.setPrezzoUnitario(dettagli.getPrezzoUnitario());
        pacchettoRepository.save(pacchetto);
    }

//    @Transactional(readOnly = true)
//    public float getPrezzoScontato(int id, float scontoPercentuale) throws PackageNotFoundException {
//        float intero = getPrezzoIntero(id);
//        return intero - intero*scontoPercentuale/100;
//    }
//
//    @Transactional(readOnly = true)
//    public float getPrezzoIntero(int ingressi) throws PackageNotFoundException {
//        Pacchetto p = getPacchettoByIngressi(ingressi);
//        return p.getPrezzoUnitario()*p.getIngressi();
//    }
}
