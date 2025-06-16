# MLB Player & Salary Data Analysis (SQL Project)

This SQL project explores Major League Baseball (MLB) player and salary data to uncover trends and insights related to player careers, school affiliations, team spending, and player demographics. The dataset includes information about players, schools, and salaries.

The analysis is divided into four main parts, each focused on answering specific business and sports-related questions.

---

## Part I: School Analysis

- **Schools by Decade**: 1990 produced the highest MLB player (494).
- **Top Schools**: University of Texas at Austin is the top school producer by 107 players.
- **Top Schools by Decade**: In decade 1970 Arizona State University procuded the most players of 32.

![image](https://github.com/user-attachments/assets/fa590935-b278-4541-8e6c-4c84e9aadc71)
![image](https://github.com/user-attachments/assets/54c32bed-ed84-4326-8721-e713136b2fc2)
![image](https://github.com/user-attachments/assets/287be6f1-e273-4be9-b4e2-c050038bc00e)


---

## Part II: Salary Analysis

- **Top-Spending Teams**: Highlighted the top 20% of teams by average annual spending.
- **Cumulative Spending**: Calculated cumulative team spending over time.
- **Billion-Dollar Threshold**: Determined the first year each team surpassed $1 billion in total salary spending.

![image](https://github.com/user-attachments/assets/4927f974-9ab5-47ca-aa56-dc1b456998eb)
![image](https://github.com/user-attachments/assets/008cf3d5-8ed9-4c85-ba3f-361c5a7489a8)
![image](https://github.com/user-attachments/assets/f156e115-3307-4c5c-bac7-4a0418d3919e)

---

## Part III: Player Career Analysis

- **Career Length & Age**: Calculated player age at debut and final game, along with career duration.
- **Team Transitions**: Tracked which teams players started and ended their careers with.
- **Longevity on One Team**: Counted players who spent over a decade on the same team from start to finish.


<img width="359" alt="image" src="https://github.com/user-attachments/assets/0f325257-c237-4471-80b0-6bb2e8a540c8" />
<img width="458" alt="image" src="https://github.com/user-attachments/assets/3ca0aa1d-4a02-4965-9ef6-bf0a0d563dca" />
<img width="98" alt="image" src="https://github.com/user-attachments/assets/4716643d-4989-4383-b448-d9ad18eafb91" />

---

## Part IV: Player Comparison Analysis

- **Shared Birthdays**: Found players who share the same birthdate (1980–1990).
- **Batting Hand Distribution**: Analyzed the percentage of right, left, and both-handed batters per team.
- **Physical Trends**: Tracked average debut height and weight by decade, along with decade-over-decade changes.


<img width="247" alt="image" src="https://github.com/user-attachments/assets/122e442e-37ef-4563-92a3-89106a1be7b7" />
<img width="229" alt="image" src="https://github.com/user-attachments/assets/a82175b8-548a-4503-bb94-cb88c73f402f" />
<img width="213" alt="image" src="https://github.com/user-attachments/assets/381815eb-5fa1-49da-97fc-474048aa0051" />

---

## Tools Used

- SQL (MySQL syntax)
- Joins, Aggregates, Window Functions, CTEs, Filtering, Grouping, and Ranking

---

## Dataset Tables

- `school_details`: Full names and IDs of schools
- `schools`: Records of MLB players and their school affiliations
- `players`: Personal and career data for MLB players
- `salaries`: Player salaries, by year and team

---

## Purpose

This project showcases advanced SQL querying skills through real-world sports data analysis. It can serve as a portfolio project for aspiring data analysts and sports data enthusiasts.
