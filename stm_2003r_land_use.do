************************************************************************************
** file: \\stm_analysis\do\stm_2003r_land_use.do
** Programmer: james r. hull
** Date started: 2012 05 20
** Date finished: 2012 05 21
** Updates: None at Present
** Data Input:  w_subtable_q89_99_land_use.dta
**              stm2003r_link.dta
**              stm2003r_hh.dta
** Data Output: stm2003r_land_use.dta
**              stm2003r_land_use_public.dta
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
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_land_use", replace text

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
** 1. Format m_subtable_q24_26_landusecover.dta
*******************************************************

**************************************************************
** ADD NEW IDENTIFIERS

** Prepare Linking File - just property level first

use stm2003r_link.dta, clear
keep id_prop id_house id_prop_hh id_w_number id_prop_rand id_house_rand id_prop_hh_rand
sort id_prop_hh
by id_prop_hh: gen dup=_n
drop if dup>1
drop dup
sort id_prop_hh
save add0001.dta, replace

** Merge New Property-level Identifiers onto existing file

use m_subtable_q24_26_landusecover.dta, clear
rename mprop_hh_id id_prop_hh
sort id_prop_hh

merge m:1 id_prop_hh using add0001.dta, update replace
tab _merge
drop if _merge==2
drop _merge 
order id_prop id_house id_prop_hh id_prop_rand id_house_rand id_prop_hh_rand id_w_number, first
save stm_2003r_land_use.dta, replace

**************************************************************
** DROP JUNK AND QUESTIONABLE VARIABLES
drop uniqueid mpropid mhouseid donolote_

drop if (_26_lot==11 | _26_lot==12 | _26_lot==13 | _26_lot==14 | _26_lot==15 | _26_lot==16)

**************************************************************
** RECODES and RENAMES

*m24_1
rename _24_1 m24_1
replace m24_1=9999 if m24_1==.
replace m24_1=9998 if m24_1==0

*m24_2
rename _24_2 m24_2

*m24_3
rename _24_3 m24_3

*m24_4
rename _24_4 m24_4
replace m24_4=9998 if m24_4==0

*m24_5
rename _24_5 m24_5
replace m24_5=9999 if m24_5==.
replace m24_5=9998 if m24_5==0

*m25_1
rename _25_1 m25_1
replace m25_1=9998 if m25_1==0

*m25_2
rename _25_2 m25_2
replace m25_2=9998 if m25_2==0

*m25_3
rename _25_3 m25_3
replace m25_3=9998 if m25_3==0
replace m25_3=9999 if m25_3==999

*m25_4a
rename _25_4 m25_4a
replace m25_4a="9998" if m25_4a=="0"
replace m25_4a="9998" if m25_4a=="8888"

*m25_5
rename _25_6 m25_5    /* Fixed sequence error */
replace m25_5=9998 if m25_5==0
replace m25_5=1 if m25_5==-1
replace m25_5=9999 if m25_5==9

*m25_6
rename _25_7 m25_6
replace m25_6=9998 if m25_6==0
replace m25_6=1 if m25_6==-1
replace m25_6=9999 if m25_6==9

*m26_lot
rename _26_lot lot_which
replace lot_which=9999 if lot_which==.

*m26_when
rename _26_when lot_when

*m26_1
rename _26_1 m26_1


*m26_2
rename _26_2 m26_2

*m26_3
rename _26_3 m26_3

*m26_4
rename _26_4 m26_4

*m26_5
rename _26_5 m26_5

*m26_6
rename _26_6 m26_6

*m26_6a
rename _26_6a m26_6a
replace m26_6a="9998" if m26_6a==""
replace m26_6a="9998" if m26_6a=="8888"

*m26_7
rename _26_7 m26_7

*m26_8
rename _26_8 m26_8

*m26_9
rename _26_9 m26_9

*m26_10
rename _26_10 m26_10

*m26_11
rename _26_11 m26_11

*m26_12
rename _26_12 m26_12

*m26_12a
rename _26_12a m26_12a
replace m26_12a="9998" if m26_12a==""
replace m26_12a="9998" if m26_12a=="8888"

*m26_13
rename _26_13 m26_13

*m26_13a
rename _26_13a m26_13a
replace m26_13a="9998" if m26_13a==""
replace m26_13a="9998" if m26_13a=="8888"

*m26_14
rename _26_14 m26_14

*m26_15
rename _26_15 m26_15

*m26_15a
rename _26_15a m26_15a
replace m26_15a="9998" if m26_15a=="8888"

*m26_15_2
rename _26_15b m26_15_2
replace m26_15_2=9999 if m26_15_2==9
replace m26_15_2=9998 if m26_15_2==8

*m26_16
rename _26_16 m26_16

*m26_16a
rename _26_16a m26_16a
replace m26_16a="9998" if m26_16a=="8888"

*m26_16_2
rename _26_16b m26_16_2
replace m26_16_2=9999 if m26_16_2==9
replace m26_16_2=9998 if m26_16_2==8

*m26_17
rename _26_17 m26_17

*m26_17a
rename _26_17a m26_17a
replace m26_17a="9998" if m26_17a=="8888"

*m26_17_2
rename _26_17b m26_17_2
replace m26_17_2=9999 if m26_17_2==9
replace m26_17_2=9998 if m26_17_2==8

*m26_18
rename _26_18 m26_18

*m26_19
rename _26_19 m26_19
replace m26_19=9999 if m26_19==.

*m26_20
rename _26_20 m26_20
replace m26_20=9999 if m26_20==.

*m26_21
rename _26_21 m26_21
replace m26_21=9999 if m26_21==.
replace m26_21=9999 if m26_21==999

*m26_22
rename _26_22 m26_22
replace m26_22=9999 if m26_22==.
*m26_23
rename _26_23 m26_23

*m26_24
rename _26_24 m26_24

order lot_which lot_when, after (id_w_number)

**************************************************************
** ADD VARIABLE DESCRIPTIONS

label variable id_prop_hh "Num: Combined property and household ID variable [form]"
label variable m24_1 "Num: Did you acquire or sell any neighboring properties: lot ID [m24]"
label variable m24_2 "Dichot: Did you acquire or sell any neighboring properties: acquired [m24]"
label variable m24_3 "Dichot: Did you acquire or sell any neighboring properties: sold [m24]"
label variable m24_4 "Num: Did you acquire or sell any neighboring properties: year [m24]"
label variable m24_5 "Num: Did you acquire or sell any neighboring properties: size (ha) [m24]"

label variable m25_1 "Num: Do you have other rural properties: lot ID [m25]"
label variable m25_2 "Num: you have other rural properties: year [m25]"
label variable m25_3 "Num: Do you have other rural properties: size (ha) [m25]"
label variable m25_4a "String: Do you have other rural properties: location [m25]"
label variable m25_5 "Cat: Do you have other rural properties: reside on it [m25]"
label variable m25_6 "Cat: Do you have other rural properties: title [m25]"

label variable lot_which "Cat: Which lot is being described [m26]"
label variable lot_when "Cat: Which time period is being described [m26]"

label variable m26_1 "Num: Land use and cover on lot: soy (hectares) [m26]"
label variable m26_2 "Num: Land use and cover on lot: rice (hectares) [m26]"
label variable m26_3 "Num: Land use and cover on lot: beans (hectares) [m26]"
label variable m26_4 "Num: Land use and cover on lot: corn (hectares) [m26]"
label variable m26_5 "Num: Land use and cover on lot: manioc (hectares) [m26]"
label variable m26_6 "Num: Land use and cover on lot: other(hectares) [m26]"
label variable m26_6a "String: Text of other annual land use and cover on lot [m26]"
label variable m26_7 "Num: Land use and cover on lot: annual (hectares) [m26]"
label variable m26_8 "Num: Land use and cover on lot: cupuacu (hectares) [m26]"
label variable m26_9 "Num: Land use and cover on lot: coffee (hectares) [m26]"
label variable m26_10 "Num: Land use and cover on lot: pepper (hectares) [m26]"
label variable m26_11 "Num: Land use and cover on lot: banana (hectares) [m26]"
label variable m26_12 "Num: Land use and cover on lot: other 1 (hectares) [m26]"
label variable m26_12a "String: Text of other 1 perrenial land use and cover on lot [m26]"
label variable m26_13 "Num: Land use and cover on lot: other 2 (hectares) [m26]"
label variable m26_13a "String: Text of other 2 land use and cover on lot [m26]"
label variable m26_14 "Num: Land use and cover on lot: perennial (hectares) [m26]"
label variable m26_15 "Num: Land use and cover on lot: combined 1 (hectares) [m26]"
label variable m26_15a "String: Text of combined 1 land use and cover on lot [m26]"
label variable m26_15_2 "Cat: Composition of combined crops [m26]"
label variable m26_16 "Num: Land use and cover on lot: combined 2 (hectares) [m26]"
label variable m26_16a "String: Text of combined 2 land use and cover on lot [m26]"
label variable m26_16_2 "Cat: Composition of combined crops [m26]"
label variable m26_17 "Num: Land use and cover on lot: combined 3 (hectares) [m26]"
label variable m26_17a "String: Text of combined 3 land use and cover on lot [m26]"
label variable m26_17_2 "Cat: Composition of combined crops [m26]"
label variable m26_18 "Num: Land use and cover on lot: comined total (hectares) [m26]"
label variable m26_19 "Num: Land use and cover on lot: orchard (hectares) [m26]"
label variable m26_20 "Num: Land use and cover on lot: pasture (hectares) [m26]"
label variable m26_21 "Num: Land use and cover on lot: ss2 (hectares) [m26]"
label variable m26_22 "Num: Land use and cover on lot: forest (hectares) [m26]"
label variable m26_23 "Num: Land use and cover on lot: water (hectares) [m26]"
label variable m26_24 "Num: Land use and cover on lot: total (hectares) [m26]"

**************************************************************
** ADD VALUE LABELS

label define lot_which_lb 1 "This lot" 2 "Neighbor: Q24 Lot 2" 3 "Neighbor: Q24 Lot 3" 4 "Neighbor: Q24 Lot 4" 5 "Neighbor: Q24 Lot 5" 6 "Neighbor: Q25 Lot 2" 7 "Neighbor: Q25 Lot 3" 8 "Neighbor: Q25 Lot 4" 11 "This lot alone" 12 "This lot with others" 13 "Neighboring properties alone" 14 "Neighboring properties with others" 15 "Separate properties alone" 16 "Separate properties with others"
label define m25_5_lb 1 "Family members" 2 "Sharecroppers" 3 "Employees" 4 "Nobody" 5 "Other"
label define m25_6_lb 1 "Does not have title" 2 "Official title in name" 3 "Previous owner's receipt" 4 "Possession paper" 5 "Notarized document" 6 "Possession paper" 7 "Other"
label define lot_when_lb 1 "When acquired" 2 "Today"
label define m26_15_2_lb 1 "All Annuals" 2 "All perennials" 3 "Mixed annuals and perennials"
label define m26_16_2_lb 1 "All Annuals" 2 "All perennials" 3 "Mixed annuals and perennials"
label define m26_17_2_lb 1 "All Annuals" 2 "All perennials" 3 "Mixed annuals and perennials"
label define m24_2_lb 0 "No" 1 "Yes"
label define m24_3_lb 0 "No" 1 "Yes" 

label values lot_which lot_which_lb
label values m25_5 m25_5_lb
label values m25_6 m25_6_lb
label values lot_when lot_when_lb
label values m26_15_2 m26_15_2_lb
label values m26_16_2 m26_16_2_lb
label values m26_17_2 m26_17_2_lb
label values m24_2 m24_2_lb
label values m24_3 m24_3_lb

label data "2003 Santarem Rural: Land Use Report" 

**************************************************************
** REPORT, CODEBOOK, AND SAVE

describe, short
save stm2003r_land_use_public.dta, replace
drop id_prop_rand id_house_rand id_prop_hh_rand
save stm2003r_land_use.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_land_use_codebook", replace
codebook, header all 
capture log close

**************************************************************
** SWAP OUT IDENTIFIERS FOR RANDOMIZED (PUBLIC) IDENTIFIERS

* Prepare linking file for later merging

use stm2003r_land_use_public.dta, clear
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

**************************************************************
** DELETE IDENTIFYING VARIABLES FOR PUBLIC DATASET

drop id_prop id_house id_prop_hh id_w_number m25_4a

**************************************************************
** CODEBOOK AND SAVE PUBLIC VERSION

label data "2003 Santarem Rural: Land Use Report Public" 

describe, short
save stm2003r_land_use_public.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_land_use_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_01.dta
capture erase id_add_02.dta
capture erase add0001.dta
