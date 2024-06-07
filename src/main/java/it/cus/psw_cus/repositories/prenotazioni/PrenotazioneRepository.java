package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.entities.Sala;
import it.cus.psw_cus.entities.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import it.cus.psw_cus.entities.Prenotazione.FasciaOraria;
import java.util.Date;
import java.util.List;

public interface PrenotazioneRepository extends JpaRepository<Prenotazione,Integer> {
    int countPrenotazioniByDataAndFasciaOrariaAndSala(Date data, FasciaOraria fasciaOraria, Sala sala);

    List<Prenotazione> findByUtenteAndDataAfter(Utente utente, Date data);
    List<Prenotazione> findByUtente(Utente utente);
}
