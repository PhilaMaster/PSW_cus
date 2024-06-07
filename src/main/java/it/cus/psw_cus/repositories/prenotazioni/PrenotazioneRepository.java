package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Prenotazione;
import it.cus.psw_cus.entities.Sala;
import org.springframework.data.jpa.repository.JpaRepository;
import it.cus.psw_cus.entities.Prenotazione.FasciaOraria;
import java.util.Date;

public interface PrenotazioneRepository extends JpaRepository<Prenotazione,Integer> {
    int countPrenotazioniByDataAndFasciaOrariaAndSala(Date data, FasciaOraria fasciaOraria, Sala sala);
}
