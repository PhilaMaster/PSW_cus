package it.cus.psw_cus.support.registration;

import it.cus.psw_cus.entities.Utente;

public record UserRegistrationRecord(String username, String email, Utente.Sesso sesso, String firstName, String lastName, String password, int id) {

}
