package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.Prodotto;
import it.cus.psw_cus.repositories.shop.ProdottoRepository;
import it.cus.psw_cus.support.exceptions.ProdottoNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class ProdottoService {

    private final ProdottoRepository prodottoRepository;

    @Autowired
    public ProdottoService(ProdottoRepository prodottoRepository) {
        this.prodottoRepository = prodottoRepository;
    }

    @Transactional
    public Prodotto save(Prodotto prodotto) {
        return prodottoRepository.save(prodotto);
    }

    @Transactional
    public void deleteProdotto(int id) {
        prodottoRepository.deleteById(id);
    }


    @Transactional
    public List<Prodotto> findByNome(String nome) {
        return prodottoRepository.findByNome(nome);
    }

    @Transactional
    public List<Prodotto> findByPrezzoBetween(double prezzoMin, double prezzoMax) {
        return prodottoRepository.findByPrezzoBetween(prezzoMin, prezzoMax);
    }

    @Transactional
    public List<Prodotto> findByCategoria(String categoria) {
        return prodottoRepository.findByCategoria(categoria);
    }

    @Transactional
    public List<Prodotto> findBySesso(Prodotto.Sesso sesso) {
        return prodottoRepository.findBySesso(sesso);
    }
}
