************************************************************************************
** file: \\stm_analysis\do\stm_2003r_cont.do
** Programmer: james r. hull
** Date started: 2012 05 17
** Date finished: 2012 05 19
** Updates: Bug Fixes 2012 06 19
** Data Input:  w_subtable_q68_73_contraception.dta
**              stm2003r_link.dta
**              stm2003r_hh.dta
** Data Output: stm2003r_cont.dta
**              stm2003r_cont_public.dta
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
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_cont", replace text

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
** 1. Format w_subtable_q68_73_contraception.dta
*******************************************************

**************************************************************
** ADD NEW IDENTIFIERS

** Prepare Linking File

use stm2003r_link.dta, clear
keep id_prop id_house id_prop_hh id_roster id_person
drop if id_roster==9999999998
sort id_roster
by id_roster: gen dup=_n
drop if dup>1
drop dup
save add0001.dta, replace

** Merge New Identifiers onto existing file

use w_subtable_q68_73_contraception.dta, clear
rename personid id_roster
sort id_roster

merge 1:1 id_roster using add0001.dta, update replace
tab _merge
drop if _merge==2
drop _merge 
drop wpropid whouseid wprop_hh_id womanhhroster
rename registro_ id_registro_w
rename otherwoman_ id_other_woman
rename donalote_ id_dona
order id_prop id_house id_prop_hh id_roster id_person, first

**************************************************************
** DROP JUNK AND QUESTIONABLE VARIABLES


**************************************************************
** RECODES and RENAMES

rename dataentr int_entry
rename wintrvr int_interviewer_w
rename w1 id_name_a
rename notes int_notes
* format int_notes  %-20s

gen time=dofc(timstamp)
gen year=year(time)
gen month=month(time)
gen day=day(time)
tostring year, replace
tostring month, replace
tostring day, replace
replace month="0"+substr(month,1,1) if substr(month,-2,1)==""
replace day="0"+substr(day,1,1) if substr(day,-2,1)==""
gen int_entered=year+"/"+month+"/"+day
drop time year month day timstamp

gen int_cont_data=.
replace int_cont_data=1 if contraception_data=="Yes"
replace int_cont_data=9999 if contraception_data=="9999"
replace int_cont_data=3 if contraception_data=="SemAtividade"
replace int_cont_data=2 if contraception_data=="8888"
drop contraception_data

order id_name int_interviewer_w int_entry int_entered int_notes int_cont_data, after (id_dona)

*w68_6a
replace w68_6a="9998" if w68_6a==""

*w68_9a
replace w68_9a="9998" if w68_9a==""

*w69_2a
rename w69_a1 w69_2_month
replace w69_2_month=9999 if w69_2_month==99
replace w69_2_month=9998 if w69_2_month==88

rename w69_a2 w69_2_year
replace w69_2_year=9998 if w69_2_year==8888

*w69
rename w69_b w69_3a
replace w69_3a="9998" if w69_3a=="8888"

rename w69_c w69_4a
replace w69_4a="9998" if w69_4a=="8888"

rename w69_d w69_5a
replace w69_5a="9998" if w69_5a=="8888"

*w70
replace w70=9999 if w70==9
replace w70=9998 if w70==8

*w71_6a
replace w71_6a="9998" if w71_6a=="8888"
replace w71_6a="9998" if w71_6a==""

*w72_1a
rename w72_1a w72_1_1

*w72_1b
rename w72_1b w72_1_2

*w72_2b
rename w72_2b w72_2_2

replace w72_2_2=9999 if w72_2_2==99
replace w72_2_2=9998 if w72_2_2==88
replace w72_2_2=12 if w72_2_2==13
replace w72_2_2=12 if w72_2_2==15

*w72_2b
rename w72_2ba w72_2_2a

replace w72_2_2a="9999" if w72_2_2a==""
replace w72_2_2a="9998" if w72_2_2a=="8888"

*w72_1c
rename w72_1c w72_1_3

*w72_2c
rename w72_2c w72_2_3

replace w72_2_3=9999 if w72_2_3==99
replace w72_2_3=9998 if w72_2_3==88
replace w72_2_3=12 if w72_2_3==15

*w72_2c
rename w72_2ca w72_2_3a

replace w72_2_3a="9999" if w72_2_3a==""
replace w72_2_3a="9998" if w72_2_3a=="8888"

*w72_1d
rename w72_1d w72_1_4

*w72_2d
rename w72_2d w72_2_4

replace w72_2_4=9999 if w72_2_4==99
replace w72_2_4=9998 if w72_2_4==88
replace w72_2_4=12 if w72_2_4==13

*w72_2d
rename w72_2da w72_2_4a

replace w72_2_4a="9999" if w72_2_4a==""
replace w72_2_4a="9998" if w72_2_4a=="8888"

*w72_1e
rename w72_1e w72_1_5

*w72_2e
rename w72_2e w72_2_5

replace w72_2_5=9999 if w72_2_5==99
replace w72_2_5=9998 if w72_2_5==88
replace w72_2_5=12 if w72_2_5==13
replace w72_2_5=12 if w72_2_5==15

*w72_2e
rename w72_2ea w72_2_5a

replace w72_2_5a="9999" if w72_2_5a==""
replace w72_2_5a="9998" if w72_2_5a=="8888"
replace w72_2_5a="9999" if w72_2_5a=="99"

*w72_1f
rename w72_1f w72_1_6

*w72_2f
rename w72_2f w72_2_6

replace w72_2_6=9999 if w72_2_6==99
replace w72_2_6=9998 if w72_2_6==88

*w72_2f
rename w72_2fa w72_2_6a

replace w72_2_6a="9999" if w72_2_6a==""
replace w72_2_6a="9998" if w72_2_6a=="8888"

*w72_1g
rename w72_1g w72_1_7

*w72_1ga
rename w72_1ga w72_1_7a

replace w72_1_7a="9999" if w72_1_7a==""
replace w72_1_7a="9998" if w72_1_7a=="8888"

*w72_2g
rename w72_2g w72_2_7

replace w72_2_7=9999 if w72_2_7==99
replace w72_2_7=9998 if w72_2_7==88
replace w72_2_7=12 if w72_2_7==13

*w72_2g
rename w72_2ga w72_2_7a

replace w72_2_7a="9999" if w72_2_7a==""
replace w72_2_7a="9998" if w72_2_7a=="8888"

*w72_3
rename w72_3a w72_3_0
rename w72_3b w72_3_2
rename w72_3c w72_3_3
rename w72_3d w72_3_4
rename w72_3e w72_3_5
rename w72_3f w72_3_6
rename w72_3g w72_3_7
rename w72_3ga w72_3_7a

replace w72_3_0=9998 if w72_3_0==88
replace w72_3_0=9999 if w72_3_0==99
replace w72_3_0=9998 if w72_3_0==0
replace w72_3_0=12 if w72_3_0==13
replace w72_3_0=12 if w72_3_0==14

*w73_10a
replace w73_10a="9998" if w73_10a=="8888"

**************************************************************
** ADD VARIABLE DESCRIPTIONS

label variable id_registro_w "Dichot: Source of information from female is household register [form]"
label variable id_roster "Num: Household roster ID variable for linking [form]"
label variable int_cont_data "Cat: Do you use anything as a contraceptive method [form]"
label variable id_other_woman "Dichot: Woman reporting is other woman on lot [form]"
label variable id_dona "Dichot: Woman reporting is dona do lote (female head of lot) [form]"
label variable id_name_a "String: Name of female respondent [form]"
label variable int_interviewer_w "String: Primary interviewer name [created]"
label variable int_entry "String: Name of person who entered data [created]"
label variable int_entered "String: Year/month/day of data entry [created]"
label variable int_notes "String: Miscellaneous interview notes from the field [form]"
label variable w68_1 "Dichot: Where do you find contraceptive information: doctor [w68]"
label variable w68_2 "Dichot: Where do you find contraceptive information: family member [w68]"
label variable w68_3 "Dichot: Where do you find contraceptive information: friend/neighbor [w68]"
label variable w68_4 "Dichot: Where do you find contraceptive information: church [w68]"
label variable w68_5 "Dichot: Where do you find contraceptive information: radio/tv [w68]"
label variable w68_6 "Dichot: Where do you find contraceptive information: ngo [w68]"
label variable w68_6a "String: Text of find contraceptive information from which ngo [w68]"
label variable w68_7 "Dichot: Where do you find contraceptive information: school [w68]"
label variable w68_8 "Dichot: Where do you find contraceptive information: never receive any [w68]"
label variable w68_9 "Dichot: Where do you find contraceptive information: other source [w68]"
label variable w68_9a "String: Text of find contraceptive information from other source [w68]"
label variable w69 "Dichot: Were you sterilized [w69]"
label variable w69_2_month "Num: Date sterilized (month) [w69]"
label variable w69_2_year "Num: Date sterilized (year) [w69]"
label variable w69_3a "String: Where were you sterilized [w69]"
label variable w69_4a "String: Who paid for sterilization [w69]"
label variable w69_5a "String: Who suggested sterilization [w69]"
label variable w70 "Cat: Do you use or do anything as a contraceptive method [w70]"
label variable w71_1 "Dichot: What methods do you currently use: contraceptive pills [w71]"
label variable w71_2 "Dichot: What methods do you currently use: contraceptive injection [w71]"
label variable w71_3 "Dichot: What methods do you currently use: calendar/rhythm method [w71]"
label variable w71_4 "Dichot: What methods do you currently use: condoms [w71]"
label variable w71_5 "Dichot: What methods do you currently use: withdrawal [w71]"
label variable w71_6 "Dichot: What methods do you currently use: other method [w71]"
label variable w71_6a "String: Text of other contraceptive methods you currently use [w71]"

label variable w72_1_1 "Dichot: Never used any method of contraception [w72]"
label variable w72_1_2 "Dichot: Used contraception in the past: pills [w72]"
label variable w72_2_2 "Cat: Reason for quitting contraceptive: pills [w72]"
label variable w72_2_2a "String: Text of other reason for quitting: pills [w72]"
label variable w72_1_3 "Dichot: Used contraception in the past: injection [w72]"
label variable w72_2_3 "Cat: Reason for quitting contraceptive: injection [w72]"
label variable w72_2_3a "String: Text of other reason for quitting: injection [w72]"
label variable w72_1_4 "Dichot: Used contraception in the past: calendar/rhythm [w72]"
label variable w72_2_4 "Cat: Reason for quitting contraceptive: calendar/rhythm [w72]"
label variable w72_2_4a "String: Text of other reason for quitting: calendar/rhythm [w72]"
label variable w72_1_5 "Dichot: Used contraception in the past: condom [w72]"
label variable w72_2_5 "Cat: Reason for quitting contraceptive: condom [w72]"
label variable w72_2_5a "String: Text of other reason for quitting: condom [w72]"
label variable w72_1_6 "Dichot: Used contraception in the past: withdrawel [w72]"
label variable w72_2_6 "Cat: Reason for quitting contraceptive: withdrawel [w72]"
label variable w72_2_6a "String: Text of other reason for quitting: withdrawel [w72]"
label variable w72_1_7 "Dichot: Used contraception in the past: other method [w72]"
label variable w72_1_7a "String: Text of other contraception use in the past [w72]"
label variable w72_2_7 "Cat: Reason for quitting contraceptive: other method [w72]"
label variable w72_2_7a "String: Text of other reason for quitting: other method [w72]"

label variable w72_3 "Dichot: Used contraception before birth of first child: none [w72]"
label variable w72_3_0 "Num: How many children did you have when you started using contraceptive methods [w72]"
label variable w72_3_2 "Dichot: Used contraception before birth of first child: pills [w72]"
label variable w72_3_3 "Dichot: Used contraception before birth of first child: injection [w72]"
label variable w72_3_4 "Dichot: Used contraception before birth of first child: calendar/rhythm [w72]"
label variable w72_3_5 "Dichot: Used contraception before birth of first child: condom [w72]"
label variable w72_3_6 "Dichot: Used contraception before birth of first child: withdrawal [w72]"
label variable w72_3_7 "Dichot: Used contraception before birth of first child: other [w72]"
label variable w72_3_7a "String: Text of other contraceptive use before birth of first child [w72]"

label variable w73_1 "Dichot: Why did you never use any contraceptive: didn't know about them [w73]"
label variable w73_2 "Dichot: Why did you never use any contraceptive: spouse had surgery [w73]"
label variable w73_3 "Dichot: Why did you never use any contraceptive: health problems [w73]"
label variable w73_4 "Dichot: Why did you never use any contraceptive: expensive methods [w73]"
label variable w73_5 "Dichot: Why did you never use any contraceptive: lack of accessibility [w73]"
label variable w73_6 "Dichot: Why did you never use any contraceptive: difficult to use [w73]"
label variable w73_7 "Dichot: Why did you never use any contraceptive: spouse opposed to it [w73]"
label variable w73_8 "Dichot: Why did you never use any contraceptive: religious reasons [w73]"
label variable w73_9 "Dichot: Why did you never use any contraceptive: wanted more children [w73]"
label variable w73_10 "Dichot: Why did you never use any contraceptive: other [w73]"
label variable w73_10a "String: Text of other reason woman never used any contraceptive [w73]"

**************************************************************
** ADD VALUE LABELS

label define id_registro_w_lb 0 "No" 1 "Yes"
label define id_other_woman_lb 0 "No" 1 "Yes"
label define id_dona_lb 0 "No" 1 "Yes"
label define int_cont_data_lb 1 "Dona or Other Woman Answered" 2 "Dona da Casa is Man" 3 "Without Activity (Virgem)"
label define w68_1_lb 0 "No" 1 "Yes"
label define w68_2_lb 0 "No" 1 "Yes"
label define w68_3_lb 0 "No" 1 "Yes"
label define w68_4_lb 0 "No" 1 "Yes"
label define w68_5_lb 0 "No" 1 "Yes"
label define w68_6_lb 0 "No" 1 "Yes"
label define w68_7_lb 0 "No" 1 "Yes"
label define w68_8_lb 0 "No" 1 "Yes"
label define w68_9_lb 0 "No" 1 "Yes"
label define w69_lb 0 "No" 1 "Yes"
label define w70_lb 1 "Yes" 2 "No" 3 "Currently Pregnant" 4 "Post-menopausal"

label define w71_1_lb 0 "No" 1 "Yes"
label define w71_2_lb 0 "No" 1 "Yes"
label define w71_3_lb 0 "No" 1 "Yes"
label define w71_4_lb 0 "No" 1 "Yes"
label define w71_5_lb 0 "No" 1 "Yes"
label define w71_6_lb 0 "No" 1 "Yes"

label define w72_1_1_lb 0 "No" 1 "Yes"
label define w72_1_2_lb 0 "No" 1 "Yes"
label define w72_2_2_lb 1 "Had Surgery" 2 "Husband Had Surgery" 3 "Health Problems" 4 "Expensive Methods" 5 "Lack of Accessibility"  6 "Difficult to Use" 7 "Husband Opposed It" 8 "Religious Reasons" 9 "Wanted More Children" 10 "Menopause" 11 "Method Didn't Work" 12 "Other"
label define w72_1_3_lb 0 "No" 1 "Yes"
label define w72_2_3_lb 1 "Had Surgery" 2 "Husband Had Surgery" 3 "Health Problems" 4 "Expensive Methods" 5 "Lack of Accessibility"  6 "Difficult to Use" 7 "Husband Opposed It" 8 "Religious Reasons" 9 "Wanted More Children" 10 "Menopause" 11 "Method Didn't Work" 12 "Other"
label define w72_1_4_lb 0 "No" 1 "Yes"
label define w72_2_4_lb 1 "Had Surgery" 2 "Husband Had Surgery" 3 "Health Problems" 4 "Expensive Methods" 5 "Lack of Accessibility"  6 "Difficult to Use" 7 "Husband Opposed It" 8 "Religious Reasons" 9 "Wanted More Children" 10 "Menopause" 11 "Method Didn't Work" 12 "Other"
label define w72_1_5_lb 0 "No" 1 "Yes"
label define w72_2_5_lb 1 "Had Surgery" 2 "Husband Had Surgery" 3 "Health Problems" 4 "Expensive Methods" 5 "Lack of Accessibility"  6 "Difficult to Use" 7 "Husband Opposed It" 8 "Religious Reasons" 9 "Wanted More Children" 10 "Menopause" 11 "Method Didn't Work" 12 "Other"
label define w72_1_6_lb 0 "No" 1 "Yes"
label define w72_2_6_lb 1 "Had Surgery" 2 "Husband Had Surgery" 3 "Health Problems" 4 "Expensive Methods" 5 "Lack of Accessibility"  6 "Difficult to Use" 7 "Husband Opposed It" 8 "Religious Reasons" 9 "Wanted More Children" 10 "Menopause" 11 "Method Didn't Work" 12 "Other"
label define w72_1_7_lb 0 "No" 1 "Yes"
label define w72_2_7_lb 1 "Had Surgery" 2 "Husband Had Surgery" 3 "Health Problems" 4 "Expensive Methods" 5 "Lack of Accessibility"  6 "Difficult to Use" 7 "Husband Opposed It" 8 "Religious Reasons" 9 "Wanted More Children" 10 "Menopause" 11 "Method Didn't Work" 12 "Other"
label define w72_3_lb 0 "No" 1 "Yes"

label define w72_3_1_lb 0 "No" 1 "Yes"
label define w72_3_2_lb 0 "No" 1 "Yes"
label define w72_3_3_lb 0 "No" 1 "Yes"
label define w72_3_4_lb 0 "No" 1 "Yes"
label define w72_3_5_lb 0 "No" 1 "Yes"
label define w72_3_6_lb 0 "No" 1 "Yes"
label define w72_3_7_lb 0 "No" 1 "Yes"

label define w73_1_lb 0 "No" 1 "Yes"
label define w73_2_lb 0 "No" 1 "Yes"
label define w73_3_lb 0 "No" 1 "Yes"
label define w73_4_lb 0 "No" 1 "Yes"
label define w73_5_lb 0 "No" 1 "Yes"
label define w73_6_lb 0 "No" 1 "Yes"
label define w73_7_lb 0 "No" 1 "Yes"
label define w73_8_lb 0 "No" 1 "Yes"
label define w73_9_lb 0 "No" 1 "Yes"
label define w73_10_lb 0 "No" 1 "Yes"


label values id_registro_w id_registro_w_lb
label values id_other_woman id_other_woman_lb
label values id_dona id_dona_lb 
label values int_cont_data int_cont_data_lb
label values w68_1 w68_1_lb
label values w68_2 w68_2_lb
label values w68_3 w68_3_lb
label values w68_4 w68_4_lb
label values w68_5 w68_5_lb
label values w68_6 w68_6_lb
label values w68_7 w68_7_lb
label values w68_8 w68_8_lb
label values w68_9 w68_9_lb
label values w69 w69_lb
label values w70 w70_lb

label values w71_1 w71_1_lb
label values w71_2 w71_2_lb
label values w71_3 w71_3_lb
label values w71_4 w71_4_lb
label values w71_5 w71_5_lb
label values w71_6 w71_6_lb

label values w72_1_1 w72_1_1_lb
label values w72_1_2 w72_1_2_lb
label values w72_2_2 w72_2_2_lb 
label values w72_1_3 w72_1_3_lb
label values w72_2_3 w72_2_3_lb
label values w72_1_4 w72_1_4_lb
label values w72_2_4 w72_2_4_lb
label values w72_1_5 w72_1_5_lb
label values w72_2_5 w72_2_5_lb 
label values w72_1_6 w72_1_6_lb
label values w72_2_6 w72_2_6_lb
label values w72_1_7 w72_1_7_lb
label values w72_2_7 w72_2_7_lb
label values w72_3 w72_3_lb

label values w72_3_1 w72_3_1_lb
label values w72_3_2 w72_3_2_lb
label values w72_3_3 w72_3_3_lb
label values w72_3_4 w72_3_4_lb
label values w72_3_5 w72_3_5_lb
label values w72_3_6 w72_3_6_lb
label values w72_3_7 w72_3_7_lb

label values w73_1 w73_1_lb
label values w73_2 w73_2_lb
label values w73_3 w73_3_lb
label values w73_4 w73_4_lb
label values w73_5 w73_5_lb
label values w73_6 w73_6_lb
label values w73_7 w73_7_lb
label values w73_8 w73_8_lb
label values w73_9 w73_9_lb
label values w73_10 w73_10_lb

label data "2003 Santarem Rural: Contraception Report"

**************************************************************
** REPORT, CODEBOOK, AND SAVE

describe, short
save stm2003r_cont.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_cont_codebook", replace
codebook, header all 
capture log close

**************************************************************
** SWAP OUT IDENTIFIERS FOR RANDOMIZED (PUBLIC) IDENTIFIERS

* Prepare linking file for later merging

use stm2003r_link.dta, clear
keep id_prop_rand id_house_rand id_prop_hh_rand id_roster
sort id_roster
by id_roster: gen dup=_n
drop if dup>1
drop if id_roster==9999999998
drop dup
save id_add_02.dta, replace

use stm2003r_cont.dta, clear
merge 1:1 id_roster using id_add_02.dta, update replace
drop if _merge==2
drop _merge id_prop id_house id_prop_hh id_roster
order id_prop_rand id_house_rand id_prop_hh_rand, first
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

save stm2003r_cont_public.dta, replace

**************************************************************
** DELETE IDENTIFYING VARIABLES FOR PUBLIC DATASET

use stm2003r_cont_public.dta, clear
drop id_name_a int_interviewer_w int_entry int_entered int_notes ///
w68_6a w68_9a w69_3a w69_4a w69_5a w71_6a w72_2_2a w72_2_3a w72_2_4a ///
w72_1_7a w72_2_5a w72_2_6a w72_2_7a w72_3_7a w73_10a w69_2_month

**************************************************************
** CODEBOOK AND SAVE PUBLIC VERSION

label data "2003 Santarem Rural: Contraception Report Public"

describe, short
save stm2003r_cont_public.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_cont_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_01.dta
capture erase id_add_02.dta
capture erase add0001.dta
