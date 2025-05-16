package com.example.mind_laundromat.user.entity;

import com.example.mind_laundromat.cbt.entity.Diary;
import com.example.mind_laundromat.cbt.entity.EmotionType;
import com.example.mind_laundromat.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@ToString
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class User extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    private String email;

    private String password;

    private String first_name;

    private String last_name;

    @OneToMany(mappedBy = "user")
    private List<Diary> diaryList = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    private Role role;

    @Enumerated(EnumType.STRING)
    private EmotionType profile_emotion;

}
