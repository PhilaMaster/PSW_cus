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
@ToString(exclude = "ordine")
@EqualsAndHashCode(exclude = "ordine")
@Table(name = "prodotto_ordine", schema = "dbprova")
public class ProdottoOrdine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "prodotto_id")
    private ProdottoCarrello prodottoCarrello;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "ordine_id")
    private Ordine ordine;

}
