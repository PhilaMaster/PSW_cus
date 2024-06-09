package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Abbonamento;
import it.cus.psw_cus.entities.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AbbonamentoRepository extends JpaRepository<Abbonamento, Integer> {
    @Query("SELECT COALESCE(SUM(a.rimanenti),0) FROM Utente u,Abbonamento a WHERE u.id = a.utente.id AND u = ?1")
    int contaIngressiRimanentiUtente(Utente utente);

    List<Abbonamento> findByUtente(Utente utente);

    @Query("SELECT a FROM Abbonamento a WHERE a.utente = ?1 AND a.rimanenti > 0")
    List<Abbonamento> findByUtenteAndRimanentiGreaterThanZero(Utente utente);
}
