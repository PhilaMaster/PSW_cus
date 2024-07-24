package it.cus.psw_cus.support.registration;

import it.cus.psw_cus.support.authentication.Utils;
import it.cus.psw_cus.support.exceptions.ErroreRegistrazione;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/users")
@AllArgsConstructor
public class KeycloakUserApi {

    private final KeycloakUserService keycloakUserService;


    @PostMapping("/registrazione")
    public ResponseEntity createUser(@RequestBody UserRegistrationRecord userRegistrationRecord) throws ErroreRegistrazione {
        return keycloakUserService.createUser(userRegistrationRecord);
    }


}
