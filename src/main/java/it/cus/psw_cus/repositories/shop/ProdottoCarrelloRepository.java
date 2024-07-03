package it.cus.psw_cus.repositories.shop;

import it.cus.psw_cus.entities.Cart;
import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.ProdottoCarrello;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProdottoCarrelloRepository extends JpaRepository<ProdottoCarrello,Integer> {

    Optional<ProdottoCarrello> findByCart(Cart cart);


}
