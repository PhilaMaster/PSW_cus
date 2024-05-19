package it.cus.psw_cus.entities;

import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@EqualsAndHashCode
@ToString
@Table(name = "utente")
public class Utente {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Basic
    @Column(name = "nome")
    private String nome;
    @Basic
    @Column(name = "cognome")
    private String cognome;

    @Basic
    @Column(name = "sesso")
    private String sesso;
    @Basic
    @Column(name = "email")
    private String email;
    @Basic
    @Column(name = "password")
    private String password;
    @Basic
    @Column(name = "privatnumIngressi")
    private int numIngressi;
}
