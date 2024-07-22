package it.cus.psw_cus.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter
@Setter
@EqualsAndHashCode(exclude = {"cart", "prenotazioni","abbonamenti","ordini"})
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
    @Column(name = "sesso", nullable = false, length = 25)
    private Sesso sesso;

    @OneToMany(mappedBy="utente", cascade = CascadeType.ALL )
    @JsonIgnore
    private List<Prenotazione> prenotazioni;

    @OneToMany(mappedBy="utente", cascade = CascadeType.ALL )
    @JsonIgnore
    private List<Abbonamento> abbonamenti;

    @OneToOne(mappedBy = "utente", cascade = CascadeType.ALL)
    @JoinColumn(name = "cart_id")
    @JsonIgnore
    private Cart cart;

    @OneToMany(mappedBy = "utente", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    @JsonIgnore
    private Set<Ordine> ordini = new HashSet<>();

    public enum Sesso{
        MASCHIO,FEMMINA,ALTRO
    }
}

