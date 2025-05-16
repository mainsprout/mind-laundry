package com.example.mind_laundromat.cbt.dto;

import com.example.mind_laundromat.cbt.entity.EmotionType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CbtEndRequest {
    private boolean isEnd;           // 대화 종료 여부
    private EmotionType emotion;     // 사용자가 선택한 감정
}
