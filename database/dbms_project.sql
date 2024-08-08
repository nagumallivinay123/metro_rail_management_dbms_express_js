-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 07, 2024 at 07:43 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbms_project`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_fare` (`low_station` INT, `high_station` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total_distance INT DEFAULT 0;
    DECLARE current_station INT;
    DECLARE next_station INT;
    DECLARE station_distance INT;
    DECLARE done INT DEFAULT 0;
    DECLARE base_fare DECIMAL(10, 2) DEFAULT 10.00; -- base fare
    DECLARE additional_fare DECIMAL(10, 2) DEFAULT 2.00; -- additional fare for every extra distance unit
    DECLARE cur CURSOR FOR 
        SELECT `fare`.`form_id`, `fare`.`to_id`, `fare`.`distance`
        FROM `fare`
        WHERE `fare`.`form_id` >= low_station AND `fare`.`distance` <= high_station;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET current_station = low_station;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO current_station, next_station, station_distance;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET total_distance = total_distance + station_distance;
        SET current_station = next_station;
    END LOOP;

    CLOSE cur;

    IF total_distance <= 8 THEN
        RETURN base_fare;
    ELSE
        RETURN base_fare + (total_distance - 8) * additional_fare;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `fare`
--

CREATE TABLE `fare` (
  `form_id` int(11) NOT NULL,
  `to_id` int(11) NOT NULL,
  `distance` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fare`
--

INSERT INTO `fare` (`form_id`, `to_id`, `distance`) VALUES
(1, 2, 2),
(2, 3, 3),
(3, 4, 1),
(4, 5, 2),
(5, 6, 3),
(6, 7, 2),
(7, 8, 4),
(8, 9, 1),
(9, 10, 2),
(10, 11, 3),
(11, 12, 2),
(12, 13, 1),
(13, 14, 3),
(14, 15, 2);

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `feedback_type` text NOT NULL,
  `name` text NOT NULL,
  `email` text NOT NULL,
  `mobile_number` text NOT NULL,
  `comments` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `passenger`
--

CREATE TABLE `passenger` (
  `passenger_id` int(11) NOT NULL,
  `first_name` text NOT NULL,
  `last_name` text NOT NULL,
  `email` text NOT NULL,
  `phone_number` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sign_up_details`
--

CREATE TABLE `sign_up_details` (
  `id` int(11) NOT NULL,
  `first_name` text NOT NULL,
  `last_name` text NOT NULL,
  `mobile_number` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stations`
--

CREATE TABLE `stations` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stations`
--

INSERT INTO `stations` (`id`, `name`) VALUES
(1, 'none'),
(2, 'Miyapur'),
(3, 'JNTU College'),
(4, 'KPHB Colony'),
(5, 'Kukatpally'),
(6, 'Balanagar'),
(7, 'Moosapet'),
(8, 'Bharat Nagar'),
(9, 'Erragadda'),
(10, 'ESI Hospital'),
(11, 'S.R. Nagar'),
(12, 'Ameerpet'),
(13, 'Madhura Nagar'),
(14, 'Yusufguda'),
(15, 'Road No. 5 Jubilee Hills'),
(16, 'Jubilee Hills Checkpost');

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `ticket_id` int(11) NOT NULL,
  `passenger_id` int(11) NOT NULL,
  `train_id` int(11) NOT NULL,
  `source_station_id` int(11) NOT NULL,
  `destination_station_id` int(11) NOT NULL,
  `booked_date` date NOT NULL,
  `fare` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `passenger`
--
ALTER TABLE `passenger`
  ADD PRIMARY KEY (`passenger_id`);

--
-- Indexes for table `sign_up_details`
--
ALTER TABLE `sign_up_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stations`
--
ALTER TABLE `stations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `passenger`
--
ALTER TABLE `passenger`
  MODIFY `passenger_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sign_up_details`
--
ALTER TABLE `sign_up_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stations`
--
ALTER TABLE `stations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
