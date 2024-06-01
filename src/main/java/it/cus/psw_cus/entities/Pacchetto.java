package it.cus.psw_cus.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name = "pacchetto", schema="dbprova")
public class Pacchetto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Basic
    @Column(name = "ingressi", nullable = false)
    private int ingressi;

    @Basic
    @Column(name = "prezzo_unitario", nullable = false)
    private float prezzoUnitario;

    @JsonIgnore
    @OneToMany(mappedBy = "pacchetto")
    private List<Abbonamento> abbonamenti;
}
