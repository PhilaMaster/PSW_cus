package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Pacchetto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PacchettoRepository extends JpaRepository<Pacchetto, Integer> {
    Optional<Pacchetto> findByIngressi(int ingressi);

    boolean existsByIngressi(int ingressi);

    Optional<List<Pacchetto>> findByPrezzoUnitarioBetween(float min, float max);

    @Query("SELECT p from Pacchetto p where p.ingressi*p.prezzoUnitario>=?1 and p.ingressi*p.prezzoUnitario<=?2")
    Optional<List<Pacchetto>> findByPrezzoBetween(float min, float max);
}
