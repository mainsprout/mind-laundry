package com.example.mind_laundromat.cbt.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@ToString
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Emotion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long emotion_id;

    @Enumerated(EnumType.STRING)
    private EmotionType emotion_type;

}
