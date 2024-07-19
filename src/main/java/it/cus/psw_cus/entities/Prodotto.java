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
@Table( name = "prodotto",schema = "dbprova")
public class Prodotto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Basic
    @Column(name = "nome")
    private String nome;

    @Basic
    @Column(name = "prezzo")
    private double prezzo;

    @Basic
    @Column(name = "categoria")
    private String categoria;

    @Basic
    @Column(name = "descrizione")
    private String descrizione;

    @Basic
    @Column(name = "immagine")
    private String immagine;


    @Basic
    @Column(name = "disponibilita")
    private int disponibilita;

    @OneToMany(mappedBy = "prodotto", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<ProdottoCarrello> prodottiCarrello;

    @Basic
    @Column(name = "sesso")
    @Enumerated(EnumType.STRING)
    private Sesso sesso; //disinzione del prodotto per sesso (F,M,UNISEX)


    @Getter
    @ToString
    public enum Sesso{
        Maschile,Femminile,Unisex;
    }

}
