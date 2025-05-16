package com.example.mind_laundromat.cbt.controller;


import com.example.mind_laundromat.cbt.entity.EmotionType;
import com.example.mind_laundromat.cbt.service.GeminiService;
import com.fasterxml.jackson.core.JsonProcessingException;
import jakarta.servlet.http.HttpSession;
import org.springframework.ai.vertexai.gemini.VertexAiGeminiChatModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RequestMapping("/gemini")
@RestController
public class GeminiController {
    private final VertexAiGeminiChatModel vertexAiGeminiChatModel;
    private final GeminiService geminiService;

    @Autowired
    public GeminiController(VertexAiGeminiChatModel chatModel, GeminiService geminiService) {
        this.vertexAiGeminiChatModel = chatModel;
        this.geminiService = geminiService;
    }

    @PostMapping("/chat")
    public Map<String, String> chat(@RequestBody String message, HttpSession session) {
        Map<String, String> responses = new HashMap<>();
        Map<String, Object> sessionData = (Map<String, Object>) session.getAttribute("chatbotSession");
        if (sessionData == null) {
            sessionData = new HashMap<>();
            session.setAttribute("chatbotSession", sessionData);
        }

        String geminiResponse = null;
        try {
            geminiResponse = geminiService.processMessage(message, sessionData, false, null, null);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        responses.put("gemini", geminiResponse);
        return responses;
    }

    @PostMapping("/chat/complete")
    public Map<String, String> completeCbtSession(
            @RequestParam EmotionType emotion,
            HttpSession session,
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        Map<String, String> responses = new HashMap<>();

        Map<String, Object> sessionData = (Map<String, Object>) session.getAttribute("chatbotSession");
        if (sessionData == null) {
            responses.put("error", "세션이 존재하지 않습니다. CBT를 먼저 시작해주세요.");
            return responses;
        }

        String email = userDetails.getUsername();
        String result = null;
        try {
            result = geminiService.processMessage(
                    "", // 종료 시 userMessage는 비워서 전달
                    sessionData,
                    true,
                    email,
                    emotion
            );

            try {
                Long diaryId = Long.parseLong(result); // 숫자일 경우
                responses.put("diary_id", String.valueOf(diaryId));
            } catch (NumberFormatException e) {
                responses.put("message", result); // "종료되었습니다." 같은 텍스트일 경우
            }

            return responses;

        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }

    }

}
