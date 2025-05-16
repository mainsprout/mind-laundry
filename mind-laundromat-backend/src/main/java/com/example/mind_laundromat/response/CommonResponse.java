package com.example.mind_laundromat.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class CommonResponse<T> {

    @Schema(description = "응답 코드", example = "S201")
    private String code;
    @Schema(description = "응답 메시지", example = "요청이 성공적으로 처리되었습니다.")
    private String message;
    @Schema(description = "응답 데이터")
    private T data;

}
