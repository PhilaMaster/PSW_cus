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
@Table(name = "sala", schema="dbprova")
public class Sala {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id", nullable = false)
    private int id;

    @Basic
    @Column(name = "nome", nullable = false, length = 30)
    private String nome;

    @Basic
    @Column(name = "indirizzo", nullable = false, length = 50)
    private String indirizzo;

    @Basic
    @Column(name = "capienza", nullable = false)
    private int capienza;
}
