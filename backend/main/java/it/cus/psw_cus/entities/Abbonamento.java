package it.cus.psw_cus.entities;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Entity
@Getter
@Setter
@EqualsAndHashCode
@ToString
@Table(name = "abbonamento")
public class Abbonamento {
    @Id
    @Column(name = "id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Basic
    @Column(name = "rimanenti")
    private int rimanenti;

    @Temporal(TemporalType.DATE)
    @Column(name = "data_acquisto")
    private Date dataAcquisto = new Date();

    @ManyToOne
    @JoinColumn(name = "utente")
    private Utente utente;

    @ManyToOne
    @JoinColumn(name = "pacchetto")
    private Pacchetto pacchetto;

    @PostPersist
    private void postPersist() {
        this.rimanenti = pacchetto.getIngressi();
    }

    @Version
    private int version;
}
