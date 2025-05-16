package com.example.mind_laundromat.cbt.repository;

import com.example.mind_laundromat.cbt.dto.DistortionCount;
import com.example.mind_laundromat.cbt.entity.Diary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface DiaryRepository extends JpaRepository<Diary, Long> {
    List<Diary> findByUserEmailAndRegDateBetween(String email, LocalDateTime startDate, LocalDateTime endDate);

    @Query("""
            SELECT new com.example.mind_laundromat.cbt.dto.DistortionCount(d.distortionType, COUNT(dd.diaryDistortion_id))
            FROM Distortion d
            LEFT JOIN DiaryDistortion dd ON d.distortion_id = dd.diaryDistortion_id
            LEFT JOIN Diary dy ON dd.diary.diary_id = dy.diary_id AND dy.user.userId = :userId
            GROUP BY d.distortion_id, d.distortionType
            ORDER BY COUNT(dd.diaryDistortion_id) DESC
    """)
    List<DistortionCount> sortDistortion(@Param("userId") Long userId);

}
