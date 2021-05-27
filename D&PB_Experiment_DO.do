*** Original Dataset ***
clear all
import excel "C:\Users\Batmanov_Alisher\Desktop\D&PB_Dataset.xlsx", sheet("Orig_Dataset") firstrow

* Create some new variables
gen alphaind5 = (W5tilde - W5)/W5*100
gen alphaind7 = (W5perpoundtilde - W7perpound)/W7perpound*100
gen alphaind3 = (W5perpoundtilde - W3perpound)/W3perpound*100
gen tiredgrowth = (t2-t1)/t1*100
gen D = 0
replace D = 1 if PHQ9>=10

gen hless10 = 0
gen h1030 = 0
gen h3050 = 0
gen h5070 = 0
gen h7090 = 0
gen h90150 = 0
replace h1030 = 1 if hhinc1020 == 1 | hhinc2030 == 1
replace h3050 = 1 if hhinc3040 == 1 | hhinc4050 == 1
replace h5070 = 1 if hhinc5060 == 1 | hhinc6070 == 1
replace h7090 = 1 if hhinc7080 == 1 | hhinc8090 == 1
replace h90150 = 1 if hhinc90100 == 1 | hhinc100150 == 1
replace hless10 = 1 if h1030 == 0 & h3050 == 0 & h5070 == 0 & h7090 == 0 & h90150 == 0

global controls Durationinseconds age children full_time white Gender highest_high_school highest_undergrad highest_grad hhinc1020 hhmembers marr student Vision
drop if Durationinseconds<900

** 1. Descriptive stats 

*a.Demographic info
sum Gender white age borninUK children hhmembers highest_high_school highest_undergrad full_time notinpaidwork hless10 h1030 h3050 h5070 h7090 h90150 soceconstatus literdiff student Vision num_approvals num_rejections Durationinseconds prolific_score

sum Gender white age borninUK children hhmembers highest_high_school highest_undergrad full_time notinpaidwork hless10 h1030 h3050 h5070 h7090 h90150 soceconstatus literdiff student Vision num_approvals num_rejections Durationinseconds prolific_score if PHQ9>=10

sum Gender white age borninUK children hhmembers highest_high_school highest_undergrad full_time notinpaidwork hless10 h1030 h3050 h5070 h7090 h90150 soceconstatus literdiff student Vision num_approvals num_rejections Durationinseconds prolific_score if PHQ9<10

ttest Gender, by(D) unequal

*b.Willingness to Work and Tiredness proxy Summary
sum W5tilde W5 W5perpoundtilde W3perpound W7perpound
sum t1 t2
reg tiredgrowth PHQ9 $controls

*c.Distribution graphs: forecast and actual willingness to work for £5, the PHQ-9 score
kdensity PHQ9, xtitle(PHQ-9 Score) title(Kernel Density of PHQ-9 Scores in Sample) scheme(s2mono)
kdensity W5tilde, addplot((kdensity W5)) ytitle(Density) xtitle(Number of Tasks) title(Kernel Density of Predicted and Actual WTW for £5) legend(on order(1 "Predicted" 2 "Actual")) scheme(s2mono)

*d. Detailed summary of PHQ-9
sum PHQ9_1 PHQ9_2 PHQ9_3 PHQ9_4 PHQ9_5 PHQ9_6 PHQ9_7 PHQ9_8 PHQ9_9
tab PHQ9_1
tab PHQ9_2
tab PHQ9_3
tab PHQ9_4
tab PHQ9_5
tab PHQ9_6
tab PHQ9_7
tab PHQ9_8
tab PHQ9_9

**2. Assessing the effect of depression (PHQ-9) on WTW ---> H_0^2: beta_PHQ9 < 0
reg W5 PHQ9
reg W5 PHQ9 $controls
reg W5tilde PHQ9
reg W5tilde PHQ9 $controls

reg W3 PHQ9
reg W3 PHQ9 $controls
reg W7 PHQ9
reg W7 PHQ9 $controls

**3. Assessing the effect of depression (PHQ-9) on projection using alpha ---> H_0^3: beta_PHQ9 < 0
reg alphaind5 PHQ9 $controls
reg alphaind7 PHQ9 $controls
reg alphaind3 PHQ9 $controls

******************************************************
*** Stacked Dataset ***
clear all
import excel "C:\Users\Batmanov_Alisher\Desktop\D&PB_Dataset.xlsx", sheet("Stacked_Dataset") firstrow

* Create some new variables
gen indW5_PHQ9 = indW5 * PHQ9
gen indW7perpound_PHQ9 = indW7perpound * PHQ9
gen indW3perpound_PHQ9 = indW3perpound * PHQ9

global controls Durationinseconds age children full_time white Gender highest_high_school highest_undergrad highest_grad hhinc1020 hhmembers marr student Vision

drop if Durationinseconds<900

**1. Assessing projection of fresh state onto tired one ---> H_0^1: beta_indW# < 0
reg W5long indW5
reg W7perpoundlong indW7perpound
reg W3perpoundlong indW3perpound

**2. Assessing the effect of depression (PHQ-9) on projection ---> H_0^3: beta_indW#long_PHQ9 > 0
reg W5long indW5 PHQ9 indW5_PHQ9 $controls
reg W7perpoundlong indW7perpound PHQ9 indW7perpound_PHQ9 $controls
reg W3perpoundlong indW3perpound PHQ9 indW3perpound_PHQ9 $controls