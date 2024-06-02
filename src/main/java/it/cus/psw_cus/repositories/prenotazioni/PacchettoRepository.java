package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Pacchetto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PacchettoRepository extends JpaRepository<Pacchetto, Integer> {
}
