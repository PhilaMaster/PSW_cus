package it.cus.psw_cus.entities;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name = "pacchetto", schema="dbprova")
public class Pacchetto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sesso", nullable = false)
    private int id;

    @Basic
    @Column(name = "ingressi", nullable = false)
    private int ingressi;

    @Basic
    @Column(name = "prezzo_unitario", nullable = false)
    private float prezzoUnitario;
}
