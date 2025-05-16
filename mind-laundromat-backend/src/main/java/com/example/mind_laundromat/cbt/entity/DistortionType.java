package com.example.mind_laundromat.cbt.entity;

import lombok.Getter;

@Getter
public enum DistortionType {
    BLACK_AND_WHITE_THINKING("이분법적 사고 (All-or-Nothing Thinking)"),
    OVERGENERALIZATION("과잉 일반화 (Overgeneralization)"),
    MENTAL_FILTER("정신적 여과 (Mental Filter)"),
    DISQUALIFYING_THE_POSITIVE("긍정적 측면 무시 (Disqualifying the Positive)"),
    EMOTIONAL_REASONING("감정적 추론 (Emotional Reasoning)"),
    JUMPING_TO_CONCLUSIONS("성급한 결론 도출 (Jumping to Conclusions)"),
    MIND_READING("독심술 (Mind Reading)"),
    FORTUNE_TELLING("부정적 예측 (Fortune Telling)"),
    MAGNIFICATION("확대 (Magnification)"),
    MINIMIZATION("축소 (Minimization)"),
    PERSONALIZATION("개인화 (Personalization)"),
    SHOULD_STATEMENTS("'해야 한다' 사고 (Should Statements)"),
    LABELING("낙인 찍기 (Labeling)"),
    CONTROL_FALLACY("통제의 오류 (Control Fallacy)"),
    FALLACY_OF_FAIRNESS("공정성 오류 (Fallacy of Fairness)"),
    BLAMING("비난 오류 (Blaming");

    private final String description;

    DistortionType(String description) {
        this.description = description;
    }

    // 모든 오류의 설명을 콤마로 구분하여 반환하는 메서드
    public static String getAllDistortions() {
        StringBuilder allDistortions = new StringBuilder();
        for (DistortionType type : DistortionType.values()) {
            allDistortions.append(type.getDescription()).append(", ");
        }
        // 마지막 쉼표와 공백 제거
        return !allDistortions.isEmpty() ? allDistortions.substring(0, allDistortions.length() - 2) : "";
    }
}
