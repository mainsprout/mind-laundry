package com.example.mind_laundromat.response;

public class ResponseBuilder {
    public static CommonResponse<Void> success() {
        return CommonResponse.<Void>builder()
                .code(ResponseCode.SUCCESS.getCode())
                .message(ResponseCode.SUCCESS.getMessage())
                .data(null)
                .build();
    }

    public static <T> CommonResponse<T> success(T data) {
        return CommonResponse.<T>builder()
                .code(ResponseCode.SUCCESS.getCode())
                .message(ResponseCode.SUCCESS.getMessage())
                .data(data)
                .build();
    }

    public static <T> CommonResponse<T> error(ResponseCode code) {
        return CommonResponse.<T>builder()
                .code(code.getCode())
                .message(code.getMessage())
                .data(null)
                .build();
    }

    public static <T> CommonResponse<T> error(ResponseCode code, String message) {
        return CommonResponse.<T>builder()
                .code(code.getCode())
                .message(message)
                .data(null)
                .build();
    }

}