package it.cus.psw_cus.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Entity
@Getter
@Setter
@EqualsAndHashCode
@ToString
@Table(name = "utente")
public class Utente {
    @Id
    @Column(name = "id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Basic
    @Column(name = "nome", nullable = false, length = 50)
    private String nome;
    @Basic
    @Column(name = "cognome", nullable = false, length = 50)
    private String cognome;

    @Enumerated(EnumType.STRING)
    @Column(name = "sesso", length = 25)
    private Sesso sesso;

//    non mi serve, ottengo l'informazione dalla lista di abbonamenti
//    @Basic
//    @Column(name = "ingressi", nullable = false)
//    private int numIngressi;

    @OneToMany(mappedBy="utente", cascade = CascadeType.MERGE )
    @JsonIgnore
    private List<Prenotazione> prenotazioni;

    @OneToMany(mappedBy="utente", cascade = CascadeType.MERGE )
    @JsonIgnore
    private List<Abbonamento> abbonamenti;


    public enum Sesso{
        MASCHIO,FEMMINA,ALTRO
    }
}

