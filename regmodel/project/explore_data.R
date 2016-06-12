data(mtcars)

# data structure

str(mtcars)

# plot(mtcars)

# plots that show a linear relationship


reg_plot<-function(f){
        lm<-lm(f, mtcars)
        plot(f, 
             mtcars, main=f)
        abline(lm)
        plot(lm)
        lm
}

fit_am <- reg_plot(mpg~am)
# linear releationship: yes
# residuals:  quite a spread of residuals
# QQ plot follows a straight line - errors are normal



fit_cyl <- reg_plot(mpg~cyl)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger
# QQ plot not good


fit_disp <- reg_plot(mpg~disp)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger

fit_hp <- reg_plot(mpg~hp)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger

fit_drat <- reg_plot(mpg~drat)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger

fit_wt <- reg_plot(mpg~wt)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger

fit_qsec <- reg_plot(mpg~qsec)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger

fit_vs <- reg_plot(mpg~vs)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger


fit_gear <- reg_plot(mpg~gear)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger

fit_carb <- reg_plot(mpg~carb)
# linear releationship: yes
# residuals:  get more spread out as fitted values get larger
