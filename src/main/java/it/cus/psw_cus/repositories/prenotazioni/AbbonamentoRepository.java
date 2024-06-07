package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Abbonamento;
import it.cus.psw_cus.entities.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AbbonamentoRepository extends JpaRepository<Abbonamento, Integer> {
    @Query("SELECT COALESCE(SUM(a.rimanenti),0) FROM Utente u,Abbonamento a WHERE u.id = a.utente.id AND u = ?1")
    int contaIngressiRimanentiUtente(Utente utente);
}
