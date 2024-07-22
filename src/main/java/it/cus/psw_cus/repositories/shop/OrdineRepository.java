package it.cus.psw_cus.repositories.shop;

import it.cus.psw_cus.entities.Ordine;
import it.cus.psw_cus.entities.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrdineRepository extends JpaRepository<Ordine,Integer> {


    List<Ordine> findByDataCreazioneBetween(Date startDate, Date endDate);

    List<Ordine> findAll();

    Optional<Ordine> findByUtente(Utente utente);
}
