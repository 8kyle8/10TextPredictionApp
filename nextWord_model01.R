# Helper function for searching n-gram by characters
charSearch <- function(x, df, colname) {
  
  x <- head(unlist(strsplit(x, "")), 5)
  x.length <- length(x)
  
  fail <- FALSE # initialise fail boolean
  
  # Match first x.length characters of the words in df
  result <- df %>% 
    slice(grep(paste0("^", paste0(x, collapse = "")), df %>% pull(colname)))
  fail <- !nrow(result)
  
  if (fail) { # if no successful character-wise search found, return original
    
    result <- df %>% filter(FALSE)
    
  }
  
  result
  
}


nextWordn1 <- function(x) {
  # x must be a character vector of length 1 containing lower-case letters only
  
  result <- charSearch(x, df.n1, "n1") %>% 
    select(n1, freq) %>% 
    arrange(desc(freq)) %>% 
    head(10)
  
  fail <- !nrow(result) # check if 1-word search is successful, if not, enter WHILE
  n <- min(4, nchar(x)) # initialise while counter
                        # max 5 as charSearch searches 5 chars max
                        # first result has failed to enter while, so use 4
  
  # This is to remove possibility of no match found
  # If no match, disregard 1 character to minimally show a result
  while (fail) {
    x <- head(unlist(strsplit(x, "")), n)
    result <- charSearch(x, df.n1, "n1") %>% 
      select(n1, freq) %>% 
      arrange(desc(freq)) %>% 
      head(10)
    n <- n - 1
    fail <- !nrow(result)
  }
  
  result # returns result
  
}

nextWordn2 <- function(x, end.space) {
  # x must be a character vector of length 1 or 2 containing lower-case letters only
  
  # 2 usage cases according to x vector input:
  # A) 1 word with space
  # B) 1 word, space, a few letters
  
  result <- df.n2 %>% 
    filter(n1 == x[1])
  
  if (end.space) {
    
    result <- result %>% 
      select(n2, freq) %>% 
      arrange(desc(freq)) %>% 
      head(10)
    
  } else {
    
    result <- charSearch(x[2], result, "n2") %>% 
      select(n2, freq) %>% 
      arrange(desc(freq)) %>% 
      head(10)
    
  }
  
  result
  
}


nextWordn3 <- function(x, end.space) {
  # x must be a character vector of length 2 or 3 containing lower-case letters only
  
  # 2 usage cases according to x vector input:
  # A) 2 words with space
  # B) 2 words, space, a few letters
  
  result <- df.n3 %>% 
    filter(n1 == x[1], n2 == x[2])
  
  if (end.space) {
    
    result <- result %>% 
      select(n3, freq) %>% 
      arrange(desc(freq)) %>% 
      head(10)
    
  } else {
    
    result <- charSearch(x[3], result, "n3") %>% 
      select(n3, freq) %>% 
      arrange(desc(freq)) %>% 
      head(10)

  }
  
  result
  
}


nextWordn4 <- function(x, end.space) {
  # x must be a character vector of length 3 or 4 containing lower-case letters only
  
  # 2 usage cases according to x vector input:
  # A) 3 word with space
  # B) 3 word, space, a few letters
  
  result <- df.n4 %>% 
    filter(n1 == x[1], n2 == x[2], n3 == x[3])
  
  if (end.space) {
    
    result <- result %>% 
      select(n4, freq) %>% 
      arrange(desc(freq)) %>% 
      head(10)
    
  } else {
    
    result <- charSearch(x[4], result, "n4") %>% 
      select(n4, freq) %>% 
      arrange(desc(freq)) %>% 
      head(10)
    
  }
  
  result
  
}


# Main function for next word prediction
nextWord <- function(x) {
  
  x.clean <- tolower(gsub("[^[:lower:]|^[:upper:] ]", "", x))
  # 2) check if the last character is a {space}; x.space is TRUE/FALSE
  # this indicates whether the user has completed typing a word
  x.space <- tail(unlist(strsplit(x.clean, "")), 1) == " "
  # 3) split string by {space}
  x.words <- unlist(strsplit(x.clean, " "))
  x.length <- length(x.words)
  
  y <- tail(x.words, 4) # keep only max 3 words
  y.length <- length(y)
  
  # adjust for 4 completed words with space scenario
  if (y.length == 4 & x.space) {
    
    y <- tail(x.words, 3)
    y.length <- length(y)
    
  }
  
  fail <- FALSE # initialise fail boolean
  
  if ((y.length == 4 & !x.space) | (y.length == 3 & x.space)) {
    
    result <- nextWordn4(y, x.space)
    fail <- !nrow(result)
    
    if (fail) {
      
      y <- tail(y, y.length - 1)
      y.length <- y.length - 1
      
    }
    
  }
  
  if ((y.length == 3 & !x.space) | (y.length == 2 & x.space) | fail) {
    
    result <- nextWordn3(y, x.space)
    fail <- !nrow(result)
    
    if (fail) {
      
      y <- tail(y, y.length - 1)
      y.length <- y.length - 1
      
    }
    
  }
  
  if ((y.length == 2 & !x.space) | (y.length == 1 & x.space) | fail) {
    
    result <- nextWordn2(y, x.space)
    fail <- !nrow(result)
    
    if (fail) {
      
      y <- tail(y, max(1, y.length - 1))
      y.length <- y.length - 1
      
    }
    
  }
  
  if ((y.length == 1 & !x.space) | fail) {
    
    result <- nextWordn1(y)
    
  }
  
  result <- result
  
  result
  
}