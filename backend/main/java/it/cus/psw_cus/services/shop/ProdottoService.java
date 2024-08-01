package it.cus.psw_cus.services.shop;

import it.cus.psw_cus.entities.Prodotto;
import it.cus.psw_cus.repositories.shop.ProdottoRepository;
import it.cus.psw_cus.support.exceptions.ProdottoEsistenteException;
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
    public Prodotto create(Prodotto prodotto) throws ProdottoEsistenteException {
        return prodottoRepository.save(prodotto);
    }

    @Transactional
    public void deleteProdotto(int id) throws ProdottoNotFoundException {
        prodottoRepository.deleteById(id);
    }

    @Transactional
    public List<Prodotto> findAll(){
       return prodottoRepository.findAll();
    }

    @Transactional
    public Prodotto findById(int id) throws ProdottoNotFoundException{
        return prodottoRepository.findById(id).orElseThrow(ProdottoNotFoundException::new);
    }

    @Transactional
    public List<Prodotto> findByNomeAndPrezzoAndCategoriaAndSesso(String nome, double prezzo, String categoria, Prodotto.Sesso sesso){
        return prodottoRepository.findByNomeAndPrezzoAndCategoriaAndSesso(nome,prezzo,categoria,sesso);
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
    public Prodotto updateProdotto(int id, Prodotto prodottoDettagli) throws ProdottoNotFoundException {
        Prodotto prodotto = prodottoRepository.findById(id).orElseThrow(ProdottoNotFoundException::new);

        prodotto.setNome(prodottoDettagli.getNome());
        prodotto.setPrezzo(prodottoDettagli.getPrezzo());
        prodotto.setCategoria(prodottoDettagli.getCategoria());
        prodotto.setDescrizione(prodottoDettagli.getDescrizione());
        prodotto.setSesso(prodottoDettagli.getSesso());
        prodotto.setProdottiCarrello(prodottoDettagli.getProdottiCarrello());

        return prodottoRepository.save(prodotto);
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
