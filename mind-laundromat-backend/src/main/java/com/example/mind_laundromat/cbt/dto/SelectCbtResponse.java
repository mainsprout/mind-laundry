package com.example.mind_laundromat.cbt.dto;

import com.example.mind_laundromat.cbt.entity.Diary;
import com.example.mind_laundromat.cbt.entity.DistortionType;
import com.example.mind_laundromat.cbt.entity.EmotionType;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class SelectCbtResponse {
    private Long user_id;

    /**
     * Diary
     * */
    private Long diary_id;

    private String before_content; // 교정 전

    private String after_content; // 교정 후

    private LocalDateTime regDate; // 생성 시간

    private LocalDateTime modDate; // 수정 시간

    /**
     * Emotion
     * */
    private EmotionType emotion_type; // 감정 종류


    /**
     * Feedback
     * */
    private String summation; // 요약

    private String solution; // 솔루션

    /**
     * Distortion
     * */
    private List<DistortionType> distortion_type; // 인지 왜곡 종류


    public SelectCbtResponse(Diary diary) {
        this.user_id = diary.getUser().getUserId();

        this.diary_id = diary.getDiary_id();
        this.before_content = diary.getBefore_content();
        this.after_content = diary.getAfter_content();
        this.regDate = diary.getRegDate();
        this.modDate = diary.getModDate();

        this.emotion_type = diary.getEmotion().getEmotion_type();

        this.summation = diary.getFeedback().getSummation();
        this.solution = diary.getFeedback().getSolution();

        this.distortion_type = diary.getDiaryDistortions().stream()
                .map(diaryDistortion -> diaryDistortion.getDistortion().getDistortionType())
                .collect(Collectors.toList());
    }
}
