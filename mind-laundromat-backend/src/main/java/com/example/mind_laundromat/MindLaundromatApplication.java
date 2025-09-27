package com.example.mind_laundromat;

import com.example.mind_laundromat.cbt.entity.Distortion;
import com.example.mind_laundromat.cbt.entity.DistortionType;
import com.example.mind_laundromat.cbt.entity.Emotion;
import com.example.mind_laundromat.cbt.entity.EmotionType;
import com.example.mind_laundromat.cbt.repository.DistortionRepository;
import com.example.mind_laundromat.cbt.repository.EmotionRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

import java.util.Arrays;
import java.util.TimeZone;

@SpringBootApplication
@EnableJpaAuditing
public class MindLaundromatApplication {

	public static void main(String[] args) {
		SpringApplication.run(MindLaundromatApplication.class, args);
	}

	@PostConstruct
	public void init(){
		// Setting Spring Boot SetTimeZone
		TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
	}

	@Bean
	public CommandLineRunner initDistortions(DistortionRepository distortionRepository) {
		return args -> {
			if (distortionRepository.count() == 0) { // 중복 저장 방지
				Arrays.stream(DistortionType.values()).forEach(type ->
						distortionRepository.save(
								Distortion.builder()
										.distortionType(type)
										.build()
						)
				);
			}
		};
	}

	@Bean
	public CommandLineRunner initEmotions(EmotionRepository emotionRepository) {
		return args -> {
			if (emotionRepository.count() == 0) { // 중복 저장 방지
				Arrays.stream(EmotionType.values()).forEach(type ->
						emotionRepository.save(
								Emotion.builder()
										.emotion_type(type)
										.build()
						)
				);
			}
		};
	}

}
