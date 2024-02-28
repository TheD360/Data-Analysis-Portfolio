# Final Project for MSBA 615 - EPL Standings Project
# NAME: DANIEL ADIELE


# Load necessary libraries - This block of code loads in the necessary R libraries, 
# 'dplyr' for data manipulation and 'readr' for reading CSV files.
library(dplyr)
library(readr)


season<- "2022/23"
Date <- "05/31/2023"

# Define the function - This is the beginning part of the defining the function 'EPL_standing'.
# It takes in two parameters; date representing the target date and season representing the football season.

EPL_Standings <- function(Date, season) {
  
  # Step 1: This block of code downloads the appropriate file based on the Season argument. It constructs the URL
  # based on the inputed season argument, which is then used to download the corresponding CSV file containing the EPL match data 
  # from the given link just as requested by the assignment question.
  season <- paste0(substr(season, 3, 4), substr(season, 6, 7), "/")
  season <- paste0(season, '/')
  url_season <- paste0('https://www.football-data.co.uk/mmz4281/', season, 'E0.csv')
  print(url_season)
  df <- read_csv(url_season) # Reads the downloaded CSV file into a dataframe 'df' using the 'read_csv'
                             # function from the 'readr' library.
  
  
  
  # Step 2: Selects only the needed columns in the data frame. 
  # This block of code helps filters the data frame to retain only the columns we need for further analysis, which are ('Date', 'HomeTeam', AwayTeam, 'FTHG', 'FTAG', 'FTR').
  df <- df %>%
    select(Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
  
  
  # Step 3: Filters the data frame for matches played until the specified Date.
  # This block of code processes the date columns, ensuring consistent date format, and filters the data frame
  # to include only matches played until the specified input date.
  date_input <- as.Date(Date, format = "%m/%d/%Y")
  df <- df %>%
    mutate(Date = as.Date(Date, format = "%d/%m/%Y")) %>%
    filter(Date <= date_input)
  
  
  # Step 4: Deals with Home and Away team/goal columns based on the guide shared in the assignment.
  # This block of code creates separate data frames for home and away matches, and adds new columns to
  # distinguish match types. The 'bind_rows' function is then used to combine the data frames together.
  home_df <- df %>%
    mutate(Date, Team = HomeTeam, Opponent = AwayTeam, Goals = FTHG, OpponentGoals = FTAG, MatchType = "Home")
  
  away_df <- df %>%
    mutate(Date, Team = AwayTeam, Opponent = HomeTeam, Goals = FTAG, OpponentGoals = FTHG, MatchType = "Away")
  
  df <- bind_rows(home_df, away_df) # This code combines the two tables (the Home table and the Away table) into one big table.
  
  
  # Step 5: Does all of the aggregation & calculations (groups by team).
  # This block of code calculates team-wise statistics such as win-draw-loss records, points, goals scored, goals conceded, etcetra
  # using the 'group_by' and 'summarize' functions from the 'dplyr' library.
  final_df <- df %>%
    group_by(Team) %>%
    summarize(
      Record = paste(sum(MatchType == "Home" & FTR == "H") + sum(MatchType == "Away" & FTR == "A"), "-", sum(MatchType == "Home" & FTR == "A") + sum(MatchType == "Away" & FTR == "H"), "-", sum(MatchType == "Home" & FTR == "D") + sum(MatchType == "Away" & FTR == "D")),
      HomeRec = paste(sum(MatchType == "Home" & FTR == "H"), "-", sum(MatchType == "Home" & FTR == "A"), "-", sum(MatchType == "Home" & FTR == "D")),
      AwayRec = paste(sum(MatchType == "Away" & FTR == "A"), "-", sum(MatchType == "Away" & FTR == "H"), "-", sum(MatchType == "Away" & FTR == "D")),
      MatchesPlayed = n(),
      Points = 3*(sum(MatchType == "Home" & FTR == "H") + sum(MatchType == "Away" & FTR == "A")) + 1*(sum(MatchType == "Home" & FTR == "D") + sum(MatchType == "Away" & FTR == "D")),
      PPM = Points / MatchesPlayed,
      PtPct = Points / (3 * MatchesPlayed),
      GS = sum(Goals),
      GSM = GS / MatchesPlayed,
      GA = sum(OpponentGoals),
      GAM = GA / MatchesPlayed
    )

  
  
  # Step 6: Arrange the results.
  # This block of code arranges the final data frame 'final_df' in a way that makes it easier to interpret. 
  # The final data frame is sorted based on points, goals scored, and goals conceded.
  final_df <- final_df %>%
    arrange(desc(PPM), desc(Points), desc(GSM), GAM)

  
  
  # Final Step: Returns the final data frame.
  # This block of code concludes the function definition and the final data frame is returned as the output of the
  # function.
  return(final_df)
}

# Example of usage:
result <- EPL_Standings("05/31/2023", "2022/23")
print(result)
