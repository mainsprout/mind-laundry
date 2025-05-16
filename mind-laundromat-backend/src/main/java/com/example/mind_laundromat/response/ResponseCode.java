package com.example.mind_laundromat.response;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum ResponseCode {

    SUCCESS("S201", "요청이 성공적으로 처리되었습니다."),
    BAD_REQUEST("E400", "잘못된 요청입니다."),
    UNAUTHORIZED("E401", "권한이 없습니다."),
    FORBIDDEN("E403", "승인이 거부되었습니다."),
    NOT_FOUND("E404", "요청 리소스를 찾을 수 없습니다."),

    SERVER_ERROR("E500", "서버 에러가 발생하였습니다.");

    private final String code;
    private final String message;
}