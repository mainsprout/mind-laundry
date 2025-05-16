package com.example.mind_laundromat.user.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateUserDTO {
    String email;

    String first_name;

    String last_name;

    String emotion_name;
}
