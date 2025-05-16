package com.example.mind_laundromat.cbt.repository;

import com.example.mind_laundromat.cbt.entity.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FeedbackRepository extends JpaRepository<Feedback, Long> {
}
