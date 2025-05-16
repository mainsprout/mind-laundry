package com.example.mind_laundromat.user.repository;

import com.example.mind_laundromat.cbt.entity.EmotionType;
import com.example.mind_laundromat.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    void deleteByEmail(String email);

    @Query("SELECT u.userId FROM User u WHERE u.email = :email")
    Long selectIdByEmail(@Param("email") String email);

    @Modifying
    @Query("UPDATE User u SET u.first_name = :first_name, u.last_name = :last_name WHERE u.userId = :userId")
    int updateUserName(@Param("userId") Long userId, @Param("first_name") String first_name, @Param("last_name") String last_name);

    @Modifying
    @Query("UPDATE User u SET u.profile_emotion = :profile_emotion WHERE u.userId = :userId")
    int updateProfileEmotion(@Param("userId") Long userId, @Param("profile_emotion") EmotionType profile_emotion);
}
