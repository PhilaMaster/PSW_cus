package it.cus.psw_cus.entities;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
@EqualsAndHashCode(exclude = "ordine")
@Table(name = "prodotto_ordine", schema = "dbprova")
public class ProdottoOrdine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @OneToOne
    @JoinColumn(name = "prodotto_id")
    private ProdottoCarrello prodottoCarrello;

    @ManyToOne()
    @JoinColumn(name = "ordine_id")
    private Ordine ordine;

}
