package it.cus.psw_cus.entities;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name = "prenotazione", schema="dbprova")
public class Prenotazione {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @ManyToOne
    @JoinColumn(name = "utente")
    private Utente utente;

    @ManyToOne
    @JoinColumn(name = "sala")
    private Sala sala;

    @Enumerated(EnumType.STRING)
    @Column(name = "fascia_oraria", nullable = false)
    private FasciaOraria fasciaOraria;

    @Temporal(TemporalType.DATE)
    @Column(name = "data", nullable = false)
    private Date data;

    @Version
    private int version;

    @Getter
    public enum FasciaOraria {
        DIECI_DODICI("10-12"),
        DODICI_QUATTORDICI("12-14"),
        QUATTORDICI_SEDICI("14-16"),
        SEDICI_DICIOTTO("16-18"),
        DICIOTTO_VENTI("18-20"),
        VENTI_VENTIDUE("20-22");

        private final String orario;

        FasciaOraria(String orario) {
            this.orario = orario;
        }

        public String toString(){
            return orario;
        }
    }
}