# Reddit

#### Pull_Reddit_DDPosts_and_Comments 
Pulls all dd posts on WSB, all comments on DD posts on WSB, and auhtor user information 

#### Pull_DDAuthor_Data
For each DD post, pull bot-generated information on post author including first appearance in WSB, store comments and posts by past DD authors, ids to previous DD posts 

#### Create_DDAuthor_Stats
Compute bot-generated stats - time in WSB, # pasts comments and posts, avg score and total score on past posts, links to previous DD

#### TickerMentions 
Pulls ticker mentions from post titles and text. Later was hand checked and collected 

#### CreateReturnMeasures.R
Uses CRSP to compute for each ticker, CAR over next 3 months, next 5 days, and next day 

#### DDPost_Consistency
Computes sentiment of dd posts, merges with return measures computed with the above