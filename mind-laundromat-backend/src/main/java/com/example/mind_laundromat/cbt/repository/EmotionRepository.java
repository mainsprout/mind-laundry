package com.example.mind_laundromat.cbt.repository;

import com.example.mind_laundromat.cbt.entity.Emotion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EmotionRepository extends JpaRepository<Emotion, Long> {
}
