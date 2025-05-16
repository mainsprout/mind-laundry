package com.example.mind_laundromat.cbt.repository;

import com.example.mind_laundromat.cbt.entity.DiaryDistortion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DiaryDistortionRepository extends JpaRepository<DiaryDistortion, Long> {

    int countDiaryDistortionByDiary_User_UserId(Long userId);
}
