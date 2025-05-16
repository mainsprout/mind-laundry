package com.example.mind_laundromat.cbt.repository;

import com.example.mind_laundromat.cbt.entity.Distortion;
import com.example.mind_laundromat.cbt.entity.DistortionType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DistortionRepository extends JpaRepository<Distortion, Long> {
    Optional<Distortion> findByDistortionType(DistortionType distortionType);
}
