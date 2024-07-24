package it.cus.psw_cus.support.registration;

import it.cus.psw_cus.entities.Cart;
import it.cus.psw_cus.entities.Utente;
import it.cus.psw_cus.repositories.UtenteRepository;
import it.cus.psw_cus.repositories.shop.CartRepository;
import it.cus.psw_cus.support.exceptions.ErroreRegistrazione;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.core.Response;
import lombok.extern.slf4j.Slf4j;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.keycloak.admin.client.resource.ClientResource;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@Slf4j
public class KeycloakUserServiceImpl implements  KeycloakUserService {

    @Autowired
    private UtenteRepository utenteRepository;

    @Value("cus")
    private String realm;

    @Value("http://localhost:8081/")
    private String serverUrl;

    @Value("admin-cli")
    private String clientId;
    @Value("UubJ2PW7y2i2F7qHJ0wD3sKaVfUl0W5y")
    private String secret;
    private String usernameAdmin = "admin";
    private String passwordAdmin = "password";

    @Autowired
    private CartRepository carrelloRepository;



    @Override
    @Transactional(rollbackOn = Exception.class)
    public ResponseEntity createUser(UserRegistrationRecord userRegistrationRecord) throws ErroreRegistrazione {

        if (userRegistrationRecord == null) {
            throw new ErroreRegistrazione();
        }
        Utente u = new Utente();
        u.setOrdini(new HashSet<>());
        u.setNome(userRegistrationRecord.firstName());
        u.setCognome(userRegistrationRecord.lastName());
        u.setEmail(userRegistrationRecord.email());
        u.setAbbonamenti(new ArrayList<>());
        u.setPrenotazioni(new ArrayList<>());
        u.setSesso(userRegistrationRecord.sesso());
        Cart c = new Cart();
        c.setUtente(u);
        Utente utente_salvato=utenteRepository.save(u);
        carrelloRepository.save(c);

        Keycloak keycloak = KeycloakBuilder.builder()
                .serverUrl(serverUrl)
                .realm(realm)
                .grantType(OAuth2Constants.PASSWORD)
                .clientId(clientId)
                .clientSecret(secret)
                .username(usernameAdmin)
                .password(passwordAdmin)
                .build();

      UserRepresentation user = new UserRepresentation();
      user.setEnabled(true);
      user.setUsername(userRegistrationRecord.username());
      user.setEmail(userRegistrationRecord.email());
      user.setFirstName(userRegistrationRecord.firstName());
      user.setLastName(userRegistrationRecord.lastName());
      user.setEmailVerified(true);

        CredentialRepresentation credentialRepresentation = new CredentialRepresentation();
        credentialRepresentation.setValue(userRegistrationRecord.password());
        credentialRepresentation.setTemporary(false);
        credentialRepresentation.setType(CredentialRepresentation.PASSWORD);

        List<CredentialRepresentation> list = new ArrayList<>();
        list.add(credentialRepresentation);

        user.setCredentials(list);

        Integer idToSave = utente_salvato.getId();
        Map<String, List<String>> attributes = new HashMap<>();
        attributes.put("userId", Collections.singletonList(idToSave.toString()));
        attributes.put("origin",Arrays.asList("demo"));
        user.setAttributes(attributes);

        RealmResource realm1 = keycloak.realm(realm);
        UsersResource userResource = realm1.users();

        Response response = userResource.create(user);

        if (response.getStatus() == Response.Status.CREATED.getStatusCode()) {
            String userId = response.getLocation().getPath().replaceAll(".*/([^/]+)$", "$1");

            ClientRepresentation clientRep = realm1.clients().findByClientId(clientId).get(0);
            ClientResource clientResource = realm1.clients().get(clientRep.getId());

            RoleRepresentation userRole = clientResource.roles().get("utente").toRepresentation();
            userResource.get(userId).roles().clientLevel(clientResource.toRepresentation().getId()).add(Collections.singletonList(userRole));

            return new ResponseEntity(utente_salvato, HttpStatus.OK);
        } else {
            throw new ErroreRegistrazione();
        }

    }

}
