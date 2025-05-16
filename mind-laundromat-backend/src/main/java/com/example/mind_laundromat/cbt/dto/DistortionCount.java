package com.example.mind_laundromat.cbt.dto;

import com.example.mind_laundromat.cbt.entity.DistortionType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DistortionCount {
    private DistortionType distortionType;
    private Long count;

    public DistortionCount(DistortionType distortionType, Long count) {
        this.distortionType = distortionType;
        this.count = count;
    }
}
