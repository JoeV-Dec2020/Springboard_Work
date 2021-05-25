-- ==================================================================
-- Part One: Medical Center - Design the schema for a medical center:
-- ==================================================================
-- A medical center employs several doctors
-- A doctors can see many patients
-- A patient can be seen by many doctors
-- During a visit, a patient may be diagnosed to have one or more diseases.
--
-- MySql:
-- ------
create schema medical_center;

USE medical_center;

create table doctors (
    Doctor_ID         Integer Primary Key, -- Value derived from Sequence
    Doctor_Last_Name  Varchar(50),
    Doctor_First_Name Varchar(50),
    Doctor_Specialty  Varchar(50),
    Doctor_Start_Date Date
);

create table patients (
    Patient_ID         Integer Primary Key, -- Value derived from Sequence
    Patient_Last_Name  Varchar(50),
    Patient_First_Name Varchar(50),
    Patient_DoB        Date
);

create table appointments (
    Appt_ID       Integer Primary Key, -- Value derived from Sequence
    Appt_DateTime Date,
    Doctor_ID     Integer,
                  Foreign Key (Doctor_ID) references doctors(Doctor_ID) on delete cascade,
    Patient_ID    Integer,
                  Foreign Key (Patient_ID) references patients(Patient_ID) on delete cascade
);

create table diseases (
    Disease_ID   Integer Primary Key, -- Value derived from Sequence
    Disease_Name Varchar(50)
);

create table patient_diagnoses (
    Diagnosis_ID   Integer Primary Key, -- Value derived from Sequence
    Diagnosis_Date Date,
    Doctor_ID      Integer,
                   Foreign Key (Doctor_ID) references doctors(Doctor_ID) on delete cascade,
    Patient_ID     Integer,
                   Foreign Key (Patient_ID) references patients(Patient_ID) on delete cascade,
    Disease_ID     Integer,
                   Foreign Key (Disease_ID) references diseases(Disease_ID) on delete cascade
);


-- ======================================================================================================
-- Part Two: Craigslist - Design a schema for Craigslist! Your schema should keep track of the following:
-- ======================================================================================================
-- The region of the craigslist post (San Francisco, Atlanta, Seattle, etc)
-- Users and preferred region
-- Posts: contains title, text, the user who has posted, the location of the posting, the region of the posting
-- Categories that each post belongs to

create schema craigslist;

USE craigslist;

create table regions (
    Region_ID   Integer Primary Key, -- Value derived from Sequence
    Region_Name Varchar(50)
);

create table users (
    User_ID          Integer Primary Key, -- Value derived from Sequence
    User_Last_Name   Varchar(50),
    User_First_Name  Varchar(50),
    User_Pref_Region Integer,
                     Foreign Key (User_Pref_Region) references regions(Region_ID)
);

create table categories (
    Category_ID   Integer Primary Key, -- Value derived from Sequence
    Category_Name Varchar(50)
);

create table posts (
    Post_ID       Integer Primary Key, -- Value derived from Sequence
    Post_Title    Varchar(50),
    Post_Text     Varchar(250),
    User_ID       Integer,
                  Foreign Key (User_ID) references users(User_ID) on delete cascade,
    Post_Location Varchar(50),
    Region_ID     Integer,
                  Foreign Key (Region_ID) references regions(Region_ID) on delete cascade,
    Category_ID   Integer,
                  Foreign Key (Category_ID) references categories(Category_ID) on delete cascade
);


-- =========================================================================================================
-- Part Three: Soccer League - Design a schema for a simple sports league. Your schema should keep track of:
-- =========================================================================================================
-- All of the teams in the league
-- All of the goals scored by every player for each game
-- All of the players in the league and their corresponding teams
-- All of the referees who have been part of each game
-- V - All of the matches played between teams
-- V - All of the start and end dates for season that a league has
-- V - The standings/rankings of each team in the league (This doesn’t have to be its own table if the data can be captured somehow).

create schema soccer_league;

USE soccer_league;

create table teams (
    Team_ID    Integer Primary Key, -- Value derived from Sequence
    Location   Varchar(50),
    Mascot     Varchar(50),
    Head_Coach Varchar(50)
);

create table seasons (
    Season_ID   Integer Primary Key, -- Value derived from Sequence
    Season_Name Varchar(50)
);

create table games (
    Game_ID    Integer Primary Key, -- Value derived from Sequence
    Game_Date  Date Not NULL,
    Season_ID  Integer,
               Foreign Key (Season_ID) references seasons(Season_ID) on delete cascade,
    Home_Team  Integer,
               Foreign Key (Home_Team) references teams(Team_ID) on delete cascade,
    Home_Score Integer,
    Away_Team  Integer,
               Foreign Key (Home_Team) references teams(Team_ID) on delete cascade,
    Away_Score Integer
);

create table players (
    Player_ID         Integer Primary Key, -- Value derived from Sequence
    Player_Last_Name  Varchar(50),
    Player_First_Name Varchar(50),
    Player_Team_ID    Integer,
                      Foreign Key (Player_Team_ID) references teams(Team_ID) on delete cascade
);

create table player_goals (
    Player_ID Integer,
              Foreign Key (Player_ID) references players(Player_ID) on delete cascade,
    Game_ID   Integer,
              Foreign Key (Game_ID) references games(Game_ID) on delete cascade,
    Goals     Integer,
    PRIMARY KEY(Player_ID, Game_ID)
);

create table referees (
    Referee_ID         Integer Primary Key, -- Value derived from Sequence
    Referee_Last_Name  Varchar(50),
    Referee_First_Name Varchar(50)
);

create table game_referees (
    Game_ID    Integer,
               Foreign Key (Game_ID) references games(Game_ID) on delete cascade,
    Referee_ID Integer,
               Foreign Key (Referee_ID) references referees(Referee_ID) on delete cascade,
    PRIMARY KEY(Game_ID, Referee_ID)
);

-- V - All of the matches played between teams
create view team_matches as
select games.Home_Team  as Favored_Team_ID,
       games.Away_Team  as Opponent_Team_ID,
       games.Season_ID,
       'Home'           as Match_Location,
       games.Game_Date,
       games.Home_Score as Favored_Score,
       games.Away_Score as Opponent_Score
 from  games
Union
select games.Away_Team  as Favored_Team_ID,
       games.Home_Team  as Opponent_Team_ID,
       games.Season_ID,
       'Away'           as Match_Location,
       games.Game_Date,
       games.Away_Score as Favored_Score,
       games.Home_Score as Opponent_Score
 from  games;

-- V - All of the start and end dates for season that a league has
create view season_dates as
select Season_Name,
       Min(Game_Date) as Start_Date,
       Max(Game_Date) as End_Date
 from  games
       inner join seasons USING (Season_ID);

-- V - The standings/rankings of each team in the league (This doesn’t have to be its own table if the data can be captured somehow).
create view team_ranking as
select t1.Season_ID,
       t1.Favored_Team_ID,
       Wins.Win_Count,
       Losses.Loss_Count,
       (Wins.Win_Count / (Wins.Win_Count + Losses.Loss_Count)) as Win_Percent,
       RANK() OVER (PARTITION BY Season_ID
                    ORDER BY (Wins.Win_Count / (Wins.Win_Count + Losses.Loss_Count)) DESC) as Final_Ranking
 from  team_matches t1,
       (select t2.Season_ID, t2.Favored_Team_ID, count(*) Win_Count
         from  team_matches t2
         where t2.Favored_Score > t2.Opponent_Score
         group by t2.Season_ID, t2.Favored_Team_ID) as Wins,
       (select t3.Season_ID, t3.Favored_Team_ID, count(*) Loss_Count
         from  team_matches t3
         where t3.Favored_Score <= t3.Opponent_Score
         group by t3.Season_ID, t3.Favored_Team_ID) as Losses
 where t1.Season_ID = Wins.Season_ID
  and  t1.Favored_Team_ID = Wins.Favored_Team_ID
  and  t1.Season_ID = Losses.Season_ID
  and  t1.Favored_Team_ID = Losses.Favored_Team_ID
 group by t1.Season_ID, t1.Favored_Team_ID;
