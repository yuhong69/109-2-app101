chinese <- list()

chinese$convert_minguo2western <- convert_minguo2western <- function(minguo_string){
  origin <- minguo_string
  
  revised <- {
    stringr::str_extract(origin, "(?<=民國)[^）\\)餘年]+") -> origin2
    stringr::str_replace(origin2, "^[拾十]","一拾") -> origin3
    stringr::str_replace_all(origin3, c("前"="-", "約"=""))
    # ○ (百)，元
  }
  
  arabics <- {
    as.numeric(revised)
  }
  
  whichIsNonArabics <- which(is.na(arabics))
  non_arabics <- {
    revised[whichIsNonArabics]
  }
  
  firstDigit <- {
    stringr::str_extract(non_arabics, "[元一二三四五六七八九壹貳參肆伍陸柒捌玖]$") ->
      firstDigit
    convert_chn2arabics(firstDigit) -> 
      firstDigit
    na_is_0(firstDigit)
  }
  
  tenth <- {
    stringr::str_extract(non_arabics,
                         "[一二三四五六七八九壹貳參肆伍陸柒捌玖](?=[十拾]|０$)") -> 
      tenth
    whichIs30 <- stringr::str_which(non_arabics,"卅")
    convert_chn2arabics(tenth) -> tenth
    tenth[whichIs30] <- "3"
    na_is_0(tenth)
  }
  
  hundredth <- {
    stringr::str_extract(non_arabics,
                         "[一二三四五六七八九壹貳參肆伍陸柒捌玖](?=[百佰O○])") -> 
      hundredth
    convert_chn2arabics(hundredth) -> hundredth
    na_is_0(hundredth)
  }
  
  minguo_integer <- as.integer(paste(hundredth, tenth, firstDigit, sep=""))
  arabics[whichIsNonArabics] <- minguo_integer
  
  westernYear <- 1911 + arabics
  # return(westernYearIntegers)
}

chinese$convert_chnWesternYears <- convert_chnWesternYears <- function(chnWestYears){
  
  # return(westernYearInteger) 
}


# helpers

convert_chn2arabics <- function(origin, naIs0 = T){
  chineseNumber1 <- "一二三四五六七八九"
  chineseNumber2 <- "壹貳參肆伍陸柒捌玖"
  chineseNumber1_char <- unlist(stringr::str_split(chineseNumber1,""))
  chineseNumber2_char <- unlist(stringr::str_split(chineseNumber2,""))
  
  replacement <- c(rep(as.character(1:9),2), "1")
  names(replacement) <- c(chineseNumber1_char, chineseNumber2_char, "元")
  
  stringr::str_replace_all(origin, replacement) -> revised
  if(naIs0){
    na_is_0(revised) -> revised
  }
  return(revised)
}
na_is_0 <- function(origin){
  whichIsNA = which(is.na(origin))
  origin[whichIsNA] = "0"
  return(origin)
}