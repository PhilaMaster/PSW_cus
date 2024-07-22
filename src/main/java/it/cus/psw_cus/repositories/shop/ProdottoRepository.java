package it.cus.psw_cus.repositories.shop;


import it.cus.psw_cus.entities.Prodotto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProdottoRepository extends JpaRepository<Prodotto,Integer> {

    List<Prodotto> findAll();

    @Query("SELECT p from Prodotto p where p.nome LIKE ?1")
    List<Prodotto> findByNome(String nome);

    @Query("SELECT p from Prodotto p where p.prezzo>=?1 and p.prezzo<=?2")
    List<Prodotto> findByPrezzoBetween(double prezzoMin, double prezzoMax);

    @Query("SELECT p from Prodotto p where p.categoria LIKE ?1")
    List<Prodotto> findByCategoria(String categoria);

    List<Prodotto> findBySesso(Prodotto.Sesso sesso);

    @Query("SELECT p FROM Prodotto p WHERE " +
            "(p.nome LIKE %:nome% OR :nome IS NULL) AND " +
            "(p.prezzo = COALESCE(:prezzo, p.prezzo)) AND " +
            "(p.categoria = COALESCE(:categoria, p.categoria)) AND " +
            "(p.sesso = COALESCE(:sesso, p.sesso))")
    List<Prodotto> findByNomeAndPrezzoAndCategoriaAndSesso(String nome, double prezzo, String categoria, Prodotto.Sesso sesso);

    //Prodotto findById(int id);

}
