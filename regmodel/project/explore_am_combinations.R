data(mtcars)

# data structure

# adjust for factor variables

mtcars$cyl <- factor(mtcars$cyl)
mtcars$am <- factor(mtcars$am)
mtcars$gear <- factor(mtcars$gear)
mtcars$carb <- factor(mtcars$carb)
mtcars$vs <- factor(mtcars$vs)

# adjust for average weight and horsepower and qsec

mtcars$wt  <- mtcars$wt - mean(mtcars$wt)
mtcars$hp  <- mtcars$hp - mean(mtcars$hp)
mtcars$qsec  <- mtcars$qsec - mean(mtcars$qsec)
mtcars$disp  <- mtcars$disp - mean(mtcars$disp)
mtcars$drat  <- mtcars$drat - mean(mtcars$drat)





# Fit nest linear models with am and additional co-variates to judge effects

reg_lm<-function(f){
        lm<-lm(f, mtcars)
        print(f)
        print(round(summary(lm)$coeff, 5))
        print(anova(lm))
        cat("\n\n")
        lm
}

# What does am look like on its own

fit_am <- reg_lm(mpg ~ am)

# Test which co-variates go best with am
#                                       Yes/No indicates whether both am + the co-variate
#                                       are significant (based on Anova table)

fit_am_gear <- reg_lm(mpg ~ am + gear)  # No
fit_am_carb <- reg_lm(mpg ~ am + carb)  # Yes   resid ms 12.52
fit_am_wt <- reg_lm(mpg ~ am + wt)      # Yes   resid ms  9.6
fit_am_disp <- reg_lm(mpg ~ am + disp)  # Yes   resid ms 10.35    
fit_am_qsec <- reg_lm(mpg ~ am + qsec)  # Yes   resid ms 12.16
fit_am_cyl <- reg_lm(mpg ~ am + cyl)    # Yes   resid ms  9.45
fit_am_hp <- reg_lm(mpg ~ am + hp)      # Yes   resid ms  8.46
fit_am_drat <- reg_lm(mpg ~ am + drat)  # No
fit_am_vs <- reg_lm(mpg ~ am + vs)      # yes   resid ms  12.19

#  Conclusion:  wt, cyl and hp seem most significant

# Perform some nested hypothesis tests

update_lm <- function(lm, newf){
        newm <- update(lm, newf)
        print(anova(lm, newm))
        cat("\n\n")
}


print ("Nested hypothesis tests\n=====================\n")

update_lm(fit_am_wt, mpg ~ am + wt + cyl)
update_lm(fit_am_wt, mpg ~ am + wt + hp)
update_lm(fit_am_wt, mpg ~ am + wt + cyl + hp)

update_lm(fit_am_hp, mpg ~ am + hp + wt)
update_lm(fit_am_hp, mpg ~ am + hp + cyl)
update_lm(fit_am_hp, mpg ~ am + hp + cyl + wt)

# Selected model ...

print("\n\nSelected Model")
fit_am_wt_hp <- reg_lm(mpg ~ am + wt + hp)      # yes   resid ms  6.44

print(summary(fit_am_wt_hp))

print("\n\nConfidence intervals around co-efficients")
print(cbind(confint(fit_am_wt_hp), Model_coef=coef(fit_am_wt_hp)))


# Better answer

# fit_am_wt_qsec <- reg_lm(mpg ~ am + wt + qsec)      # yes   resid ms  6.05



