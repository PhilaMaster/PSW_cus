package it.cus.psw_cus.repositories.shop;

import it.cus.psw_cus.entities.Cart;
import it.cus.psw_cus.entities.ProdottoCarrello;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProdottoCarrelloRepository extends JpaRepository<ProdottoCarrello, Integer> {

    List<ProdottoCarrello> findByCart(Cart cart);

    @Query("SELECT pc FROM ProdottoCarrello pc WHERE pc.cart = ?1 AND pc.prodotto.id = ?2")
    ProdottoCarrello findByCartAndProdottoId(Cart cart, int prodottoId);
}