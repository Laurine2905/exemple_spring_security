package monprojet.dao;

import monprojet.entity.Arret;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArretRepository extends JpaRepository<Arret, Integer> {
}