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
    @Column(name = "id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Basic
    @Column(name = "nome", nullable = false, length = 50)
    private String nome;
    @Basic
    @Column(name = "cognome", nullable = false, length = 50)
    private String cognome;

    @Enumerated(EnumType.STRING)
    @Column(name = "sesso", length = 25)
    private Sesso sesso;
//  vanno su keycloak(?)
//    @Basic
//    @Column(name = "email")
//    private String email;
//    @Basic
//    @Column(name = "password")
//    private String password;
    @Basic
    @Column(name = "ingressi", nullable = false)
    private int numIngressi;

    public enum Sesso{
        MASCHIO,FEMMINA,ALTRO
    }
}

