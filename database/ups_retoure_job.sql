-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: dedi3453.your-server.de
-- Erstellungszeit: 18. Dez 2025 um 14:01
-- Server-Version: 10.11.14-MariaDB-0+deb12u2
-- PHP-Version: 8.5.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `wwwrau_db1`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tx_ups_retoure_job`
--

CREATE TABLE `tx_ups_retoure_job` (
  `uid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT 0,
  `tstamp` int(11) NOT NULL DEFAULT 0,
  `crdate` int(11) NOT NULL DEFAULT 0,
  `cruser_id` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(4) NOT NULL DEFAULT 0,
  `hidden` tinyint(4) NOT NULL DEFAULT 0,
  `company` tinytext DEFAULT NULL,
  `address` tinytext DEFAULT NULL,
  `postcode` tinytext DEFAULT NULL,
  `city` tinytext DEFAULT NULL,
  `country` tinytext DEFAULT NULL,
  `gender` tinytext DEFAULT NULL,
  `lastname` tinytext DEFAULT NULL,
  `phone` tinytext DEFAULT NULL,
  `email` tinytext DEFAULT NULL,
  `pickup_date` tinytext DEFAULT NULL,
  `ready_time` tinytext DEFAULT NULL,
  `close_time` tinytext DEFAULT NULL,
  `tracking_number_1` tinytext DEFAULT NULL,
  `tracking_number_2` tinytext DEFAULT NULL,
  `tracking_number_3` tinytext DEFAULT NULL,
  `tracking_number_4` tinytext DEFAULT NULL,
  `gender_text` tinytext DEFAULT NULL,
  `close_time_ups` tinytext DEFAULT NULL,
  `ready_time_ups` tinytext DEFAULT NULL,
  `pickup_date_ups` tinytext DEFAULT NULL,
  `pickup_number` tinytext DEFAULT NULL,
  `response_status` tinytext DEFAULT NULL,
  `closed` tinytext DEFAULT NULL,
  `error` tinytext DEFAULT NULL,
  `error_description` tinytext DEFAULT NULL,
  `transfered` tinyint(3) NOT NULL DEFAULT 0,
  `order_timestamp` varchar(255) NOT NULL DEFAULT '0',
  `response_information` tinytext DEFAULT NULL,
  `secure` varchar(255) NOT NULL,
  `timestamp_e18d30b5f7` tinytext DEFAULT NULL,
  `return_reason` tinytext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `tx_ups_retoure_job`
--
ALTER TABLE `tx_ups_retoure_job`
  ADD PRIMARY KEY (`uid`),
  ADD KEY `parent` (`pid`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `tx_ups_retoure_job`
--
ALTER TABLE `tx_ups_retoure_job`
  MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
