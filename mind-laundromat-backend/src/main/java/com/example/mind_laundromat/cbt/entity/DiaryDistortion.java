package com.example.mind_laundromat.cbt.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@ToString
@Getter
@Setter
public class DiaryDistortion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long diaryDistortion_id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "diary_id")
    private Diary diary;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "distortion_id")
    private Distortion distortion;
}
