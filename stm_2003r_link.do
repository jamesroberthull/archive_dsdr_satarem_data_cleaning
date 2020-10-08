************************************************************************************
** file: \\stm_analysis\do\stm_2003r_link.do
** Programmer: james r. hull
** Date started: 2012 05 15
** Date finished: 
** Updates: None at Present
** Data Input: w_subtable_q16_31_household_roster.dta
**             w_subtable_q68_73_contraception.dta
**             w_subtable_q50_67_children.dta
**             w_subtable_q89_99_life_history.dta
**             w_subtable_q74_88_former_members.dta
**             stm_2003r_hh.dta
**
** Data Output: stm2003r_link.dta
** STATA Version: 11
** Purpose: Create a master linking file for individuals, households, and other subsamples
** Notes: This file also creates the random identifiers needed for deidentification
************************************************************************************

****************************************************************************************

*********************************
** SET ENVIRONMENTAL PARAMETERS
*********************************

capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_link", replace text

* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
cd "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\data\stm_2003r\data\stata\"

* Tell Stata to create all new variables in type double in order to prevent truncation of ID vars and so forth
set type double, permanently

* Tell Stata not to pause in displaying results of this do-file
set more off

****************************************************************************************

********************************************
** SEQUENTIAL MERGE OF LINKING IDENTIFIERS 
********************************************

***************************************************************************************************
* Merge all identifier files into a single master file --> link00XX.dta
*******************************************************

** ROSTER DATA
** Use Household Roster data as Base File for Subsequent Merges (n=2252)

use w_subtable_q16_31_household_roster.dta, clear
rename wintrno id_w_number
rename propid id_prop
rename prophhid id_prop_hh
rename hhid id_house
rename personid id_roster
rename childid id_child
rename _2w_17 id_name
gen form_fhead=1 if (_2w_18=="a propria" | _2w_18=="mulher" | _2w_18=="a mesma" | _2w_18=="esposa")
replace form_fhead=0 if form_fhead==.
keep id_w_number id_prop id_prop_hh id_house id_roster id_child id_name form_fhead _2w_18
gen form_rost=1
replace id_child=9999999998 if id_child==.
format id_child %12.0g
sort id_w_number
save link0001_sort.dta, replace

** FROM HH FILE
** Merge id_woman (hh roster number of woman) onto file by id_w_number (wintrno)

use stm2003r_hh.dta, clear
keep id_woman id_w_number id_dona_is_man
sort id_w_number
save add0001.dta, replace

use link0001_sort.dta, clear
merge m:1 id_w_number using add0001.dta, update replace
tab _merge
drop _merge
replace form_fhead=2 if (id_dona_is_man==1 & (_2w_18=="o proprio" | _2w_18=="o mesmo" | _2w_18=="o marido" | _2w_18=="o esposo" | _2w_18=="mesmo" | _2w_18=="marido" |_2w_18=="dono da casa" | _2w_18=="dono - pai" | _2w_18=="dono - filho" | _2w_18=="Dono do Lote" | _2w_18=="proprio" | _2w_18=="esposo"))
drop _2w_18 id_dona_is_man
order id_w_number id_woman, after (id_prop_hh)
save link0002_sort.dta, replace

** CONTRACEPTION DATA
** Merge contraception data onto main file as a test of identifier matching 
** (34 deceased mother reports do not match onto roster file)

use w_subtable_q68_73_contraception.dta, clear
keep womanhhroster personid w1
rename personid id_roster
sort id_roster
rename w1 id_name
save add0002.dta, replace

use link0002_sort.dta, clear
sort id_roster
merge m:1 id_roster using add0002.dta, update
tab _merge
gen form_cont=0
replace form_cont=1 if (_merge==2 | _merge==3 | _merge==5)
drop _merge womanhhroster
sort id_child

replace id_prop_hh=int(id_roster/100) if id_prop_hh==.
replace id_prop=int(id_prop_hh/100) if id_prop==.
replace id_house=(id_prop_hh-(id_prop*100)) if id_house==.
replace id_child=9999999998 if id_child==.
replace form_rost=0 if form_rost==.
replace id_woman=id_roster if id_woman==.
replace form_fhead=3 if form_fhead==.
save link0003_sort.dta, replace

use add0001.dta, clear
sort id_woman
save add0001_2.dta, replace

use link0003_sort.dta, clear
sort id_woman
merge m:1 id_woman using add0001_2.dta, update
tab _merge
drop _merge id_dona_is_man
sort id_roster
save link0003_sort.dta, replace

** CHILDREN
** Merge reproductive history identifiers onto main data stream

use w_subtable_q50_67_children.dta, clear
keep motherid childid _3w_54 _3w_50a
rename child id_child
rename motherid id_mother
sort id_child
save add0003.dta, replace

use add0003.dta, clear
sort id_child
merge m:m id_child using link0003_sort.dta, update replace
tab _merge
sort id_mother id_child _merge

gen form_child=0
replace form_child=1 if (_merge==1 | _merge==3)

gen roster=1 if (_merge==2 | _merge==3)
gen child=1 if (_merge==1 | _merge==3)
gen child_code=.
replace child_code=1 if (roster==1 & child==1)                    /* child in HH */
replace child_code=0 if (roster==. & child==1 & _3w_54==1)     /* child not in HH */
replace child_code=3 if (roster==. & child==1 & _3w_54==0)      /* child is deceased */
replace child_code=2 if (roster==1 & child==. & id_child~=.)   /* child is adopted */
replace child_code=9998 if (roster==1 & child==. & id_child==.) /* not a child */
replace child_code=9999 if child_code==.                          /* missing/unknown */
format id_child %12.0g
drop _merge roster child 
save link0004_sort.dta, replace

** Insert missing values into main file

use stm2003r_hh.dta, clear
keep id_w_number id_prop id_house id_prop_hh id_woman
sort id_woman
save add0004.dta, replace

use link0004_sort.dta, clear
replace id_mother=9999999998 if id_mother==.
replace id_name=_3w_50a if id_name==""
drop _3w_50a _3w_54
replace form_cont=0 if form_cont==.
replace id_woman=id_mother if id_woman==.
replace form_rost=0 if id_roster==.
replace id_roster=9999999998 if id_roster==.
sort id_woman

merge m:1 id_woman using add0004.dta, update   /*fill in missing values only */
tab _merge
drop _merge
sort id_woman

save link0005_sort.dta, replace

use w_other_woman_main.dta, clear
rename propid id_prop
rename houseid id_house
rename prop_hh_id id_prop_hh
rename womanid id_woman
keep id_prop id_house id_prop_hh id_woman
sort id_prop_hh 
save add0005.dta, replace

** Merge id_w_number to other woman data file prior to merging onto main file

use add0004.dta, clear
sort id_prop_hh
save add0004_2.dta, replace

use add0005.dta, clear
merge m:1 id_prop_hh using add0004_2.dta, update
tab _merge
drop _merge
sort id_woman
save add0005_2.dta, replace

use link0005_sort.dta, clear
merge m:1 id_woman using add0005_2.dta, update   /*fill in missing values only on OTHER WOMEN */
tab _merge
drop _merge
drop if id_roster==.
replace form_fhead=0 if form_fhead==.
save link0006_sort.dta, replace

** LIFE TABLES
** Merge life table identifiers onto main data stream

use w_subtable_q89_99_life_history.dta, clear
sort wintrno
by wintrno: keep if _n==1
keep wintrno
rename wintrno id_w_number
save add0006.dta, replace

use link0006_sort.dta, clear
sort id_w_number
merge m:1 id_w_number using add0006.dta, update   /*fill in missing values only on OTHER WOMEN */
tab _merge
gen form_life=1 if ((_merge==3 & form_cont==1) & (id_woman==id_roster))
replace form_life=0 if form_life==.
drop _merge
save link0007_sort.dta, replace

** Rearrange Variable Order in Final Link File **

use link0007_sort.dta, clear
order id_prop id_house id_prop_hh, first
order id_woman id_w_number id_mother id_child child_code id_roster id_name, after (id_prop_hh)
order form_rost form_cont form_child form_life, last
sort id_woman id_mother id_child id_roster

** gen summary = 1000*form_rost+100*form_cont+10*form_child+form_life /* handy code for quick checking counts */

save link0008_sort.dta, replace

** OTHER HH MEMBERS
** Merge other hh member identifiers onto main data stream

use w_subtable_q74_88_former_members.dta, clear
sort wintrno id
keep wintrno id _4w_02
rename wintrno id_w_number
rename _4w_02 id_name

merge m:1 id_w_number using add0001.dta, update replace
drop if _merge==2
drop id_dona_is_man

gen id_former=id_woman*100+id
format id_former %12.0g
drop id _merge
save add0007.dta, replace 

use link0008_sort.dta, clear
append using add0007.dta, gen(form_former)

replace id_former=9999999998 if id_former==.
replace id_child=9999999998 if id_child==.
replace id_mother=9999999998 if id_mother==.
replace id_roster=9999999998 if id_roster==.
replace child_code=9998 if child_code==.
replace form_rost=0 if form_rost==.
replace form_cont=0 if form_cont==.
replace form_child=0 if form_child==.
replace form_life=0 if form_life==.
replace form_fhead=0 if form_fhead==.

sort id_woman

save link0009_sort.dta, replace

use stm2003r_hh.dta, clear
keep id_woman id_prop id_house id_prop_hh
sort id_woman
save add0008.dta, replace

use link0009_sort.dta, clear
merge m:1 id_woman using add0008.dta, update  /*fill in missing values only on FORMER MEMBERS */
drop _merge

order id_former, after(id_roster)

drop child_code                              /* comment out to keep this useful, but extraneous variable */

save link0010_sort.dta, replace

***************************************************************************

* NEW IDENTIFIERS
** Adds a set of randomized identifiers to data for public release

** Create identifier id_woman_rand

use link0010_sort.dta, clear
keep id_woman
sort id_woman
by id_woman: gen dup01=_n
drop if dup01>1
drop dup01

set seed 42                                  /* Setting a seed allows the randomized processes below to be replicable */

gen newrand=1+int((_N-1+1)*runiform())
gen newrand2=1+int((20000-1+1)*runiform())    /* The two random numbers together will (almost always) uniquely order every case in the dataset */
sort newrand newrand2                        /* When the data are sorted by both random var's it results in a replicable new sort order */
by newrand newrand2: gen temp3=_N            /* A check of the uniqueness of the sort order */
tab temp3
drop temp3 newrand newrand2
gen id_woman_rand=_n
sort id_woman
save id_woman_list_sort.dta, replace

** Create identifier id_house_rand

use link0010_sort.dta, clear
keep id_prop id_house
sort id_prop id_house
by id_prop id_house: gen dup02=_n
drop if dup02>1
drop dup02

set seed 42                                  /* Setting a seed allows the randomized processes below to be replicable */

gen newrand=1+int((20000-1+1)*runiform())
sort id_prop newrand
by id_prop: gen id_house_rand=_n
drop newrand
save id_house_list_sort.dta, replace

** Create identifier id_prop_rand

use link0010_sort.dta, clear
keep id_prop
sort id_prop
by id_prop:  gen dup02 = _n
drop if dup02>1
drop dup02

set seed 42                                  /* Setting a seed allows the randomized processes below to be replicable */
	
gen newrand=1+int((_N-1+1)*runiform())
gen newrand2=1+int((20000-1+1)*runiform())    /* The two random numbers together uniquely order every case in the dataset in a sort */
sort newrand newrand2                         /* When the data are sorted by both random var's it results in a replicable new sort order */
by newrand newrand2: gen temp3=_N             /* A check of the uniqueness of the sort order */
tab temp3
drop temp3 newrand newrand2
gen id_prop_rand=_n
sort id_prop
save id_prop_list_sort.dta, replace

** Generate file to transfer new random identifiers to main data stream

use id_house_list_sort.dta, clear
merge m:1 id_prop using id_prop_list_sort.dta, update replace
drop _merge
gen id_prop_hh_rand=100000+id_prop_rand*100+id_house_rand
gen id_prop_hh=id_prop*100+id_house
sort id_prop_hh
drop id_prop id_house
save add0010.dta, replace

use link0010_sort.dta, clear
sort id_prop_hh
merge m:m id_prop_hh using add0010.dta, update replace
order id_prop_rand id_house_rand id_prop_hh_rand, after (id_prop_hh)
drop _merge

** INDIVIDUAL IDENTIFIER
** Adds a single individual id to supercede multiple other individual-level identifiers   
** 1 + (PLOT) + (HH) + (random 4-digit #) = unique 10-digit identifier

set seed 42

gen newrand=1+int((_N-1+1)*runiform())
gen newrand2=1+int((20000-1+1)*runiform())    /* The two random numbers together uniquely order every case in the dataset in a sort */
sort newrand newrand2                         /* When the data are sorted by both random var's it results in a replicable new sort order */
by newrand newrand2: gen temp3=_N             /* A check of the uniqueness of the sort order */
tab temp3
drop temp3 newrand newrand2
gen id_person_1=_n
gen id_person=id_prop_hh_rand*10000+id_person_1
format id_person %12.0g
sort id_prop_hh id_woman id_roster
drop id_person_1
order id_person, after (id_prop_hh_rand)
rename id_name id_name_a

save link0011_sort.dta, replace

**************************************************************
** ADD VARIABLE DESCRIPTIONS and VALUE LABELS

use link0011_sort.dta, clear

label variable id_prop  "Num: Property (lot) ID variable [form]"
label variable id_house "Num: Household ID variable [form]"
label variable id_prop_hh "Num: Combined property and household ID variable [form]"
label variable id_prop_rand "Num: Randomly-generated property ID variable [created]"
label variable id_house_rand "Num: Randomly-generated household ID variable [created]"
label variable id_prop_hh_rand "Num: Randomly-generated household-property ID variable 1+000+00 [created]"
label variable id_person "Num: Randomly-generated person-level ID variable 1+000+00+0000 [created]"
label variable id_woman "Num: Woman ID variable for linking [hh_prop_id + roster #]"
label variable id_w_number "Num: Woman interview number ID variable for linking [id_prop_hh+00] [form]"
label variable id_mother "Num: Mother ID variable for linking [form]"
label variable id_child "Num: Child ID variable for linking [id_mother + 00] [form]"
label variable id_roster "Num: Household Roster ID variable for linking [id_prop_hh + 00] [form]"
label variable id_former "Num: Former Household Member ID variable for linking [idwoman + 00] [form]"
label variable id_name "String: Individual's Name [form]"
label variable form_rost "Dichot: Individual is listed on Household Roster [created]"
label variable form_cont "Dichot: Individual filled out a Contraceptive Report [created]"
label variable form_child "Dichot: Individual is listed on Mother's Childbearing History [created]"
label variable form_life "Dichot: Individual filled out a Life History Calendar [created]"
label variable form_former "Dichot: Individual is listed on Household Former Member Roster [created]"
label variable form_fhead "Cat: Individual is a female head of household [created]"

label define form_dichot_lb 0 "No" 1 "Yes" 
label define form_fhead_lb 0 "No" 1 "Yes" 2 "Dono reporting on Dona" 3 "Deceased Dona" 

label values form_rost form_dichot_lb
label values form_cont form_dichot_lb
label values form_child form_dichot_lb
label values form_life form_dichot_lb
label values form_former form_dichot_lb
label values form_fhead form_fhead_lb

label data "2003 Santarem Rural: Linking File"

save stm2003r_link.dta, replace

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase add0001.dta
capture erase add0002.dta
capture erase add0003.dta
capture erase add0004.dta
capture erase add0005.dta
capture erase add0006.dta
capture erase add0007.dta
capture erase add0008.dta
capture erase add0010.dta
capture erase add0001_2.dta
capture erase add0002_2.dta
capture erase add0004_2.dta
capture erase add0005_2.dta

capture erase link0001_sort.dta
capture erase link0002_sort.dta
capture erase link0003_sort.dta
capture erase link0004_sort.dta
capture erase link0005_sort.dta
capture erase link0006_sort.dta
capture erase link0007_sort.dta
capture erase link0008_sort.dta
capture erase link0009_sort.dta
capture erase link0010_sort.dta
capture erase link0011_sort.dta

capture erase id_house_list_sort.dta
capture erase id_prop_list_sort.dta
capture erase id_prop_hh_list_sort.dta
capture erase id_woman_list_sort.dta


