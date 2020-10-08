************************************************************************************
** file: \\stm_analysis\do\stm_2003r_former.do
** Programmer: james r. hull
** Date started: 2012 05 20
** Date finished: 2012 05 21
** Updates: None at Present
** Data Input:  w_subtable_q89_99_former_history.dta
**              stm2003r_link.dta
**              stm2003r_hh.dta
** Data Output: stm2003r_former.dta
**              stm2003r_former_public.dta
** STATA Version: 11
** Purpose: Complete Merge and Clean of 2003 Rural Santarem Individual-Level Data
** Notes: 
************************************************************************************

****************************************************************************************

***********************************************************************************************
**************************************************************** SET ENVIRONMENTAL PARAMETERS
***********************************************************************************************

capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_former", replace text

* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
cd "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\data\stm_2003r\data\stata\"

* Tell Stata to create all new variables in type double in order to prevent truncation of ID vars and so forth
set type double, permanently

* Tell Stata not to pause in displaying results of this do-file
set more off

****************************************************************************************

******************************************************************************************************************
**************************************************************** CLEANING AND FORMATTING OF INDIVIDUAL DATA FILES
******************************************************************************************************************

***************************************************************************************************
** 1. Format w_subtable_q74_88_former_members.dta
*******************************************************

**************************************************************
** ADD NEW IDENTIFIERS

** Prepare Linking File - just property level first

use stm2003r_link.dta, clear
keep id_prop id_house id_prop_hh id_w_number id_woman form_former form_fhead id_former id_person
drop if id_former==9999999998
sort id_w_number
gen tempsort=_n
save add0001.dta, replace

** Merge New Property-level Identifiers onto existing file

use w_subtable_q74_88_former_members.dta, clear
rename wintrno id_w_number
rename id id_other
sort id_w_number
gen tempsort=_n

merge 1:1 tempsort using add0001.dta, update replace
tab _merge
drop if _merge==2
drop _merge 
drop tempsort form_former form_fhead
order id_prop id_house id_prop_hh id_person id_w_number id_woman id_former id_other, first
save stm_2003r_former.dta, replace

**************************************************************
** DROP JUNK AND QUESTIONABLE VARIABLES
drop key _4w_75a

**************************************************************
** RECODES and RENAMES

*_4w_02
rename _4w_02 id_name_a

*_4w_74
rename _4w_74 w74
replace w74=0 if w74==1
replace w74=1 if w74==2

*_4w_75
rename _4w_75 w75a

*_4w_76
rename _4w_76 w76_month
replace w76_month=9999 if w76_month==99

*_4w_76a
rename _4w_76a w76_year

*_4w_77
rename _4w_77 w77
replace w77=9999 if w77==9

*_4w_77a
rename _4w_77a w77a
replace w77a="9998" if w77a=="8888"
replace w77a="9999" if w77a==""

*_4w_78
rename _4w_78 w78


*_4w_79
rename _4w_79 w79

*_4w_79a
rename _4w_79a w79a
replace w79a="9998" if w79a=="8888"
replace w79a="9999" if w79a==""

*_4w_80
rename _4w_80 w80_month
replace w80=9999 if w80==99
replace w80=9999 if w80==0
replace w80=9999 if w80==999

*_4w_80a
rename _4w_80a w80_year

*_4w_81
rename _4w_81 w81

*_4w_81a
rename _4w_81a w81a
replace w81a="9998" if w81a=="8888"

*_4w_82
rename _4w_82 w82a
replace w82a="9998" if w82a=="8888"
replace w82a="9999" if w82a==""

*_4w_83
rename _4w_83 w83

*_4w_84
rename _4w_84 w84
replace w84=9999 if w84==999
replace w84=9999 if w84==.
replace w84=9998 if w84==0

*_4w_85
rename _4w_85 w85
replace w85=9999 if w85==9
replace w85=9999 if w85==.
replace w85=9998 if w85==8
replace w85=9998 if w85==0

*_4w_85a
rename _4w_85a w85a
replace w85a="9999" if w85a=="9"
replace w85a="9998" if w85a=="8888"
replace w85a="9998" if w85a==""

*_4w_86
rename _4w_86 w86
replace w86=9998 if w86==0

*_4w_87
rename _4w_87 w87
replace w87=9999 if w87==9
replace w87=9999 if w87==.
replace w87=9998 if w87==8
replace w87=9998 if w87==0

*_4w_87a
rename _4w_87 w87a
replace w87a="9999" if w87a=="9"
replace w87a="9998" if w87a=="8888"
replace w87a="9998" if w87a==""

*_4w_88
rename _4w_88 w88
replace w88=9998 if w88==0

**************************************************************
** ADD VARIABLE DESCRIPTIONS

label variable id_w_number "Num: Woman interview number for linking [form]"
label variable id_other "Num: Former HH member ID on paper forms [form]"
label variable id_former "Num: Unique ID for each person listed on former HH member form [created]"             
label variable id_name_a "String: Name of former household member [form]"
label variable w74 "Dichot: Other household member is male [w74]"
label variable w75a "String: Relation to interviewee/dona [w75]"
label variable w76_month "Num: Date joined HH (month) [w76]"
label variable w76_year "Num: Date joined HH (year) [w76]"
label variable w77 "Cat: Reason for moving in [w77]"
label variable w77a "String: Text of other reason for moving in [w77]"
label variable w78 "Dichot: Worked on property while in HH [w78]"
label variable w79 "Dichot: Had outside job while in HH [w79]"
label variable w79a "String: Text of other outside job while in HH [w79]"
label variable w80_month "Num: Date left the property (month) [w80]"
label variable w80_year "Num: Date left the property (year) [w80]"
label variable w81 "Cat: Reason for leaving [w74]"
label variable w81a "String: Text of other reason for leaving [w81]"
label variable w82a "String: Text of where did person go [w82]"
label variable w83 "Dichot: Still in contact with person [w83]"
label variable w84 "Num: Number of visits in last year [w84]"
label variable w85 "Cat: How did person contribute to HH last year [w85]"
label variable w85a "String: Text of other way person contributed last year [w85]"
label variable w86 "Num: If person sent money, how much [w86]"
label variable w87 "Cat: How did HH contribute to person last year [w87]"
label variable w87a "String: Text of other way HH contributed last year [w87]"
label variable w88 "Num: If HH sent money, how much [w88]"

**************************************************************
** ADD VALUE LABELS

label define w74_lb 0 "No" 1 "Yes"
label define w77_lb 1 "Got married" 2 "To work" 3 "to study" 4 "Conflict" 5 "Other"
label define w78_lb 0 "No" 1 "Yes"
label define w79_lb 0 "No" 1 "Yes"
label define w81_lb 1 "Got married" 2 "To work" 3 "to study" 4 "Conflict" 5 "Other"
label define w83_lb 0 "No" 1 "Yes"
label define w85_lb 1 "Did not contribute" 2 "Money" 3 "Work" 4 "Other"
label define w87_lb 1 "Did not contribute" 2 "Money" 3 "Work" 4 "Other"

label values w74 w74_lb
label values w77 w77_lb
label values w78 w78_lb
label values w79 w79_lb
label values w81 w81_lb
label values w83 w83_lb
label values w85 w85_lb
label values w87 w87_lb

label data "2003 Santarem Rural: Former Household Member Roster"

**************************************************************
** REPORT, CODEBOOK, AND SAVE

describe, short
save stm2003r_former.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_former_codebook", replace
codebook, header all 
capture log close

**************************************************************
** SWAP OUT IDENTIFIERS FOR RANDOMIZED (PUBLIC) IDENTIFIERS

* Prepare linking file for later merging

use stm2003r_link.dta, clear
keep id_prop_rand id_house_rand id_prop_hh_rand id_w_number id_former
sort id_former
by id_former: gen dup=_n
drop if dup>1
drop if id_former==9999999998
drop dup
save id_add_02.dta, replace

use stm2003r_former.dta, clear
sort id_former
merge m:1 id_former using id_add_02.dta, update replace
drop if _merge==2
drop _merge id_prop id_house id_prop_hh id_w_number id_woman
order id_prop_rand id_house_rand id_prop_hh_rand, first
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

save stm2003r_former_public.dta, replace

**************************************************************
** DELETE IDENTIFYING VARIABLES FOR PUBLIC DATASET

use stm2003r_former_public.dta, clear
drop id_name_a id_former id_other w76_month w77a w79a w80_month w81a w82a w85a w87a

**************************************************************
** CODEBOOK AND SAVE PUBLIC VERSION

label data "2003 Santarem Rural: Former Household Member Roster Public"

describe, short
save stm2003r_former_public.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_former_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_01.dta
capture erase id_add_02.dta
capture erase add0001.dta
