package it.cus.psw_cus.support.registration;

import it.cus.psw_cus.support.exceptions.ErroreRegistrazione;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.http.ResponseEntity;

public interface KeycloakUserService {

    ResponseEntity createUser(UserRegistrationRecord userRegistrationRecord) throws ErroreRegistrazione;

}
