************************************************************************************
** file: \\stm_analysis\do\stm_2003r_child.do
** Programmer: james r. hull
** Date started: 2012 05 17
** Date finished: 2012 05 17
** Updates: None at Present
** Data Input: w_subtable_q50_67_children.dta
**             stm2003r_link.dta
**             stm2003r_hh.dta
** Data Output: stm2003r_child.dta
**              stm2003r_child_public.dta
** STATA Version: 11
** Purpose: Complete Clean of 2003 Rural Santarem Child Roster Data
** Notes: 
************************************************************************************

****************************************************************************************

***********************************************************************************************
**************************************************************** SET ENVIRONMENTAL PARAMETERS
***********************************************************************************************

capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_child", replace text

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
** 1. Format w_subtable_q50_67_children.dta 
*******************************************************

**************************************************************
** ADD NEW IDENTIFIERS

** Prepare Linking File

use stm2003r_link.dta, clear
keep id_prop id_house id_prop_hh id_roster id_w_number id_person id_mother id_child
drop if id_child==9999999998
sort id_child
by id_child: gen dup=_n
drop if dup>1
drop dup
save add0001.dta, replace

** Merge New Identifiers onto existing file

use w_subtable_q50_67_children.dta, clear
rename childid id_child
sort id_child
format id_child %12.0g

merge 1:1 id_child using add0001.dta, update replace
tab _merge
drop if _merge==2
drop _merge 
drop propid houseid prop_hh_id motherid hhrostermother id
rename motheralive_ id_mother_alive
rename registro_ id_registro_w
rename otherwoman_ id_other_woman
rename donalote_ id_dona
order id_registro_w id_other_woman id_dona, after(id_child)
order id_prop id_house id_prop_hh id_w_number id_mother id_roster id_person, first
order id_mother_alive, after (id_dona)

**************************************************************
** RECODES and RENAMES

*w50
rename _3w_50a id_name_a

*w50
rename _3w_50 w50
replace w50=0 if w50==1
replace w50=1 if w50==2
replace w50=9999 if w50==3
replace w50=9999 if w50==.

*w51
rename _3w_51 w51_month
rename _3w_51a w51_year
replace w51_month=9998 if w51_month==0
replace w51_month=9999 if w51_month==99
replace w51_month=9998 if w51_month==88
replace w51_month=9999 if w51_month==.

replace w51_year=9999 if w51_year==.

*w52
rename _3w_52 w52a
replace w52a="9999" if w52a==""

*w53
rename _3w_53 w53
replace w53=9999 if w53==9
replace w53=9999 if w53==.

*w54
rename _3w_54 w54

*w55
rename _3w_55 w55a
replace w55a="9999" if w55a==""
replace w55a="9998" if w55a=="8888"

*w56
rename _3w_56 w56_month
rename _3w_56a w56_year

replace w56_month=9999 if w56_month==.
replace w56_month=9999 if w56_month==99
replace w56_month=9998 if w56_month==88
replace w56_month=9998 if w56_month==8888

replace w56_year=9998 if w56_year==8888
replace w56_year=9999 if w56_year==.

*w57
rename _3w_57 w57a
replace w57a="9999" if w57a==""
replace w57a="9998" if w57a=="8888"

*w58
rename _3w_58 w58_month
rename _3w_58a w58_year

replace w58_month=9999 if w58_month==.
replace w58_month=9999 if w58_month==99
replace w58_month=9998 if w58_month==88
replace w58_month=9998 if w58_month==0

replace w58_year=9999 if w58_year==.
replace w58_year=9998 if w58_year==8888
replace w58_year=9998 if w58_year==0

*w59
rename _3w_59 w59
rename _3w_59a w59a

replace w59=9999 if w59==.
replace w59=9999 if w59==9
replace w59=9998 if w59==8888
replace w59=9998 if w59==8
replace w59=9998 if w59==0

replace w59a="9999" if w59a==""
replace w59a="9998" if w59a=="8888"

*w60
rename _3w_60 w60

replace w60=9999 if w60==.
replace w60=9998 if w60==8888
replace w60=9998 if w60==888
replace w60=9999 if w60==999

*w61
rename _3w_61 w61
rename _3w_61a w61a

replace w61=9998 if w61==8
replace w61=9999 if w61==9
replace w61=9998 if w61==0
replace w61=9999 if w61==.
replace w61a="9999" if w61a==""
replace w61a="9998" if w61a=="8888"

*w62
rename _3w_62 w62

replace w62=9999 if w62==.
replace w62=9998 if w62==8888

*w63
rename _3w_63 w63
rename _3w_63a w63a

replace w63=9999 if w63==.
replace w63=9999 if w63==9
replace w63=9998 if w63==8
replace w63=9998 if w63==0

replace w63a="9999" if w63a==""
replace w63a="9998" if w63a=="8888"

*64
rename _3w_64 w64

replace w64=9999 if w64==.
replace w64=9998 if w64==8888

*65
rename _3w_65 w65

replace w65=9999 if w65==.
replace w65=9999 if w65==99
replace w65=9999 if w65==999
replace w65=9998 if w65==88
replace w65=9998 if w65==8888

*66
rename _3w_66 w66

replace w66=9999 if w66==.
replace w66=9999 if w66==9
replace w66=9998 if w66==8
replace w66=9998 if w66==0

replace w66=9999 if w66==3

*67
rename _3w_67 w67
rename _3w_67a w67a

replace w67=9999 if w67==.
replace w67=9999 if w67==9
replace w67=9998 if w67==8
replace w67=9998 if w67==0

replace w67a="9998" if substr(w67a,1,4)=="8888"
replace w67a="9999" if substr(w67a,1,4)=="9999"
replace w67a="9999" if w67a==""

**************************************************************
** DROP JUNK AND QUESTIONABLE VARIABLES

drop childbirth childorder idademorte idademortefonte hhrosterchd 

**************************************************************
** ADD VARIABLE DESCRIPTIONS

label variable id_registro_w "Dichot: Responses based upon information from the register [form]"
label variable id_other_woman "Dichot: Mother is listed as an other woman in Household [form]"
label variable id_dona "Dichot: Mother is the dona of the lot [form]"
label variable id_mother_alive "Dichot: Mother is alive [form]"
label variable w50 "Dichot: Child is male [w50]"
label variable w51_month "Num: Date of birth (month) [w51]"
label variable w51_year "Num: Date of birth (year) [w51]"
label variable w52a "String: Location of Birth [w52]"
label variable w53 "Cat: Place of Birth [w53]"
label variable w54 "Dichot: Is child still alive [w54]"
label variable w55a "String: Cause of death [w55]"
label variable w56_month "Num: Date of death (month) [w56]"
label variable w56_year "Num: Date of death (year) [w56]"
label variable w57a "String: Where does child live [w57]"
label variable w58_month "Num: Date child moved out (month) [w58]"
label variable w58_year "Num: Date child moved out (year) [w58]"
label variable w59 "Cat: Reason child moved out [w59]"
label variable w59a "String: Text of reason child moved out [w59]"
label variable w60 "Num: Visits from child in the last year [w60]"
label variable w61 "Cat: Did child contribute to household in last year [w61]"
label variable w61a "String: Text of other child contribution in last year [w61]"
label variable w62 "Num: Amount of child monetary contribution (Reais) [w62]"
label variable w63 "Cat: Did household contribute to child in last year [w63]"
label variable w63a "String: Text of other household contribution in last year [w63]"
label variable w64 "Num: Amount of household monetary contribution (Reais) [w64]"
label variable w65 "Num: Years of education completed [w65]"
label variable w66 "Cat: Marital status of child [w66]"
label variable w67 "Cat: Main occupation of child [w67]"
label variable w67a "String: Text of other main occupation of child [w67]"

**************************************************************
** ADD VALUE LABELS

label define id_registro_w_lb 0 "No" 1 "Yes" 
label define id_other_woman_lb 0 "No" 1 "Yes" 
label define id_dona_lb 0 "No" 1 "Yes" 
label define id_mother_alive_lb 0 "No" 1 "Yes" 
label define w50_lb 0 "No" 1 "Yes"
label define w53_lb 1 "Hospital" 2 "Home" 3 "Other"
label define w54_lb 0 "No" 1 "Yes"
label define w59_lb 1 "Got Married" 2 "Work" 3 "To study" 4 "Conflict" 5 "Other"
label define w61_lb 1 "Did not contribute" 2 "Money" 3 "Work" 4 "Other"
label define w63_lb 1 "Did not contribute" 2 "Money" 3 "Work" 4 "Other"
label define w66_lb 1 "Single" 2 "Married" 4 "Separated/Divorced" 5 "Widow(er)"
label define w67_lb 1 "Agropastoral" 2 "Business" 3 "Professional" 4 "Domestic Work" 5 "Other" 6 "None"

label values id_registro_w id_registro_w_lb
label values id_other_woman id_other_woman_lb
label values id_dona id_dona_lb
label values id_mother_alive id_mother_alive_lb
label values w50 w50_lb
label values w53 w53_lb
label values w54 w54_lb
label values w59 w59_lb
label values w61 w61_lb
label values w63 w63_lb
label values w66 w66_lb
label values w67 w67_lb

label data "2003 Santarem Rural: Child Roster"

**************************************************************
** REPORT, CODEBOOK, AND SAVE

describe, short
save stm2003r_child.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_child_codebook", replace
codebook, header all 
capture log close

**************************************************************
** SWAP OUT IDENTIFIERS FOR RANDOMIZED (PUBLIC) IDENTIFIERS

* Prepare linking file for later merging

use stm2003r_link.dta, clear
keep id_prop_rand id_house_rand id_prop_hh_rand id_child
sort id_child
by id_child: gen dup=_n
drop if dup>1
drop if id_child==9999999998
drop dup
save id_add_02.dta, replace

use stm2003r_child.dta, clear
sort id_child
merge 1:1 id_child using id_add_02.dta, update replace
drop if _merge==2
drop _merge id_prop id_house id_prop_hh id_mother id_w_number id_roster id_child
order id_prop_rand id_house_rand id_prop_hh_rand, first
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

save stm2003r_child_public.dta, replace

**************************************************************
** DELETE IDENTIFYING VARIABLES FOR PUBLIC DATASET

use stm2003r_child_public.dta, clear
drop id_name_a w51_month w52a w55a w57a w59a w61a w63a w67a w56_month w58_month 

**************************************************************
** CODEBOOK AND SAVE PUBLIC VERSION

label data "2003 Santarem Rural: Child Roster Public"

describe, short
save stm2003r_child_public.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_child_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_01.dta
capture erase id_add_02.dta
capture erase add0001.dta
