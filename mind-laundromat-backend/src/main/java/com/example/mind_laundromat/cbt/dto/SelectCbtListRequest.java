package com.example.mind_laundromat.cbt.dto;

import lombok.*;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SelectCbtListRequest {
    private String email;
    private LocalDate localDate;
    private String timezone;
}
