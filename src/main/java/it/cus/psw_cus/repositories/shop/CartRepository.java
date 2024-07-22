package it.cus.psw_cus.repositories.shop;

import it.cus.psw_cus.entities.Cart;
import it.cus.psw_cus.entities.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CartRepository extends JpaRepository<Cart, Integer> {

    Cart findByUtente(Utente u);


}
