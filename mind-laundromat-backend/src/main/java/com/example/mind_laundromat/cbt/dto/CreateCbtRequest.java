package com.example.mind_laundromat.cbt.dto;

import com.example.mind_laundromat.cbt.entity.DistortionType;
import com.example.mind_laundromat.cbt.entity.EmotionType;
import lombok.*;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class CreateCbtRequest {
    /**
     * User
     * */
    private String email;

    /**
     * Diary
     * */
    private String before_content; //교정 전

    private String after_content; //교정 후

    /**
     * Emotion
     * */
    private EmotionType emotion_type; // 감정 종류

    /**
     * Feedback
     * */
    private String summation;

    private String solution;

    /**
     * Distortion
     * */
    private List<DistortionType> distortions;
}
