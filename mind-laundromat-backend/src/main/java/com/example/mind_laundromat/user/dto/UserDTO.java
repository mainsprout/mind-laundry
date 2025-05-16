package com.example.mind_laundromat.user.dto;

import com.example.mind_laundromat.cbt.entity.EmotionType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
public class UserDTO {
    private String email;

    private String password;

    private String first_name;

    private String last_name;

    private EmotionType emotion;

}
