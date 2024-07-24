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

    @Basic
    @Column(name = "in_carrello")
    private boolean inCarrello;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        ProdottoCarrello that = (ProdottoCarrello) o;

        if (quantita != that.quantita) return false;
        if (!prodotto.equals(that.prodotto)) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = prodotto.hashCode();
        result = 31 * result + quantita;
        return result;
    }

}
