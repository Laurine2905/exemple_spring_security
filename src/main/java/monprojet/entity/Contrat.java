package monprojet.entity;


import lombok.*;
import javax.persistence.*;
import java.time.LocalDate;

// Un exemple d'entité
// On utilise Lombok pour auto-générer getter / setter / toString...
// cf. https://examples.javacodegeeks.com/spring-boot-with-lombok/
@Getter @Setter @NoArgsConstructor @RequiredArgsConstructor @ToString
@Entity // Une entité JPA
public class Contrat {
    // id auto généré
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Setter(AccessLevel.NONE) // la clé est auto-générée par la BD, pas de "setter"
    private Integer id;

    @NonNull
    private LocalDate debut;

    @NonNull
    private LocalDate fin;

    // la durée est en jour pour l'instant voir s'il faut le changer plus tard
    @NonNull
    private int duree_en_jours;

    @NonNull
    private String motif;

    @ManyToOne(optional = false)
    @NonNull
    private Intervenant intervenant;

}
