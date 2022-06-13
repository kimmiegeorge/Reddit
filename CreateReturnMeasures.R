# Create return measures - 3 month CAR and 5 day CAR 

library(pacman)
p_load(data.table)


# load data 
crsp <- fread('/Volumes/Elements/Research/Reddit_Credibility/Data/CRSP_2021.csv')

dates <- unique(crsp[, .(date)])
dates[, rn := 1:.N]

# fix returns 
crsp[, RET := as.numeric(RET)]
crsp[, AbRET := RET - vwretd]

# merge with dates 
setkey(crsp, date)
setkey(dates, date)
crsp <- dates[crsp]

### create 3 month ahead CAR 
car_3m <- data.table()

for (row in dates$rn){
  crsp[, diff := rn - row]
  crsp_dt = crsp[diff > 0 & diff <= 21*3]
  permno_dt = crsp_dt[, list(CumAbRet3m = sum(AbRET), 
                             CumRet3m = sum(RET), 
                             NumDays3m = .N), .(PERMNO)]
  permno_dt[, rn := row]
  car_3m = rbind(car_3m, permno_dt)
}

### create 5 day ahead CAR 
car_5d <- data.table()

for (row in dates$rn){
  crsp[, diff := rn - row]
  crsp_dt = crsp[diff > 0 & diff <= 5]
  permno_dt = crsp_dt[, list(CumAbRet5d = sum(AbRET), 
                             CumRet5d = sum(RET), 
                             NumDays5d = .N), .(PERMNO)]
  permno_dt[, rn := row]
  car_5d = rbind(car_5d, permno_dt)
}

### merge back with crsp 
setkey(crsp, PERMNO, rn)
setkey(car_3m, PERMNO, rn)
setkey(car_5d, PERMNO, rn)

crsp <- car_3m[crsp]
crsp <- car_5d[crsp]

# create one day ahead ret 
crsp[, leadRET := shift(RET, n = 1L, type = 'lead'), .(PERMNO)]
crsp[, leadAbRET := shift(AbRET, n = 1L, type = 'lead'), .(PERMNO)]

# only needed variables 
crsp <- crsp[, .(PERMNO, TICKER, date, SHRCD, EXCHCD, RET, AbRET, leadRET, leadAbRET, 
                 CumAbRet3m, CumRet3m, NumDays3m, 
                 CumAbRet5d, CumRet5d, NumDays5d)]

write.csv(crsp, '/Volumes/Elements/Research/Reddit_Credibility/Data/ReturnMeasures.csv')
