-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2019 at 09:46 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `volleyboard`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `callIDNum` (IN `idnum` VARCHAR(225))  begin
select getIDNum(idnum);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetchWinLose` (IN `Team` VARCHAR(10), IN `TourID` INT, IN `Rnd` INT)  begin
select Team_ID,(Select count(*) from match_up where WinLoseStatus_ID = 'W' AND Team_ID = Team AND Tournament_ID = TourID AND Round_ID=Rnd) AS WIN from match_up Where Team_ID = Team Group by Team_ID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCoach` (IN `coachname` VARCHAR(150))  begin
select getCoachID(coachname);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMatchLose` (IN `ID` INT(8), IN `TEAM` VARCHAR(10))  begin
(Select count(*) from matchup_set where (Match_ID = ID AND Team_ID = TEAM AND WinLoseStatus_ID = 'L'));
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMatchWin` (IN `ID` INT(8), IN `TEAM` VARCHAR(10))  begin
(Select count(*) from matchup_set where (Match_ID = ID AND Team_ID = TEAM AND WinLoseStatus_ID = 'W'));
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `StandingView` (IN `Team` VARCHAR(10), IN `TourID` INT, IN `Rnd` INT)  begin
select Team_ID,(Select count(*) from match_up where WinLoseStatus_ID = 'W' AND Team_ID = Team AND Tournament_ID = TourID AND Round_ID=Rnd) AS WIN, (Select count(*) from match_up where WinLoseStatus_ID = 'L' AND Team_ID = Team AND Tournament_ID = TourID AND Round_ID = Rnd) AS LOSE from match_up WHERE Team_ID = Team GROUP BY Team_ID;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `StandingWinLoseView` (IN `TourID` INT, IN `Rnd` INT)  begin
declare done int default 0;
declare current_Team varchar (10);
declare dteamcur cursor for select Team_ID from match_up;
declare continue handler for not found set done = 1;
open dteamcur;
repeat
fetch dteamcur into current_Team;

Call fetchWinLose (current_Team,TourID,Rnd);

until done
end repeat;
close dteamcur;
end$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getCoachID` (`coachname` VARCHAR(150)) RETURNS INT(11) begin
declare coachid int (4);
set coachid = (select Coach_ID from coach where (select concat (Coach_Fname,Coach_Lname)) = coachname);
return coachid;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getIDNum` (`tour_name` VARCHAR(225)) RETURNS INT(11) begin
declare idnum int (10);
set idnum = (select Tournament_ID from tournament where Tournament_Name = tour_name);
return idnum;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getWin` (`Team` VARCHAR(10), `TourID` INT, `RoundID` INT) RETURNS INT(11) begin
declare win int;
set win = (select count(*) from match_up where (WinLoseStatus_ID = 'W' AND Team_ID = Team AND Tournament_ID = TourID AND Round_ID= RoundID) GROUP BY Team_ID);
return win;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `LoseCount` (`M_ID` INT, `Team` VARCHAR(10)) RETURNS INT(1) begin
declare win int(1);
set win = 'Call getMatchLose (M_ID,Team)';
return (win);
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `WinCount` (`M_ID` INT, `Team` VARCHAR(10)) RETURNS INT(1) begin
declare win int (1);
set win = 'Call getMatchWin(M_ID,Team)';
return (win);
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `coach`
--

CREATE TABLE `coach` (
  `Coach_ID` int(4) NOT NULL,
  `Coach_Fname` varchar(50) NOT NULL,
  `Coach_Lname` varchar(50) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Career_Started` date NOT NULL,
  `Contact_Number` varchar(20) NOT NULL,
  `Address` varchar(225) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `coach`
--

INSERT INTO `coach` (`Coach_ID`, `Coach_Fname`, `Coach_Lname`, `DateOfBirth`, `Career_Started`, `Contact_Number`, `Address`) VALUES
(1, 'Mark', 'Bueno', '1990-09-01', '2018-08-02', '097728819371', 'Laak, Comval'),
(2, 'Jake', 'Lawas', '1991-01-01', '2018-06-20', '09267725341', 'Asuncion, Davao del Norte'),
(3, 'Rex', 'Otero', '1989-10-03', '2019-03-06', '091778492731', 'Samal, Davao del Norte'),
(4, 'Ritchie', 'Cabangon', '1985-04-03', '2018-05-01', '09208877452', 'M\'lang North Cotabato'),
(5, 'Steve', 'Kerr', '1973-05-01', '1973-05-01', '09108829372', 'Oracle Arena'),
(6, 'Domingo', 'Custudio', '1975-02-05', '2013-05-20', '092088728381', 'Cubao, Manila'),
(7, 'Airess', 'Padda', '1990-05-20', '2000-09-06', '091088374763', 'Manila'),
(8, 'Oliver ', 'Almadro', '1982-11-20', '2001-12-05', '092877644721', 'Manila Ph.'),
(9, 'Arnold ', 'Laniog', '1964-05-20', '2009-05-20', '09872937192', 'Diliman');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `Username` varchar(15) NOT NULL,
  `Password` varchar(225) NOT NULL,
  `Email_Add` varchar(30) NOT NULL,
  `Status_ID` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`Username`, `Password`, `Email_Add`, `Status_ID`) VALUES
('admin', 'i/mmsWL4X6Q=', 'thisistest@gmail.com', 1),
('kristinevarona', '8TLWaic/gcZW5tj', 'kristine@gmail.com', 1),
('kvarona', 'yZt9Ud9PUXdW5tjL4LjYGw==', 'kimvarona.acads@gmail.com', 1),
('login', 'YdHdb33TWuZW5tjL4LjYGw==', 'loginpassword@gmail.com', 1),
('test', 'YdHdb33TWuaRM0De4Ytv7g==', 'test@gmail.com', 1),
('testaccount', 'YdHdb33TWuZW5tjL4LjYGw==', 'testaccount@gmail.com', 1);

--
-- Triggers `login`
--
DELIMITER $$
CREATE TRIGGER `after_insertcred` AFTER INSERT ON `login` FOR EACH ROW begin
insert into password_tracking
set Username = NEW.Username,
Password = NEW.Password,
Email_Add = NEW.Email_Add,
Date_Changed = (SELECT CURDATE()); 
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_passwordchanged` AFTER UPDATE ON `login` FOR EACH ROW begin
insert into password_tracking
SET Username = OLD.Username,
Password = NEW.Password,
Email_Add = NEW.Email_Add,
Date_Changed = (Select CURDATE());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `loginview`
-- (See below for the actual view)
--
CREATE TABLE `loginview` (
`Username` varchar(15)
,`Email_Add` varchar(30)
,`Status_Description` varchar(150)
);

-- --------------------------------------------------------

--
-- Table structure for table `matchup_info`
--

CREATE TABLE `matchup_info` (
  `Matchupinfo_ID` int(8) NOT NULL,
  `Match_Date` date NOT NULL,
  `Match_Time` time NOT NULL,
  `Location` varchar(225) NOT NULL,
  `NumberOfSets` int(1) NOT NULL,
  `Referee1` varchar(100) NOT NULL,
  `Referee2` varchar(100) NOT NULL,
  `LineMan1` varchar(100) NOT NULL,
  `LineMan2` varchar(100) NOT NULL,
  `ScoreKeeper` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `matchup_info`
--

INSERT INTO `matchup_info` (`Matchupinfo_ID`, `Match_Date`, `Match_Time`, `Location`, `NumberOfSets`, `Referee1`, `Referee2`, `LineMan1`, `LineMan2`, `ScoreKeeper`) VALUES
(1, '2019-05-17', '10:49:26', 'Bangkal, Davao City', 3, 'Kim Varona', 'Michael Jackson', 'Michael Jordan', 'Michael Buble', 'Michael Angelo'),
(2, '2019-05-17', '11:14:22', 'Ateneo Gym', 5, 'Steve Mark Tionco', 'Rafael Donatelo', 'Donald Trump', 'Rody Duterte', 'Bam Aquino'),
(3, '2019-05-17', '02:21:28', 'Moa Arena', 5, 'Kim Varona', 'Phil Jackson', 'Michael Jackson', 'Peter Pan', 'Peter Parker'),
(4, '2019-05-20', '07:55:05', 'MOA Arena', 5, 'Steve Mark Ghan', 'Roider Birondo', 'Statue Liberty', 'Roland Daquipil', 'Rex Otero'),
(5, '2019-05-21', '12:34:10', 'Bangkal Gym', 3, 'Rody Duterte', 'Sarah Duterte', 'Baste Duterte', 'Pulong Duterte', 'Kitty Duterte'),
(6, '2019-05-21', '03:28:26', 'MOA ARENA', 5, 'Kim Varona', 'Rody Duterte', 'Kitty Duterte', 'Flor Duran', 'Kimmy Ko');

-- --------------------------------------------------------

--
-- Table structure for table `matchup_set`
--

CREATE TABLE `matchup_set` (
  `Match_ID` int(8) NOT NULL,
  `Team_ID` varchar(10) NOT NULL,
  `Set_Number` int(1) NOT NULL,
  `Score` int(2) NOT NULL,
  `WinLoseStatus_ID` enum('W','L','P','') NOT NULL DEFAULT 'P'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `matchup_set`
--

INSERT INTO `matchup_set` (`Match_ID`, `Team_ID`, `Set_Number`, `Score`, `WinLoseStatus_ID`) VALUES
(2, 'Ateneo', 1, 18, 'L'),
(2, 'Ateneo', 2, 25, 'W'),
(2, 'Ateneo', 3, 25, 'W'),
(2, 'Ateneo', 4, 21, 'L'),
(2, 'Ateneo', 5, 17, 'L'),
(2, 'UST', 1, 25, 'W'),
(2, 'UST', 2, 23, 'L'),
(2, 'UST', 3, 23, 'L'),
(2, 'UST', 4, 25, 'W'),
(2, 'UST', 5, 19, 'W'),
(3, 'NU', 1, 15, 'L'),
(3, 'NU', 2, 25, 'L'),
(3, 'NU', 3, 8, 'L'),
(3, 'UP', 1, 25, 'W'),
(3, 'UP', 2, 27, 'W'),
(3, 'UP', 3, 25, 'W'),
(4, 'NU', 1, 25, 'W'),
(4, 'NU', 2, 24, 'L'),
(4, 'NU', 3, 23, 'L'),
(4, 'NU', 4, 23, 'L'),
(4, 'UST', 1, 22, 'L'),
(4, 'UST', 2, 26, 'W'),
(4, 'UST', 3, 25, 'W'),
(4, 'UST', 4, 25, 'W'),
(5, 'Ateneo', 1, 23, 'L'),
(5, 'Ateneo', 2, 22, 'L'),
(5, 'NU', 1, 25, 'W'),
(5, 'NU', 2, 25, 'W'),
(6, 'NU', 1, 24, 'L'),
(6, 'NU', 2, 23, 'L'),
(6, 'NU', 3, 21, 'L'),
(6, 'UP', 1, 26, 'W'),
(6, 'UP', 2, 25, 'W'),
(6, 'UP', 3, 25, 'W');

--
-- Triggers `matchup_set`
--
DELIMITER $$
CREATE TRIGGER `after_matchupset_update` AFTER UPDATE ON `matchup_set` FOR EACH ROW begin

DECLARE setwin int (1);
DECLARE setlose int (1);

set setlose =  (SELECT COUNT(*) from matchup_set where (Match_ID = OLD.Match_ID AND Team_ID = OLD.Team_ID AND WinLoseStatus_ID = 'L'));
set setwin = (SELECT COUNT(*) from matchup_set where (Match_ID = OLD.Match_ID AND Team_ID = OLD.Team_ID AND WinLoseStatus_ID = 'W'));


update match_up set Set_Win = setwin , Set_Lose = setlose WHERE (Match_ID = OLD.Match_ID AND Team_ID = OLD.Team_ID);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `match_up`
--

CREATE TABLE `match_up` (
  `Match_ID` int(8) NOT NULL,
  `Round_ID` int(2) NOT NULL,
  `Tournament_ID` int(6) NOT NULL,
  `Team_ID` varchar(10) NOT NULL,
  `MatchInfo_ID` int(8) NOT NULL,
  `Set_Win` int(1) NOT NULL,
  `Set_Lose` int(1) NOT NULL,
  `WinLoseStatus_ID` enum('W','L','P','') NOT NULL DEFAULT 'P'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `match_up`
--

INSERT INTO `match_up` (`Match_ID`, `Round_ID`, `Tournament_ID`, `Team_ID`, `MatchInfo_ID`, `Set_Win`, `Set_Lose`, `WinLoseStatus_ID`) VALUES
(2, 1, 19, 'Ateneo', 2, 2, 3, 'L'),
(2, 1, 19, 'UST', 2, 3, 2, 'W'),
(3, 1, 19, 'NU', 3, 0, 3, 'L'),
(3, 1, 19, 'UP', 3, 3, 0, 'W'),
(4, 1, 19, 'NU', 4, 1, 3, 'L'),
(4, 1, 19, 'UST', 4, 3, 1, 'W'),
(5, 1, 19, 'Ateneo', 5, 0, 2, 'L'),
(5, 1, 19, 'NU', 5, 2, 0, 'W'),
(6, 1, 19, 'NU', 6, 0, 3, 'L'),
(6, 1, 19, 'UP', 6, 3, 0, 'W');

-- --------------------------------------------------------

--
-- Table structure for table `password_tracking`
--

CREATE TABLE `password_tracking` (
  `Username` varchar(20) NOT NULL,
  `Password` varchar(225) NOT NULL,
  `Email_Add` varchar(50) NOT NULL,
  `Date_Changed` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `password_tracking`
--

INSERT INTO `password_tracking` (`Username`, `Password`, `Email_Add`, `Date_Changed`) VALUES
('', '', '', '2019-05-16'),
('test', 'YdHdb33TWuZW5tjL4LjYGw==', 'test@gmail.com', '2019-05-16'),
('test', 'i/mmsWL4X6Q=', 'test@gmail.com', '2019-05-16'),
('test', 'YdHdb33TWuaRM0De4Ytv7g==', 'test@gmail.com', '2019-05-20');

-- --------------------------------------------------------

--
-- Table structure for table `player`
--

CREATE TABLE `player` (
  `Player_ID` int(6) NOT NULL,
  `Jersey_ID` int(2) NOT NULL,
  `Player_Fname` varchar(50) NOT NULL,
  `Player_Lname` varchar(50) NOT NULL,
  `Player_Type` int(1) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Contact_Number` varchar(20) NOT NULL,
  `Address` varchar(225) NOT NULL,
  `Team_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `player`
--

INSERT INTO `player` (`Player_ID`, `Jersey_ID`, `Player_Fname`, `Player_Lname`, `Player_Type`, `DateOfBirth`, `Contact_Number`, `Address`, `Team_ID`) VALUES
(1, 12, 'Gracelchen', 'Ave', 3, '1993-04-08', '09238491283', 'Malabon, Manila', 'UP'),
(2, 34, 'Princess Nina', 'Balang', 3, '1995-05-01', '09258823491', 'Antipolo, Rizal', 'UP'),
(3, 14, 'Mary Joy', 'Dacoron', 2, '1993-06-11', '09178829371', 'Cebu City', ''),
(4, 45, 'Stephen', 'Curry', 6, '1993-05-17', '093877239411', 'The Bay Area', ''),
(6, 15, 'Sisi', 'Rondina', 1, '2019-05-20', '098387182931', 'Cebu City', ''),
(7, 24, 'Bernadette A.', 'Flora', 1, '2019-05-20', '092837719281', 'Marilog District', ''),
(8, 23, 'Trisha Mae', 'Genesis', 5, '2019-05-20', '092839182731', 'Manila Power City', ''),
(9, 0, 'Mary Jane ', 'Igao', 1, '1993-04-29', '0928381919231', 'Cubao Luzon', ''),
(10, 87, 'Hannah Nicole', 'Infante', 1, '1993-05-20', '09882739182', 'Pangasinan', ''),
(11, 11, ' Lea-ann M.', 'Perez', 4, '1995-05-20', '0928379182', 'Glorietta', ''),
(12, 16, 'Chiara ', 'Permentilla', 7, '1996-07-20', '09283982731', 'Davao City', ''),
(13, 88, 'Ceasa Joria', 'Pinar', 8, '2019-10-15', '092837729371', 'Marikina', ''),
(14, 45, 'Nikka Sophia Ruth S', 'Yandoc', 1, '2019-05-20', '091928379421', 'Olongapo City', ''),
(15, 7, 'Isabel Beatriz P', 'De Leon', 7, '1995-05-02', '092082738191', 'Zamboanga City', '');

-- --------------------------------------------------------

--
-- Stand-in structure for view `playertoaddview`
-- (See below for the actual view)
--
CREATE TABLE `playertoaddview` (
`Player_ID` int(6)
,`Jersey_ID` int(2)
,`Player_Fname` varchar(50)
,`Player_Lname` varchar(50)
,`Type_Description` varchar(50)
,`DateOfBirth` date
,`Contact_Number` varchar(20)
,`Address` varchar(225)
,`Team_ID` varchar(10)
);

-- --------------------------------------------------------

--
-- Table structure for table `playertype`
--

CREATE TABLE `playertype` (
  `PlayerType_ID` int(1) NOT NULL,
  `Type_Description` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `playertype`
--

INSERT INTO `playertype` (`PlayerType_ID`, `Type_Description`) VALUES
(1, 'Captain'),
(2, 'Libero'),
(3, 'Member'),
(4, 'Setter'),
(5, 'Passer/Defender'),
(6, 'Server'),
(7, 'Setter'),
(8, 'Digger');

-- --------------------------------------------------------

--
-- Stand-in structure for view `playerview`
-- (See below for the actual view)
--
CREATE TABLE `playerview` (
`Player_ID` int(6)
,`Jersey_ID` int(2)
,`Player_Fname` varchar(50)
,`Player_Lname` varchar(50)
,`Type_Description` varchar(50)
,`DateOfBirth` date
,`Contact_Number` varchar(20)
,`Address` varchar(225)
);

-- --------------------------------------------------------

--
-- Table structure for table `player_stats`
--

CREATE TABLE `player_stats` (
  `Match_ID` int(8) NOT NULL,
  `Team_ID` varchar(10) NOT NULL,
  `Player_ID` int(6) NOT NULL,
  `Set_Number` int(1) NOT NULL,
  `Attack` int(3) NOT NULL,
  `Block` int(3) NOT NULL,
  `Service_Ace` int(3) NOT NULL,
  `Service_Error` int(3) NOT NULL,
  `Oppensive_Error` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `round`
--

CREATE TABLE `round` (
  `Round_ID` int(2) NOT NULL,
  `Round_Description` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `round`
--

INSERT INTO `round` (`Round_ID`, `Round_Description`) VALUES
(1, 'Elimination'),
(5, 'Friendly Game'),
(2, 'Playoffs'),
(3, 'Semi-Finals'),
(4, 'Volleyball Finals');

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

CREATE TABLE `team` (
  `Team_ID` varchar(10) NOT NULL,
  `Tournament_ID` int(6) NOT NULL,
  `Team_Name` varchar(150) NOT NULL,
  `Coach_ID` int(4) NOT NULL,
  `Address` varchar(225) NOT NULL,
  `Contact_Number` varchar(20) NOT NULL,
  `Email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `team`
--

INSERT INTO `team` (`Team_ID`, `Tournament_ID`, `Team_Name`, `Coach_ID`, `Address`, `Contact_Number`, `Email`) VALUES
('Adamson', 19, 'Adamson Lady Falcons', 3, '900 San Marcelino St., Manila, Metro Manila 1000', '09281283123', 'Adamson@gmail.com'),
('AdDU', 16, 'Ateneo de Davao University', 2, 'Roxas Avenue, Davao City', '09102239293', 'jake@gmail.com'),
('Ateneo', 19, 'Ateneo Lady Eagles', 2, 'Manila, Philippines', '09212349521', 'ateneo@gmail.com'),
('DLSU', 19, 'De La Salle Lady Spikers', 3, 'Manila Ph', '09235829102', 'dlsu@gmail.com'),
('FEU', 19, 'FEU Lady Tamaraw', 4, 'University Belt, Manila', '0923213481', 'FEU@gmail.com'),
('Guatem', 1, 'Guatemala', 2, 'Taga Guatemala Gani', '09227391729', 'guatemala@gmail.com'),
('NU', 19, 'NU Lady Bulldogs', 1, 'Quiapo, Manila', '09992382412', 'NationalU@gmail.com'),
('Opal', 8, 'Ateneo 3rd year Opal', 3, 'Mc-Arthur Highway, Matina Davao City', '09772668263', 'opalgangnamstyle@gmail.com'),
('Sapphire', 8, 'Ateneo 3rd year Sapphire', 1, 'Mc-Arthur Highway, Matina Davao City', '09283759123', 'Sapphirerocks@gmail.com'),
('UE', 1, 'UE Lady Red Warriors', 1, 'Malolos, Bulacan', '09438472138', 'UE@gmail.com'),
('UE', 19, 'UE Lady Red Warriors', 1, 'Glorietta, Manila', '09284759321', 'UE@gmail.com'),
('UMin', 1, 'University of Mindanao - VolleyBall', 3, 'Matina, Davao City', '09223451283', 'mark@gmail.com'),
('UMin', 16, 'University of Mindanao - Varsity', 1, 'Matina, Davao City', '09223451283', 'mark@gmail.com'),
('UP', 19, 'UP Lady Fighting Maroons', 1, 'Diliman', '091083484921', 'updiliman@gmail.com'),
('UST', 1, 'UST Golden Tigresses', 4, 'UST Field', '09279817394', 'UST@gmail.com'),
('UST', 19, 'UST Golden Tigresses', 1, 'UST Fields', '09279472812', 'UST@gmail.com');

-- --------------------------------------------------------

--
-- Stand-in structure for view `teamplayerview`
-- (See below for the actual view)
--
CREATE TABLE `teamplayerview` (
`Player_ID` int(6)
,`Jersey_ID` int(2)
,`Player_Fname` varchar(50)
,`Player_Lname` varchar(50)
,`Type_Description` varchar(50)
,`DateOfBirth` date
,`Contact_Number` varchar(20)
,`Address` varchar(225)
,`Team_ID` varchar(10)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `teamview`
-- (See below for the actual view)
--
CREATE TABLE `teamview` (
`Team_ID` varchar(10)
,`Tournament_Name` varchar(100)
,`Team_Name` varchar(150)
,`(select concat(coach.Coach_Fname," " ,coach.Coach_Lname))` varchar(101)
,`Address` varchar(225)
,`Contact_Number` varchar(20)
,`Email` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `team_detail`
--

CREATE TABLE `team_detail` (
  `Team_ID` varchar(10) NOT NULL,
  `Tournament_ID` int(6) NOT NULL,
  `Player_ID` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `team_detail`
--

INSERT INTO `team_detail` (`Team_ID`, `Tournament_ID`, `Player_ID`) VALUES
('UP', 19, 1),
('UP', 19, 2);

-- --------------------------------------------------------

--
-- Table structure for table `team_standing`
--

CREATE TABLE `team_standing` (
  `Team_ID` varchar(10) NOT NULL,
  `Tournament_ID` int(6) NOT NULL,
  `Round_ID` int(2) NOT NULL,
  `Win` int(3) NOT NULL,
  `Lose` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tournament`
--

CREATE TABLE `tournament` (
  `Tournament_ID` int(6) NOT NULL,
  `Tournament_Name` varchar(100) NOT NULL,
  `Start_Date` date NOT NULL,
  `End_Date` date NOT NULL,
  `Division` varchar(50) NOT NULL,
  `Status_ID` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tournament`
--

INSERT INTO `tournament` (`Tournament_ID`, `Tournament_Name`, `Start_Date`, `End_Date`, `Division`, `Status_ID`) VALUES
(1, '2019 Palarong Pambansa - Men Secondary', '2019-04-04', '2019-05-16', 'Men Secondary', 1),
(2, '2019 Palarong Pambansa - Women Secondary', '2019-04-01', '2019-05-31', 'Women Secondary', 1),
(3, '2019 Palarong Pambansa - Men Elementary', '2019-05-08', '2019-05-20', 'Men Elementary', 1),
(4, '2018 Palarong Pambansa - Men Secondary', '2019-02-01', '2019-05-01', 'Men Secondary', 2),
(5, '2018 Palarong Pambansa - Women Secondary', '2018-11-01', '2019-01-03', 'Women Secondary', 2),
(6, '2019 Palarong Pambata - Baby Edition', '2019-05-01', '2019-05-10', 'Infant', 1),
(7, '2019 Palarong Panglalaki - Boys Edition', '2019-05-02', '2019-05-13', 'Panglalaki lang jud', 1),
(8, 'Ateneo 3rd Year Volleyball League', '2019-05-09', '2019-05-09', '3rd Year - Women', 1),
(9, 'Davao City Inter-School League', '2019-05-09', '2019-05-09', 'College Division', 1),
(10, 'HCDC Intrams Volleyball', '2019-05-01', '2019-05-09', 'Campus Division', 1),
(11, '2019 Palarong Pambata - Teen Edition', '2019-05-08', '2019-05-08', 'Infant', 1),
(12, 'Shakeys D-League', '2019-05-09', '2019-05-09', 'Governement Agencies', 1),
(13, 'Gotcha', '2019-05-08', '2019-05-08', 'asdasd', 2),
(14, 'asd', '2019-05-08', '2019-05-08', 'asd', 2),
(15, 'wewo', '2019-05-08', '2019-05-08', 'wew', 2),
(16, 'V-League 2019', '2019-05-09', '2019-05-09', 'Business Division', 1),
(17, 'UM Mindanao Volleyball', '2019-05-01', '2019-05-16', 'CCE', 1),
(18, 'Ateneo Elementary Volleyball', '2019-05-01', '2019-05-21', 'Kinder Garten', 1),
(19, 'UAAP Season 81 Volleyball Tournament ', '2019-05-10', '2019-06-30', 'Women\'s Division', 1),
(20, 'UM Volleyball Tournament', '2019-05-16', '2019-06-01', 'Men\'s Division', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tournament_status`
--

CREATE TABLE `tournament_status` (
  `Status_ID` int(2) NOT NULL,
  `Status_Description` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tournament_status`
--

INSERT INTO `tournament_status` (`Status_ID`, `Status_Description`) VALUES
(1, 'Active'),
(2, 'Inactive');

-- --------------------------------------------------------

--
-- Table structure for table `winlose_status`
--

CREATE TABLE `winlose_status` (
  `WinLoseStatus_ID` enum('W','L','P') NOT NULL,
  `Status_Description` varchar(225) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `winlose_status`
--

INSERT INTO `winlose_status` (`WinLoseStatus_ID`, `Status_Description`) VALUES
('W', 'Winner'),
('L', 'Loser'),
('P', 'Playing');

-- --------------------------------------------------------

--
-- Structure for view `loginview`
--
DROP TABLE IF EXISTS `loginview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `loginview`  AS  select `login`.`Username` AS `Username`,`login`.`Email_Add` AS `Email_Add`,`tournament_status`.`Status_Description` AS `Status_Description` from (`login` join `tournament_status` on((`login`.`Status_ID` = `tournament_status`.`Status_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `playertoaddview`
--
DROP TABLE IF EXISTS `playertoaddview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `playertoaddview`  AS  select `player`.`Player_ID` AS `Player_ID`,`player`.`Jersey_ID` AS `Jersey_ID`,`player`.`Player_Fname` AS `Player_Fname`,`player`.`Player_Lname` AS `Player_Lname`,`playertype`.`Type_Description` AS `Type_Description`,`player`.`DateOfBirth` AS `DateOfBirth`,`player`.`Contact_Number` AS `Contact_Number`,`player`.`Address` AS `Address`,`player`.`Team_ID` AS `Team_ID` from (`player` join `playertype` on((`player`.`Player_Type` = `playertype`.`PlayerType_ID`))) where (`player`.`Team_ID` = '') ;

-- --------------------------------------------------------

--
-- Structure for view `playerview`
--
DROP TABLE IF EXISTS `playerview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `playerview`  AS  select `player`.`Player_ID` AS `Player_ID`,`player`.`Jersey_ID` AS `Jersey_ID`,`player`.`Player_Fname` AS `Player_Fname`,`player`.`Player_Lname` AS `Player_Lname`,`playertype`.`Type_Description` AS `Type_Description`,`player`.`DateOfBirth` AS `DateOfBirth`,`player`.`Contact_Number` AS `Contact_Number`,`player`.`Address` AS `Address` from (`player` join `playertype` on((`player`.`Player_Type` = `playertype`.`PlayerType_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `teamplayerview`
--
DROP TABLE IF EXISTS `teamplayerview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `teamplayerview`  AS  select `player`.`Player_ID` AS `Player_ID`,`player`.`Jersey_ID` AS `Jersey_ID`,`player`.`Player_Fname` AS `Player_Fname`,`player`.`Player_Lname` AS `Player_Lname`,`playertype`.`Type_Description` AS `Type_Description`,`player`.`DateOfBirth` AS `DateOfBirth`,`player`.`Contact_Number` AS `Contact_Number`,`player`.`Address` AS `Address`,`player`.`Team_ID` AS `Team_ID` from ((`team_detail` join `player` on((`team_detail`.`Player_ID` = `player`.`Player_ID`))) join `playertype` on((`player`.`Player_Type` = `playertype`.`PlayerType_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `teamview`
--
DROP TABLE IF EXISTS `teamview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `teamview`  AS  select `team`.`Team_ID` AS `Team_ID`,`tournament`.`Tournament_Name` AS `Tournament_Name`,`team`.`Team_Name` AS `Team_Name`,(select concat(`coach`.`Coach_Fname`,' ',`coach`.`Coach_Lname`)) AS `(select concat(coach.Coach_Fname," " ,coach.Coach_Lname))`,`team`.`Address` AS `Address`,`team`.`Contact_Number` AS `Contact_Number`,`team`.`Email` AS `Email` from ((`team` join `tournament` on((`team`.`Tournament_ID` = `tournament`.`Tournament_ID`))) join `coach` on((`team`.`Coach_ID` = `coach`.`Coach_ID`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `coach`
--
ALTER TABLE `coach`
  ADD PRIMARY KEY (`Coach_ID`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`Username`),
  ADD UNIQUE KEY `Email_Add` (`Email_Add`),
  ADD KEY `Status_ID` (`Status_ID`);

--
-- Indexes for table `matchup_info`
--
ALTER TABLE `matchup_info`
  ADD PRIMARY KEY (`Matchupinfo_ID`);

--
-- Indexes for table `matchup_set`
--
ALTER TABLE `matchup_set`
  ADD PRIMARY KEY (`Match_ID`,`Team_ID`,`Set_Number`),
  ADD KEY `Match_ID` (`Match_ID`,`Team_ID`),
  ADD KEY `Team_ID` (`Team_ID`),
  ADD KEY `WinLoseStatus_ID` (`WinLoseStatus_ID`);

--
-- Indexes for table `match_up`
--
ALTER TABLE `match_up`
  ADD PRIMARY KEY (`Match_ID`,`Round_ID`,`Team_ID`),
  ADD KEY `Round_ID` (`Round_ID`,`Tournament_ID`,`Team_ID`,`MatchInfo_ID`),
  ADD KEY `Tournament_ID` (`Tournament_ID`),
  ADD KEY `Team_ID` (`Team_ID`),
  ADD KEY `MatchInfo_ID` (`MatchInfo_ID`),
  ADD KEY `WinLoseStatus_ID` (`WinLoseStatus_ID`);

--
-- Indexes for table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`Player_ID`),
  ADD KEY `Player_Type` (`Player_Type`),
  ADD KEY `Team_ID` (`Team_ID`);

--
-- Indexes for table `playertype`
--
ALTER TABLE `playertype`
  ADD PRIMARY KEY (`PlayerType_ID`);

--
-- Indexes for table `player_stats`
--
ALTER TABLE `player_stats`
  ADD PRIMARY KEY (`Match_ID`,`Team_ID`,`Player_ID`,`Set_Number`),
  ADD KEY `Match_ID` (`Match_ID`,`Team_ID`,`Player_ID`),
  ADD KEY `Team_ID` (`Team_ID`),
  ADD KEY `Player_ID` (`Player_ID`);

--
-- Indexes for table `round`
--
ALTER TABLE `round`
  ADD PRIMARY KEY (`Round_ID`),
  ADD UNIQUE KEY `Round_Description` (`Round_Description`);

--
-- Indexes for table `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`Team_ID`,`Tournament_ID`),
  ADD KEY `Tournament_ID` (`Tournament_ID`,`Coach_ID`),
  ADD KEY `Coach_ID` (`Coach_ID`);

--
-- Indexes for table `team_detail`
--
ALTER TABLE `team_detail`
  ADD PRIMARY KEY (`Team_ID`,`Tournament_ID`,`Player_ID`),
  ADD KEY `Team_ID` (`Team_ID`,`Tournament_ID`,`Player_ID`),
  ADD KEY `Tournament_ID` (`Tournament_ID`),
  ADD KEY `Player_ID` (`Player_ID`);

--
-- Indexes for table `team_standing`
--
ALTER TABLE `team_standing`
  ADD KEY `Team_ID` (`Team_ID`,`Tournament_ID`,`Round_ID`),
  ADD KEY `Tournament_ID` (`Tournament_ID`),
  ADD KEY `Round_ID` (`Round_ID`);

--
-- Indexes for table `tournament`
--
ALTER TABLE `tournament`
  ADD PRIMARY KEY (`Tournament_ID`),
  ADD UNIQUE KEY `Tournament_Name` (`Tournament_Name`),
  ADD KEY `Status_ID` (`Status_ID`);

--
-- Indexes for table `tournament_status`
--
ALTER TABLE `tournament_status`
  ADD PRIMARY KEY (`Status_ID`);

--
-- Indexes for table `winlose_status`
--
ALTER TABLE `winlose_status`
  ADD PRIMARY KEY (`WinLoseStatus_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `coach`
--
ALTER TABLE `coach`
  MODIFY `Coach_ID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `matchup_info`
--
ALTER TABLE `matchup_info`
  MODIFY `Matchupinfo_ID` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `player`
--
ALTER TABLE `player`
  MODIFY `Player_ID` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `playertype`
--
ALTER TABLE `playertype`
  MODIFY `PlayerType_ID` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `round`
--
ALTER TABLE `round`
  MODIFY `Round_ID` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tournament`
--
ALTER TABLE `tournament`
  MODIFY `Tournament_ID` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tournament_status`
--
ALTER TABLE `tournament_status`
  MODIFY `Status_ID` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`Status_ID`) REFERENCES `tournament_status` (`Status_ID`);

--
-- Constraints for table `matchup_set`
--
ALTER TABLE `matchup_set`
  ADD CONSTRAINT `matchup_set_ibfk_1` FOREIGN KEY (`Match_ID`) REFERENCES `match_up` (`Match_ID`),
  ADD CONSTRAINT `matchup_set_ibfk_2` FOREIGN KEY (`Team_ID`) REFERENCES `team` (`Team_ID`),
  ADD CONSTRAINT `matchup_set_ibfk_3` FOREIGN KEY (`WinLoseStatus_ID`) REFERENCES `winlose_status` (`WinLoseStatus_ID`);

--
-- Constraints for table `match_up`
--
ALTER TABLE `match_up`
  ADD CONSTRAINT `match_up_ibfk_1` FOREIGN KEY (`Round_ID`) REFERENCES `round` (`Round_ID`),
  ADD CONSTRAINT `match_up_ibfk_2` FOREIGN KEY (`Tournament_ID`) REFERENCES `tournament` (`Tournament_ID`),
  ADD CONSTRAINT `match_up_ibfk_3` FOREIGN KEY (`Team_ID`) REFERENCES `team` (`Team_ID`),
  ADD CONSTRAINT `match_up_ibfk_4` FOREIGN KEY (`MatchInfo_ID`) REFERENCES `matchup_info` (`Matchupinfo_ID`),
  ADD CONSTRAINT `match_up_ibfk_5` FOREIGN KEY (`WinLoseStatus_ID`) REFERENCES `winlose_status` (`WinLoseStatus_ID`);

--
-- Constraints for table `player`
--
ALTER TABLE `player`
  ADD CONSTRAINT `player_ibfk_1` FOREIGN KEY (`Player_Type`) REFERENCES `playertype` (`PlayerType_ID`);

--
-- Constraints for table `player_stats`
--
ALTER TABLE `player_stats`
  ADD CONSTRAINT `player_stats_ibfk_1` FOREIGN KEY (`Match_ID`) REFERENCES `match_up` (`Match_ID`),
  ADD CONSTRAINT `player_stats_ibfk_2` FOREIGN KEY (`Team_ID`) REFERENCES `team` (`Team_ID`),
  ADD CONSTRAINT `player_stats_ibfk_3` FOREIGN KEY (`Player_ID`) REFERENCES `player` (`Player_ID`);

--
-- Constraints for table `team`
--
ALTER TABLE `team`
  ADD CONSTRAINT `team_ibfk_1` FOREIGN KEY (`Coach_ID`) REFERENCES `coach` (`Coach_ID`),
  ADD CONSTRAINT `team_ibfk_2` FOREIGN KEY (`Tournament_ID`) REFERENCES `tournament` (`Tournament_ID`);

--
-- Constraints for table `team_detail`
--
ALTER TABLE `team_detail`
  ADD CONSTRAINT `team_detail_ibfk_1` FOREIGN KEY (`Team_ID`) REFERENCES `team` (`Team_ID`),
  ADD CONSTRAINT `team_detail_ibfk_2` FOREIGN KEY (`Tournament_ID`) REFERENCES `tournament` (`Tournament_ID`),
  ADD CONSTRAINT `team_detail_ibfk_3` FOREIGN KEY (`Player_ID`) REFERENCES `player` (`Player_ID`);

--
-- Constraints for table `team_standing`
--
ALTER TABLE `team_standing`
  ADD CONSTRAINT `team_standing_ibfk_1` FOREIGN KEY (`Tournament_ID`) REFERENCES `tournament` (`Tournament_ID`),
  ADD CONSTRAINT `team_standing_ibfk_2` FOREIGN KEY (`Team_ID`) REFERENCES `team` (`Team_ID`),
  ADD CONSTRAINT `team_standing_ibfk_3` FOREIGN KEY (`Round_ID`) REFERENCES `round` (`Round_ID`);

--
-- Constraints for table `tournament`
--
ALTER TABLE `tournament`
  ADD CONSTRAINT `tournament_ibfk_1` FOREIGN KEY (`Status_ID`) REFERENCES `tournament_status` (`Status_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
