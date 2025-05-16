package com.example.mind_laundromat.cbt.service;

import com.example.mind_laundromat.cbt.dto.*;
import com.example.mind_laundromat.cbt.entity.*;
import com.example.mind_laundromat.cbt.repository.*;
import com.example.mind_laundromat.user.entity.User;
import com.example.mind_laundromat.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.time.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Log4j2
@RequiredArgsConstructor
@Transactional
public class CbtService {

    private final DiaryRepository diaryRepository;
    private final UserRepository userRepository;
    private final EmotionRepository emotionRepository;
    private final FeedbackRepository feedbackRepository;
    private final DistortionRepository distortionRepository;
    private final DiaryDistortionRepository diaryDistortionRepository;


    // CREATE CBT
    @Transactional
    public Long createCbt(CreateCbtRequest createCbtRequest) {

        // 1. User 정보 확인
        User user = userRepository.findByEmail(createCbtRequest.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저입니다."));

        // 2. Diary 저장
        Diary diary = Diary.builder()
                .user(user)
                .before_content(createCbtRequest.getBefore_content())
                .after_content(createCbtRequest.getAfter_content())
                .build();
        Diary saveDiary = diaryRepository.save(diary);

        // 3. Emotion 저장
        Emotion emotion = Emotion.builder()
                .emotion_type(createCbtRequest.getEmotion_type())
                .build();
        Emotion saveEmotion = emotionRepository.save(emotion);

        // 4. Feedback 저장
        Feedback feedback = Feedback.builder()
                .summation(createCbtRequest.getSummation())
                .solution(createCbtRequest.getSolution())
                .build();
        Feedback saveFeedback = feedbackRepository.save(feedback);

        // 5. Diary에 Emotion, Feedback 연결
        saveDiary.setEmotion(saveEmotion);
        saveDiary.setFeedback(saveFeedback);

        saveDiary.setDiaryDistortions(new ArrayList<>());
        System.out.println(saveDiary.getDiaryDistortions());

        // 6.
        for (DistortionType distortionType : createCbtRequest.getDistortions()) {
            Distortion distortion = distortionRepository.findByDistortionType(distortionType)
                    .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 인지 왜곡 유형입니다: " + distortionType));

            DiaryDistortion diaryDistortion = new DiaryDistortion();
            diaryDistortion.setDiary(saveDiary);
            diaryDistortion.setDistortion(distortion);
            DiaryDistortion saveDiaryDistortion = diaryDistortionRepository.save(diaryDistortion);

            saveDiary.getDiaryDistortions().add(saveDiaryDistortion);
        }

        diaryRepository.save(saveDiary);

        return saveDiary.getDiary_id();
    }

    // SELECT CBT
    public SelectCbtResponse selectCbt(Long diary_id) {

        // 1. Diary 정보 가져오기
        Diary diary = diaryRepository.findById(diary_id)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 기록입니다."));

        // 2. dto 변환
        return SelectCbtResponse.builder()
                .user_id(diary.getUser().getUserId())
                .diary_id(diary.getDiary_id())
                .before_content(diary.getBefore_content())
                .after_content(diary.getAfter_content())
                .regDate(diary.getRegDate())
                .modDate(diary.getModDate())
                .emotion_type(diary.getEmotion().getEmotion_type())
                .summation(diary.getFeedback().getSummation())
                .solution(diary.getFeedback().getSolution())
                .distortion_type(
                        diary.getDiaryDistortions().stream()
                                .map(dd -> dd.getDistortion().getDistortionType())
                                .collect(Collectors.toList())
                )
                .build();
    }

    // SELECT CBT List
    public List<SelectCbtResponse> selectCbtList(SelectCbtListRequest selectCbtListRequest) {

        // 1. 타임존이 null일 경우 기본값 설정 (예: UTC)
        String timezone = Optional.ofNullable(selectCbtListRequest.getTimezone()).orElse("UTC");
        ZoneId userZoneId = ZoneId.of(timezone);

        // 2. 사용자의 날짜 기준 하루의 시작과 끝 (타임존 포함)
        LocalDate userLocalDate = selectCbtListRequest.getLocalDate();

        ZonedDateTime startZdt = userLocalDate.atStartOfDay(userZoneId);  // 00:00:00
        ZonedDateTime endZdt = userLocalDate.atTime(LocalTime.MAX).atZone(userZoneId); // 23:59:59.999999999

        // 3. UTC 기준 시간으로 변환
        LocalDateTime utcStart = startZdt.withZoneSameInstant(ZoneOffset.UTC).toLocalDateTime();
        LocalDateTime utcEnd = endZdt.withZoneSameInstant(ZoneOffset.UTC).toLocalDateTime();

        // 4. 해당 범위의 다이어리 조회 (DB는 UTC 기준으로 저장된 regDate 사용)
        List<Diary> diaries = diaryRepository.findByUserEmailAndRegDateBetween(
                selectCbtListRequest.getEmail(), utcStart, utcEnd
        );

        // 5. 변환
        return diaries.stream()
                .map(SelectCbtResponse::new)
                .collect(Collectors.toList());
    }

    // SELECT CBT DATE
    public List<LocalDate> selectCbtDateList(SelectCbtListRequest selectCbtListRequest) {

        LocalDate localDate = selectCbtListRequest.getLocalDate();
        String timezone = selectCbtListRequest.getTimezone(); // ex: "Asia/Seoul"

        ZoneId userZoneId = ZoneId.of(timezone);

        // 해당 달의 첫날 00:00:00 (사용자 로컬 기준)
        ZonedDateTime startZdt = localDate.withDayOfMonth(1).atStartOfDay(userZoneId);

        // 해당 달의 마지막날 23:59:59.999 (사용자 로컬 기준)
        LocalDate lastDay = localDate.withDayOfMonth(localDate.lengthOfMonth());
        ZonedDateTime endZdt = lastDay.atTime(LocalTime.MAX).atZone(userZoneId);

        // UTC 기준으로 변환
        LocalDateTime utcStart = startZdt.withZoneSameInstant(ZoneOffset.UTC).toLocalDateTime();
        LocalDateTime utcEnd = endZdt.withZoneSameInstant(ZoneOffset.UTC).toLocalDateTime();

        // 다이어리 조회 (regDate는 UTC로 저장되었음)
        List<Diary> diaries = diaryRepository.findByUserEmailAndRegDateBetween(
                selectCbtListRequest.getEmail(), utcStart, utcEnd
        );

        return diaries.stream()
                .map(diary -> diary.getRegDate().atZone(ZoneOffset.UTC).withZoneSameInstant(userZoneId).toLocalDate())
                .distinct()
                .sorted()
                .toList();
    }


    // DELETE CBT
    public void deleteCbt(Long diary_id) {

        // 1. Diary 정보 가져오기
        Diary diary = diaryRepository.findById(diary_id)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 기록입니다."));

        // 2. 삭제
        diaryRepository.delete(diary);
    }

    // Distortion count
    public DistortionListRequest sortDistortion(String email) {
        Long user_id = userRepository.selectIdByEmail(email);

        return DistortionListRequest.builder()
                .distortionList(diaryRepository.sortDistortion(user_id))
                .total(diaryDistortionRepository.countDiaryDistortionByDiary_User_UserId(user_id))
                .build();
    }
}
