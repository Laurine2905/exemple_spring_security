package monprojet.entity;


import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;

// Un exemple d'entité
// On utilise Lombok pour auto-générer getter / setter / toString...
// cf. https://examples.javacodegeeks.com/spring-boot-with-lombok/
@Getter @Setter @NoArgsConstructor @RequiredArgsConstructor @ToString
@Entity // Une entité JPA
public class Arret {
    // id auto généré
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Setter(AccessLevel.NONE) // la clé est auto-générée par la BD, pas de "setter"
    private Integer id;

    @NonNull
    private LocalDate debut;

    @NonNull
    private LocalDate fin;
    @NonNull
    private int nb_jours;

    @NonNull
    private String objet;

    @ManyToOne(optional = false)
    @NonNull
    private Intervenant intervenant;

}
