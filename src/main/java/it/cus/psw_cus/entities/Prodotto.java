package it.cus.psw_cus.entities;


import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;



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
    @Column(name = "sesso")
    @Enumerated(EnumType.STRING)
    private Sesso sesso; //disinzione del prodotto per sesso (F,M,UNISEX)


    @Getter
    @ToString
    public enum Sesso {
        M("Maschio"),
        F("Femmina"),
        U("Unisex");

        private final String sesso;

        Sesso(String sesso) {
            this.sesso = sesso;
        }

    }

}
