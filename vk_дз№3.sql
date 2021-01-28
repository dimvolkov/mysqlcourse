-- MySQL Script generated by MySQL Workbench
-- Thu Jan 28 02:52:11 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema vk
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema vk
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `vk` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `vk` ;

-- -----------------------------------------------------
-- Table `vk`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(145) NOT NULL,
  `phone` BIGINT(12) NOT NULL,
  `password_hash` CHAR(65) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`media_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`media_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`media` (
  `id` INT NOT NULL,
  `media_types_id` INT UNSIGNED NOT NULL,
  `users_id` INT UNSIGNED NULL DEFAULT NULL,
  `file` VARCHAR(45) NULL DEFAULT NULL COMMENT '/folder/file.jpg\n',
  `blob` BLOB NULL DEFAULT NULL,
  `metadata` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_media_media_types1_idx` (`media_types_id` ASC) VISIBLE,
  INDEX `fk_media_users1_idx` (`users_id` ASC) VISIBLE,
  CONSTRAINT `fk_media_media_types1`
    FOREIGN KEY (`media_types_id`)
    REFERENCES `vk`.`media_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`profiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`profiles` (
  `users_id` INT UNSIGNED NOT NULL,
  `firstname` VARCHAR(145) NOT NULL,
  `lastname` VARCHAR(145) NOT NULL,
  `gender` ENUM('m', 'f', 'x') NOT NULL,
  `birthday` DATE NOT NULL,
  `address` VARCHAR(245) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `photo_id` INT NULL DEFAULT NULL,
  INDEX `fk_profiles_users_idx` (`users_id` ASC) VISIBLE,
  PRIMARY KEY (`users_id`),
  INDEX `fk_profiles_media1_idx` (`photo_id` ASC) VISIBLE,
  CONSTRAINT `fk_profiles_users`
    FOREIGN KEY (`users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_profiles_media1`
    FOREIGN KEY (`photo_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`messages` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_users_id` INT UNSIGNED NOT NULL,
  `to_users_id` INT UNSIGNED NOT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `read_at` DATETIME NULL DEFAULT NULL,
  `media_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_messages_users1_idx` (`from_users_id` ASC) VISIBLE,
  INDEX `fk_messages_users2_idx` (`to_users_id` ASC) VISIBLE,
  INDEX `fk_messages_media1_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `fk_messages_users1`
    FOREIGN KEY (`from_users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_messages_users2`
    FOREIGN KEY (`to_users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_messages_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`friend_requests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`friend_requests` (
  `from_users_id` INT UNSIGNED NOT NULL,
  `to_users_id` INT UNSIGNED NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '-1 - отклонен\n0 - запрос\n1 - принят',
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  INDEX `fk_friend_requests_users1_idx` (`from_users_id` ASC) VISIBLE,
  INDEX `fk_friend_requests_users2_idx` (`to_users_id` ASC) VISIBLE,
  PRIMARY KEY (`from_users_id`, `to_users_id`),
  CONSTRAINT `fk_friend_requests_users1`
    FOREIGN KEY (`from_users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_friend_requests_users2`
    FOREIGN KEY (`to_users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`communities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`communities` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `desc` VARCHAR(245) NULL DEFAULT NULL,
  `admin_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_communities_users1_idx` (`admin_id` ASC) VISIBLE,
  CONSTRAINT `fk_communities_users1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`users_communities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`users_communities` (
  `communities_id` INT UNSIGNED NOT NULL,
  `users_id` INT UNSIGNED NOT NULL,
  INDEX `fk_users_communities_communities1_idx` (`communities_id` ASC) VISIBLE,
  INDEX `fk_users_communities_users1_idx` (`users_id` ASC) VISIBLE,
  PRIMARY KEY (`communities_id`, `users_id`),
  CONSTRAINT `fk_users_communities_communities1`
    FOREIGN KEY (`communities_id`)
    REFERENCES `vk`.`communities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_communities_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`posts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `posts_id` INT UNSIGNED NULL DEFAULT NULL,
  `users_id` INT UNSIGNED NOT NULL,
  `communities_id` INT UNSIGNED NULL DEFAULT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `media_id` INT NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `fk_posts_users1_idx` (`users_id` ASC) VISIBLE,
  INDEX `fk_posts_communities1_idx` (`communities_id` ASC) VISIBLE,
  INDEX `fk_posts_media1_idx` (`media_id` ASC) VISIBLE,
  INDEX `fk_posts_posts1_idx` (`posts_id` ASC) VISIBLE,
  CONSTRAINT `fk_posts_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_posts_communities1`
    FOREIGN KEY (`communities_id`)
    REFERENCES `vk`.`communities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_posts_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_posts_posts1`
    FOREIGN KEY (`posts_id`)
    REFERENCES `vk`.`posts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vk`.`likes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vk`.`likes` (
  `users_id` INT UNSIGNED NOT NULL,
  `like_type` ENUM("smile", "pitty", "angry") NOT NULL,
  `like_date` DATETIME NOT NULL DEFAULT now (),
  `posts_id` INT UNSIGNED NOT NULL,
  `media_id` INT NOT NULL,
  INDEX `fk_likes_users1_idx` (`users_id` ASC) VISIBLE,
  INDEX `fk_likes_posts1_idx` (`posts_id` ASC) VISIBLE,
  INDEX `fk_likes_media1_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `fk_likes_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `vk`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_likes_posts1`
    FOREIGN KEY (`posts_id`)
    REFERENCES `vk`.`posts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_likes_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
