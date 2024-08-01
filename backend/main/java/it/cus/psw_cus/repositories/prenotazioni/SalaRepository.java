package it.cus.psw_cus.repositories.prenotazioni;

import it.cus.psw_cus.entities.Sala;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SalaRepository extends JpaRepository<Sala, Integer> {
    Optional<Sala> findByNome(String nome);

    Optional<List<Sala>> findByNomeContainingIgnoreCase(String nome);
}
