package it.cus.psw_cus.entities;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString(exclude = "cart")
@EqualsAndHashCode(exclude = "cart")
@Table( name = "prodotto_carrello",schema = "dbprova")
public class ProdottoCarrello {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "quantita")
    private int quantita;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "carrello_id")
    private Cart cart;

    @ManyToOne
    @JoinColumn(name = "prodotto_id")
    private Prodotto prodotto;



}
