package com.example.mind_laundromat.cbt.service;

import com.example.mind_laundromat.cbt.dto.CreateCbtRequest;
import com.example.mind_laundromat.cbt.entity.DistortionType;
import com.example.mind_laundromat.cbt.entity.EmotionType;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ai.vertexai.gemini.VertexAiGeminiChatModel;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class GeminiService {

    private final VertexAiGeminiChatModel vertexAiGeminiChatModel;
    private final CbtService cbtService;

    private static final String INITIAL_PROMPT_TEMPLATE = "당신은 사용자의 마음 건강을 돕는 CBT 기반 챗봇 입니다. " +
            "사용자가 기록한 내용에 대해 공감하며, 어떤 감정을 느끼고 있는지, 어떤 생각을 하고 있는지 질문해주세요.";
    private static final String IDENTIFY_DISTORTION_PROMPT_TEMPLATE = "당신은 사용자의 마음 건강을 돕는 CBT 기반 챗봇 입니다. " +
            "다음은 지금까지 대화의 요약입니다. {사용자가 기록한 생각} 이 전체 기록은 참고용으로만 사용하세요. " +
            "{마지막 메시지} 이 마지막 메시지에 집중하여, 인지적 오류(왜곡된 생각)가 보이면 어떤 유형인지 짚어주고, 더 건강한 생각을 할 수 있도록 질문해주세요. 가능한 인지적 오류 목록: {cognitiveDistortionList}." +
            "만약 인지적 오류가 보이지 않는다면, 감정을 공감해주고 자연스럽게 대화를 이어가 주세요." +
            "※ 대화가 충분히 진행되어 사용자의 감정과 생각이 정리되었다고 판단되면,\"오늘 대화를 여기서 마무리해도 괜찮을까요?\" 와 같이 자연스럽게 종료를 제안해 주세요. " +
            "아직 충분하지 않다면 공감과 질문을 이어가 주세요.";

    public String processMessage(String userMessage, Map<String, Object> sessionData, boolean isEnd, String email, EmotionType emotion) throws JsonProcessingException {
        String prompt;

        // 초기 대화인 경우 초기 프롬프트 사용
        if (sessionData.isEmpty() || !sessionData.containsKey("conversationHistory")) {
            prompt = INITIAL_PROMPT_TEMPLATE;
        } else {
            List<String> history = (List<String>) sessionData.get("conversationHistory"); // 사용자 입력 저장

            // 전체 대화 불러오기
            StringBuilder fullConversation = new StringBuilder();
            for (String message : history) {
                fullConversation.append(message).append("\n");
            }

            String summaryPrompt = "다음은 사용자와 상담사의 대화입니다.\n" +
                    "이 대화를 요약할 때, 단순한 분위기 요약이 아닌 다음 사항을 꼭 포함해 주세요:\n" +
                    "- 사용자가 보인 반복적인 인지적 왜곡 유형 (예: 이분법적 사고, 과일반화 등)\n" +
                    "- 사용자가 표현한 주요 감정 (예: 불안, 무기력, 자책 등)\n" +
                    "- 사용자가 반복적으로 보인 사고 패턴\n" +
                    "- 상담사가 제공한 주요 피드백이나 질문 방식\n" +
                    "요약은 핵심 내용이 빠지지 않도록 3~10문장 이내로 정리해주세요.\n" +
                    "대화:" + fullConversation;


            String summary = vertexAiGeminiChatModel.call(summaryPrompt);

            // 종료 시 summary만 리턴
            if (isEnd) {
                history.add("사용자: " + userMessage);
                sessionData.put("conversationHistory", history);
                CreateCbtRequest request = saveCbtFromSummary(summary, email, emotion);
                if (request != null) {
                    Long diaryId = cbtService.createCbt(request); // ID를 반환하는 메서드로 변경
                    return String.valueOf(diaryId);
                }
                return "종료되었습니다."; // 이건 위에서 생성된 summary
            }

            history.add("요약: " + summary);

            if (/* 감정 왜곡 감지 */ true) {
                String cognitiveDistortionList = String.join(", ", DistortionType.getAllDistortions());
                prompt = IDENTIFY_DISTORTION_PROMPT_TEMPLATE.replace("{사용자가 기록한 생각}", summary)
                        .replace("{마지막 메시지}", userMessage)
                        .replace("{cognitiveDistortionList}", cognitiveDistortionList);
            } else {
                prompt = "사용자님의 이야기에 공감하며, 더 자세히 이야기해 주시겠어요?";
            }
        }

        String finalPrompt = prompt + "\n사용자 메시지: " + userMessage;

        // Gemini 응답 받기
        String response = vertexAiGeminiChatModel.call(finalPrompt);

        // 사용자 입력을 sessionData에 저장
        List<String> history = (List<String>) sessionData.getOrDefault("conversationHistory", new ArrayList<>());
        history.add("사용자: " + userMessage);
        history.add("상담사: " + response);
        sessionData.put("conversationHistory", history);

        return response;
    }

    public CreateCbtRequest saveCbtFromSummary(String summary, String email, EmotionType emotion) throws JsonProcessingException {
        try {
            String diaryPrompt = String.format("""
                    다음 요약을 바탕으로 아래 형식의 CBT 다이어리를 JSON 형태로 작성해 주세요.
                    - 'summation'은 사용자의 경험을 **한 문장으로 간결하게 요약**해 주세요. 예: "팀원에게 화를 내고 후회함"
                    단, distortions 항목은 반드시 아래 Enum 값 중에서만 선택하세요 (쉼표로 구분됨):
                    [BLACK_AND_WHITE_THINKING, OVERGENERALIZATION, MENTAL_FILTER, DISQUALIFYING_THE_POSITIVE, EMOTIONAL_REASONING, JUMPING_TO_CONCLUSIONS, MIND_READING, FORTUNE_TELLING, MAGNIFICATION, MINIMIZATION, PERSONALIZATION, SHOULD_STATEMENTS, LABELING, CONTROL_FALLACY, FALLACY_OF_FAIRNESS, BLAMING]

                    요약:
                    %s

                    {
                      "before_content": "...",
                      "after_content": "...",
                      "summation": "...",
                      "solution": "...",
                      "distortions": ["..."]
                    }
                    """, summary);

            String json = vertexAiGeminiChatModel.call(diaryPrompt);

            // 백틱 제거 및 JSON만 추출
            json = json.replaceAll("(?s)```json\\s*", "")
                    .replaceAll("(?s)```", "")
                    .trim();

            System.out.println("✅ Gemini 응답 (정제 후):\n" + json);

            ObjectMapper mapper = new ObjectMapper();
            CreateCbtRequest request = mapper.readValue(json, CreateCbtRequest.class);
            request.setEmail(email);
            request.setEmotion_type(emotion);
            return request;
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return null;
        }
    }
}

