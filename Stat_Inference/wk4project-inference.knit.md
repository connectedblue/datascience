---
title: "Analysis of the Effect of Vitamin C on Tooth Growth in Guinea Pigs"
author: "Chris Shaw"
date: "23 April 2016"
output: pdf_document
---




# Synopsis

This paper analyses how dosage levels and delivery method of vitmain C effect the length of odontoblasts (cells responsible for tooth growth) in 60 guinea pigs. Each animal received one of three dose levels of vitamin C (0.5, 1, and 2 mg/day) by one of two delivery methods, (orange juice or ascorbic acid (a form of vitamin C and coded as VC).  

We conclude that dose levels make a significant impact to the mean tooth length, whereas the delivery methods do not.

# Exploratory Analysis

The following table summarises the dataset.  The mean and standard deviation of cell length is show for each dosage level and each delivery method.  The number of observations in each grouping is also shown.


Table: Summary of tooth length by supplement and dosage

 Supplement    Dose    Num obs    Mean     Std dev 
------------  ------  ---------  -------  ---------
     OJ        0.5       10       13.23     4.46   
     OJ        1.0       10       22.70     3.91   
     OJ        2.0       10       26.06     2.66   
     VC        0.5       10       7.98      2.75   
     VC        1.0       10       16.77     2.52   
     VC        2.0       10       26.14     4.80   

# Assumptions

The population of odontoblast cell lengths is assumed to be normally distributed with mean $\mu$ and variance $\sigma^2$.  The table above ahows that the mean is very different depending on the dose and delivery method of vitmain C.  

The plots overleaf show how the length varies depending on these variables.

![](wk4project-inference_files/figure-latex/boxplots-1.pdf) 

Although the OJ delivery method seems to have a larger mean, the variance of the VC method is much wider. However, when it comes to dose levels, the mean seems to clearly increase as doseage increases.

Both of these will be examined more rigorously by hypothesis testing.

# Hypothesis testing

First we compare the different supplements, OJ and VC.  The mean tooth length from the population using each of these is $\mu_{oj}$ and $\mu_{vc}$ respectively.  The null hypothesis, $H_0$ is that these means are equal, i.e: 
$$H_0 : \mu_{oj} = \mu_{vc}$$
$$H_a : \mu_{oj} \neq \mu_{vc}$$
We want to find evidence of whether the alternative hypothesis $H_a$ may be true, that the means are not equal.



A two sided t-test was performed to test this (see appendix for details). The p-value is calculated at 0.0604.  This is quite high, so we fail to reject the null hypthosis and conclude there is no evidence that the means are different.

\newpage
Next we compare the differences in cell length depending on dosage level.  The mean tooth length from the population for each is $\mu_2$, $\mu_1$ and $\mu_{0.5}$ respectively.  The null hypothesis, $H_0$ is that these means are equal, i.e: 
$$H_0 : \mu_2 = \mu_1$$
$$H_a : \mu_2 > \mu_1$$
We want to find evidence of whether the alternative hypothesis $H_a$ may be true, that $\mu_2$ is greater than $\mu_1$.



We run a one sided t-test (see appendix) and the p-value is calculated at 9.0541427&times; 10^-6^.  This is very low, so we reject the null hypthosis and conclude the alternate hypothesis $H_a$ is true.


# Conclusion

The analysis of the data and the hypothesis testing leads us to the following conclusions:

* It is not possible to determine whether the delivery method of orange juice or ascorbic acid produces a higher mean cell length.
* The doseage levels however do produce a significant difference and enables us to say that higher doses will lead to a higher mean cell length.

\clearpage
\appendix
\pagenumbering{roman}

# Appendix

This is the code used to generate the summary table:


```r
data(ToothGrowth)
#extract measurements for each of the supplement types and dosage levels
vc<-ToothGrowth[ToothGrowth$supp=="VC",]$len
oj<-ToothGrowth[ToothGrowth$supp=="OJ",]$len
d_05<-ToothGrowth[ToothGrowth$dose==0.5,]$len
d_1<-ToothGrowth[ToothGrowth$dose==1,]$len
d_2<-ToothGrowth[ToothGrowth$dose==2,]$len

# Calculate aggregrated statistics on supp and dose (number of obs, mean and sd)
ag<-aggregate(len~supp+dose, ToothGrowth, 
              function(x) c(n=as.integer(length(x)), 
                            mn=round(mean(x),2), 
                            sd=round(sd(x),2)))

# force the aggregrated output into a printable dataframe and re-order
ag <- cbind(ag[,1:2], as.data.frame(unlist(ag$len)))
ag <- ag[with(ag, order(supp, dose)),]

kable(ag, col.names = c("Supplement", "Dose", "Num obs", "Mean", "Std dev"),
           row.names = FALSE,
          align=c("c", "c", "c", "c", "c"),
          caption = "Summary of tooth length by supplement and dosage")
```

The T test ran to compare the hypothesis for whether the delivery method influences the mean:


```r
pv <- t.test(oj, vc, paired=FALSE, var.equal = TRUE, alternative = "two.sided")
```

The T test ran to compare dose of 1.0 to 2.0:


```r
pv <- t.test(d_2, d_1, paired=FALSE, var.equal = TRUE, alternative = "greater")
```
