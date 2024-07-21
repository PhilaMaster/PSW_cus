package it.cus.psw_cus.entities;


import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Calendar;
import java.util.HashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@ToString
@EqualsAndHashCode
@Table(name = "cart", schema="dbprova")
public class Cart {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne(fetch = FetchType.LAZY) //consente di prendere i dati solo quando realmente necessario
    @JoinColumn(name = "utente_id")
    private Utente utente;

    @Column(name = "prodotto")
    @OneToMany(mappedBy = "cart", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Set<ProdottoCarrello> prodotti = new HashSet<>();

    @Version
    @Column(name="version", nullable = true)
    private int version;

}
