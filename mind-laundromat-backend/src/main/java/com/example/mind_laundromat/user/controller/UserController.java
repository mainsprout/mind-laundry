package com.example.mind_laundromat.user.controller;

import com.example.mind_laundromat.response.CommonResponse;
import com.example.mind_laundromat.response.ResponseBuilder;
import com.example.mind_laundromat.user.dto.UpdateUserDTO;
import com.example.mind_laundromat.user.dto.UserDTO;
import com.example.mind_laundromat.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@Log4j2
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/signup")
    public ResponseEntity<CommonResponse<String>> signup(@RequestBody UserDTO userDTO) {
        userService.registerUser(userDTO);

        return ResponseEntity.ok(ResponseBuilder.success("회원가입에 성공하였습니다."));
    }

    @GetMapping("/info")
    public ResponseEntity<CommonResponse<UserDTO>> getUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String tokenEmail = authentication.getName();

        return ResponseEntity.ok(ResponseBuilder.success(userService.findByUserEmail(tokenEmail)));
    }

    @DeleteMapping()
    public ResponseEntity<CommonResponse<String>> deleteUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String tokenEmail = authentication.getName();

        userService.deleteUser(tokenEmail);
        return ResponseEntity.ok(ResponseBuilder.success(tokenEmail + " 이 삭제되었습니다."));
    }

    @PatchMapping("/update")
    public ResponseEntity<CommonResponse<String>> updateUser(@RequestBody UpdateUserDTO updateUserDTO) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        updateUserDTO.setEmail(authentication.getName());
        userService.updateUser(updateUserDTO);

        return ResponseEntity.ok(ResponseBuilder.success("이름이 " + updateUserDTO.getFirst_name() + " "
                + updateUserDTO.getLast_name() + "로 업데이트 되었습니다.\n"
        + "이모지가 " + updateUserDTO.getEmotion_name() + " 로 업데이트 되었습니다."));
    }
}
