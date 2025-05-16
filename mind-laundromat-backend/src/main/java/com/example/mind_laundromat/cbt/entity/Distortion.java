package com.example.mind_laundromat.cbt.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@ToString
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Distortion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long distortion_id;

    @Enumerated(EnumType.STRING)
    @Column(name = "distortion_type")
    private DistortionType distortionType;

}
