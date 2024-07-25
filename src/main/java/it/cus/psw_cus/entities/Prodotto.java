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
@ToString(exclude = "prodottiCarrello")
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Prodotto prodotto = (Prodotto) o;

        if (Double.compare(prodotto.prezzo, prezzo) != 0) return false;
        if (disponibilita != prodotto.disponibilita) return false;
        if (nome != null ? !nome.equals(prodotto.nome) : prodotto.nome != null) return false;
        if (categoria != null ? !categoria.equals(prodotto.categoria) : prodotto.categoria != null) return false;
        if (descrizione != null ? !descrizione.equals(prodotto.descrizione) : prodotto.descrizione != null) return false;
        if (immagine != null ? !immagine.equals(prodotto.immagine) : prodotto.immagine != null) return false;
        return sesso == prodotto.sesso;
    }

    @Override
    public int hashCode() {

        int result;
        result = nome != null ? nome.hashCode() : 0;
        result = 31 * result + (prezzo != +0.0d ? (int)(prezzo) : 0);
        result = 31 * result + (categoria != null ? categoria.hashCode() : 0);
        result = 31 * result + (descrizione != null ? descrizione.hashCode() : 0);
        result = 31 * result + (immagine != null ? immagine.hashCode() : 0);
        result = 31 * result + disponibilita;
        result = 31 * result + (sesso != null ? sesso.hashCode() : 0);
        return result;
    }


}
