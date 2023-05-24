package monprojet.entity;


import lombok.*;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

// Un exemple d'entité
// On utilise Lombok pour auto-générer getter / setter / toString...
// cf. https://examples.javacodegeeks.com/spring-boot-with-lombok/
@Getter @Setter @NoArgsConstructor @RequiredArgsConstructor @ToString
@Entity // Une entité JPA
public class Intervenant {
    // Numéro de sécurité sociale = unique donc c'est l'id
    @Id
    private Integer num_SS;

    @NonNull
    private String nom;

    @NonNull
    private String prenom;

// nom de jeune fille pas obligatoire
    private String nom_jeune_fille;

    // date de naissance au format date
    @NonNull
    private LocalDate date_naiss;

    @NonNull
    private String adresse;

    // date d'entree dans la collectivité au format date

    @NonNull
    private LocalDate entree_collectivité;

    // date titularisation pas obligatoire
    private LocalDate date_titularisation;

    @NonNull
    private String grade;

    @NonNull
    private String libelle_temps_travail;

    @NonNull
    private int temps_travail_pourcentage;

    @NonNull
    private String titulaire;

    @NonNull
    private String metier;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "intervenant")
    private List<Arret> arrets = new ArrayList<>();
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "intervenant")
    private List<Arret2> arrets2 = new ArrayList<>();
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "intervenant")
    private List<Contrat> contrats = new ArrayList<>();
}
