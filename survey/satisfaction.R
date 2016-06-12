
# set parameters of the survey
# num_questions is the total number of questions asked
# top_choices is the number of most popular choices
num_questions <- 10
top_choices <- 3

choice_matrix <- function(num_questions, top_choices){
        # get all possible combinations of questions that could be the
        # most popular
        combinations <- combn(1:num_questions, top_choices)
        lc <- ncol(combinations)
        
        # initialise a matrix of zeroes
        mat <- matrix(rep(0, num_questions * lc),
                      nrow=num_questions, ncol = lc)
        
        # Populate each column with a 1 at the relevant question number row
        # according to the combinations matrix

        for (cn in 1:lc) {
                for (r in 1:top_choices) {
                        rn <- combinations[r,cn]
                        mat[rn,cn] <- 1
                }
        }
        mat
}

m<- choice_matrix(10,3)
