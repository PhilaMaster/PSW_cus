package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Pacchetto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PacchettoRepository extends JpaRepository<Pacchetto, Integer> {
    Optional<Pacchetto> findByIngressi(int ingressi);
}
