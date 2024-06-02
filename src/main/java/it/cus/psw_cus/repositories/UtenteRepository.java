package it.cus.psw_cus.repositories;

import it.cus.psw_cus.entities.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UtenteRepository extends JpaRepository<Utente, Integer> {
    //List<it.cus.pswprogetto.entities.Utente> findByNome(String name);
}
