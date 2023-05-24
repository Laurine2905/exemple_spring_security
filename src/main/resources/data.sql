-- Initialisation des tables
-- La ligne suivante ne sert à rien, mais le fichier ne doit pas être vide
SELECT 'hello' AS message;

-- Initialisation des tables
INSERT INTO Intervenant(num_SS, nom, prenom, date_naiss, nom_jeune_fille, adresse, entree_collectivité,
                        date_titularisation, grade, libelle_temps_travail, temps_travail_pourcentage, titulaire, metier)
VALUES (098, 'Demarle', 'Eliot', '1999-10-14', NULL, '26 rue henri IV 81100 CASTRES', '2021-10-05', '2022-07-22', 'mp1',
        'temps plein', 100, 'oui', 'militaire'),
       (05678, 'Rat', 'Laurine', '2002-05-29', NULL, '26 rue henri IV 81100 CASTRES', '2023-04-05', '2022-09-22',
        'stagiaire', 'temps plein', 100, 'non', 'developpeuse'),
       (099, 'Lami', 'Doriane', '1999-10-14', NULL, 'Bordeaux', '2021-10-05', NULL, '3', 'temps plein', 100, 'non',
        'militaire'),
       (123, 'Villatte', 'Amandine', '1999-10-14', NULL, 'CASTRES', '2021-10-05', '2022-07-22', '5', 'temps plein', 100,
        'oui', 'AS'),
       (345, 'Dupe', 'Cassandra', '1999-10-14', NULL, 'Avignon', '2021-10-05', '2022-07-22', 'mp4', 'temps plein', 100,
        'non', 'infirmière'),
       (237, 'Lock-fat', 'Amélie', '1999-10-14', NULL, 'Tours', '2021-10-05', '2022-07-22', 'y', 'temps plein', 100,
        'oui', 'docteur'),
       (2478904, 'Estadieu', 'Jean', '1999-10-14', NULL, 'Lyon', '2021-10-05', '2022-07-22', 'z', 'temps plein', 100,
        'oui', 'professeur'),
       (13580, 'Chambonnet', 'Arnaud', '1999-10-14', NULL, 'Limoges', '2021-10-05', '2022-07-22', 'd', 'temps plein',
        100, 'oui', 'RH'),
       (23680, 'Delbos', 'Lucille', '1999-10-14', NULL, 'Douai', '2021-10-05', '2022-07-22', 'mp1', 'temps plein', 100,
        'non', 'cuisinier'),
       (345347, 'UVGY', 'Jacque', '1999-10-14', NULL, 'Tours', '2021-10-05', NULL, 'y', 'temps plein', 100, 'non',
        'docteur'),
       (2458920, 'Adam', 'Maddie', '1999-10-14', NULL, 'Paris', '2021-10-05', '2022-07-22', 'd', 'temps plein', 100,
        'oui', 'stagiaire'),
       (24789304, 'Nivoix', 'Thomas', '1999-10-14', NULL, 'Lyon', '2021-10-05', '2022-07-22', 'z', 'temps plein', 100,
        'oui', 'professeur'),
       (245890, 'Feron', 'Mélanie', '1999-10-14', NULL, 'Paris II', '2021-10-05', '2022-07-22', 'd', 'temps plein', 100,
        'non', 'stagiaire');

INSERT INTO Arret(debut, fin, nb_jours, objet, intervenant_num_SS)
VALUES ('2023-04-26', '2023-06-23', '5', 'CD', (select num_SS from Intervenant where nom = 'Rat')),
       ('2023-04-21', '2023-04-23', '65', 'MD', (select num_SS from Intervenant where nom = 'Demarle')),
       ('2023-04-21', '2023-04-23', '655', 'LD', (select num_SS from Intervenant where nom = 'Dupe'));

INSERT INTO Arret2(debut, fin, nb_jours, categorie, objet, intervenant_num_SS)
VALUES ('2023-04-26', '2026-05-21', '65','1', 'maternité', (select num_SS from Intervenant where nom = 'Feron')),
       ('2023-04-21', '2024-08-19', '65','2', 'congé spécial', (select num_SS from Intervenant where nom = 'Lami'));
INSERT INTO Contrat(debut, fin, duree_en_jours, motif, intervenant_num_SS)
VALUES ('2023-06-23', '2023-06-26', '2', 'remplacement', (select num_SS from Intervenant where nom = 'Demarle')),
       ('2023-01-21', '2023-04-23', '65', 'CDD', (select num_SS from Intervenant where nom = 'Rat'));