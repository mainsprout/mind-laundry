package com.example.mind_laundromat.cbt.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class DistortionListRequest {
    private int total;
    private List<DistortionCount> distortionList;
}
