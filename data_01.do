////This is the data preparation code used to generate state-level Corporal Punishment (CP) and Suspension Rates that are then aggregated to National Level and Graphed////////////////////
////Created by Sarah Asson///////

//This is code to combine corporal punishment variables across the years //

cd "Set Working Directory"
do ".\variable names program.do"
confirmdir ".\Cleaned data\Documentation\"
if _rc!=0 {
	mkdir ".\Cleaned data\Documentation\"
} 
confirmdir ".\Cleaned data\CorporalPunishment\"
if _rc!=0 {
	mkdir ".\Cleaned data\CorporalPunishment\"
} 

//1973-2006
capture confirm file ".\Cleaned data\Dropped 2006 - 1.dta"
if _rc==0 {
	use ".\Cleaned data\Dropped 2006 - 1.dta", clear
}
if _rc!=0 {
	import excel ".\crdc_1968_2009_ts COPY\Data\LEA\5. Dropped Data\Dropped 2006 - 1.xlsx", firstrow clear
	save ".\Cleaned data\Dropped 2006 - 1.dta"
}

rename T_AME_COR CORP_AI
rename T_ASI_COR CORP_AS
rename T_HIS_COR CORP_HI
rename T_BLA_COR CORP_BL
rename T_WHI_COR CORP_WH

keep YEAR LEAID CORP_AI-CORP_WH
destring YEAR CORP*, replace
save ".\Cleaned data\CorporalPunishment\corp_73to06_lea_RA.dta", replace


//1980,82,94,97 counts for students with disabilities
capture confirm file ".\Cleaned data\Dropped 1997-1972.dta"
if _rc==0 {
	use ".\Cleaned data\Dropped 1997-1972.dta", clear
}
if _rc!=0 {
	import excel ".\crdc_1968_2009_ts COPY\Data\LEA\5. Dropped Data\Dropped 1997-1972.xlsx", firstrow clear
	save ".\Cleaned data\Dropped 1997-1972.dta"
}

keep YEAR LEAID XUSE_68 CORP_DS //XUSE_68 was collected in 1980 and 1982 and is labelled "Corporal Punishment - Handicapped" //CORP_DS was collected in 1994 and 1997 and is labelled "Corporal Punishment: Total Disabled"
egen CORP_DIS = rowtotal(XUSE_68 CORP_DS), missing //Assumes the two variables are equivalent and will be equivalent to later collections of students under IDEA + 504

keep YEAR LEAID CORP_DIS
save ".\Cleaned data\CorporalPunishment\corp_dis_80to82and94to97_lea_RA.dta", replace


//2009 (from restricted access, historical data)
*students without disabilities
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students without Disabilities\Pt2-wo Disab CorpPunish(Q34).xlsx", sheet("Pt2-wo Disab CorpPunish(Q34)") firstrow clear

destring M_AME_5_CORP_NO_DIS-TOT_LEP_CORP_NO_DIS, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen CORP_M_AI_NODIS = M_AME_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_AI_NODIS = M_AME_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_AS_NODIS = M_ASI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_AS_NODIS = M_ASI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_HI_NODIS = M_HIS_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_HI_NODIS = M_HIS_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_BL_NODIS = M_BLA_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_BL_NODIS = M_BLA_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_WH_NODIS = M_WHI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_WH_NODIS = M_WHI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_HP_NODIS = M_HI_PAC_7_CORP_NO_DIS
gen CORP_M_MR_NODIS = M_2_OR_MORE_7_CORP_NO_DIS
gen CORP_M_NODIS = M_TOT_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_NODIS = M_TOT_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_NODIS_LEP = M_LEP_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_NODIS_LEP = M_LEP_7_CORP_NO_DIS if RACES_REPORTED==7

gen CORP_F_AI_NODIS = F_AME_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_AI_NODIS = F_AME_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_AS_NODIS = F_ASI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_AS_NODIS = F_ASI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_HI_NODIS = F_HIS_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_HI_NODIS = F_HIS_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_BL_NODIS = F_BLA_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_BL_NODIS = F_BLA_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_WH_NODIS = F_WHI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_WH_NODIS = F_WHI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_HP_NODIS = F_HI_PAC_7_CORP_NO_DIS
gen CORP_F_MR_NODIS = F_2_OR_MORE_7_CORP_NO_DIS
gen CORP_F_NODIS = F_TOT_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_NODIS = F_TOT_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_NODIS_LEP = F_LEP_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_NODIS_LEP = F_LEP_7_CORP_NO_DIS if RACES_REPORTED==7

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

keep YEAR LEAID RACES_REPORTED LEA_STATE CORP_*
save ".\Cleaned data\CorporalPunishment\corp_nodis_09_lea_RA.dta", replace


*students with disabilities
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students with Disabilities\Pt2-w Disab CorpPunish(Q35).xlsx", sheet("Pt2-w Disab CorpPunish(Q35)") firstrow clear

destring M_AME_5_CORP_DIS-TOT_504_CORP_DIS, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen CORP_M_AI_IDEA = M_AME_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_AI_IDEA = M_AME_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_AS_IDEA = M_ASI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_AS_IDEA = M_ASI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_HI_IDEA = M_HIS_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_HI_IDEA = M_HIS_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_BL_IDEA = M_BLA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_BL_IDEA = M_BLA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_WH_IDEA = M_WHI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_WH_IDEA = M_WHI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_HP_IDEA = M_HI_PAC_7_CORP_DIS
gen CORP_M_MR_IDEA = M_2_OR_MORE_7_CORP_DIS
gen CORP_M_IDEA = M_TOT_IDEA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_IDEA = M_TOT_IDEA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_504 = M_504_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_504 = M_504_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_DIS_LEP = M_LEP_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_DIS_LEP = M_LEP_7_CORP_DIS if RACES_REPORTED==7

gen CORP_F_AI_IDEA = F_AME_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_AI_IDEA = F_AME_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_AS_IDEA = F_ASI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_AS_IDEA = F_ASI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_HI_IDEA = F_HIS_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_HI_IDEA = F_HIS_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_BL_IDEA = F_BLA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_BL_IDEA = F_BLA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_WH_IDEA = F_WHI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_WH_IDEA = F_WHI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_HP_IDEA = F_HI_PAC_7_CORP_DIS
gen CORP_F_MR_IDEA = F_2_OR_MORE_7_CORP_DIS
gen CORP_F_IDEA = F_TOT_IDEA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_IDEA = F_TOT_IDEA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_504 = F_504_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_504 = F_504_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_DIS_LEP = F_LEP_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_DIS_LEP = F_LEP_7_CORP_DIS if RACES_REPORTED==7

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

keep YEAR LEAID LEA_STATE RACES_REPORTED CORP_*
save ".\Cleaned data\CorporalPunishment\corp_dis_09_lea_RA.dta", replace

//2009 public data

*students without disabilities
import excel ".\2009-10-crdc-data\2009-12 Public Use File\CRDC -collected data\School\Pt 2-Discipline of Students without Disabilities\CRDC-data_SCH_Pt 2-Dis of Stud without Dis_Pt 2-Students Wo Dis Corporal punishment.xlsx", sheet("Data") firstrow clear
drop JJ
names corpnodis 2009

gen YEAR=2009

destring M_AME_5_CORP_NO_DIS-F_LEP_7_CORP_NO_DIS, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen CORP_M_AI_NODIS = M_AME_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_AI_NODIS = M_AME_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_AS_NODIS = M_ASI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_AS_NODIS = M_ASI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_HI_NODIS = M_HIS_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_HI_NODIS = M_HIS_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_BL_NODIS = M_BLA_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_BL_NODIS = M_BLA_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_WH_NODIS = M_WHI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_WH_NODIS = M_WHI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_HP_NODIS = M_HI_PAC_7_CORP_NO_DIS
gen CORP_M_MR_NODIS = M_2_OR_MORE_7_CORP_NO_DIS
gen CORP_M_NODIS = M_TOT_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_NODIS = M_TOT_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_M_NODIS_LEP = M_LEP_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_M_NODIS_LEP = M_LEP_7_CORP_NO_DIS if RACES_REPORTED==7

gen CORP_F_AI_NODIS = F_AME_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_AI_NODIS = F_AME_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_AS_NODIS = F_ASI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_AS_NODIS = F_ASI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_HI_NODIS = F_HIS_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_HI_NODIS = F_HIS_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_BL_NODIS = F_BLA_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_BL_NODIS = F_BLA_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_WH_NODIS = F_WHI_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_WH_NODIS = F_WHI_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_HP_NODIS = F_HI_PAC_7_CORP_NO_DIS
gen CORP_F_MR_NODIS = F_2_OR_MORE_7_CORP_NO_DIS
gen CORP_F_NODIS = F_TOT_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_NODIS = F_TOT_7_CORP_NO_DIS if RACES_REPORTED==7
gen CORP_F_NODIS_LEP = F_LEP_5_CORP_NO_DIS if RACES_REPORTED==5
replace CORP_F_NODIS_LEP = F_LEP_7_CORP_NO_DIS if RACES_REPORTED==7

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

keep LEA_STATE LEAID LEA_NAME SCHID SCH_NAME COMBOKEY YEAR RACES_REPORTED CORP_*
save ".\Cleaned data\CorporalPunishment\corp_nodis_09_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY
collapse (sum) CORP_M_AI_NODIS CORP_M_AS_NODIS CORP_M_HI_NODIS CORP_M_BL_NODIS CORP_M_WH_NODIS CORP_M_HP_NODIS CORP_M_MR_NODIS CORP_M_NODIS CORP_M_NODIS_LEP CORP_F_AI_NODIS CORP_F_AS_NODIS CORP_F_HI_NODIS CORP_F_BL_NODIS CORP_F_WH_NODIS CORP_F_HP_NODIS CORP_F_MR_NODIS CORP_F_NODIS CORP_F_NODIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_nodis_09_lea.dta", replace

*students with disabilities
import excel ".\2009-10-crdc-data\2009-12 Public Use File\CRDC -collected data\School\Pt 2-Discipline of Students with Disabilities\CRDC-data_SCH_Pt 2-Dis of Stud with Dis_Pt 2-Students W Dis  Corporal punishment.xlsx", sheet("Data") firstrow clear
drop JJ
names corpdis 2009

gen YEAR=2009

destring M_AME_5_CORP_DIS-F_LEP_7_CORP_DIS, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen CORP_M_AI_IDEA = M_AME_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_AI_IDEA = M_AME_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_AS_IDEA = M_ASI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_AS_IDEA = M_ASI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_HI_IDEA = M_HIS_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_HI_IDEA = M_HIS_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_BL_IDEA = M_BLA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_BL_IDEA = M_BLA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_WH_IDEA = M_WHI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_WH_IDEA = M_WHI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_HP_IDEA = M_HI_PAC_7_CORP_DIS
gen CORP_M_MR_IDEA = M_2_OR_MORE_7_CORP_DIS
gen CORP_M_IDEA = M_TOT_IDEA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_IDEA = M_TOT_IDEA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_504 = M_504_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_504 = M_504_7_CORP_DIS if RACES_REPORTED==7
gen CORP_M_DIS_LEP = M_LEP_5_CORP_DIS if RACES_REPORTED==5
replace CORP_M_DIS_LEP = M_LEP_7_CORP_DIS if RACES_REPORTED==7

gen CORP_F_AI_IDEA = F_AME_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_AI_IDEA = F_AME_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_AS_IDEA = F_ASI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_AS_IDEA = F_ASI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_HI_IDEA = F_HIS_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_HI_IDEA = F_HIS_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_BL_IDEA = F_BLA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_BL_IDEA = F_BLA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_WH_IDEA = F_WHI_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_WH_IDEA = F_WHI_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_HP_IDEA = F_HI_PAC_7_CORP_DIS
gen CORP_F_MR_IDEA = F_2_OR_MORE_7_CORP_DIS
gen CORP_F_IDEA = F_TOT_IDEA_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_IDEA = F_TOT_IDEA_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_504 = F_504_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_504 = F_504_7_CORP_DIS if RACES_REPORTED==7
gen CORP_F_DIS_LEP = F_LEP_5_CORP_DIS if RACES_REPORTED==5
replace CORP_F_DIS_LEP = F_LEP_7_CORP_DIS if RACES_REPORTED==7

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

keep LEA_STATE LEAID LEA_NAME SCHID SCH_NAME COMBOKEY YEAR RACES_REPORTED CORP_*
save ".\Cleaned data\CorporalPunishment\corp_dis_09_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY
collapse (sum) CORP_M_AI_IDEA CORP_M_AS_IDEA CORP_M_HI_IDEA CORP_M_BL_IDEA CORP_M_WH_IDEA CORP_M_HP_IDEA CORP_M_MR_IDEA CORP_M_IDEA CORP_M_504 CORP_M_DIS_LEP CORP_F_AI_IDEA CORP_F_AS_IDEA CORP_F_HI_IDEA CORP_F_BL_IDEA CORP_F_WH_IDEA CORP_F_HP_IDEA CORP_F_MR_IDEA CORP_F_IDEA CORP_F_504 CORP_F_DIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_dis_09_lea.dta", replace

**combine variable name files
use ".\vars_corpnodis_2009.dta", clear
append using ".\vars_corpdis_2009.dta"
duplicates drop
save ".\vars_corp_2009.dta", replace
erase ".\vars_corpnodis_2009.dta"
erase ".\vars_corpdis_2009.dta"

//2011-12
*students without disabilities
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Disc of Stud wo Disab\2011-12 Public Use File_SCH_CRDC-Pt 2_35-1 - Students WO Dis Corp punish.xlsx", sheet("Suppressed Data") firstrow clear
drop JJ
names corpnodis 2011

destring M_AME_7_CORP_NO_DIS-F_LEP_7_CORP_NO_DIS, ignore("‡") replace 

gen YEAR=2011
gen RACES_REPORTED=7

rename M_AME_7_CORP_NO_DIS CORP_M_AI_NODIS
rename M_ASI_7_CORP_NO_DIS CORP_M_AS_NODIS 
rename M_HIS_7_CORP_NO_DIS CORP_M_HI_NODIS 
rename M_BLA_7_CORP_NO_DIS CORP_M_BL_NODIS 
rename M_WHI_7_CORP_NO_DIS CORP_M_WH_NODIS
rename M_HI_PAC_7_CORP_NO_DIS CORP_M_HP_NODIS
rename M_2_OR_MORE_7_CORP_NO_DIS CORP_M_MR_NODIS
rename M_TOT_7_CORP_NO_DIS CORP_M_NODIS
rename M_LEP_7_CORP_NO_DIS CORP_M_NODIS_LEP

rename F_AME_7_CORP_NO_DIS CORP_F_AI_NODIS
rename F_ASI_7_CORP_NO_DIS CORP_F_AS_NODIS 
rename F_HIS_7_CORP_NO_DIS CORP_F_HI_NODIS 
rename F_BLA_7_CORP_NO_DIS CORP_F_BL_NODIS 
rename F_WHI_7_CORP_NO_DIS CORP_F_WH_NODIS
rename F_HI_PAC_7_CORP_NO_DIS CORP_F_HP_NODIS
rename F_2_OR_MORE_7_CORP_NO_DIS CORP_F_MR_NODIS
rename F_TOT_7_CORP_NO_DIS CORP_F_NODIS
rename F_LEP_7_CORP_NO_DIS CORP_F_NODIS_LEP

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}
	
*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\CorporalPunishment\corp_nodis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY
collapse (sum) CORP_M_AI_NODIS CORP_M_AS_NODIS CORP_M_HI_NODIS CORP_M_BL_NODIS CORP_M_WH_NODIS CORP_M_HP_NODIS CORP_M_MR_NODIS CORP_M_NODIS CORP_M_NODIS_LEP CORP_F_AI_NODIS CORP_F_AS_NODIS CORP_F_HI_NODIS CORP_F_BL_NODIS CORP_F_WH_NODIS CORP_F_HP_NODIS CORP_F_MR_NODIS CORP_F_NODIS CORP_F_NODIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_nodis_11_lea.dta", replace

*students with disabilities
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Discpline of Students with Disabilities\2011-12 Public Use File_SCH_CRDC-Pt 2_36-1 - Stud W Dis Corp punishment (1).xlsx", sheet("Suppressed Data") firstrow clear
drop JJ
names corpdis 2011

destring M_AME_7_CORP_DIS-F_LEP_7_CORP_DIS, ignore("‡") replace 

gen YEAR=2011
gen RACES_REPORTED=7

rename M_AME_7_CORP_DIS CORP_M_AI_IDEA 
rename M_ASI_7_CORP_DIS CORP_M_AS_IDEA 
rename M_HIS_7_CORP_DIS CORP_M_HI_IDEA
rename M_BLA_7_CORP_DIS CORP_M_BL_IDEA
rename M_WHI_7_CORP_DIS CORP_M_WH_IDEA 
rename M_HI_PAC_7_CORP_DIS CORP_M_HP_IDEA 
rename M_2_OR_MORE_7_CORP_DIS CORP_M_MR_IDEA
rename M_TOT_IDEA_7_CORP_DIS CORP_M_IDEA
rename M_504_7_CORP_DIS CORP_M_504 
rename M_LEP_7_CORP_DIS CORP_M_DIS_LEP 

rename F_AME_7_CORP_DIS CORP_F_AI_IDEA 
rename F_ASI_7_CORP_DIS CORP_F_AS_IDEA 
rename F_HIS_7_CORP_DIS CORP_F_HI_IDEA
rename F_BLA_7_CORP_DIS CORP_F_BL_IDEA
rename F_WHI_7_CORP_DIS CORP_F_WH_IDEA 
rename F_HI_PAC_7_CORP_DIS CORP_F_HP_IDEA 
rename F_2_OR_MORE_7_CORP_DIS CORP_F_MR_IDEA
rename F_TOT_IDEA_7_CORP_DIS CORP_F_IDEA
rename F_504_7_CORP_DIS CORP_F_504 
rename F_LEP_7_CORP_DIS CORP_F_DIS_LEP 

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}
	
*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\CorporalPunishment\corp_dis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY
collapse (sum) CORP_M_AI_IDEA CORP_M_AS_IDEA CORP_M_HI_IDEA CORP_M_BL_IDEA CORP_M_WH_IDEA CORP_M_HP_IDEA CORP_M_MR_IDEA CORP_M_IDEA CORP_M_504 CORP_M_DIS_LEP CORP_F_AI_IDEA CORP_F_AS_IDEA CORP_F_HI_IDEA CORP_F_BL_IDEA CORP_F_WH_IDEA CORP_F_HP_IDEA CORP_F_MR_IDEA CORP_F_IDEA CORP_F_504 CORP_F_DIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_dis_11_lea.dta", replace

**combine variable name files
use ".\vars_corpnodis_2011.dta", clear
append using ".\vars_corpdis_2011.dta"
duplicates drop
save ".\vars_corp_2011.dta", replace
erase ".\vars_corpnodis_2011.dta"
erase ".\vars_corpdis_2011.dta"

//2013-14
import excel ".\2013-14-crdc-data\2013-14 CRDC\School\CRDC-collected data file for Schools\11-1 Corporal Punishment.xlsx", sheet("Data") firstrow clear
drop JJ
drop AU-BR
names corp 2013

gen YEAR=2013
gen RACES_REPORTED=7

gen CORPIND=1 if SCH_CORPINSTANCES_IND=="Yes"
replace CORPIND=0 if SCH_CORPINSTANCES_IND=="No"
replace CORPIND=-5 if SCH_CORPINSTANCES_IND=="-5"
label drop _all
drop SCH_CORPINSTANCES_IND

*students without disabilities
rename SCH_DISCWODIS_CORP_AM_M CORP_M_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_M CORP_M_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_M CORP_M_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_M CORP_M_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_M CORP_M_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_M CORP_M_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_M CORP_M_MR_NODIS
rename TOT_DISCWODIS_CORP_M CORP_M_NODIS
rename SCH_DISCWODIS_CORP_LEP_M CORP_M_NODIS_LEP

rename SCH_DISCWODIS_CORP_AM_F CORP_F_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_F CORP_F_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_F CORP_F_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_F CORP_F_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_F CORP_F_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_F CORP_F_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_F CORP_F_MR_NODIS
rename TOT_DISCWODIS_CORP_F CORP_F_NODIS
rename SCH_DISCWODIS_CORP_LEP_F CORP_F_NODIS_LEP

*students with disabilities
rename SCH_DISCWDIS_CORP_IDEA_AM_M CORP_M_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_M CORP_M_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_M CORP_M_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_M CORP_M_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_M CORP_M_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_M CORP_M_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_M CORP_M_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_M CORP_M_IDEA
rename SCH_DISCWDIS_CORP_504_M CORP_M_504 
rename SCH_DISCWDIS_CORP_LEP_M CORP_M_DIS_LEP 

rename SCH_DISCWDIS_CORP_IDEA_AM_F CORP_F_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_F CORP_F_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_F CORP_F_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_F CORP_F_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_F CORP_F_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_F CORP_F_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_F CORP_F_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_F CORP_F_IDEA
rename SCH_DISCWDIS_CORP_504_F CORP_F_504 
rename SCH_DISCWDIS_CORP_LEP_F CORP_F_DIS_LEP 

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

save ".\Cleaned data\CorporalPunishment\corp_13_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY
collapse (sum) CORP_M_HI_NODIS CORP_F_HI_NODIS CORP_M_AI_NODIS CORP_F_AI_NODIS CORP_M_AS_NODIS CORP_F_AS_NODIS CORP_M_HP_NODIS CORP_F_HP_NODIS CORP_M_BL_NODIS CORP_F_BL_NODIS CORP_M_WH_NODIS CORP_F_WH_NODIS CORP_M_MR_NODIS CORP_F_MR_NODIS CORP_M_NODIS CORP_F_NODIS CORP_M_NODIS_LEP CORP_F_NODIS_LEP CORP_M_HI_IDEA CORP_F_HI_IDEA CORP_M_AI_IDEA CORP_F_AI_IDEA CORP_M_AS_IDEA CORP_F_AS_IDEA CORP_M_HP_IDEA CORP_F_HP_IDEA CORP_M_BL_IDEA CORP_F_BL_IDEA CORP_M_WH_IDEA CORP_F_WH_IDEA CORP_M_MR_IDEA CORP_F_MR_IDEA CORP_M_IDEA CORP_F_IDEA CORP_M_DIS_LEP CORP_F_DIS_LEP CORP_M_504 CORP_F_504 (max) YEAR RACES_REPORTED CORPIND, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_13_lea.dta", replace

//2015-16
import delimited ".\2015-16-crdc-data\Data Files and Layouts\CRDC 2015-16 School Data.csv", stringcols(3 5 7) clear 
keep lea_state lea_state_name leaid lea_name schid sch_name combokey *corp*
names corp 2015

rename *, upper
gen YEAR = 2015
gen RACES_REPORTED = 7

*recreate COMBOKEY as a string variable with no scientific notation
gen str5 SCHID_NEW = string(real(SCHID), "%05.0f")
gen COMBOKEY_NEW = LEAID + SCHID_NEW
order LEA_STATE LEA_STATE_NAME LEAID LEA_NAME SCHID SCHID_NEW SCH_NAME COMBOKEY COMBOKEY_NEW
drop SCHID COMBOKEY
rename SCHID_NEW SCHID
rename COMBOKEY_NEW COMBOKEY

*instances
gen CORPIND=1 if SCH_CORPINSTANCES_IND=="Yes"
replace CORPIND=0 if SCH_CORPINSTANCES_IND=="No"
replace CORPIND=-5 if SCH_CORPINSTANCES_IND=="-5"
label drop _all
drop SCH_CORPINSTANCES_IND

rename SCH_CORPINSTANCES_WODIS CORPINST_NODIS
rename SCH_CORPINSTANCES_WDIS CORPINST_DIS


*pre-school
rename SCH_PSDISC_CORP_AM_M CORP_M_AI_PS
rename SCH_PSDISC_CORP_AS_M CORP_M_AS_PS
rename SCH_PSDISC_CORP_HI_M CORP_M_HI_PS
rename SCH_PSDISC_CORP_BL_M CORP_M_BL_PS
rename SCH_PSDISC_CORP_WH_M CORP_M_WH_PS
rename SCH_PSDISC_CORP_HP_M CORP_M_HP_PS
rename SCH_PSDISC_CORP_TR_M CORP_M_MR_PS
rename TOT_PSDISC_CORP_M CORP_M_PS
rename SCH_PSDISC_CORP_LEP_M CORP_M_LEP_PS
rename SCH_PSDISC_CORP_IDEA_M CORP_M_IDEA_PS

rename SCH_PSDISC_CORP_AM_F CORP_F_AI_PS
rename SCH_PSDISC_CORP_AS_F CORP_F_AS_PS
rename SCH_PSDISC_CORP_HI_F CORP_F_HI_PS
rename SCH_PSDISC_CORP_BL_F CORP_F_BL_PS
rename SCH_PSDISC_CORP_WH_F CORP_F_WH_PS
rename SCH_PSDISC_CORP_HP_F CORP_F_HP_PS
rename SCH_PSDISC_CORP_TR_F CORP_F_MR_PS
rename TOT_PSDISC_CORP_F CORP_F_PS
rename SCH_PSDISC_CORP_LEP_F CORP_F_LEP_PS
rename SCH_PSDISC_CORP_IDEA_F CORP_F_IDEA_PS

rename SCH_PSCORPINSTANCES_ALL CORPINST_PS
rename SCH_PSCORPINSTANCES_IDEA CORPINST_IDEA_PS

*students without disabilities
rename SCH_DISCWODIS_CORP_AM_M CORP_M_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_M CORP_M_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_M CORP_M_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_M CORP_M_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_M CORP_M_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_M CORP_M_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_M CORP_M_MR_NODIS
rename TOT_DISCWODIS_CORP_M CORP_M_NODIS
rename SCH_DISCWODIS_CORP_LEP_M CORP_M_NODIS_LEP

rename SCH_DISCWODIS_CORP_AM_F CORP_F_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_F CORP_F_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_F CORP_F_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_F CORP_F_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_F CORP_F_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_F CORP_F_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_F CORP_F_MR_NODIS
rename TOT_DISCWODIS_CORP_F CORP_F_NODIS
rename SCH_DISCWODIS_CORP_LEP_F CORP_F_NODIS_LEP

*students with disabilities
rename SCH_DISCWDIS_CORP_IDEA_AM_M CORP_M_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_M CORP_M_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_M CORP_M_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_M CORP_M_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_M CORP_M_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_M CORP_M_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_M CORP_M_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_M CORP_M_IDEA
rename SCH_DISCWDIS_CORP_504_M CORP_M_504 
rename SCH_DISCWDIS_CORP_LEP_M CORP_M_DIS_LEP 

rename SCH_DISCWDIS_CORP_IDEA_AM_F CORP_F_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_F CORP_F_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_F CORP_F_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_F CORP_F_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_F CORP_F_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_F CORP_F_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_F CORP_F_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_F CORP_F_IDEA
rename SCH_DISCWDIS_CORP_504_F CORP_F_504 
rename SCH_DISCWDIS_CORP_LEP_F CORP_F_DIS_LEP 

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

save ".\Cleaned data\CorporalPunishment\corp_15_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY 
collapse (sum) CORP_M_HI_PS CORP_F_HI_PS CORP_M_AI_PS CORP_F_AI_PS CORP_M_AS_PS CORP_F_AS_PS CORP_M_HP_PS CORP_F_HP_PS CORP_M_BL_PS CORP_F_BL_PS CORP_M_WH_PS CORP_F_WH_PS CORP_M_MR_PS CORP_F_MR_PS CORP_M_PS CORP_F_PS CORP_M_LEP_PS CORP_F_LEP_PS CORP_M_IDEA_PS CORP_F_IDEA_PS CORPINST_PS CORPINST_IDEA_PS CORP_M_HI_NODIS CORP_F_HI_NODIS CORP_M_AI_NODIS CORP_F_AI_NODIS CORP_M_AS_NODIS CORP_F_AS_NODIS CORP_M_HP_NODIS CORP_F_HP_NODIS CORP_M_BL_NODIS CORP_F_BL_NODIS CORP_M_WH_NODIS CORP_F_WH_NODIS CORP_M_MR_NODIS CORP_F_MR_NODIS CORP_M_NODIS CORP_F_NODIS CORP_M_NODIS_LEP CORP_F_NODIS_LEP CORP_M_HI_IDEA CORP_F_HI_IDEA CORP_M_AI_IDEA CORP_F_AI_IDEA CORP_M_AS_IDEA CORP_F_AS_IDEA CORP_M_HP_IDEA CORP_F_HP_IDEA CORP_M_BL_IDEA CORP_F_BL_IDEA CORP_M_WH_IDEA CORP_F_WH_IDEA CORP_M_MR_IDEA CORP_F_MR_IDEA CORP_M_IDEA CORP_F_IDEA CORP_M_DIS_LEP CORP_F_DIS_LEP CORP_M_504 CORP_F_504 CORPINST_NODIS CORPINST_DIS (max) YEAR RACES_REPORTED CORPIND, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_15_lea.dta", replace

//2017-18
import delimited ".\2017-18-crdc-data\2017-18-crdc-data-corrected-publication 2\2017-18 Public-Use Files\Data\SCH\CRDC\CSV\Corporal Punishment.csv", stringcols(3 5 7) clear 
drop jj
names corp 2017

gen YEAR = 2017
rename *, upper
gen RACES_REPORTED=7

*instances
gen CORPIND=1 if SCH_CORPINSTANCES_IND=="Yes"
replace CORPIND=0 if SCH_CORPINSTANCES_IND=="No"
replace CORPIND=-5 if SCH_CORPINSTANCES_IND=="-5"
label drop _all
drop SCH_CORPINSTANCES_IND

rename SCH_CORPINSTANCES_WODIS CORPINST_NODIS
rename SCH_CORPINSTANCES_WDIS CORPINST_DIS

*pre-school
rename SCH_PSDISC_CORP_AM_M CORP_M_AI_PS
rename SCH_PSDISC_CORP_AS_M CORP_M_AS_PS
rename SCH_PSDISC_CORP_HI_M CORP_M_HI_PS
rename SCH_PSDISC_CORP_BL_M CORP_M_BL_PS
rename SCH_PSDISC_CORP_WH_M CORP_M_WH_PS
rename SCH_PSDISC_CORP_HP_M CORP_M_HP_PS
rename SCH_PSDISC_CORP_TR_M CORP_M_MR_PS
rename TOT_PSDISC_CORP_M CORP_M_PS
rename SCH_PSDISC_CORP_LEP_M CORP_M_LEP_PS
rename SCH_PSDISC_CORP_IDEA_M CORP_M_IDEA_PS

rename SCH_PSDISC_CORP_AM_F CORP_F_AI_PS
rename SCH_PSDISC_CORP_AS_F CORP_F_AS_PS
rename SCH_PSDISC_CORP_HI_F CORP_F_HI_PS
rename SCH_PSDISC_CORP_BL_F CORP_F_BL_PS
rename SCH_PSDISC_CORP_WH_F CORP_F_WH_PS
rename SCH_PSDISC_CORP_HP_F CORP_F_HP_PS
rename SCH_PSDISC_CORP_TR_F CORP_F_MR_PS
rename TOT_PSDISC_CORP_F CORP_F_PS
rename SCH_PSDISC_CORP_LEP_F CORP_F_LEP_PS
rename SCH_PSDISC_CORP_IDEA_F CORP_F_IDEA_PS

rename SCH_PSCORPINSTANCES_ALL CORPINST_PS
rename SCH_PSCORPINSTANCES_IDEA CORPINST_IDEA_PS

*students without disabilities
rename SCH_DISCWODIS_CORP_AM_M CORP_M_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_M CORP_M_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_M CORP_M_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_M CORP_M_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_M CORP_M_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_M CORP_M_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_M CORP_M_MR_NODIS
rename TOT_DISCWODIS_CORP_M CORP_M_NODIS
rename SCH_DISCWODIS_CORP_LEP_M CORP_M_NODIS_LEP

rename SCH_DISCWODIS_CORP_AM_F CORP_F_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_F CORP_F_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_F CORP_F_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_F CORP_F_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_F CORP_F_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_F CORP_F_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_F CORP_F_MR_NODIS
rename TOT_DISCWODIS_CORP_F CORP_F_NODIS
rename SCH_DISCWODIS_CORP_LEP_F CORP_F_NODIS_LEP

*students with disabilities
rename SCH_DISCWDIS_CORP_IDEA_AM_M CORP_M_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_M CORP_M_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_M CORP_M_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_M CORP_M_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_M CORP_M_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_M CORP_M_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_M CORP_M_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_M CORP_M_IDEA
rename SCH_DISCWDIS_CORP_504_M CORP_M_504 
rename SCH_DISCWDIS_CORP_LEP_M CORP_M_DIS_LEP 

rename SCH_DISCWDIS_CORP_IDEA_AM_F CORP_F_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_F CORP_F_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_F CORP_F_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_F CORP_F_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_F CORP_F_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_F CORP_F_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_F CORP_F_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_F CORP_F_IDEA
rename SCH_DISCWDIS_CORP_504_F CORP_F_504 
rename SCH_DISCWDIS_CORP_LEP_F CORP_F_DIS_LEP 

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

save ".\Cleaned data\CorporalPunishment\corp_17_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY 
collapse (sum) CORP_M_HI_PS CORP_F_HI_PS CORP_M_AI_PS CORP_F_AI_PS CORP_M_AS_PS CORP_F_AS_PS CORP_M_HP_PS CORP_F_HP_PS CORP_M_BL_PS CORP_F_BL_PS CORP_M_WH_PS CORP_F_WH_PS CORP_M_MR_PS CORP_F_MR_PS CORP_M_PS CORP_F_PS CORP_M_LEP_PS CORP_F_LEP_PS CORP_M_IDEA_PS CORP_F_IDEA_PS CORPINST_PS CORPINST_IDEA_PS CORP_M_HI_NODIS CORP_F_HI_NODIS CORP_M_AI_NODIS CORP_F_AI_NODIS CORP_M_AS_NODIS CORP_F_AS_NODIS CORP_M_HP_NODIS CORP_F_HP_NODIS CORP_M_BL_NODIS CORP_F_BL_NODIS CORP_M_WH_NODIS CORP_F_WH_NODIS CORP_M_MR_NODIS CORP_F_MR_NODIS CORP_M_NODIS CORP_F_NODIS CORP_M_NODIS_LEP CORP_F_NODIS_LEP CORP_M_HI_IDEA CORP_F_HI_IDEA CORP_M_AI_IDEA CORP_F_AI_IDEA CORP_M_AS_IDEA CORP_F_AS_IDEA CORP_M_HP_IDEA CORP_F_HP_IDEA CORP_M_BL_IDEA CORP_F_BL_IDEA CORP_M_WH_IDEA CORP_F_WH_IDEA CORP_M_MR_IDEA CORP_F_MR_IDEA CORP_M_IDEA CORP_F_IDEA CORP_M_DIS_LEP CORP_F_DIS_LEP CORP_M_504 CORP_F_504 CORPINST_NODIS CORPINST_DIS (max) YEAR RACES_REPORTED CORPIND, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_17_lea.dta", replace

//2020-21
import delimited ".\2020-21-crdc-data\CRDC\School\Corporal Punishment.csv", stringcols(3 5 7) clear 
drop jj
names corp 2020

gen YEAR = 2020
rename *, upper
gen RACES_REPORTED=7

*instances
gen CORPIND=1 if SCH_CORPINSTANCES_IND=="Yes"
replace CORPIND=0 if SCH_CORPINSTANCES_IND=="No"
replace CORPIND=-5 if SCH_CORPINSTANCES_IND=="-5"
label drop _all
drop SCH_CORPINSTANCES_IND

rename SCH_CORPINSTANCES_WODIS CORPINST_NODIS
rename SCH_CORPINSTANCES_WDIS CORPINST_DIS

*pre-school
rename SCH_PSDISC_CORP_AM_M CORP_M_AI_PS
rename SCH_PSDISC_CORP_AS_M CORP_M_AS_PS
rename SCH_PSDISC_CORP_HI_M CORP_M_HI_PS
rename SCH_PSDISC_CORP_BL_M CORP_M_BL_PS
rename SCH_PSDISC_CORP_WH_M CORP_M_WH_PS
rename SCH_PSDISC_CORP_HP_M CORP_M_HP_PS
rename SCH_PSDISC_CORP_TR_M CORP_M_MR_PS
rename TOT_PSDISC_CORP_M CORP_M_PS
rename SCH_PSDISC_CORP_LEP_M CORP_M_LEP_PS
rename SCH_PSDISC_CORP_IDEA_M CORP_M_IDEA_PS

rename SCH_PSDISC_CORP_AM_F CORP_F_AI_PS
rename SCH_PSDISC_CORP_AS_F CORP_F_AS_PS
rename SCH_PSDISC_CORP_HI_F CORP_F_HI_PS
rename SCH_PSDISC_CORP_BL_F CORP_F_BL_PS
rename SCH_PSDISC_CORP_WH_F CORP_F_WH_PS
rename SCH_PSDISC_CORP_HP_F CORP_F_HP_PS
rename SCH_PSDISC_CORP_TR_F CORP_F_MR_PS
rename TOT_PSDISC_CORP_F CORP_F_PS
rename SCH_PSDISC_CORP_LEP_F CORP_F_LEP_PS
rename SCH_PSDISC_CORP_IDEA_F CORP_F_IDEA_PS

rename SCH_PSCORPINSTANCES_ALL CORPINST_PS
rename SCH_PSCORPINSTANCES_IDEA CORPINST_IDEA_PS

*students without disabilities
rename SCH_DISCWODIS_CORP_AM_M CORP_M_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_M CORP_M_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_M CORP_M_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_M CORP_M_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_M CORP_M_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_M CORP_M_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_M CORP_M_MR_NODIS
rename TOT_DISCWODIS_CORP_M CORP_M_NODIS
rename SCH_DISCWODIS_CORP_LEP_M CORP_M_NODIS_LEP

rename SCH_DISCWODIS_CORP_AM_F CORP_F_AI_NODIS
rename SCH_DISCWODIS_CORP_AS_F CORP_F_AS_NODIS 
rename SCH_DISCWODIS_CORP_HI_F CORP_F_HI_NODIS 
rename SCH_DISCWODIS_CORP_BL_F CORP_F_BL_NODIS 
rename SCH_DISCWODIS_CORP_WH_F CORP_F_WH_NODIS
rename SCH_DISCWODIS_CORP_HP_F CORP_F_HP_NODIS
rename SCH_DISCWODIS_CORP_TR_F CORP_F_MR_NODIS
rename TOT_DISCWODIS_CORP_F CORP_F_NODIS
rename SCH_DISCWODIS_CORP_LEP_F CORP_F_NODIS_LEP

*students with disabilities
rename SCH_DISCWDIS_CORP_IDEA_AM_M CORP_M_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_M CORP_M_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_M CORP_M_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_M CORP_M_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_M CORP_M_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_M CORP_M_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_M CORP_M_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_M CORP_M_IDEA
rename SCH_DISCWDIS_CORP_504_M CORP_M_504 
rename SCH_DISCWDIS_CORP_LEP_M CORP_M_DIS_LEP 

rename SCH_DISCWDIS_CORP_IDEA_AM_F CORP_F_AI_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_AS_F CORP_F_AS_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HI_F CORP_F_HI_IDEA
rename SCH_DISCWDIS_CORP_IDEA_BL_F CORP_F_BL_IDEA
rename SCH_DISCWDIS_CORP_IDEA_WH_F CORP_F_WH_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_HP_F CORP_F_HP_IDEA 
rename SCH_DISCWDIS_CORP_IDEA_TR_F CORP_F_MR_IDEA
rename TOT_DISCWDIS_CORP_IDEA_F CORP_F_IDEA
rename SCH_DISCWDIS_CORP_504_F CORP_F_504 
rename SCH_DISCWDIS_CORP_LEP_F CORP_F_DIS_LEP 

*Replace reserve codes
ds, has(type numeric)
return list
foreach var of varlist `r(varlist)' {
	replace `var' = . if `var' < 0
	}

save ".\Cleaned data\CorporalPunishment\corp_20_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY 
collapse (sum) CORP_M_HI_PS CORP_F_HI_PS CORP_M_AI_PS CORP_F_AI_PS CORP_M_AS_PS CORP_F_AS_PS CORP_M_HP_PS CORP_F_HP_PS CORP_M_BL_PS CORP_F_BL_PS CORP_M_WH_PS CORP_F_WH_PS CORP_M_MR_PS CORP_F_MR_PS CORP_M_PS CORP_F_PS CORP_M_LEP_PS CORP_F_LEP_PS CORP_M_IDEA_PS CORP_F_IDEA_PS CORPINST_PS CORPINST_IDEA_PS CORP_M_HI_NODIS CORP_F_HI_NODIS CORP_M_AI_NODIS CORP_F_AI_NODIS CORP_M_AS_NODIS CORP_F_AS_NODIS CORP_M_HP_NODIS CORP_F_HP_NODIS CORP_M_BL_NODIS CORP_F_BL_NODIS CORP_M_WH_NODIS CORP_F_WH_NODIS CORP_M_MR_NODIS CORP_F_MR_NODIS CORP_M_NODIS CORP_F_NODIS CORP_M_NODIS_LEP CORP_F_NODIS_LEP CORP_M_HI_IDEA CORP_F_HI_IDEA CORP_M_AI_IDEA CORP_F_AI_IDEA CORP_M_AS_IDEA CORP_F_AS_IDEA CORP_M_HP_IDEA CORP_F_HP_IDEA CORP_M_BL_IDEA CORP_F_BL_IDEA CORP_M_WH_IDEA CORP_F_WH_IDEA CORP_M_MR_IDEA CORP_F_MR_IDEA CORP_M_IDEA CORP_F_IDEA CORP_M_DIS_LEP CORP_F_DIS_LEP CORP_M_504 CORP_F_504 CORPINST_NODIS CORPINST_DIS (max) YEAR RACES_REPORTED CORPIND, by(LEAID)
save ".\Cleaned data\CorporalPunishment\corp_20_lea.dta", replace


/// combine historical and contemporary data - district level
use ".\Cleaned data\CorporalPunishment\corp_73to06_lea_RA.dta", clear
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_dis_80to82and94to97_lea_RA.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_nodis_09_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_dis_09_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_nodis_11_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_dis_11_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_13_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_15_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_17_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_20_lea.dta", nogen
sort YEAR LEAID

*calculate total corporal punishment counts by race (sum across single and multiple, disability and no disability)
egen CORP_AI_summed = rowtotal(CORP_M_AI_NODIS CORP_M_AI_IDEA CORP_F_AI_NODIS CORP_F_AI_IDEA), missing
egen CORP_AS_summed = rowtotal(CORP_M_AS_NODIS CORP_M_AS_IDEA CORP_F_AS_NODIS CORP_F_AS_IDEA), missing
egen CORP_HI_summed = rowtotal(CORP_M_HI_NODIS CORP_M_HI_IDEA CORP_F_HI_NODIS CORP_F_HI_IDEA), missing
egen CORP_BL_summed = rowtotal(CORP_M_BL_NODIS CORP_M_BL_IDEA CORP_F_BL_NODIS CORP_F_BL_IDEA), missing
egen CORP_WH_summed = rowtotal(CORP_M_WH_NODIS CORP_M_WH_IDEA CORP_F_WH_NODIS CORP_F_WH_IDEA), missing
egen CORP_HP_summed = rowtotal(CORP_M_HP_NODIS CORP_M_HP_IDEA CORP_F_HP_NODIS CORP_F_HP_IDEA), missing
egen CORP_MR_summed = rowtotal(CORP_M_MR_NODIS CORP_M_MR_IDEA CORP_F_MR_NODIS CORP_F_MR_IDEA), missing

*replace these variables with the summed counts
replace CORP_AI = CORP_AI_summed if CORP_AI==. & CORP_AI_summed!=.
replace CORP_AS = CORP_AS_summed if CORP_AS==. & CORP_AS_summed!=.
replace CORP_BL = CORP_BL_summed if CORP_BL==. & CORP_BL_summed!=.
replace CORP_HI = CORP_HI_summed if CORP_HI==. & CORP_HI_summed!=.
replace CORP_WH = CORP_WH_summed if CORP_WH==. & CORP_WH_summed!=.
gen CORP_HP = CORP_HP_summed 
gen CORP_MR = CORP_MR_summed

drop *_summed 

//calculate a total corporal punishment counts by summing the counts by race. This doesn't always match the reported total variable from older years (OSS)
egen CORP_sumrace = rowtotal(CORP_AI CORP_AS CORP_HI CORP_BL CORP_WH CORP_HP CORP_MR), missing 
 
order YEAR LEAID CORP_AI CORP_AS CORP_HI CORP_BL CORP_WH CORP_HP CORP_MR CORP_sumrace

save ".\Cleaned data\CorporalPunishment\corp_73to20_lea.dta", replace


/// combine contemporary public data - school level
use ".\Cleaned data\CorporalPunishment\corp_nodis_09_sch.dta", clear
merge 1:1 YEAR COMBOKEY using ".\Cleaned data\CorporalPunishment\corp_dis_09_sch.dta", nogen
merge 1:1 YEAR COMBOKEY using ".\Cleaned data\CorporalPunishment\corp_nodis_11_sch.dta", nogen
merge 1:1 YEAR COMBOKEY using ".\Cleaned data\CorporalPunishment\corp_dis_11_sch.dta", nogen
merge 1:1 YEAR COMBOKEY using ".\Cleaned data\CorporalPunishment\corp_13_sch.dta", nogen
merge 1:1 YEAR COMBOKEY using ".\Cleaned data\CorporalPunishment\corp_15_sch.dta", nogen
merge 1:1 YEAR COMBOKEY using ".\Cleaned data\CorporalPunishment\corp_17_sch.dta", nogen
merge 1:1 YEAR COMBOKEY using ".\Cleaned data\CorporalPunishment\corp_20_sch.dta", nogen
save ".\Cleaned data\CorporalPunishment\corp_09to20_sch.dta", replace

//create spreadsheet of variable names
names corp all
use ".\vars_corp_all.dta", clear
*merge 1:1 name_merge gender race DIS LEP PS DSO instances races_reported using ".\vars_corpnodis_2009.dta", nogen
*merge 1:1 name_merge gender race DIS LEP PS DSO instances races_reported using ".\vars_corpdis_2009.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances races_reported using ".\vars_corp_2011.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances races_reported using ".\vars_corp_2013.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances races_reported using ".\vars_corp_2015.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances races_reported using ".\vars_corp_2017.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances races_reported using ".\vars_corp_2020.dta", nogen
drop gender race DIS LEP PS races_reported instances DSO enroll hb_type hb_domain suspension expulsion offense seclusion satactug athletics ssclass course coursetype coursegrade retgrade status name_merge
rename (name_all type_all) (name type)
save ".\Cleaned data\Documentation\vars_corp.dta", replace
erase ".\vars_corp_all.dta"
erase ".\vars_corp_2009.dta"
erase ".\vars_corp_2011.dta"
erase ".\vars_corp_2013.dta"
erase ".\vars_corp_2015.dta"
erase ".\vars_corp_2017.dta"
erase ".\vars_corp_2020.dta"

//add variable labels
do ".\variable labels program.do"
labels ".\Cleaned data\CorporalPunishment\corp_09to20_sch.dta"

/////////Suspension 

//This is code to combine suspension variables across the years //

cd "Set Working Directory"
do ".\variable names program.do"
confirmdir ".\Cleaned data\Documentation\"
if _rc!=0 {
	mkdir ".\Cleaned data\Documentation\"
} 
confirmdir ".\Cleaned data\Suspensions\"
if _rc!=0 {
	mkdir ".\Cleaned data\Suspensions\"
} 

// 1973 to 2006 
capture confirm file ".\Cleaned data\Dropped 2006 - 1.dta"
if _rc==0 {
	use ".\Cleaned data\Dropped 2006 - 1.dta", clear
}
if _rc!=0 {
	import excel ".\crdc_1968_2009_ts COPY\Data\LEA\5. Dropped Data\Dropped 2006 - 1.xlsx", firstrow clear
	save ".\Cleaned data\Dropped 2006 - 1.dta"
}
rename T_AME_SUS OSS_AI
rename T_ASI_SUS OSS_AS
rename T_HIS_SUS OSS_HI
rename T_BLA_SUS OSS_BL
rename T_WHI_SUS OSS_WH
rename T_TOT_SUS OSS
rename T_LEP_SUS OSS_LEP

rename M_AME_SUS OSS_M_AI
rename M_ASI_SUS OSS_M_AS
rename M_HIS_SUS OSS_M_HI
rename M_BLA_SUS OSS_M_BL
rename M_WHI_SUS OSS_M_WH
rename M_TOT_SUS OSS_M
rename M_LEP_SUS OSS_M_LEP

rename F_AME_SUS OSS_F_AI
rename F_ASI_SUS OSS_F_AS
rename F_HIS_SUS OSS_F_HI
rename F_BLA_SUS OSS_F_BL
rename F_WHI_SUS OSS_F_WH
rename F_TOT_SUS OSS_F
rename F_LEP_SUS OSS_F_LEP

keep YEAR LEAID OSS*
destring YEAR OSS*, replace
save ".\Cleaned data\Suspensions\sus_oss_73to06.dta", replace


// 2009 (from historical, restricted access time series data)

*students with disabilities - 1 out of school suspension
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students with Disabilities\Pt2-w Dis 1 out-sch susp(Q35).xlsx", sheet("Pt2-w Dis 1 out-sch susp(Q35)") firstrow clear

destring, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

//counts by race sum only to the TOT_IDEA counts and do not include TOT_504
gen SINGOSS_M_AI_IDEA = M_AME_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_AI_IDEA = M_AME_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_M_AS_IDEA = M_ASI_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_AS_IDEA = M_ASI_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_M_HI_IDEA = M_HIS_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_HI_IDEA = M_HIS_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_M_BL_IDEA = M_BLA_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_BL_IDEA = M_BLA_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_M_WH_IDEA = M_WHI_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_WH_IDEA = M_WHI_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_M_HP_IDEA = M_HI_PAC_7_SINGLE_SUS_DIS
gen SINGOSS_M_MR_IDEA = M_2_OR_MORE_7_SINGLE_SUS_DIS
gen SINGOSS_M_IDEA = M_TOT_IDEA_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_IDEA = M_TOT_IDEA_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_M_504 = M_504_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_504 = M_504_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_M_DIS_LEP = M_LEP_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_M_DIS_LEP = M_LEP_7_SINGLE_SUS_DIS if RACES_REPORTED==7 //unclear if this is IDEA + 504?

gen SINGOSS_F_AI_IDEA = F_AME_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_F_AI_IDEA = F_AME_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_F_AS_IDEA = F_ASI_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_F_AS_IDEA = F_ASI_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_F_HI_IDEA = F_HIS_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_F_HI_IDEA = F_HIS_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_F_BL_IDEA = F_BLA_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_F_BL_IDEA = F_BLA_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_F_WH_IDEA = F_WHI_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_F_WH_IDEA = F_WHI_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_F_HP_IDEA = F_HI_PAC_7_SINGLE_SUS_DIS
gen SINGOSS_F_MR_IDEA = F_2_OR_MORE_7_SINGLE_SUS_DIS
gen SINGOSS_F_IDEA = F_TOT_IDEA_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_F_IDEA = F_TOT_IDEA_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_F_504 = F_504_5_SINGLE_SUS_DIS if RACES_REPORTED==5 
replace SINGOSS_F_504 = F_504_7_SINGLE_SUS_DIS if RACES_REPORTED==7
gen SINGOSS_F_DIS_LEP = F_LEP_5_SINGLE_SUS_DIS if RACES_REPORTED==5
replace SINGOSS_F_DIS_LEP = F_LEP_7_SINGLE_SUS_DIS if RACES_REPORTED==7 //unclear if this is IDEA + 504? 

keep YEAR LEAID LEA_STATE RACES_REPORTED SINGOSS* 
save ".\Cleaned data\Suspensions\sus_singoss_dis_09_RA.dta", replace

*students with disabilities - more than 1 out of school suspension
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students with Disabilities\Pt2-w Dis more1 out-susp(Q35).xlsx", sheet("Pt2-w Dis more1 out-susp(Q35)") firstrow clear

destring, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

//counts by race sum only to the TOT_IDEA counts and do not include TOT_504
gen MULTOSS_M_AI_IDEA = M_AME_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_AI_IDEA = M_AME_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_M_AS_IDEA = M_ASI_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_AS_IDEA = M_ASI_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_M_HI_IDEA = M_HIS_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_HI_IDEA = M_HIS_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_M_BL_IDEA = M_BLA_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_BL_IDEA = M_BLA_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_M_WH_IDEA = M_WHI_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_WH_IDEA = M_WHI_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_M_HP_IDEA = M_HI_PAC_7_MULT_SUS_DIS
gen MULTOSS_M_MR_IDEA = M_2_OR_MORE_7_MULT_SUS_DIS
gen MULTOSS_M_IDEA = M_TOT_IDEA_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_IDEA = M_TOT_IDEA_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_M_504 = M_504_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_504 = M_504_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_M_DIS_LEP = M_LEP_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_M_DIS_LEP = M_LEP_7_MULT_SUS_DIS if RACES_REPORTED==7 //unclear if this is IDEA + 504?

gen MULTOSS_F_AI_IDEA = F_AME_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_F_AI_IDEA = F_AME_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_F_AS_IDEA = F_ASI_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_F_AS_IDEA = F_ASI_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_F_HI_IDEA = F_HIS_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_F_HI_IDEA = F_HIS_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_F_BL_IDEA = F_BLA_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_F_BL_IDEA = F_BLA_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_F_WH_IDEA = F_WHI_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_F_WH_IDEA = F_WHI_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_F_HP_IDEA = F_HI_PAC_7_MULT_SUS_DIS
gen MULTOSS_F_MR_IDEA = F_2_OR_MORE_7_MULT_SUS_DIS
gen MULTOSS_F_IDEA = F_TOT_IDEA_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_F_IDEA = F_TOT_IDEA_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_F_504 = F_504_5_MULT_SUS_DIS if RACES_REPORTED==5 
replace MULTOSS_F_504 = F_504_7_MULT_SUS_DIS if RACES_REPORTED==7
gen MULTOSS_F_DIS_LEP = F_LEP_5_MULT_SUS_DIS if RACES_REPORTED==5
replace MULTOSS_F_DIS_LEP = F_LEP_7_MULT_SUS_DIS if RACES_REPORTED==7 //unclear if this is IDEA + 504? 

keep YEAR LEAID LEA_STATE RACES_REPORTED MULTOSS*
save ".\Cleaned data\Suspensions\sus_multoss_dis_09_RA.dta", replace

*students with disabilities - in school suspension
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students with Disabilities\Pt2-w Disab in-sch susp(Q35).xlsx", sheet("Pt2-w Disab in-sch susp(Q35)") firstrow clear

destring, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen ISS_M_AI_IDEA = M_AME_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_AI_IDEA = M_AME_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_M_AS_IDEA = M_ASI_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_AS_IDEA = M_ASI_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_M_HI_IDEA = M_HIS_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_HI_IDEA = M_HIS_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_M_BL_IDEA = M_BLA_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_BL_IDEA = M_BLA_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_M_WH_IDEA = M_WHI_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_WH_IDEA = M_WHI_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_M_HP_IDEA = M_HI_PAC_7_IN_SCH_SUS_DIS
gen ISS_M_MR_IDEA = M_2_OR_MORE_7_IN_SCH_SUS_DIS
gen ISS_M_IDEA = M_TOT_IDEA_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_IDEA = M_TOT_IDEA_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_M_504 = M_504_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_504 = M_504_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_M_DIS_LEP = M_LEP_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_M_DIS_LEP = M_LEP_7_IN_SCH_SUS_DIS if RACES_REPORTED==7 //unclear if this is IDEA + 504?

gen ISS_F_AI_IDEA = F_AME_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_F_AI_IDEA = F_AME_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_F_AS_IDEA = F_ASI_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_F_AS_IDEA = F_ASI_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_F_HI_IDEA = F_HIS_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_F_HI_IDEA = F_HIS_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_F_BL_IDEA = F_BLA_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_F_BL_IDEA = F_BLA_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_F_WH_IDEA = F_WHI_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_F_WH_IDEA = F_WHI_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_F_HP_IDEA = F_HI_PAC_7_IN_SCH_SUS_DIS
gen ISS_F_MR_IDEA = F_2_OR_MORE_7_IN_SCH_SUS_DIS
gen ISS_F_IDEA = F_TOT_IDEA_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_F_IDEA = F_TOT_IDEA_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_F_504 = F_504_5_IN_SCH_SUS_DIS if RACES_REPORTED==5 
replace ISS_F_504 = F_504_7_IN_SCH_SUS_DIS if RACES_REPORTED==7
gen ISS_F_DIS_LEP = F_LEP_5_IN_SCH_SUS_DIS if RACES_REPORTED==5
replace ISS_F_DIS_LEP = F_LEP_7_IN_SCH_SUS_DIS if RACES_REPORTED==7 //unclear if this is IDEA + 504?

keep YEAR LEAID LEA_STATE RACES_REPORTED ISS*
save ".\Cleaned data\Suspensions\sus_iss_dis_09_RA.dta", replace

*students without disabilities - 1 out of school suspension
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students without Disabilities\Pt2-wo Dis 1 out-sch susp(Q34).xlsx", sheet("Pt2-wo Dis 1 out-sch susp(Q34)") firstrow clear

destring, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen SINGOSS_M_AI_NODIS = M_AME_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_M_AI_NODIS = M_AME_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_M_AS_NODIS = M_ASI_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_M_AS_NODIS = M_ASI_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_M_HI_NODIS = M_HIS_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_M_HI_NODIS = M_HIS_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_M_BL_NODIS = M_BLA_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_M_BL_NODIS = M_BLA_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_M_WH_NODIS = M_WHI_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_M_WH_NODIS = M_WHI_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_M_HP_NODIS = M_HI_PAC_7_SINGLE_SUS_NO_DIS
gen SINGOSS_M_MR_NODIS = M_2_OR_MORE_7_SINGLE_SUS_NO_DIS
gen SINGOSS_M_NODIS = M_TOT_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_M_NODIS = M_TOT_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_M_NODIS_LEP = M_LEP_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_M_NODIS_LEP = M_LEP_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7 

gen SINGOSS_F_AI_NODIS = F_AME_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_F_AI_NODIS = F_AME_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_F_AS_NODIS = F_ASI_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_F_AS_NODIS = F_ASI_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_F_HI_NODIS = F_HIS_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_F_HI_NODIS = F_HIS_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_F_BL_NODIS = F_BLA_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_F_BL_NODIS = F_BLA_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_F_WH_NODIS = F_WHI_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_F_WH_NODIS = F_WHI_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_F_HP_NODIS = F_HI_PAC_7_SINGLE_SUS_NO_DIS
gen SINGOSS_F_MR_NODIS = F_2_OR_MORE_7_SINGLE_SUS_NO_DIS
gen SINGOSS_F_NODIS = F_TOT_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_F_NODIS = F_TOT_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7
gen SINGOSS_F_NODIS_LEP = F_LEP_5_SINGLE_SUS_NO_DIS if RACES_REPORTED==5
replace SINGOSS_F_NODIS_LEP = F_LEP_7_SINGLE_SUS_NO_DIS if RACES_REPORTED==7 

keep YEAR LEAID LEA_STATE RACES_REPORTED SINGOSS*
save ".\Cleaned data\Suspensions\sus_singoss_nodis_09_RA.dta", replace

*students without disabilities - more than 1 out of school suspension
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students without Disabilities\Pt2-wo Dis more1 out-susp(Q34).xlsx", sheet("Pt2-wo Dis more1 out-susp(Q34)") firstrow clear

destring, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen MULTOSS_M_AI_NODIS = M_AME_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_M_AI_NODIS = M_AME_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_M_AS_NODIS = M_ASI_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_M_AS_NODIS = M_ASI_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_M_HI_NODIS = M_HIS_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_M_HI_NODIS = M_HIS_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_M_BL_NODIS = M_BLA_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_M_BL_NODIS = M_BLA_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_M_WH_NODIS = M_WHI_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_M_WH_NODIS = M_WHI_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_M_HP_NODIS = M_HI_PAC_7_MULT_SUS_NO_DIS
gen MULTOSS_M_MR_NODIS = M_2_OR_MORE_7_MULT_SUS_NO_DIS
gen MULTOSS_M_NODIS = M_TOT_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_M_NODIS = M_TOT_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_M_NODIS_LEP = M_LEP_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_M_NODIS_LEP = M_LEP_7_MULT_SUS_NO_DIS if RACES_REPORTED==7 

gen MULTOSS_F_AI_NODIS = F_AME_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_F_AI_NODIS = F_AME_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_F_AS_NODIS = F_ASI_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_F_AS_NODIS = F_ASI_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_F_HI_NODIS = F_HIS_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_F_HI_NODIS = F_HIS_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_F_BL_NODIS = F_BLA_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_F_BL_NODIS = F_BLA_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_F_WH_NODIS = F_WHI_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_F_WH_NODIS = F_WHI_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_F_HP_NODIS = F_HI_PAC_7_MULT_SUS_NO_DIS
gen MULTOSS_F_MR_NODIS = F_2_OR_MORE_7_MULT_SUS_NO_DIS
gen MULTOSS_F_NODIS = F_TOT_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_F_NODIS = F_TOT_7_MULT_SUS_NO_DIS if RACES_REPORTED==7
gen MULTOSS_F_NODIS_LEP = F_LEP_5_MULT_SUS_NO_DIS if RACES_REPORTED==5
replace MULTOSS_F_NODIS_LEP = F_LEP_7_MULT_SUS_NO_DIS if RACES_REPORTED==7

keep YEAR LEAID LEA_STATE RACES_REPORTED MULTOSS*
save ".\Cleaned data\Suspensions\sus_multoss_nodis_09_RA.dta", replace

*students without disabilities - in school suspension
import excel ".\crdc_1968_2009_ts COPY\Data\LEA\3. CRDC-collected School level data aggregated for LEAs\Pt 2-Discipline of Students without Disabilities\Pt2-wo Disab in-sch susp(Q34).xlsx", sheet("Pt2-wo Disab in-sch susp(Q34)") firstrow clear

destring, ignore("-") replace

egen total_5 = rowtotal(*_5_*)
egen total_7 = rowtotal(*_7_*)
count if total_5 != 0 & total_7 != 0
gen RACES_REPORTED = 5
replace RACES_REPORTED = 7 if total_7 != . & total_7 != 0
drop total_5 total_7 //some districts report in terms of 5 racial groups, others report in terms of 7 racial groups. No districts report both

gen ISS_M_AI_NODIS = M_AME_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_M_AI_NODIS = M_AME_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_M_AS_NODIS = M_ASI_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_M_AS_NODIS = M_ASI_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_M_HI_NODIS = M_HIS_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_M_HI_NODIS = M_HIS_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_M_BL_NODIS = M_BLA_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_M_BL_NODIS = M_BLA_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_M_WH_NODIS = M_WHI_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_M_WH_NODIS = M_WHI_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_M_HP_NODIS = M_HI_PAC_7_IN_SCH_SUS_NO_DIS
gen ISS_M_MR_NODIS = M_2_OR_MORE_7_IN_SCH_SUS_NO_DIS
gen ISS_M_NODIS = M_TOT_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_M_NODIS = M_TOT_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_M_NODIS_LEP = M_LEP_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_M_NODIS_LEP = M_LEP_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7 

gen ISS_F_AI_NODIS = F_AME_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_F_AI_NODIS = F_AME_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_F_AS_NODIS = F_ASI_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_F_AS_NODIS = F_ASI_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_F_HI_NODIS = F_HIS_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_F_HI_NODIS = F_HIS_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_F_BL_NODIS = F_BLA_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_F_BL_NODIS = F_BLA_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_F_WH_NODIS = F_WHI_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_F_WH_NODIS = F_WHI_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_F_HP_NODIS = F_HI_PAC_7_IN_SCH_SUS_NO_DIS
gen ISS_F_MR_NODIS = F_2_OR_MORE_7_IN_SCH_SUS_NO_DIS
gen ISS_F_NODIS = F_TOT_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_F_NODIS = F_TOT_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7
gen ISS_F_NODIS_LEP = F_LEP_5_IN_SCH_SUS_NO_DIS if RACES_REPORTED==5
replace ISS_F_NODIS_LEP = F_LEP_7_IN_SCH_SUS_NO_DIS if RACES_REPORTED==7

keep YEAR LEAID LEA_STATE RACES_REPORTED ISS*
save ".\Cleaned data\Suspensions\sus_iss_nodis_09_RA.dta", replace

// 2009-10 (from public use school level data)
/*
*students with disabilities - 1 out of school suspension
import excel ".\2009-10-crdc-data\2009-12 Public Use File\CRDC -collected data\School\Pt 2-Discipline of Students with Disabilities\CRDC-data_SCH_Pt 2-Dis of Stud with Dis_Pt 2-Students W Dis Receiving only one out-of-school suspension.xlsx", firstrow clear

gen YEAR=2009

destring, ignore("-") replace
*/


// 2011-12 (from public use school level data)

*students with disabilities - 1 out of school suspension
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Discpline of Students with Disabilities\2011-12 Public Use File_SCH_CRDC-Pt 2_36-3 - Stud W Dis Receiving only one out- (1).xlsx", firstrow clear
drop JJ
names singossdis 2011

destring M_AME_7_SINGLE_SUS_DIS-F_LEP_7_SINGLE_SUS_DIS, ignore("‡") replace

gen YEAR=2011
gen RACES_REPORTED=7 //all districts report in terms of 7 racial groups in this year

rename M_AME_7_SINGLE_SUS_DIS SINGOSS_M_AI_IDEA
rename M_ASI_7_SINGLE_SUS_DIS SINGOSS_M_AS_IDEA
rename M_HIS_7_SINGLE_SUS_DIS SINGOSS_M_HI_IDEA
rename M_BLA_7_SINGLE_SUS_DIS SINGOSS_M_BL_IDEA
rename M_WHI_7_SINGLE_SUS_DIS SINGOSS_M_WH_IDEA
rename M_HI_PAC_7_SINGLE_SUS_DIS SINGOSS_M_HP_IDEA
rename M_2_OR_MORE_7_SINGLE_SUS_DIS SINGOSS_M_MR_IDEA
rename M_TOT_IDEA_7_SINGLE_SUS_DIS SINGOSS_M_IDEA
rename M_504_7_SINGLE_SUS_DIS SINGOSS_M_504
rename M_LEP_7_SINGLE_SUS_DIS SINGOSS_M_DIS_LEP

rename F_AME_7_SINGLE_SUS_DIS SINGOSS_F_AI_IDEA
rename F_ASI_7_SINGLE_SUS_DIS SINGOSS_F_AS_IDEA
rename F_HIS_7_SINGLE_SUS_DIS SINGOSS_F_HI_IDEA
rename F_BLA_7_SINGLE_SUS_DIS SINGOSS_F_BL_IDEA
rename F_WHI_7_SINGLE_SUS_DIS SINGOSS_F_WH_IDEA
rename F_HI_PAC_7_SINGLE_SUS_DIS SINGOSS_F_HP_IDEA
rename F_2_OR_MORE_7_SINGLE_SUS_DIS SINGOSS_F_MR_IDEA
rename F_TOT_IDEA_7_SINGLE_SUS_DIS SINGOSS_F_IDEA
rename F_504_7_SINGLE_SUS_DIS SINGOSS_F_504
rename F_LEP_7_SINGLE_SUS_DIS SINGOSS_F_DIS_LEP

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\Suspensions\sus_singoss_dis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY
collapse (sum) SINGOSS_M_AI_IDEA SINGOSS_M_AS_IDEA SINGOSS_M_HI_IDEA SINGOSS_M_BL_IDEA SINGOSS_M_WH_IDEA SINGOSS_M_HP_IDEA SINGOSS_M_MR_IDEA SINGOSS_M_IDEA SINGOSS_M_504 SINGOSS_M_DIS_LEP SINGOSS_F_AI_IDEA SINGOSS_F_AS_IDEA SINGOSS_F_HI_IDEA SINGOSS_F_BL_IDEA SINGOSS_F_WH_IDEA SINGOSS_F_HP_IDEA SINGOSS_F_MR_IDEA SINGOSS_F_IDEA SINGOSS_F_504 SINGOSS_F_DIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_singoss_dis_11_lea.dta", replace


*students with disabilities - more than 1 out of school suspension
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Discpline of Students with Disabilities\2011-12 Public Use File_SCH_CRDC-Pt 2_36-4 - Stud W Dis Receiving more than one out-of (1).xlsx", firstrow clear
drop JJ
names multossdis 2011

destring M_AME_7_MULT_SUS_DIS-F_LEP_7_MULT_SUS_DIS, ignore("‡") replace

gen YEAR=2011
gen RACES_REPORTED=7 //all districts report in terms of 7 racial groups in this year

rename M_AME_7_MULT_SUS_DIS MULTOSS_M_AI_IDEA
rename M_ASI_7_MULT_SUS_DIS MULTOSS_M_AS_IDEA
rename M_HIS_7_MULT_SUS_DIS MULTOSS_M_HI_IDEA
rename M_BLA_7_MULT_SUS_DIS MULTOSS_M_BL_IDEA
rename M_WHI_7_MULT_SUS_DIS MULTOSS_M_WH_IDEA
rename M_HI_PAC_7_MULT_SUS_DIS MULTOSS_M_HP_IDEA
rename M_2_OR_MORE_7_MULT_SUS_DIS MULTOSS_M_MR_IDEA
rename M_TOT_IDEA_7_MULT_SUS_DIS MULTOSS_M_IDEA
rename M_504_7_MULT_SUS_DIS MULTOSS_M_504
rename M_LEP_7_MULT_SUS_DIS MULTOSS_M_DIS_LEP

rename F_AME_7_MULT_SUS_DIS MULTOSS_F_AI_IDEA
rename F_ASI_7_MULT_SUS_DIS MULTOSS_F_AS_IDEA
rename F_HIS_7_MULT_SUS_DIS MULTOSS_F_HI_IDEA
rename F_BLA_7_MULT_SUS_DIS MULTOSS_F_BL_IDEA
rename F_WHI_7_MULT_SUS_DIS MULTOSS_F_WH_IDEA
rename F_HI_PAC_7_MULT_SUS_DIS MULTOSS_F_HP_IDEA
rename F_2_OR_MORE_7_MULT_SUS_DIS MULTOSS_F_MR_IDEA
rename F_TOT_IDEA_7_MULT_SUS_DIS MULTOSS_F_IDEA
rename F_504_7_MULT_SUS_DIS MULTOSS_F_504
rename F_LEP_7_MULT_SUS_DIS MULTOSS_F_DIS_LEP

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\Suspensions\sus_multoss_dis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY 
collapse (sum) MULTOSS_M_AI_IDEA MULTOSS_M_AS_IDEA MULTOSS_M_HI_IDEA MULTOSS_M_BL_IDEA MULTOSS_M_WH_IDEA MULTOSS_M_HP_IDEA MULTOSS_M_MR_IDEA MULTOSS_M_IDEA MULTOSS_M_504 MULTOSS_M_DIS_LEP MULTOSS_F_AI_IDEA MULTOSS_F_AS_IDEA MULTOSS_F_HI_IDEA MULTOSS_F_BL_IDEA MULTOSS_F_WH_IDEA MULTOSS_F_HP_IDEA MULTOSS_F_MR_IDEA MULTOSS_F_IDEA MULTOSS_F_504 MULTOSS_F_DIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_multoss_dis_11_lea.dta", replace

*students with disabilities - in school suspension
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Discpline of Students with Disabilities\2011-12 Public Use File_SCH_CRDC-Pt 2_36-2 - Stud W Dis Receiving one or more i (1).xlsx", firstrow clear
drop JJ
names issdis 2011

destring M_AME_7_IN_SCH_SUS_DIS-F_LEP_7_IN_SCH_SUS_DIS, ignore("‡") replace

gen YEAR=2011
gen RACES_REPORTED = 7 //all districts report in terms of 7 racial groups in this year

rename M_AME_7_IN_SCH_SUS_DIS ISS_M_AI_IDEA
rename M_ASI_7_IN_SCH_SUS_DIS ISS_M_AS_IDEA
rename M_HIS_7_IN_SCH_SUS_DIS ISS_M_HI_IDEA
rename M_BLA_7_IN_SCH_SUS_DIS ISS_M_BL_IDEA
rename M_WHI_7_IN_SCH_SUS_DIS ISS_M_WH_IDEA
rename M_HI_PAC_7_IN_SCH_SUS_DIS ISS_M_HP_IDEA
rename M_2_OR_MORE_7_IN_SCH_SUS_DIS ISS_M_MR_IDEA
rename M_TOT_IDEA_7_IN_SCH_SUS_DIS ISS_M_IDEA
rename M_504_7_IN_SCH_SUS_DIS ISS_M_504
rename M_LEP_7_IN_SCH_SUS_DIS ISS_M_DIS_LEP

rename F_AME_7_IN_SCH_SUS_DIS ISS_F_AI_IDEA
rename F_ASI_7_IN_SCH_SUS_DIS ISS_F_AS_IDEA
rename F_HIS_7_IN_SCH_SUS_DIS ISS_F_HI_IDEA
rename F_BLA_7_IN_SCH_SUS_DIS ISS_F_BL_IDEA
rename F_WHI_7_IN_SCH_SUS_DIS ISS_F_WH_IDEA
rename F_HI_PAC_7_IN_SCH_SUS_DIS ISS_F_HP_IDEA
rename F_2_OR_MORE_7_IN_SCH_SUS_DIS ISS_F_MR_IDEA
rename F_TOT_IDEA_7_IN_SCH_SUS_DIS ISS_F_IDEA
rename F_504_7_IN_SCH_SUS_DIS ISS_F_504
rename F_LEP_7_IN_SCH_SUS_DIS ISS_F_DIS_LEP

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\Suspensions\sus_iss_dis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY INCOMPLETE
collapse (sum) ISS_M_AI_IDEA ISS_M_AS_IDEA ISS_M_HI_IDEA ISS_M_BL_IDEA ISS_M_WH_IDEA ISS_M_HP_IDEA ISS_M_MR_IDEA ISS_M_IDEA ISS_M_504 ISS_M_DIS_LEP ISS_F_AI_IDEA ISS_F_AS_IDEA ISS_F_HI_IDEA ISS_F_BL_IDEA ISS_F_WH_IDEA ISS_F_HP_IDEA ISS_F_MR_IDEA ISS_F_IDEA ISS_F_504 ISS_F_DIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_iss_dis_11_lea.dta", replace


*students without disabilities - 1 out of school suspension
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Disc of Stud wo Disab\2011-12 Public Use File_SCH_CRDC-Pt 2_35-3 - Students WO Dis Receiving 1 out-of-sch.xlsx", firstrow clear
drop JJ
names singossnodis 2011

destring M_AME_7_SINGLE_SUS_NO_DIS-F_LEP_7_SINGLE_SUS_NO_DIS, ignore("‡") replace

gen YEAR=2011
gen RACES_REPORTED = 7 //all districts report in terms of 7 racial groups in this year

rename M_AME_7_SINGLE_SUS_NO_DIS SINGOSS_M_AI_NODIS
rename M_ASI_7_SINGLE_SUS_NO_DIS SINGOSS_M_AS_NODIS
rename M_HIS_7_SINGLE_SUS_NO_DIS SINGOSS_M_HI_NODIS
rename M_BLA_7_SINGLE_SUS_NO_DIS SINGOSS_M_BL_NODIS
rename M_WHI_7_SINGLE_SUS_NO_DIS SINGOSS_M_WH_NODIS
rename M_HI_PAC_7_SINGLE_SUS_NO_DIS SINGOSS_M_HP_NODIS
rename M_2_OR_MORE_7_SINGLE_SUS_NO_DIS SINGOSS_M_MR_NODIS
rename M_TOT_7_SINGLE_SUS_NO_DIS SINGOSS_M_NODIS
rename M_LEP_7_SINGLE_SUS_NO_DIS SINGOSS_M_NODIS_LEP

rename F_AME_7_SINGLE_SUS_NO_DIS SINGOSS_F_AI_NODIS
rename F_ASI_7_SINGLE_SUS_NO_DIS SINGOSS_F_AS_NODIS
rename F_HIS_7_SINGLE_SUS_NO_DIS SINGOSS_F_HI_NODIS
rename F_BLA_7_SINGLE_SUS_NO_DIS SINGOSS_F_BL_NODIS
rename F_WHI_7_SINGLE_SUS_NO_DIS SINGOSS_F_WH_NODIS
rename F_HI_PAC_7_SINGLE_SUS_NO_DIS SINGOSS_F_HP_NODIS
rename F_2_OR_MORE_7_SINGLE_SUS_NO_DIS SINGOSS_F_MR_NODIS
rename F_TOT_7_SINGLE_SUS_NO_DIS SINGOSS_F_NODIS
rename F_LEP_7_SINGLE_SUS_NO_DIS SINGOSS_F_NODIS_LEP

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\Suspensions\sus_singoss_nodis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY INCOMPLETE
collapse (sum) SINGOSS_M_AI_NODIS SINGOSS_M_AS_NODIS SINGOSS_M_HI_NODIS SINGOSS_M_BL_NODIS SINGOSS_M_WH_NODIS SINGOSS_M_HP_NODIS SINGOSS_M_MR_NODIS SINGOSS_M_NODIS SINGOSS_M_NODIS_LEP SINGOSS_F_AI_NODIS SINGOSS_F_AS_NODIS SINGOSS_F_HI_NODIS SINGOSS_F_BL_NODIS SINGOSS_F_WH_NODIS SINGOSS_F_HP_NODIS SINGOSS_F_MR_NODIS SINGOSS_F_NODIS SINGOSS_F_NODIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_singoss_nodis_11_lea.dta", replace

*students without disabilities - more than 1 out of school suspension
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Disc of Stud wo Disab\2011-12 Public Use File_SCH_CRDC-Pt 2_35-4 - Students WO Disab Rec 1+ out-of-scho.xlsx", firstrow clear
drop JJ
names multossnodis 2011

destring M_AME_7_MULT_SUS_NO_DIS-F_LEP_7_MULT_SUS_NO_DIS, ignore("‡") replace

gen YEAR=2011
gen RACES_REPORTED = 7 //all districts report in terms of 7 racial groups in this year

rename M_AME_7_MULT_SUS_NO_DIS MULTOSS_M_AI_NODIS
rename M_ASI_7_MULT_SUS_NO_DIS MULTOSS_M_AS_NODIS
rename M_HIS_7_MULT_SUS_NO_DIS MULTOSS_M_HI_NODIS
rename M_BLA_7_MULT_SUS_NO_DIS MULTOSS_M_BL_NODIS
rename M_WHI_7_MULT_SUS_NO_DIS MULTOSS_M_WH_NODIS
rename M_HI_PAC_7_MULT_SUS_NO_DIS MULTOSS_M_HP_NODIS
rename M_2_OR_MORE_7_MULT_SUS_NO_DIS MULTOSS_M_MR_NODIS
rename M_TOT_7_MULT_SUS_NO_DIS MULTOSS_M_NODIS
rename M_LEP_7_MULT_SUS_NO_DIS MULTOSS_M_NODIS_LEP

rename F_AME_7_MULT_SUS_NO_DIS MULTOSS_F_AI_NODIS
rename F_ASI_7_MULT_SUS_NO_DIS MULTOSS_F_AS_NODIS
rename F_HIS_7_MULT_SUS_NO_DIS MULTOSS_F_HI_NODIS
rename F_BLA_7_MULT_SUS_NO_DIS MULTOSS_F_BL_NODIS
rename F_WHI_7_MULT_SUS_NO_DIS MULTOSS_F_WH_NODIS
rename F_HI_PAC_7_MULT_SUS_NO_DIS MULTOSS_F_HP_NODIS
rename F_2_OR_MORE_7_MULT_SUS_NO_DIS MULTOSS_F_MR_NODIS
rename F_TOT_7_MULT_SUS_NO_DIS MULTOSS_F_NODIS
rename F_LEP_7_MULT_SUS_NO_DIS MULTOSS_F_NODIS_LEP

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\Suspensions\sus_multoss_nodis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY INCOMPLETE
collapse (sum) MULTOSS_M_AI_NODIS MULTOSS_M_AS_NODIS MULTOSS_M_HI_NODIS MULTOSS_M_BL_NODIS MULTOSS_M_WH_NODIS MULTOSS_M_HP_NODIS MULTOSS_M_MR_NODIS MULTOSS_M_NODIS MULTOSS_M_NODIS_LEP MULTOSS_F_AI_NODIS MULTOSS_F_AS_NODIS MULTOSS_F_HI_NODIS MULTOSS_F_BL_NODIS MULTOSS_F_WH_NODIS MULTOSS_F_HP_NODIS MULTOSS_F_MR_NODIS MULTOSS_F_NODIS MULTOSS_F_NODIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_multoss_nodis_11_lea.dta", replace

*students without disabilities - in school suspension
import excel ".\2011-12-crdc-data\2011-12 Public Use File\SCH\CRDC-collected data file for schools\Pt 2-Disc of Stud wo Disab\2011-12 Public Use File_SCH_CRDC-Pt 2_35-2 - Students WO Dis Receiving 1+ in-scho.xlsx", firstrow clear
drop JJ
names issnodis 2011

destring M_AME_7_IN_SCH_SUS_NO_DIS-F_LEP_7_IN_SCH_SUS_NO_DIS, ignore("‡") replace

gen YEAR=2011
gen RACES_REPORTED = 7 //all districts report in terms of 7 racial groups in this year

rename M_AME_7_IN_SCH_SUS_NO_DIS ISS_M_AI_NODIS
rename M_ASI_7_IN_SCH_SUS_NO_DIS ISS_M_AS_NODIS
rename M_HIS_7_IN_SCH_SUS_NO_DIS ISS_M_HI_NODIS
rename M_BLA_7_IN_SCH_SUS_NO_DIS ISS_M_BL_NODIS
rename M_WHI_7_IN_SCH_SUS_NO_DIS ISS_M_WH_NODIS
rename M_HI_PAC_7_IN_SCH_SUS_NO_DIS ISS_M_HP_NODIS
rename M_2_OR_MORE_7_IN_SCH_SUS_NO_DIS ISS_M_MR_NODIS
rename M_TOT_7_IN_SCH_SUS_NO_DIS ISS_M_NODIS
rename M_LEP_7_IN_SCH_SUS_NO_DIS ISS_M_NODIS_LEP

rename F_AME_7_IN_SCH_SUS_NO_DIS ISS_F_AI_NODIS
rename F_ASI_7_IN_SCH_SUS_NO_DIS ISS_F_AS_NODIS
rename F_HIS_7_IN_SCH_SUS_NO_DIS ISS_F_HI_NODIS
rename F_BLA_7_IN_SCH_SUS_NO_DIS ISS_F_BL_NODIS
rename F_WHI_7_IN_SCH_SUS_NO_DIS ISS_F_WH_NODIS
rename F_HI_PAC_7_IN_SCH_SUS_NO_DIS ISS_F_HP_NODIS
rename F_2_OR_MORE_7_IN_SCH_SUS_NO_DIS ISS_F_MR_NODIS
rename F_TOT_7_IN_SCH_SUS_NO_DIS ISS_F_NODIS
rename F_LEP_7_IN_SCH_SUS_NO_DIS ISS_F_NODIS_LEP

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

*Encode incomplete
encode Incomplete, gen(Inc_num)
recode Inc_num (.=0) (2 = 1) (3=1)
drop Incomplete
rename Inc_num INCOMPLETE
label drop _all

save ".\Cleaned data\Suspensions\sus_iss_nodis_11_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY INCOMPLETE
collapse (sum) ISS_M_AI_NODIS ISS_M_AS_NODIS ISS_M_HI_NODIS ISS_M_BL_NODIS ISS_M_WH_NODIS ISS_M_HP_NODIS ISS_M_MR_NODIS ISS_M_NODIS ISS_M_NODIS_LEP ISS_F_AI_NODIS ISS_F_AS_NODIS ISS_F_HI_NODIS ISS_F_BL_NODIS ISS_F_WH_NODIS ISS_F_HP_NODIS ISS_F_MR_NODIS ISS_F_NODIS ISS_F_NODIS_LEP (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_iss_nodis_11_lea.dta", replace

**combine variable name files
use ".\vars_singossdis_2011.dta", clear
append using ".\vars_multossdis_2011.dta"
append using ".\vars_issdis_2011.dta"
append using ".\vars_singossnodis_2011.dta"
append using ".\vars_multossnodis_2011.dta"
append using ".\vars_issnodis_2011.dta"
duplicates drop
save ".\vars_sus_2011.dta", replace
erase ".\vars_singossdis_2011.dta"
erase ".\vars_multossdis_2011.dta"
erase ".\vars_issdis_2011.dta"
erase ".\vars_singossnodis_2011.dta"
erase ".\vars_multossnodis_2011.dta"
erase ".\vars_issnodis_2011.dta"

//2013 (from public use, school level data)
import excel ".\2013-14-crdc-data\2013-14 CRDC\School\CRDC-collected data file for Schools\11-2 Suspensions (required elements).xlsx", sheet("Data") firstrow clear
drop JJ
names sus 2013

gen YEAR=2013
gen RACES_REPORTED = 7 //all districts report in terms of 7 racial groups in this year

rename SCH_PSDISC_SINGOOS_HI_M SINGOSS_M_HI_PS
rename SCH_PSDISC_SINGOOS_HI_F SINGOSS_F_HI_PS
rename SCH_PSDISC_SINGOOS_AM_M SINGOSS_M_AI_PS
rename SCH_PSDISC_SINGOOS_AM_F SINGOSS_F_AI_PS
rename SCH_PSDISC_SINGOOS_AS_M SINGOSS_M_AS_PS
rename SCH_PSDISC_SINGOOS_AS_F SINGOSS_F_AS_PS
rename SCH_PSDISC_SINGOOS_HP_M SINGOSS_M_HP_PS
rename SCH_PSDISC_SINGOOS_HP_F SINGOSS_F_HP_PS
rename SCH_PSDISC_SINGOOS_BL_M SINGOSS_M_BL_PS
rename SCH_PSDISC_SINGOOS_BL_F SINGOSS_F_BL_PS
rename SCH_PSDISC_SINGOOS_WH_M SINGOSS_M_WH_PS
rename SCH_PSDISC_SINGOOS_WH_F SINGOSS_F_WH_PS
rename SCH_PSDISC_SINGOOS_TR_M SINGOSS_M_MR_PS
rename SCH_PSDISC_SINGOOS_TR_F SINGOSS_F_MR_PS
rename TOT_PSDISC_SINGOOS_M SINGOSS_M_PS
rename TOT_PSDISC_SINGOOS_F SINGOSS_F_PS
rename SCH_PSDISC_SINGOOS_LEP_M SINGOSS_M_LEP_PS
rename SCH_PSDISC_SINGOOS_LEP_F SINGOSS_F_LEP_PS
rename SCH_PSDISC_SINGOOS_IDEA_M SINGOSS_M_IDEA_PS
rename SCH_PSDISC_SINGOOS_IDEA_F SINGOSS_F_IDEA_PS

rename SCH_PSDISC_MULTOOS_HI_M MULTOSS_M_HI_PS
rename SCH_PSDISC_MULTOOS_HI_F MULTOSS_F_HI_PS
rename SCH_PSDISC_MULTOOS_AM_M MULTOSS_M_AI_PS
rename SCH_PSDISC_MULTOOS_AM_F MULTOSS_F_AI_PS
rename SCH_PSDISC_MULTOOS_AS_M MULTOSS_M_AS_PS
rename SCH_PSDISC_MULTOOS_AS_F MULTOSS_F_AS_PS
rename SCH_PSDISC_MULTOOS_HP_M MULTOSS_M_HP_PS
rename SCH_PSDISC_MULTOOS_HP_F MULTOSS_F_HP_PS
rename SCH_PSDISC_MULTOOS_BL_M MULTOSS_M_BL_PS
rename SCH_PSDISC_MULTOOS_BL_F MULTOSS_F_BL_PS
rename SCH_PSDISC_MULTOOS_WH_M MULTOSS_M_WH_PS
rename SCH_PSDISC_MULTOOS_WH_F MULTOSS_F_WH_PS
rename SCH_PSDISC_MULTOOS_TR_M MULTOSS_M_MR_PS
rename SCH_PSDISC_MULTOOS_TR_F MULTOSS_F_MR_PS
rename TOT_PSDISC_MULTOOS_M MULTOSS_M_PS
rename TOT_PSDISC_MULTOOS_F MULTOSS_F_PS
rename SCH_PSDISC_MULTOOS_LEP_M MULTOSS_M_LEP_PS
rename SCH_PSDISC_MULTOOS_LEP_F MULTOSS_F_LEP_PS
rename SCH_PSDISC_MULTOOS_IDEA_M MULTOSS_M_IDEA_PS
rename SCH_PSDISC_MULTOOS_IDEA_F MULTOSS_F_IDEA_PS

rename SCH_DISCWODIS_ISS_HI_M ISS_M_HI_NODIS
rename SCH_DISCWODIS_ISS_HI_F ISS_F_HI_NODIS
rename SCH_DISCWODIS_ISS_AM_M ISS_M_AI_NODIS
rename SCH_DISCWODIS_ISS_AM_F ISS_F_AI_NODIS
rename SCH_DISCWODIS_ISS_AS_M ISS_M_AS_NODIS
rename SCH_DISCWODIS_ISS_AS_F ISS_F_AS_NODIS
rename SCH_DISCWODIS_ISS_HP_M ISS_M_HP_NODIS
rename SCH_DISCWODIS_ISS_HP_F ISS_F_HP_NODIS
rename SCH_DISCWODIS_ISS_BL_M ISS_M_BL_NODIS
rename SCH_DISCWODIS_ISS_BL_F ISS_F_BL_NODIS
rename SCH_DISCWODIS_ISS_WH_M ISS_M_WH_NODIS
rename SCH_DISCWODIS_ISS_WH_F ISS_F_WH_NODIS
rename SCH_DISCWODIS_ISS_TR_M ISS_M_MR_NODIS
rename SCH_DISCWODIS_ISS_TR_F ISS_F_MR_NODIS
rename TOT_DISCWODIS_ISS_M ISS_M_NODIS
rename TOT_DISCWODIS_ISS_F ISS_F_NODIS
rename SCH_DISCWODIS_ISS_LEP_M ISS_M_NODIS_LEP
rename SCH_DISCWODIS_ISS_LEP_F ISS_F_NODIS_LEP

rename SCH_DISCWODIS_SINGOOS_HI_M SINGOSS_M_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_HI_F SINGOSS_F_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_M SINGOSS_M_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_F SINGOSS_F_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_M SINGOSS_M_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_F SINGOSS_F_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_M SINGOSS_M_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_F SINGOSS_F_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_M SINGOSS_M_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_F SINGOSS_F_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_M SINGOSS_M_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_F SINGOSS_F_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_M SINGOSS_M_MR_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_F SINGOSS_F_MR_NODIS
rename TOT_DISCWODIS_SINGOOS_M SINGOSS_M_NODIS
rename TOT_DISCWODIS_SINGOOS_F SINGOSS_F_NODIS
rename SCH_DISCWODIS_SINGOOS_LEP_M SINGOSS_M_NODIS_LEP
rename SCH_DISCWODIS_SINGOOS_LEP_F SINGOSS_F_NODIS_LEP

rename SCH_DISCWODIS_MULTOOS_HI_M MULTOSS_M_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_HI_F MULTOSS_F_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_M MULTOSS_M_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_F MULTOSS_F_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_M MULTOSS_M_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_F MULTOSS_F_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_M MULTOSS_M_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_F MULTOSS_F_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_M MULTOSS_M_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_F MULTOSS_F_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_M MULTOSS_M_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_F MULTOSS_F_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_M MULTOSS_M_MR_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_F MULTOSS_F_MR_NODIS
rename TOT_DISCWODIS_MULTOOS_M MULTOSS_M_NODIS
rename TOT_DISCWODIS_MULTOOS_F MULTOSS_F_NODIS
rename SCH_DISCWODIS_MULTOOS_LEP_M MULTOSS_M_NODIS_LEP
rename SCH_DISCWODIS_MULTOOS_LEP_F MULTOSS_F_NODIS_LEP

rename SCH_DISCWDIS_ISS_IDEA_HI_M ISS_M_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HI_F ISS_F_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_M ISS_M_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_F ISS_F_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_M ISS_M_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_F ISS_F_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_M ISS_M_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_F ISS_F_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_M ISS_M_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_F ISS_F_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_M ISS_M_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_F ISS_F_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_M ISS_M_MR_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_F ISS_F_MR_IDEA
rename TOT_DISCWDIS_ISS_IDEA_M ISS_M_IDEA
rename TOT_DISCWDIS_ISS_IDEA_F ISS_F_IDEA
rename SCH_DISCWDIS_ISS_LEP_M ISS_M_DIS_LEP
rename SCH_DISCWDIS_ISS_LEP_F ISS_F_DIS_LEP
rename SCH_DISCWDIS_ISS_504_M ISS_M_504
rename SCH_DISCWDIS_ISS_504_F ISS_F_504

rename SCH_DISCWDIS_SINGOOS_IDEA_HI_M SINGOSS_M_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HI_F SINGOSS_F_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_M SINGOSS_M_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_F SINGOSS_F_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_M SINGOSS_M_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_F SINGOSS_F_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_M SINGOSS_M_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_F SINGOSS_F_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_M SINGOSS_M_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_F SINGOSS_F_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_M SINGOSS_M_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_F SINGOSS_F_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_M SINGOSS_M_MR_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_F SINGOSS_F_MR_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_M SINGOSS_M_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_F SINGOSS_F_IDEA
rename SCH_DISCWDIS_SINGOOS_LEP_M SINGOSS_M_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_LEP_F SINGOSS_F_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_504_M SINGOSS_M_504
rename SCH_DISCWDIS_SINGOOS_504_F SINGOSS_F_504

rename SCH_DISCWDIS_MULTOOS_IDEA_HI_M MULTOSS_M_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HI_F MULTOSS_F_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_M MULTOSS_M_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_F MULTOSS_F_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_M MULTOSS_M_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_F MULTOSS_F_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_M MULTOSS_M_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_F MULTOSS_F_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_M MULTOSS_M_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_F MULTOSS_F_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_M MULTOSS_M_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_F MULTOSS_F_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_M MULTOSS_M_MR_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_F MULTOSS_F_MR_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_M MULTOSS_M_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_F MULTOSS_F_IDEA
rename SCH_DISCWDIS_MULTOOS_LEP_M MULTOSS_M_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_LEP_F MULTOSS_F_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_504_M MULTOSS_M_504
rename SCH_DISCWDIS_MULTOOS_504_F MULTOSS_F_504

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

save ".\Cleaned data\Suspensions\sus_13_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY
collapse (sum) SINGOSS_M_HI_PS SINGOSS_F_HI_PS SINGOSS_M_AI_PS SINGOSS_F_AI_PS SINGOSS_M_AS_PS SINGOSS_F_AS_PS SINGOSS_M_HP_PS SINGOSS_F_HP_PS SINGOSS_M_BL_PS SINGOSS_F_BL_PS SINGOSS_M_WH_PS SINGOSS_F_WH_PS SINGOSS_M_MR_PS SINGOSS_F_MR_PS SINGOSS_M_PS SINGOSS_F_PS SINGOSS_M_LEP_PS SINGOSS_F_LEP_PS SINGOSS_M_IDEA_PS SINGOSS_F_IDEA_PS MULTOSS_M_HI_PS MULTOSS_F_HI_PS MULTOSS_M_AI_PS MULTOSS_F_AI_PS MULTOSS_M_AS_PS MULTOSS_F_AS_PS MULTOSS_M_HP_PS MULTOSS_F_HP_PS MULTOSS_M_BL_PS MULTOSS_F_BL_PS MULTOSS_M_WH_PS MULTOSS_F_WH_PS MULTOSS_M_MR_PS MULTOSS_F_MR_PS MULTOSS_M_PS MULTOSS_F_PS MULTOSS_M_LEP_PS MULTOSS_F_LEP_PS MULTOSS_M_IDEA_PS MULTOSS_F_IDEA_PS ISS_M_HI_NODIS ISS_F_HI_NODIS ISS_M_AI_NODIS ISS_F_AI_NODIS ISS_M_AS_NODIS ISS_F_AS_NODIS ISS_M_HP_NODIS ISS_F_HP_NODIS ISS_M_BL_NODIS ISS_F_BL_NODIS ISS_M_WH_NODIS ISS_F_WH_NODIS ISS_M_MR_NODIS ISS_F_MR_NODIS ISS_M_NODIS ISS_F_NODIS ISS_M_NODIS_LEP ISS_F_NODIS_LEP SINGOSS_M_HI_NODIS SINGOSS_F_HI_NODIS SINGOSS_M_AI_NODIS SINGOSS_F_AI_NODIS SINGOSS_M_AS_NODIS SINGOSS_F_AS_NODIS SINGOSS_M_HP_NODIS SINGOSS_F_HP_NODIS SINGOSS_M_BL_NODIS SINGOSS_F_BL_NODIS SINGOSS_M_WH_NODIS SINGOSS_F_WH_NODIS SINGOSS_M_MR_NODIS SINGOSS_F_MR_NODIS SINGOSS_M_NODIS SINGOSS_F_NODIS SINGOSS_M_NODIS_LEP SINGOSS_F_NODIS_LEP MULTOSS_M_HI_NODIS MULTOSS_F_HI_NODIS MULTOSS_M_AI_NODIS MULTOSS_F_AI_NODIS MULTOSS_M_AS_NODIS MULTOSS_F_AS_NODIS MULTOSS_M_HP_NODIS MULTOSS_F_HP_NODIS MULTOSS_M_BL_NODIS MULTOSS_F_BL_NODIS MULTOSS_M_WH_NODIS MULTOSS_F_WH_NODIS MULTOSS_M_MR_NODIS MULTOSS_F_MR_NODIS MULTOSS_M_NODIS MULTOSS_F_NODIS MULTOSS_M_NODIS_LEP MULTOSS_F_NODIS_LEP ISS_M_HI_IDEA ISS_F_HI_IDEA ISS_M_AI_IDEA ISS_F_AI_IDEA ISS_M_AS_IDEA ISS_F_AS_IDEA ISS_M_HP_IDEA ISS_F_HP_IDEA ISS_M_BL_IDEA ISS_F_BL_IDEA ISS_M_WH_IDEA ISS_F_WH_IDEA ISS_M_MR_IDEA ISS_F_MR_IDEA ISS_M_IDEA ISS_F_IDEA ISS_M_DIS_LEP ISS_F_DIS_LEP ISS_M_504 ISS_F_504 SINGOSS_M_HI_IDEA SINGOSS_F_HI_IDEA SINGOSS_M_AI_IDEA SINGOSS_F_AI_IDEA SINGOSS_M_AS_IDEA SINGOSS_F_AS_IDEA SINGOSS_M_HP_IDEA SINGOSS_F_HP_IDEA SINGOSS_M_BL_IDEA SINGOSS_F_BL_IDEA SINGOSS_M_WH_IDEA SINGOSS_F_WH_IDEA SINGOSS_M_MR_IDEA SINGOSS_F_MR_IDEA SINGOSS_M_IDEA SINGOSS_F_IDEA SINGOSS_M_DIS_LEP SINGOSS_F_DIS_LEP SINGOSS_M_504 SINGOSS_F_504 MULTOSS_M_HI_IDEA MULTOSS_F_HI_IDEA MULTOSS_M_AI_IDEA MULTOSS_F_AI_IDEA MULTOSS_M_AS_IDEA MULTOSS_F_AS_IDEA MULTOSS_M_HP_IDEA MULTOSS_F_HP_IDEA MULTOSS_M_BL_IDEA MULTOSS_F_BL_IDEA MULTOSS_M_WH_IDEA MULTOSS_F_WH_IDEA MULTOSS_M_MR_IDEA MULTOSS_F_MR_IDEA MULTOSS_M_IDEA MULTOSS_F_IDEA MULTOSS_M_DIS_LEP MULTOSS_F_DIS_LEP MULTOSS_M_504 MULTOSS_F_504 (max) YEAR RACES_REPORTED, by(LEAID) 
save ".\Cleaned data\Suspensions\sus_13_lea.dta", replace


//2015 (from public use, school level data)
import delimited ".\2015-16-crdc-data\Data Files and Layouts\CRDC 2015-16 School Data.csv", stringcols(3 5 7) clear
keep lea_state lea_state_name leaid lea_name schid sch_name combokey *singoos* *multoos* *iss* *oosinstances* *daysmissed* 
names sus 2015

gen YEAR=2015
rename *, upper 
gen RACES_REPORTED=7

*recreate COMBOKEY as a string variable with no scientific notation
gen str5 SCHID_NEW = string(real(SCHID), "%05.0f")
gen COMBOKEY_NEW = LEAID + SCHID_NEW
order LEA_STATE LEA_STATE_NAME LEAID LEA_NAME SCHID SCHID_NEW SCH_NAME COMBOKEY COMBOKEY_NEW
drop SCHID COMBOKEY
rename SCHID_NEW SCHID
rename COMBOKEY_NEW COMBOKEY

rename SCH_PSDISC_SINGOOS_HI_M SINGOSS_M_HI_PS
rename SCH_PSDISC_SINGOOS_HI_F SINGOSS_F_HI_PS
rename SCH_PSDISC_SINGOOS_AM_M SINGOSS_M_AI_PS
rename SCH_PSDISC_SINGOOS_AM_F SINGOSS_F_AI_PS
rename SCH_PSDISC_SINGOOS_AS_M SINGOSS_M_AS_PS
rename SCH_PSDISC_SINGOOS_AS_F SINGOSS_F_AS_PS
rename SCH_PSDISC_SINGOOS_HP_M SINGOSS_M_HP_PS
rename SCH_PSDISC_SINGOOS_HP_F SINGOSS_F_HP_PS
rename SCH_PSDISC_SINGOOS_BL_M SINGOSS_M_BL_PS
rename SCH_PSDISC_SINGOOS_BL_F SINGOSS_F_BL_PS
rename SCH_PSDISC_SINGOOS_WH_M SINGOSS_M_WH_PS
rename SCH_PSDISC_SINGOOS_WH_F SINGOSS_F_WH_PS
rename SCH_PSDISC_SINGOOS_TR_M SINGOSS_M_MR_PS
rename SCH_PSDISC_SINGOOS_TR_F SINGOSS_F_MR_PS
rename TOT_PSDISC_SINGOOS_M SINGOSS_M_PS
rename TOT_PSDISC_SINGOOS_F SINGOSS_F_PS
rename SCH_PSDISC_SINGOOS_LEP_M SINGOSS_M_LEP_PS
rename SCH_PSDISC_SINGOOS_LEP_F SINGOSS_F_LEP_PS
rename SCH_PSDISC_SINGOOS_IDEA_M SINGOSS_M_IDEA_PS
rename SCH_PSDISC_SINGOOS_IDEA_F SINGOSS_F_IDEA_PS

rename SCH_PSDISC_MULTOOS_HI_M MULTOSS_M_HI_PS
rename SCH_PSDISC_MULTOOS_HI_F MULTOSS_F_HI_PS
rename SCH_PSDISC_MULTOOS_AM_M MULTOSS_M_AI_PS
rename SCH_PSDISC_MULTOOS_AM_F MULTOSS_F_AI_PS
rename SCH_PSDISC_MULTOOS_AS_M MULTOSS_M_AS_PS
rename SCH_PSDISC_MULTOOS_AS_F MULTOSS_F_AS_PS
rename SCH_PSDISC_MULTOOS_HP_M MULTOSS_M_HP_PS
rename SCH_PSDISC_MULTOOS_HP_F MULTOSS_F_HP_PS
rename SCH_PSDISC_MULTOOS_BL_M MULTOSS_M_BL_PS
rename SCH_PSDISC_MULTOOS_BL_F MULTOSS_F_BL_PS
rename SCH_PSDISC_MULTOOS_WH_M MULTOSS_M_WH_PS
rename SCH_PSDISC_MULTOOS_WH_F MULTOSS_F_WH_PS
rename SCH_PSDISC_MULTOOS_TR_M MULTOSS_M_MR_PS
rename SCH_PSDISC_MULTOOS_TR_F MULTOSS_F_MR_PS
rename TOT_PSDISC_MULTOOS_M MULTOSS_M_PS
rename TOT_PSDISC_MULTOOS_F MULTOSS_F_PS
rename SCH_PSDISC_MULTOOS_LEP_M MULTOSS_M_LEP_PS
rename SCH_PSDISC_MULTOOS_LEP_F MULTOSS_F_LEP_PS
rename SCH_PSDISC_MULTOOS_IDEA_M MULTOSS_M_IDEA_PS
rename SCH_PSDISC_MULTOOS_IDEA_F MULTOSS_F_IDEA_PS

rename SCH_DISCWODIS_ISS_HI_M ISS_M_HI_NODIS
rename SCH_DISCWODIS_ISS_HI_F ISS_F_HI_NODIS
rename SCH_DISCWODIS_ISS_AM_M ISS_M_AI_NODIS
rename SCH_DISCWODIS_ISS_AM_F ISS_F_AI_NODIS
rename SCH_DISCWODIS_ISS_AS_M ISS_M_AS_NODIS
rename SCH_DISCWODIS_ISS_AS_F ISS_F_AS_NODIS
rename SCH_DISCWODIS_ISS_HP_M ISS_M_HP_NODIS
rename SCH_DISCWODIS_ISS_HP_F ISS_F_HP_NODIS
rename SCH_DISCWODIS_ISS_BL_M ISS_M_BL_NODIS
rename SCH_DISCWODIS_ISS_BL_F ISS_F_BL_NODIS
rename SCH_DISCWODIS_ISS_WH_M ISS_M_WH_NODIS
rename SCH_DISCWODIS_ISS_WH_F ISS_F_WH_NODIS
rename SCH_DISCWODIS_ISS_TR_M ISS_M_MR_NODIS
rename SCH_DISCWODIS_ISS_TR_F ISS_F_MR_NODIS
rename TOT_DISCWODIS_ISS_M ISS_M_NODIS
rename TOT_DISCWODIS_ISS_F ISS_F_NODIS
rename SCH_DISCWODIS_ISS_LEP_M ISS_M_NODIS_LEP
rename SCH_DISCWODIS_ISS_LEP_F ISS_F_NODIS_LEP

rename SCH_DISCWODIS_SINGOOS_HI_M SINGOSS_M_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_HI_F SINGOSS_F_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_M SINGOSS_M_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_F SINGOSS_F_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_M SINGOSS_M_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_F SINGOSS_F_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_M SINGOSS_M_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_F SINGOSS_F_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_M SINGOSS_M_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_F SINGOSS_F_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_M SINGOSS_M_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_F SINGOSS_F_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_M SINGOSS_M_MR_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_F SINGOSS_F_MR_NODIS
rename TOT_DISCWODIS_SINGOOS_M SINGOSS_M_NODIS
rename TOT_DISCWODIS_SINGOOS_F SINGOSS_F_NODIS
rename SCH_DISCWODIS_SINGOOS_LEP_M SINGOSS_M_NODIS_LEP
rename SCH_DISCWODIS_SINGOOS_LEP_F SINGOSS_F_NODIS_LEP

rename SCH_DISCWODIS_MULTOOS_HI_M MULTOSS_M_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_HI_F MULTOSS_F_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_M MULTOSS_M_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_F MULTOSS_F_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_M MULTOSS_M_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_F MULTOSS_F_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_M MULTOSS_M_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_F MULTOSS_F_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_M MULTOSS_M_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_F MULTOSS_F_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_M MULTOSS_M_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_F MULTOSS_F_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_M MULTOSS_M_MR_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_F MULTOSS_F_MR_NODIS
rename TOT_DISCWODIS_MULTOOS_M MULTOSS_M_NODIS
rename TOT_DISCWODIS_MULTOOS_F MULTOSS_F_NODIS
rename SCH_DISCWODIS_MULTOOS_LEP_M MULTOSS_M_NODIS_LEP
rename SCH_DISCWODIS_MULTOOS_LEP_F MULTOSS_F_NODIS_LEP

rename SCH_DISCWDIS_ISS_IDEA_HI_M ISS_M_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HI_F ISS_F_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_M ISS_M_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_F ISS_F_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_M ISS_M_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_F ISS_F_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_M ISS_M_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_F ISS_F_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_M ISS_M_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_F ISS_F_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_M ISS_M_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_F ISS_F_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_M ISS_M_MR_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_F ISS_F_MR_IDEA
rename TOT_DISCWDIS_ISS_IDEA_M ISS_M_IDEA
rename TOT_DISCWDIS_ISS_IDEA_F ISS_F_IDEA
rename SCH_DISCWDIS_ISS_LEP_M ISS_M_DIS_LEP
rename SCH_DISCWDIS_ISS_LEP_F ISS_F_DIS_LEP
rename SCH_DISCWDIS_ISS_504_M ISS_M_504
rename SCH_DISCWDIS_ISS_504_F ISS_F_504

rename SCH_DISCWDIS_SINGOOS_IDEA_HI_M SINGOSS_M_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HI_F SINGOSS_F_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_M SINGOSS_M_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_F SINGOSS_F_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_M SINGOSS_M_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_F SINGOSS_F_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_M SINGOSS_M_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_F SINGOSS_F_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_M SINGOSS_M_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_F SINGOSS_F_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_M SINGOSS_M_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_F SINGOSS_F_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_M SINGOSS_M_MR_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_F SINGOSS_F_MR_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_M SINGOSS_M_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_F SINGOSS_F_IDEA
rename SCH_DISCWDIS_SINGOOS_LEP_M SINGOSS_M_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_LEP_F SINGOSS_F_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_504_M SINGOSS_M_504
rename SCH_DISCWDIS_SINGOOS_504_F SINGOSS_F_504

rename SCH_DISCWDIS_MULTOOS_IDEA_HI_M MULTOSS_M_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HI_F MULTOSS_F_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_M MULTOSS_M_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_F MULTOSS_F_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_M MULTOSS_M_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_F MULTOSS_F_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_M MULTOSS_M_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_F MULTOSS_F_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_M MULTOSS_M_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_F MULTOSS_F_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_M MULTOSS_M_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_F MULTOSS_F_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_M MULTOSS_M_MR_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_F MULTOSS_F_MR_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_M MULTOSS_M_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_F MULTOSS_F_IDEA
rename SCH_DISCWDIS_MULTOOS_LEP_M MULTOSS_M_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_LEP_F MULTOSS_F_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_504_M MULTOSS_M_504
rename SCH_DISCWDIS_MULTOOS_504_F MULTOSS_F_504

rename SCH_PSOOSINSTANCES_ALL OSSINSTANCES_PS
rename SCH_PSOOSINSTANCES_IDEA OSSINSTANCES_IDEA_PS
rename SCH_OOSINSTANCES_WODIS OSSINSTANCES_NODIS
rename SCH_OOSINSTANCES_IDEA OSSINSTANCES_IDEA 
rename SCH_OOSINSTANCES_504 OSSINSTANCES_504

rename SCH_DAYSMISSED_HI_M SUS_DAYSMISSED_M_HI
rename SCH_DAYSMISSED_HI_F SUS_DAYSMISSED_F_HI
rename SCH_DAYSMISSED_AM_M SUS_DAYSMISSED_M_AI
rename SCH_DAYSMISSED_AM_F SUS_DAYSMISSED_F_AI
rename SCH_DAYSMISSED_AS_M SUS_DAYSMISSED_M_AS
rename SCH_DAYSMISSED_AS_F SUS_DAYSMISSED_F_AS
rename SCH_DAYSMISSED_HP_M SUS_DAYSMISSED_M_HP
rename SCH_DAYSMISSED_HP_F SUS_DAYSMISSED_F_HP
rename SCH_DAYSMISSED_BL_M SUS_DAYSMISSED_M_BL
rename SCH_DAYSMISSED_BL_F SUS_DAYSMISSED_F_BL
rename SCH_DAYSMISSED_WH_M SUS_DAYSMISSED_M_WH
rename SCH_DAYSMISSED_WH_F SUS_DAYSMISSED_F_WH
rename SCH_DAYSMISSED_TR_M SUS_DAYSMISSED_M_MR
rename SCH_DAYSMISSED_TR_F SUS_DAYSMISSED_F_MR
rename TOT_DAYSMISSED_M SUS_DAYSMISSED_M
rename TOT_DAYSMISSED_F SUS_DAYSMISSED_F
rename SCH_DAYSMISSED_LEP_M SUS_DAYSMISSED_M_LEP
rename SCH_DAYSMISSED_LEP_F SUS_DAYSMISSED_F_LEP
rename SCH_DAYSMISSED_504_M SUS_DAYSMISSED_M_504
rename SCH_DAYSMISSED_504_F SUS_DAYSMISSED_F_504
rename SCH_DAYSMISSED_IDEA_M SUS_DAYSMISSED_M_IDEA
rename SCH_DAYSMISSED_IDEA_F SUS_DAYSMISSED_F_IDEA

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

save ".\Cleaned data\Suspensions\sus_15_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY 
collapse (sum) SINGOSS_M_HI_PS SINGOSS_F_HI_PS SINGOSS_M_AI_PS SINGOSS_F_AI_PS SINGOSS_M_AS_PS SINGOSS_F_AS_PS SINGOSS_M_HP_PS SINGOSS_F_HP_PS SINGOSS_M_BL_PS SINGOSS_F_BL_PS SINGOSS_M_WH_PS SINGOSS_F_WH_PS SINGOSS_M_MR_PS SINGOSS_F_MR_PS SINGOSS_M_PS SINGOSS_F_PS SINGOSS_M_LEP_PS SINGOSS_F_LEP_PS SINGOSS_M_IDEA_PS SINGOSS_F_IDEA_PS MULTOSS_M_HI_PS MULTOSS_F_HI_PS MULTOSS_M_AI_PS MULTOSS_F_AI_PS MULTOSS_M_AS_PS MULTOSS_F_AS_PS MULTOSS_M_HP_PS MULTOSS_F_HP_PS MULTOSS_M_BL_PS MULTOSS_F_BL_PS MULTOSS_M_WH_PS MULTOSS_F_WH_PS MULTOSS_M_MR_PS MULTOSS_F_MR_PS MULTOSS_M_PS MULTOSS_F_PS MULTOSS_M_LEP_PS MULTOSS_F_LEP_PS MULTOSS_M_IDEA_PS MULTOSS_F_IDEA_PS OSSINSTANCES_PS OSSINSTANCES_IDEA_PS ISS_M_HI_NODIS ISS_F_HI_NODIS ISS_M_AI_NODIS ISS_F_AI_NODIS ISS_M_AS_NODIS ISS_F_AS_NODIS ISS_M_HP_NODIS ISS_F_HP_NODIS ISS_M_BL_NODIS ISS_F_BL_NODIS ISS_M_WH_NODIS ISS_F_WH_NODIS ISS_M_MR_NODIS ISS_F_MR_NODIS ISS_M_NODIS ISS_F_NODIS ISS_M_NODIS_LEP ISS_F_NODIS_LEP SINGOSS_M_HI_NODIS SINGOSS_F_HI_NODIS SINGOSS_M_AI_NODIS SINGOSS_F_AI_NODIS SINGOSS_M_AS_NODIS SINGOSS_F_AS_NODIS SINGOSS_M_HP_NODIS SINGOSS_F_HP_NODIS SINGOSS_M_BL_NODIS SINGOSS_F_BL_NODIS SINGOSS_M_WH_NODIS SINGOSS_F_WH_NODIS SINGOSS_M_MR_NODIS SINGOSS_F_MR_NODIS SINGOSS_M_NODIS SINGOSS_F_NODIS SINGOSS_M_NODIS_LEP SINGOSS_F_NODIS_LEP MULTOSS_M_HI_NODIS MULTOSS_F_HI_NODIS MULTOSS_M_AI_NODIS MULTOSS_F_AI_NODIS MULTOSS_M_AS_NODIS MULTOSS_F_AS_NODIS MULTOSS_M_HP_NODIS MULTOSS_F_HP_NODIS MULTOSS_M_BL_NODIS MULTOSS_F_BL_NODIS MULTOSS_M_WH_NODIS MULTOSS_F_WH_NODIS MULTOSS_M_MR_NODIS MULTOSS_F_MR_NODIS MULTOSS_M_NODIS MULTOSS_F_NODIS MULTOSS_M_NODIS_LEP MULTOSS_F_NODIS_LEP ISS_M_HI_IDEA ISS_F_HI_IDEA ISS_M_AI_IDEA ISS_F_AI_IDEA ISS_M_AS_IDEA ISS_F_AS_IDEA ISS_M_HP_IDEA ISS_F_HP_IDEA ISS_M_BL_IDEA ISS_F_BL_IDEA ISS_M_WH_IDEA ISS_F_WH_IDEA ISS_M_MR_IDEA ISS_F_MR_IDEA ISS_M_IDEA ISS_F_IDEA ISS_M_DIS_LEP ISS_F_DIS_LEP ISS_M_504 ISS_F_504 SINGOSS_M_HI_IDEA SINGOSS_F_HI_IDEA SINGOSS_M_AI_IDEA SINGOSS_F_AI_IDEA SINGOSS_M_AS_IDEA SINGOSS_F_AS_IDEA SINGOSS_M_HP_IDEA SINGOSS_F_HP_IDEA SINGOSS_M_BL_IDEA SINGOSS_F_BL_IDEA SINGOSS_M_WH_IDEA SINGOSS_F_WH_IDEA SINGOSS_M_MR_IDEA SINGOSS_F_MR_IDEA SINGOSS_M_IDEA SINGOSS_F_IDEA SINGOSS_M_DIS_LEP SINGOSS_F_DIS_LEP SINGOSS_M_504 SINGOSS_F_504 MULTOSS_M_HI_IDEA MULTOSS_F_HI_IDEA MULTOSS_M_AI_IDEA MULTOSS_F_AI_IDEA MULTOSS_M_AS_IDEA MULTOSS_F_AS_IDEA MULTOSS_M_HP_IDEA MULTOSS_F_HP_IDEA MULTOSS_M_BL_IDEA MULTOSS_F_BL_IDEA MULTOSS_M_WH_IDEA MULTOSS_F_WH_IDEA MULTOSS_M_MR_IDEA MULTOSS_F_MR_IDEA MULTOSS_M_IDEA MULTOSS_F_IDEA MULTOSS_M_DIS_LEP MULTOSS_F_DIS_LEP MULTOSS_M_504 MULTOSS_F_504 OSSINSTANCES_NODIS OSSINSTANCES_IDEA OSSINSTANCES_504 SUS_DAYSMISSED_M_HI SUS_DAYSMISSED_F_HI SUS_DAYSMISSED_M_AI SUS_DAYSMISSED_F_AI SUS_DAYSMISSED_M_AS SUS_DAYSMISSED_F_AS SUS_DAYSMISSED_M_HP SUS_DAYSMISSED_F_HP SUS_DAYSMISSED_M_BL SUS_DAYSMISSED_F_BL SUS_DAYSMISSED_M_WH SUS_DAYSMISSED_F_WH SUS_DAYSMISSED_M_MR SUS_DAYSMISSED_F_MR SUS_DAYSMISSED_M SUS_DAYSMISSED_F SUS_DAYSMISSED_M_LEP SUS_DAYSMISSED_F_LEP SUS_DAYSMISSED_M_504 SUS_DAYSMISSED_F_504 SUS_DAYSMISSED_M_IDEA SUS_DAYSMISSED_F_IDEA (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_15_lea.dta", replace

//2017 (from public use, school level data)
import delimited ".\2017-18-crdc-data\2017-18-crdc-data-corrected-publication 2\2017-18 Public-Use Files\Data\SCH\CRDC\CSV\Suspensions.csv", stringcols(3 5 7) clear
drop jj
names sus 2017

gen YEAR=2017
rename *, upper 
gen RACES_REPORTED=7

rename SCH_PSDISC_SINGOOS_HI_M SINGOSS_M_HI_PS
rename SCH_PSDISC_SINGOOS_HI_F SINGOSS_F_HI_PS
rename SCH_PSDISC_SINGOOS_AM_M SINGOSS_M_AI_PS
rename SCH_PSDISC_SINGOOS_AM_F SINGOSS_F_AI_PS
rename SCH_PSDISC_SINGOOS_AS_M SINGOSS_M_AS_PS
rename SCH_PSDISC_SINGOOS_AS_F SINGOSS_F_AS_PS
rename SCH_PSDISC_SINGOOS_HP_M SINGOSS_M_HP_PS
rename SCH_PSDISC_SINGOOS_HP_F SINGOSS_F_HP_PS
rename SCH_PSDISC_SINGOOS_BL_M SINGOSS_M_BL_PS
rename SCH_PSDISC_SINGOOS_BL_F SINGOSS_F_BL_PS
rename SCH_PSDISC_SINGOOS_WH_M SINGOSS_M_WH_PS
rename SCH_PSDISC_SINGOOS_WH_F SINGOSS_F_WH_PS
rename SCH_PSDISC_SINGOOS_TR_M SINGOSS_M_MR_PS
rename SCH_PSDISC_SINGOOS_TR_F SINGOSS_F_MR_PS
rename TOT_PSDISC_SINGOOS_M SINGOSS_M_PS
rename TOT_PSDISC_SINGOOS_F SINGOSS_F_PS
rename SCH_PSDISC_SINGOOS_LEP_M SINGOSS_M_LEP_PS
rename SCH_PSDISC_SINGOOS_LEP_F SINGOSS_F_LEP_PS
rename SCH_PSDISC_SINGOOS_IDEA_M SINGOSS_M_IDEA_PS
rename SCH_PSDISC_SINGOOS_IDEA_F SINGOSS_F_IDEA_PS

rename SCH_PSDISC_MULTOOS_HI_M MULTOSS_M_HI_PS
rename SCH_PSDISC_MULTOOS_HI_F MULTOSS_F_HI_PS
rename SCH_PSDISC_MULTOOS_AM_M MULTOSS_M_AI_PS
rename SCH_PSDISC_MULTOOS_AM_F MULTOSS_F_AI_PS
rename SCH_PSDISC_MULTOOS_AS_M MULTOSS_M_AS_PS
rename SCH_PSDISC_MULTOOS_AS_F MULTOSS_F_AS_PS
rename SCH_PSDISC_MULTOOS_HP_M MULTOSS_M_HP_PS
rename SCH_PSDISC_MULTOOS_HP_F MULTOSS_F_HP_PS
rename SCH_PSDISC_MULTOOS_BL_M MULTOSS_M_BL_PS
rename SCH_PSDISC_MULTOOS_BL_F MULTOSS_F_BL_PS
rename SCH_PSDISC_MULTOOS_WH_M MULTOSS_M_WH_PS
rename SCH_PSDISC_MULTOOS_WH_F MULTOSS_F_WH_PS
rename SCH_PSDISC_MULTOOS_TR_M MULTOSS_M_MR_PS
rename SCH_PSDISC_MULTOOS_TR_F MULTOSS_F_MR_PS
rename TOT_PSDISC_MULTOOS_M MULTOSS_M_PS
rename TOT_PSDISC_MULTOOS_F MULTOSS_F_PS
rename SCH_PSDISC_MULTOOS_LEP_M MULTOSS_M_LEP_PS
rename SCH_PSDISC_MULTOOS_LEP_F MULTOSS_F_LEP_PS
rename SCH_PSDISC_MULTOOS_IDEA_M MULTOSS_M_IDEA_PS
rename SCH_PSDISC_MULTOOS_IDEA_F MULTOSS_F_IDEA_PS

rename SCH_DISCWODIS_ISS_HI_M ISS_M_HI_NODIS
rename SCH_DISCWODIS_ISS_HI_F ISS_F_HI_NODIS
rename SCH_DISCWODIS_ISS_AM_M ISS_M_AI_NODIS
rename SCH_DISCWODIS_ISS_AM_F ISS_F_AI_NODIS
rename SCH_DISCWODIS_ISS_AS_M ISS_M_AS_NODIS
rename SCH_DISCWODIS_ISS_AS_F ISS_F_AS_NODIS
rename SCH_DISCWODIS_ISS_HP_M ISS_M_HP_NODIS
rename SCH_DISCWODIS_ISS_HP_F ISS_F_HP_NODIS
rename SCH_DISCWODIS_ISS_BL_M ISS_M_BL_NODIS
rename SCH_DISCWODIS_ISS_BL_F ISS_F_BL_NODIS
rename SCH_DISCWODIS_ISS_WH_M ISS_M_WH_NODIS
rename SCH_DISCWODIS_ISS_WH_F ISS_F_WH_NODIS
rename SCH_DISCWODIS_ISS_TR_M ISS_M_MR_NODIS
rename SCH_DISCWODIS_ISS_TR_F ISS_F_MR_NODIS
rename TOT_DISCWODIS_ISS_M ISS_M_NODIS
rename TOT_DISCWODIS_ISS_F ISS_F_NODIS
rename SCH_DISCWODIS_ISS_LEP_M ISS_M_NODIS_LEP
rename SCH_DISCWODIS_ISS_LEP_F ISS_F_NODIS_LEP

rename SCH_DISCWODIS_SINGOOS_HI_M SINGOSS_M_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_HI_F SINGOSS_F_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_M SINGOSS_M_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_F SINGOSS_F_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_M SINGOSS_M_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_F SINGOSS_F_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_M SINGOSS_M_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_F SINGOSS_F_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_M SINGOSS_M_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_F SINGOSS_F_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_M SINGOSS_M_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_F SINGOSS_F_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_M SINGOSS_M_MR_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_F SINGOSS_F_MR_NODIS
rename TOT_DISCWODIS_SINGOOS_M SINGOSS_M_NODIS
rename TOT_DISCWODIS_SINGOOS_F SINGOSS_F_NODIS
rename SCH_DISCWODIS_SINGOOS_LEP_M SINGOSS_M_NODIS_LEP
rename SCH_DISCWODIS_SINGOOS_LEP_F SINGOSS_F_NODIS_LEP

rename SCH_DISCWODIS_MULTOOS_HI_M MULTOSS_M_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_HI_F MULTOSS_F_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_M MULTOSS_M_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_F MULTOSS_F_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_M MULTOSS_M_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_F MULTOSS_F_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_M MULTOSS_M_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_F MULTOSS_F_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_M MULTOSS_M_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_F MULTOSS_F_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_M MULTOSS_M_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_F MULTOSS_F_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_M MULTOSS_M_MR_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_F MULTOSS_F_MR_NODIS
rename TOT_DISCWODIS_MULTOOS_M MULTOSS_M_NODIS
rename TOT_DISCWODIS_MULTOOS_F MULTOSS_F_NODIS
rename SCH_DISCWODIS_MULTOOS_LEP_M MULTOSS_M_NODIS_LEP
rename SCH_DISCWODIS_MULTOOS_LEP_F MULTOSS_F_NODIS_LEP

rename SCH_DISCWDIS_ISS_IDEA_HI_M ISS_M_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HI_F ISS_F_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_M ISS_M_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_F ISS_F_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_M ISS_M_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_F ISS_F_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_M ISS_M_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_F ISS_F_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_M ISS_M_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_F ISS_F_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_M ISS_M_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_F ISS_F_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_M ISS_M_MR_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_F ISS_F_MR_IDEA
rename TOT_DISCWDIS_ISS_IDEA_M ISS_M_IDEA
rename TOT_DISCWDIS_ISS_IDEA_F ISS_F_IDEA
rename SCH_DISCWDIS_ISS_LEP_M ISS_M_DIS_LEP
rename SCH_DISCWDIS_ISS_LEP_F ISS_F_DIS_LEP
rename SCH_DISCWDIS_ISS_504_M ISS_M_504
rename SCH_DISCWDIS_ISS_504_F ISS_F_504

rename SCH_DISCWDIS_SINGOOS_IDEA_HI_M SINGOSS_M_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HI_F SINGOSS_F_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_M SINGOSS_M_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_F SINGOSS_F_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_M SINGOSS_M_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_F SINGOSS_F_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_M SINGOSS_M_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_F SINGOSS_F_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_M SINGOSS_M_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_F SINGOSS_F_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_M SINGOSS_M_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_F SINGOSS_F_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_M SINGOSS_M_MR_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_F SINGOSS_F_MR_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_M SINGOSS_M_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_F SINGOSS_F_IDEA
rename SCH_DISCWDIS_SINGOOS_LEP_M SINGOSS_M_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_LEP_F SINGOSS_F_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_504_M SINGOSS_M_504
rename SCH_DISCWDIS_SINGOOS_504_F SINGOSS_F_504

rename SCH_DISCWDIS_MULTOOS_IDEA_HI_M MULTOSS_M_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HI_F MULTOSS_F_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_M MULTOSS_M_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_F MULTOSS_F_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_M MULTOSS_M_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_F MULTOSS_F_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_M MULTOSS_M_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_F MULTOSS_F_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_M MULTOSS_M_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_F MULTOSS_F_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_M MULTOSS_M_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_F MULTOSS_F_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_M MULTOSS_M_MR_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_F MULTOSS_F_MR_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_M MULTOSS_M_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_F MULTOSS_F_IDEA
rename SCH_DISCWDIS_MULTOOS_LEP_M MULTOSS_M_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_LEP_F MULTOSS_F_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_504_M MULTOSS_M_504
rename SCH_DISCWDIS_MULTOOS_504_F MULTOSS_F_504

rename SCH_PSOOSINSTANCES_ALL OSSINSTANCES_PS 
rename SCH_PSOOSINSTANCES_IDEA OSSINSTANCES_IDEA_PS
rename SCH_OOSINSTANCES_WODIS OSSINSTANCES_NODIS
rename SCH_OOSINSTANCES_IDEA OSSINSTANCES_IDEA
rename SCH_OOSINSTANCES_504 OSSINSTANCES_504
rename SCH_DAYSMISSED_HI_M SUS_DAYSMISSED_M_HI
rename SCH_DAYSMISSED_HI_F SUS_DAYSMISSED_F_HI
rename SCH_DAYSMISSED_AM_M SUS_DAYSMISSED_M_AI
rename SCH_DAYSMISSED_AM_F SUS_DAYSMISSED_F_AI
rename SCH_DAYSMISSED_AS_M SUS_DAYSMISSED_M_AS
rename SCH_DAYSMISSED_AS_F SUS_DAYSMISSED_F_AS
rename SCH_DAYSMISSED_HP_M SUS_DAYSMISSED_M_HP
rename SCH_DAYSMISSED_HP_F SUS_DAYSMISSED_F_HP
rename SCH_DAYSMISSED_BL_M SUS_DAYSMISSED_M_BL
rename SCH_DAYSMISSED_BL_F SUS_DAYSMISSED_F_BL
rename SCH_DAYSMISSED_WH_M SUS_DAYSMISSED_M_WH
rename SCH_DAYSMISSED_WH_F SUS_DAYSMISSED_F_WH
rename SCH_DAYSMISSED_TR_M SUS_DAYSMISSED_M_MR
rename SCH_DAYSMISSED_TR_F SUS_DAYSMISSED_F_MR
rename TOT_DAYSMISSED_M SUS_DAYSMISSED_M
rename TOT_DAYSMISSED_F SUS_DAYSMISSED_F
rename SCH_DAYSMISSED_LEP_M SUS_DAYSMISSED_M_LEP
rename SCH_DAYSMISSED_LEP_F SUS_DAYSMISSED_F_LEP
rename SCH_DAYSMISSED_504_M SUS_DAYSMISSED_M_504
rename SCH_DAYSMISSED_504_F SUS_DAYSMISSED_F_504
rename SCH_DAYSMISSED_IDEA_M SUS_DAYSMISSED_M_IDEA
rename SCH_DAYSMISSED_IDEA_F SUS_DAYSMISSED_F_IDEA

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

save ".\Cleaned data\Suspensions\sus_17_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY 
collapse (sum) SINGOSS_M_HI_PS SINGOSS_F_HI_PS SINGOSS_M_AI_PS SINGOSS_F_AI_PS SINGOSS_M_AS_PS SINGOSS_F_AS_PS SINGOSS_M_HP_PS SINGOSS_F_HP_PS SINGOSS_M_BL_PS SINGOSS_F_BL_PS SINGOSS_M_WH_PS SINGOSS_F_WH_PS SINGOSS_M_MR_PS SINGOSS_F_MR_PS SINGOSS_M_PS SINGOSS_F_PS SINGOSS_M_LEP_PS SINGOSS_F_LEP_PS SINGOSS_M_IDEA_PS SINGOSS_F_IDEA_PS MULTOSS_M_HI_PS MULTOSS_F_HI_PS MULTOSS_M_AI_PS MULTOSS_F_AI_PS MULTOSS_M_AS_PS MULTOSS_F_AS_PS MULTOSS_M_HP_PS MULTOSS_F_HP_PS MULTOSS_M_BL_PS MULTOSS_F_BL_PS MULTOSS_M_WH_PS MULTOSS_F_WH_PS MULTOSS_M_MR_PS MULTOSS_F_MR_PS MULTOSS_M_PS MULTOSS_F_PS MULTOSS_M_LEP_PS MULTOSS_F_LEP_PS MULTOSS_M_IDEA_PS MULTOSS_F_IDEA_PS ISS_M_HI_NODIS ISS_F_HI_NODIS ISS_M_AI_NODIS ISS_F_AI_NODIS ISS_M_AS_NODIS ISS_F_AS_NODIS ISS_M_HP_NODIS ISS_F_HP_NODIS ISS_M_BL_NODIS ISS_F_BL_NODIS ISS_M_WH_NODIS ISS_F_WH_NODIS ISS_M_MR_NODIS ISS_F_MR_NODIS ISS_M_NODIS ISS_F_NODIS ISS_M_NODIS_LEP ISS_F_NODIS_LEP SINGOSS_M_HI_NODIS SINGOSS_F_HI_NODIS SINGOSS_M_AI_NODIS SINGOSS_F_AI_NODIS SINGOSS_M_AS_NODIS SINGOSS_F_AS_NODIS SINGOSS_M_HP_NODIS SINGOSS_F_HP_NODIS SINGOSS_M_BL_NODIS SINGOSS_F_BL_NODIS SINGOSS_M_WH_NODIS SINGOSS_F_WH_NODIS SINGOSS_M_MR_NODIS SINGOSS_F_MR_NODIS SINGOSS_M_NODIS SINGOSS_F_NODIS SINGOSS_M_NODIS_LEP SINGOSS_F_NODIS_LEP MULTOSS_M_HI_NODIS MULTOSS_F_HI_NODIS MULTOSS_M_AI_NODIS MULTOSS_F_AI_NODIS MULTOSS_M_AS_NODIS MULTOSS_F_AS_NODIS MULTOSS_M_HP_NODIS MULTOSS_F_HP_NODIS MULTOSS_M_BL_NODIS MULTOSS_F_BL_NODIS MULTOSS_M_WH_NODIS MULTOSS_F_WH_NODIS MULTOSS_M_MR_NODIS MULTOSS_F_MR_NODIS MULTOSS_M_NODIS MULTOSS_F_NODIS MULTOSS_M_NODIS_LEP MULTOSS_F_NODIS_LEP ISS_M_HI_IDEA ISS_F_HI_IDEA ISS_M_AI_IDEA ISS_F_AI_IDEA ISS_M_AS_IDEA ISS_F_AS_IDEA ISS_M_HP_IDEA ISS_F_HP_IDEA ISS_M_BL_IDEA ISS_F_BL_IDEA ISS_M_WH_IDEA ISS_F_WH_IDEA ISS_M_MR_IDEA ISS_F_MR_IDEA ISS_M_IDEA ISS_F_IDEA ISS_M_DIS_LEP ISS_F_DIS_LEP ISS_M_504 ISS_F_504 SINGOSS_M_HI_IDEA SINGOSS_F_HI_IDEA SINGOSS_M_AI_IDEA SINGOSS_F_AI_IDEA SINGOSS_M_AS_IDEA SINGOSS_F_AS_IDEA SINGOSS_M_HP_IDEA SINGOSS_F_HP_IDEA SINGOSS_M_BL_IDEA SINGOSS_F_BL_IDEA SINGOSS_M_WH_IDEA SINGOSS_F_WH_IDEA SINGOSS_M_MR_IDEA SINGOSS_F_MR_IDEA SINGOSS_M_IDEA SINGOSS_F_IDEA SINGOSS_M_DIS_LEP SINGOSS_F_DIS_LEP SINGOSS_M_504 SINGOSS_F_504 MULTOSS_M_HI_IDEA MULTOSS_F_HI_IDEA MULTOSS_M_AI_IDEA MULTOSS_F_AI_IDEA MULTOSS_M_AS_IDEA MULTOSS_F_AS_IDEA MULTOSS_M_HP_IDEA MULTOSS_F_HP_IDEA MULTOSS_M_BL_IDEA MULTOSS_F_BL_IDEA MULTOSS_M_WH_IDEA MULTOSS_F_WH_IDEA MULTOSS_M_MR_IDEA MULTOSS_F_MR_IDEA MULTOSS_M_IDEA MULTOSS_F_IDEA MULTOSS_M_DIS_LEP MULTOSS_F_DIS_LEP MULTOSS_M_504 MULTOSS_F_504 OSSINSTANCES_IDEA_PS OSSINSTANCES_PS OSSINSTANCES_NODIS OSSINSTANCES_IDEA OSSINSTANCES_504 SUS_DAYSMISSED_M_HI SUS_DAYSMISSED_F_HI SUS_DAYSMISSED_M_AI SUS_DAYSMISSED_F_AI SUS_DAYSMISSED_M_AS SUS_DAYSMISSED_F_AS SUS_DAYSMISSED_M_HP SUS_DAYSMISSED_F_HP SUS_DAYSMISSED_M_BL SUS_DAYSMISSED_F_BL SUS_DAYSMISSED_M_WH SUS_DAYSMISSED_F_WH SUS_DAYSMISSED_M_MR SUS_DAYSMISSED_F_MR SUS_DAYSMISSED_M SUS_DAYSMISSED_F SUS_DAYSMISSED_M_LEP SUS_DAYSMISSED_F_LEP SUS_DAYSMISSED_M_504 SUS_DAYSMISSED_F_504 SUS_DAYSMISSED_M_IDEA SUS_DAYSMISSED_F_IDEA (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_17_lea.dta", replace


//2020-21 (from public use, school level data)
import delimited ".\2020-21-crdc-data\CRDC\School\Suspensions.csv", stringcols(3 5 7) clear 
drop jj
names sus 2020

gen YEAR=2020
rename *, upper 
gen RACES_REPORTED=7

rename SCH_PSDISC_OOMOOS_HI_M OSS_M_HI_PS
rename SCH_PSDISC_OOMOOS_HI_F OSS_F_HI_PS
rename SCH_PSDISC_OOMOOS_AM_M OSS_M_AI_PS
rename SCH_PSDISC_OOMOOS_AM_F OSS_F_AI_PS
rename SCH_PSDISC_OOMOOS_AS_M OSS_M_AS_PS
rename SCH_PSDISC_OOMOOS_AS_F OSS_F_AS_PS
rename SCH_PSDISC_OOMOOS_HP_M OSS_M_HP_PS
rename SCH_PSDISC_OOMOOS_HP_F OSS_F_HP_PS
rename SCH_PSDISC_OOMOOS_BL_M OSS_M_BL_PS
rename SCH_PSDISC_OOMOOS_BL_F OSS_F_BL_PS
rename SCH_PSDISC_OOMOOS_WH_M OSS_M_WH_PS
rename SCH_PSDISC_OOMOOS_WH_F OSS_F_WH_PS
rename SCH_PSDISC_OOMOOS_TR_M OSS_M_TR_PS
rename SCH_PSDISC_OOMOOS_TR_F OSS_F_TR_PS
rename TOT_PSDISC_OOMOOS_M OSS_M_PS
rename TOT_PSDISC_OOMOOS_F OSS_F_PS
rename SCH_PSDISC_OOMOOS_LEP_M OSS_M_LEP_PS
rename SCH_PSDISC_OOMOOS_LEP_F OSS_F_LEP_PS
rename SCH_PSDISC_OOMOOS_IDEA_M OSS_F_IDEA_PS
rename SCH_PSDISC_OOMOOS_IDEA_F OSS_M_IDEA_PS
rename SCH_PSOOSINSTANCES_ALL OSSINSTANCES_PS 
rename SCH_PSOOSINSTANCES_IDEA OSSINSTANCES_IDEA_PS

rename SCH_DISCWODIS_ISS_HI_M ISS_M_HI_NODIS
rename SCH_DISCWODIS_ISS_HI_F ISS_F_HI_NODIS
rename SCH_DISCWODIS_ISS_AM_M ISS_M_AI_NODIS
rename SCH_DISCWODIS_ISS_AM_F ISS_F_AI_NODIS
rename SCH_DISCWODIS_ISS_AS_M ISS_M_AS_NODIS
rename SCH_DISCWODIS_ISS_AS_F ISS_F_AS_NODIS
rename SCH_DISCWODIS_ISS_HP_M ISS_M_HP_NODIS
rename SCH_DISCWODIS_ISS_HP_F ISS_F_HP_NODIS
rename SCH_DISCWODIS_ISS_BL_M ISS_M_BL_NODIS
rename SCH_DISCWODIS_ISS_BL_F ISS_F_BL_NODIS
rename SCH_DISCWODIS_ISS_WH_M ISS_M_WH_NODIS
rename SCH_DISCWODIS_ISS_WH_F ISS_F_WH_NODIS
rename SCH_DISCWODIS_ISS_TR_M ISS_M_MR_NODIS
rename SCH_DISCWODIS_ISS_TR_F ISS_F_MR_NODIS
rename TOT_DISCWODIS_ISS_M ISS_M_NODIS
rename TOT_DISCWODIS_ISS_F ISS_F_NODIS
rename SCH_DISCWODIS_ISS_LEP_M ISS_M_NODIS_LEP
rename SCH_DISCWODIS_ISS_LEP_F ISS_F_NODIS_LEP

rename SCH_DISCWODIS_SINGOOS_HI_M SINGOSS_M_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_HI_F SINGOSS_F_HI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_M SINGOSS_M_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AM_F SINGOSS_F_AI_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_M SINGOSS_M_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_AS_F SINGOSS_F_AS_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_M SINGOSS_M_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_HP_F SINGOSS_F_HP_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_M SINGOSS_M_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_BL_F SINGOSS_F_BL_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_M SINGOSS_M_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_WH_F SINGOSS_F_WH_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_M SINGOSS_M_MR_NODIS
rename SCH_DISCWODIS_SINGOOS_TR_F SINGOSS_F_MR_NODIS
rename TOT_DISCWODIS_SINGOOS_M SINGOSS_M_NODIS
rename TOT_DISCWODIS_SINGOOS_F SINGOSS_F_NODIS
rename SCH_DISCWODIS_SINGOOS_LEP_M SINGOSS_M_NODIS_LEP
rename SCH_DISCWODIS_SINGOOS_LEP_F SINGOSS_F_NODIS_LEP

rename SCH_DISCWODIS_MULTOOS_HI_M MULTOSS_M_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_HI_F MULTOSS_F_HI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_M MULTOSS_M_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AM_F MULTOSS_F_AI_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_M MULTOSS_M_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_AS_F MULTOSS_F_AS_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_M MULTOSS_M_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_HP_F MULTOSS_F_HP_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_M MULTOSS_M_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_BL_F MULTOSS_F_BL_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_M MULTOSS_M_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_WH_F MULTOSS_F_WH_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_M MULTOSS_M_MR_NODIS
rename SCH_DISCWODIS_MULTOOS_TR_F MULTOSS_F_MR_NODIS
rename TOT_DISCWODIS_MULTOOS_M MULTOSS_M_NODIS
rename TOT_DISCWODIS_MULTOOS_F MULTOSS_F_NODIS
rename SCH_DISCWODIS_MULTOOS_LEP_M MULTOSS_M_NODIS_LEP
rename SCH_DISCWODIS_MULTOOS_LEP_F MULTOSS_F_NODIS_LEP

rename SCH_DISCWDIS_ISS_IDEA_HI_M ISS_M_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HI_F ISS_F_HI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_M ISS_M_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AM_F ISS_F_AI_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_M ISS_M_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_AS_F ISS_F_AS_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_M ISS_M_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_HP_F ISS_F_HP_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_M ISS_M_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_BL_F ISS_F_BL_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_M ISS_M_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_WH_F ISS_F_WH_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_M ISS_M_MR_IDEA
rename SCH_DISCWDIS_ISS_IDEA_TR_F ISS_F_MR_IDEA
rename TOT_DISCWDIS_ISS_IDEA_M ISS_M_IDEA
rename TOT_DISCWDIS_ISS_IDEA_F ISS_F_IDEA
rename SCH_DISCWDIS_ISS_LEP_M ISS_M_DIS_LEP
rename SCH_DISCWDIS_ISS_LEP_F ISS_F_DIS_LEP
rename SCH_DISCWDIS_ISS_504_M ISS_M_504
rename SCH_DISCWDIS_ISS_504_F ISS_F_504

rename SCH_DISCWDIS_SINGOOS_IDEA_HI_M SINGOSS_M_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HI_F SINGOSS_F_HI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_M SINGOSS_M_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AM_F SINGOSS_F_AI_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_M SINGOSS_M_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_AS_F SINGOSS_F_AS_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_M SINGOSS_M_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_HP_F SINGOSS_F_HP_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_M SINGOSS_M_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_BL_F SINGOSS_F_BL_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_M SINGOSS_M_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_WH_F SINGOSS_F_WH_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_M SINGOSS_M_MR_IDEA
rename SCH_DISCWDIS_SINGOOS_IDEA_TR_F SINGOSS_F_MR_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_M SINGOSS_M_IDEA
rename TOT_DISCWDIS_SINGOOS_IDEA_F SINGOSS_F_IDEA
rename SCH_DISCWDIS_SINGOOS_LEP_M SINGOSS_M_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_LEP_F SINGOSS_F_DIS_LEP
rename SCH_DISCWDIS_SINGOOS_504_M SINGOSS_M_504
rename SCH_DISCWDIS_SINGOOS_504_F SINGOSS_F_504

rename SCH_DISCWDIS_MULTOOS_IDEA_HI_M MULTOSS_M_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HI_F MULTOSS_F_HI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_M MULTOSS_M_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AM_F MULTOSS_F_AI_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_M MULTOSS_M_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_AS_F MULTOSS_F_AS_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_M MULTOSS_M_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_HP_F MULTOSS_F_HP_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_M MULTOSS_M_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_BL_F MULTOSS_F_BL_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_M MULTOSS_M_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_WH_F MULTOSS_F_WH_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_M MULTOSS_M_MR_IDEA
rename SCH_DISCWDIS_MULTOOS_IDEA_TR_F MULTOSS_F_MR_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_M MULTOSS_M_IDEA
rename TOT_DISCWDIS_MULTOOS_IDEA_F MULTOSS_F_IDEA
rename SCH_DISCWDIS_MULTOOS_LEP_M MULTOSS_M_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_LEP_F MULTOSS_F_DIS_LEP
rename SCH_DISCWDIS_MULTOOS_504_M MULTOSS_M_504
rename SCH_DISCWDIS_MULTOOS_504_F MULTOSS_F_504

rename SCH_OOSINSTANCES_WODIS OSSINSTANCES_NODIS
rename SCH_OOSINSTANCES_IDEA OSSINSTANCES_IDEA
rename SCH_OOSINSTANCES_504 OSSINSTANCES_504
rename SCH_DAYSMISSED_HI_M SUS_DAYSMISSED_M_HI
rename SCH_DAYSMISSED_HI_F SUS_DAYSMISSED_F_HI
rename SCH_DAYSMISSED_AM_M SUS_DAYSMISSED_M_AI
rename SCH_DAYSMISSED_AM_F SUS_DAYSMISSED_F_AI
rename SCH_DAYSMISSED_AS_M SUS_DAYSMISSED_M_AS
rename SCH_DAYSMISSED_AS_F SUS_DAYSMISSED_F_AS
rename SCH_DAYSMISSED_HP_M SUS_DAYSMISSED_M_HP
rename SCH_DAYSMISSED_HP_F SUS_DAYSMISSED_F_HP
rename SCH_DAYSMISSED_BL_M SUS_DAYSMISSED_M_BL
rename SCH_DAYSMISSED_BL_F SUS_DAYSMISSED_F_BL
rename SCH_DAYSMISSED_WH_M SUS_DAYSMISSED_M_WH
rename SCH_DAYSMISSED_WH_F SUS_DAYSMISSED_F_WH
rename SCH_DAYSMISSED_TR_M SUS_DAYSMISSED_M_MR
rename SCH_DAYSMISSED_TR_F SUS_DAYSMISSED_F_MR
rename TOT_DAYSMISSED_M SUS_DAYSMISSED_M
rename TOT_DAYSMISSED_F SUS_DAYSMISSED_F
rename SCH_DAYSMISSED_LEP_M SUS_DAYSMISSED_M_LEP
rename SCH_DAYSMISSED_LEP_F SUS_DAYSMISSED_F_LEP
rename SCH_DAYSMISSED_504_M SUS_DAYSMISSED_M_504
rename SCH_DAYSMISSED_504_F SUS_DAYSMISSED_F_504
rename SCH_DAYSMISSED_IDEA_M SUS_DAYSMISSED_M_IDEA
rename SCH_DAYSMISSED_IDEA_F SUS_DAYSMISSED_F_IDEA

*replace reserve codes
ds, has(type numeric)
foreach var in `r(varlist)' {    
    replace `var' = . if `var' < 0
}

save ".\Cleaned data\Suspensions\sus_20_sch.dta", replace

drop SCHID SCH_NAME COMBOKEY 
collapse (sum) OSS_M_HI_PS OSS_F_HI_PS OSS_M_AI_PS OSS_F_AI_PS OSS_M_AS_PS OSS_F_AS_PS OSS_M_HP_PS OSS_F_HP_PS OSS_M_BL_PS OSS_F_BL_PS OSS_M_WH_PS OSS_F_WH_PS OSS_M_TR_PS OSS_F_TR_PS OSS_M_PS OSS_F_PS OSS_M_LEP_PS OSS_F_LEP_PS OSS_F_IDEA_PS OSS_M_IDEA_PS OSSINSTANCES_PS OSSINSTANCES_IDEA_PS ISS_M_HI_NODIS ISS_F_HI_NODIS ISS_M_AI_NODIS ISS_F_AI_NODIS ISS_M_AS_NODIS ISS_F_AS_NODIS ISS_M_HP_NODIS ISS_F_HP_NODIS ISS_M_BL_NODIS ISS_F_BL_NODIS ISS_M_WH_NODIS ISS_F_WH_NODIS ISS_M_MR_NODIS ISS_F_MR_NODIS ISS_M_NODIS ISS_F_NODIS ISS_M_NODIS_LEP ISS_F_NODIS_LEP SINGOSS_M_HI_NODIS SINGOSS_F_HI_NODIS SINGOSS_M_AI_NODIS SINGOSS_F_AI_NODIS SINGOSS_M_AS_NODIS SINGOSS_F_AS_NODIS SINGOSS_M_HP_NODIS SINGOSS_F_HP_NODIS SINGOSS_M_BL_NODIS SINGOSS_F_BL_NODIS SINGOSS_M_WH_NODIS SINGOSS_F_WH_NODIS SINGOSS_M_MR_NODIS SINGOSS_F_MR_NODIS SINGOSS_M_NODIS SINGOSS_F_NODIS SINGOSS_M_NODIS_LEP SINGOSS_F_NODIS_LEP MULTOSS_M_HI_NODIS MULTOSS_F_HI_NODIS MULTOSS_M_AI_NODIS MULTOSS_F_AI_NODIS MULTOSS_M_AS_NODIS MULTOSS_F_AS_NODIS MULTOSS_M_HP_NODIS MULTOSS_F_HP_NODIS MULTOSS_M_BL_NODIS MULTOSS_F_BL_NODIS MULTOSS_M_WH_NODIS MULTOSS_F_WH_NODIS MULTOSS_M_MR_NODIS MULTOSS_F_MR_NODIS MULTOSS_M_NODIS MULTOSS_F_NODIS MULTOSS_M_NODIS_LEP MULTOSS_F_NODIS_LEP ISS_M_HI_IDEA ISS_F_HI_IDEA ISS_M_AI_IDEA ISS_F_AI_IDEA ISS_M_AS_IDEA ISS_F_AS_IDEA ISS_M_HP_IDEA ISS_F_HP_IDEA ISS_M_BL_IDEA ISS_F_BL_IDEA ISS_M_WH_IDEA ISS_F_WH_IDEA ISS_M_MR_IDEA ISS_F_MR_IDEA ISS_M_IDEA ISS_F_IDEA ISS_M_DIS_LEP ISS_F_DIS_LEP ISS_M_504 ISS_F_504 SINGOSS_M_HI_IDEA SINGOSS_F_HI_IDEA SINGOSS_M_AI_IDEA SINGOSS_F_AI_IDEA SINGOSS_M_AS_IDEA SINGOSS_F_AS_IDEA SINGOSS_M_HP_IDEA SINGOSS_F_HP_IDEA SINGOSS_M_BL_IDEA SINGOSS_F_BL_IDEA SINGOSS_M_WH_IDEA SINGOSS_F_WH_IDEA SINGOSS_M_MR_IDEA SINGOSS_F_MR_IDEA SINGOSS_M_IDEA SINGOSS_F_IDEA SINGOSS_M_DIS_LEP SINGOSS_F_DIS_LEP SINGOSS_M_504 SINGOSS_F_504 MULTOSS_M_HI_IDEA MULTOSS_F_HI_IDEA MULTOSS_M_AI_IDEA MULTOSS_F_AI_IDEA MULTOSS_M_AS_IDEA MULTOSS_F_AS_IDEA MULTOSS_M_HP_IDEA MULTOSS_F_HP_IDEA MULTOSS_M_BL_IDEA MULTOSS_F_BL_IDEA MULTOSS_M_WH_IDEA MULTOSS_F_WH_IDEA MULTOSS_M_MR_IDEA MULTOSS_F_MR_IDEA MULTOSS_M_IDEA MULTOSS_F_IDEA MULTOSS_M_DIS_LEP MULTOSS_F_DIS_LEP MULTOSS_M_504 MULTOSS_F_504 OSSINSTANCES_NODIS OSSINSTANCES_IDEA OSSINSTANCES_504 SUS_DAYSMISSED_M_HI SUS_DAYSMISSED_F_HI SUS_DAYSMISSED_M_AI SUS_DAYSMISSED_F_AI SUS_DAYSMISSED_M_AS SUS_DAYSMISSED_F_AS SUS_DAYSMISSED_M_HP SUS_DAYSMISSED_F_HP SUS_DAYSMISSED_M_BL SUS_DAYSMISSED_F_BL SUS_DAYSMISSED_M_WH SUS_DAYSMISSED_F_WH SUS_DAYSMISSED_M_MR SUS_DAYSMISSED_F_MR SUS_DAYSMISSED_M SUS_DAYSMISSED_F SUS_DAYSMISSED_M_LEP SUS_DAYSMISSED_F_LEP SUS_DAYSMISSED_M_504 SUS_DAYSMISSED_F_504 SUS_DAYSMISSED_M_IDEA SUS_DAYSMISSED_F_IDEA (max) YEAR RACES_REPORTED, by(LEAID)
save ".\Cleaned data\Suspensions\sus_20_lea.dta", replace


// Combine restricted access historical data
use ".\Cleaned data\Suspensions\sus_oss_73to06.dta", clear
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_singoss_dis_09_RA.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_multoss_dis_09_RA.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_iss_dis_09_RA.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_singoss_nodis_09_RA.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_multoss_nodis_09_RA.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_iss_nodis_09_RA.dta", nogen

*calculate total out of school suspension counts by race (sum across single and multiple, disability and no disability)
egen OSS_AI_summed = rowtotal(SINGOSS_M_AI_IDEA SINGOSS_F_AI_IDEA MULTOSS_M_AI_IDEA MULTOSS_F_AI_IDEA SINGOSS_M_AI_NODIS SINGOSS_F_AI_NODIS MULTOSS_M_AI_NODIS MULTOSS_F_AI_NODIS), missing
egen OSS_AS_summed = rowtotal(SINGOSS_M_AS_IDEA SINGOSS_F_AS_IDEA MULTOSS_M_AS_IDEA MULTOSS_F_AS_IDEA SINGOSS_M_AS_NODIS SINGOSS_F_AS_NODIS MULTOSS_M_AS_NODIS MULTOSS_F_AS_NODIS), missing
egen OSS_BL_summed = rowtotal(SINGOSS_M_BL_IDEA SINGOSS_F_BL_IDEA MULTOSS_M_BL_IDEA MULTOSS_F_BL_IDEA SINGOSS_M_BL_NODIS SINGOSS_F_BL_NODIS MULTOSS_M_BL_NODIS MULTOSS_F_BL_NODIS), missing
egen OSS_HI_summed = rowtotal(SINGOSS_M_HI_IDEA SINGOSS_F_HI_IDEA MULTOSS_M_HI_IDEA MULTOSS_F_HI_IDEA SINGOSS_M_HI_NODIS SINGOSS_F_HI_NODIS MULTOSS_M_HI_NODIS MULTOSS_F_HI_NODIS), missing
egen OSS_WH_summed = rowtotal(SINGOSS_M_WH_IDEA SINGOSS_F_WH_IDEA MULTOSS_M_WH_IDEA MULTOSS_F_WH_IDEA SINGOSS_M_WH_NODIS SINGOSS_F_WH_NODIS MULTOSS_M_WH_NODIS MULTOSS_F_WH_NODIS), missing
egen OSS_HP_summed = rowtotal(SINGOSS_M_HP_IDEA SINGOSS_F_HP_IDEA MULTOSS_M_HP_IDEA MULTOSS_F_HP_IDEA SINGOSS_M_HP_NODIS SINGOSS_F_HP_NODIS MULTOSS_M_HP_NODIS MULTOSS_F_HP_NODIS), missing
egen OSS_MR_summed = rowtotal(SINGOSS_M_MR_IDEA SINGOSS_F_MR_IDEA MULTOSS_M_MR_IDEA MULTOSS_F_MR_IDEA SINGOSS_M_MR_NODIS SINGOSS_F_MR_NODIS MULTOSS_M_MR_NODIS MULTOSS_F_MR_NODIS), missing

*replace these variables (which are missing in 2009) with the summed counts
replace OSS_AI = OSS_AI_summed if OSS_AI==. & OSS_AI_summed!=.
replace OSS_AS = OSS_AS_summed if OSS_AS==. & OSS_AS_summed!=.
replace OSS_BL = OSS_BL_summed if OSS_BL==. & OSS_BL_summed!=.
replace OSS_HI = OSS_HI_summed if OSS_HI==. & OSS_HI_summed!=.
replace OSS_WH = OSS_WH_summed if OSS_WH==. & OSS_WH_summed!=.
gen OSS_HP = OSS_HP_summed 
gen OSS_MR = OSS_MR_summed

drop *_summed 

//calculate a total suspension counts by summing the counts by race. This doesn't always match the reported total variable from older years (OSS)
egen OSS_sumrace = rowtotal(OSS_AI OSS_AS OSS_HI OSS_BL OSS_WH OSS_HP OSS_MR), missing 
 
order YEAR LEAID LEA_STATE OSS_AI OSS_AS OSS_HI OSS_BL OSS_WH OSS_HP OSS_MR OSS_sumrace

save ".\Cleaned data\Suspensions\sus_68to09_lea.dta", replace

// Combine public use contemporary data at lea-level
use ".\Cleaned data\Suspensions\sus_singoss_dis_11_lea.dta", clear
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_multoss_dis_11_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_iss_dis_11_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_singoss_nodis_11_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_multoss_nodis_11_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_iss_nodis_11_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_13_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_15_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_17_lea.dta", nogen
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_20_lea.dta", nogen

order LEAID YEAR RACES_REPORTED
sort LEAID YEAR

*create overall OSS variables to match to historical data
egen OSS_AI = rowtotal(SINGOSS_M_AI_IDEA SINGOSS_F_AI_IDEA MULTOSS_M_AI_IDEA MULTOSS_F_AI_IDEA SINGOSS_M_AI_NODIS SINGOSS_F_AI_NODIS MULTOSS_M_AI_NODIS MULTOSS_F_AI_NODIS), missing
egen OSS_AS = rowtotal(SINGOSS_M_AS_IDEA SINGOSS_F_AS_IDEA MULTOSS_M_AS_IDEA MULTOSS_F_AS_IDEA SINGOSS_M_AS_NODIS SINGOSS_F_AS_NODIS MULTOSS_M_AS_NODIS MULTOSS_F_AS_NODIS), missing
egen OSS_BL = rowtotal(SINGOSS_M_BL_IDEA SINGOSS_F_BL_IDEA MULTOSS_M_BL_IDEA MULTOSS_F_BL_IDEA SINGOSS_M_BL_NODIS SINGOSS_F_BL_NODIS MULTOSS_M_BL_NODIS MULTOSS_F_BL_NODIS), missing
egen OSS_HI = rowtotal(SINGOSS_M_HI_IDEA SINGOSS_F_HI_IDEA MULTOSS_M_HI_IDEA MULTOSS_F_HI_IDEA SINGOSS_M_HI_NODIS SINGOSS_F_HI_NODIS MULTOSS_M_HI_NODIS MULTOSS_F_HI_NODIS), missing
egen OSS_WH = rowtotal(SINGOSS_M_WH_IDEA SINGOSS_F_WH_IDEA MULTOSS_M_WH_IDEA MULTOSS_F_WH_IDEA SINGOSS_M_WH_NODIS SINGOSS_F_WH_NODIS MULTOSS_M_WH_NODIS MULTOSS_F_WH_NODIS), missing
egen OSS_HP = rowtotal(SINGOSS_M_HP_IDEA SINGOSS_F_HP_IDEA MULTOSS_M_HP_IDEA MULTOSS_F_HP_IDEA SINGOSS_M_HP_NODIS SINGOSS_F_HP_NODIS MULTOSS_M_HP_NODIS MULTOSS_F_HP_NODIS), missing
egen OSS_MR = rowtotal(SINGOSS_M_MR_IDEA SINGOSS_F_MR_IDEA MULTOSS_M_MR_IDEA MULTOSS_F_MR_IDEA SINGOSS_M_MR_NODIS SINGOSS_F_MR_NODIS MULTOSS_M_MR_NODIS MULTOSS_F_MR_NODIS), missing

*calculate a total suspension counts by summing the counts by race. This doesn't always match the reported total (OSS)
egen OSS_sumrace = rowtotal(OSS_AI OSS_AS OSS_HI OSS_BL OSS_WH OSS_HP OSS_MR), missing 

order YEAR LEAID OSS_AI OSS_AS OSS_HI OSS_BL OSS_WH OSS_HP OSS_MR OSS_sumrace

save ".\Cleaned data\Suspensions\sus_09to20_lea.dta", replace

//Combine historical restricted access data (1972-2009) with contemporary lea-level data
use ".\Cleaned data\Suspensions\sus_68to09_lea.dta", clear
merge 1:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_09to20_lea.dta", nogen

sort LEAID YEAR

save ".\Cleaned data\Suspensions\sus_68to20_lea.dta", replace

//Combine public school level data 2011-2020
use ".\Cleaned data\Suspensions\sus_singoss_dis_11_sch.dta", clear
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_multoss_dis_11_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_iss_dis_11_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_singoss_nodis_11_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_multoss_nodis_11_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_iss_nodis_11_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_13_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_15_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_17_sch.dta", nogen
merge 1:1 COMBOKEY YEAR using ".\Cleaned data\Suspensions\sus_20_sch.dta", nogen

order COMBOKEY YEAR RACES_REPORTED
sort COMBOKEY YEAR

save ".\Cleaned data\Suspensions\sus_09to20_sch.dta", replace


//create spreadsheet of variable names
names sus all
use ".\vars_sus_all.dta", clear
merge 1:1 name_merge gender race DIS LEP PS DSO instances suspension races_reported using ".\vars_sus_2011.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances suspension races_reported using ".\vars_sus_2013.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances suspension races_reported using ".\vars_sus_2015.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances suspension races_reported using ".\vars_sus_2017.dta", nogen
merge 1:1 name_merge gender race DIS LEP PS DSO instances suspension races_reported using ".\vars_sus_2020.dta", nogen
drop gender race DIS LEP PS races_reported instances DSO enroll hb_type hb_domain suspension expulsion offense seclusion satactug athletics ssclass course coursetype coursegrade retgrade status name_merge
rename (name_all type_all) (name type)
save ".\Cleaned data\Documentation\vars_sus.dta", replace
erase ".\vars_sus_all.dta"
erase ".\vars_sus_2011.dta"
erase ".\vars_sus_2013.dta"
erase ".\vars_sus_2015.dta"
erase ".\vars_sus_2017.dta"
erase ".\vars_sus_2020.dta"

//add variable labels
do ".\variable labels program.do"
labels ".\Cleaned data\Suspensions\sus_09to20_sch.dta"

////Analyze CP//////

cd "Set Working Directory"

//// Merge enrollment data with corporal punishment  data
use ".\Cleaned data\Enrollments\enr_68to20_lea.dta", clear
merge 1:1 LEAID YEAR using ".\Cleaned data\CorporalPunishment\corp_73to20_lea.dta"
//5 observations from corporal punishment data are not matched to enrollment data. Looks like they are special leas (eg 16SOP01) and they all have missing or zeros for CORP variables anyway, so I am dropping
drop if _merge==2
//There are 5 observations from 2005 that have enrollment data, but did not appear in corporal punishment file. Dropping these as well.
drop if _merge==1
drop _merge

tab YEAR
duplicates report LEAID YEAR

//// Decide which districts' enrollment counts to include in the denominators

//Option 1: All observations are included in the sample.
gen insample_1 = 1

//Option 2: To be included in the sample, observations must have non-missing value reported for CORP_sumrace, meaning they must have reported a suspension count (even if 0) for at least one racial group. 
gen insample_2 = .
replace insample_2 = 1 if CORP_sumrace !=.

*Choosing option 2 
keep if insample_2==1 
tab YEAR //CORP_sumrace is all zeros in 1973 and 1974

//// Fill in all STATE variables
gen FIPS = substr(LEAID, 1, 2)
order YEAR LEAID STATE FIPS

preserve
keep FIPS STATE
duplicates drop
sort FIPS STATE
quietly bysort FIPS: gen dup=cond(_N==1, 0, _n)
drop if dup==1
drop dup
rename STATE STATE_CODE
save ".\Cleaned data\state codes.dta", replace
restore

merge m:1 FIPS using ".\Cleaned data\state codes.dta"
order YEAR LEAID STATE FIPS STATE_CODE

//// Collapse to state level /////

* For total counts, I use the totals calculated by summing counts by race
collapse (sum) ENR_AI ENR_AS ENR_BL ENR_HI ENR_WH ENR_HP ENR_MR ENR_sumrace CORP_AI CORP_AS CORP_HI CORP_BL CORP_WH CORP_HP CORP_MR CORP_sumrace, by(YEAR STATE_CODE)
reshape long CORP_ ENR_, i(YEAR STATE_CODE) j(race) string

* Round all numbers to nearest 5 for disclosure purposes
foreach var in ENR_ CORP_ {    
    replace `var' = 5*round(`var'/5)
}

//Produce table
export excel using ".\Outputs\corp_76to20_bystate.xlsx", firstrow(variables) replace

////Analyze OOS////

cd "Set Working Directory"

//merge enrollment data with suspension data
use ".\Cleaned data\Enrollments\enr_68to20_lea.dta", clear
merge m:1 LEAID YEAR using ".\Cleaned data\Suspensions\sus_allyears_combined_lea.dta"
//5 observations with suspension data do not match to enrollment data. They all look like special LEAIDs. I drop them.
drop if _merge==2
//There are 5 districts in 2009 that do not match to any suspension data. Why? Also dropping these for now.
drop if _merge==1
drop _merge

tab YEAR

////// Calculate the proportion of students from each racial group who receive an out of school suspension, by year

//// Decide which districts' enrollment counts to include in the denominators (iterations through i)

//Option 1: All observations are included in the sample.
gen insample_1 = 1

//Option 2: To be included in the sample, observations must have non-missing value reported for OSS_sumrace, meaning they must have reported a suspension count (even if 0) for at least one racial group. 
gen insample_2 = .
replace insample_2 = 1 if OSS_sumrace !=.


//// Fill in all STATE variables
gen FIPS = substr(LEAID, 1, 2)
order YEAR LEAID STATE FIPS

preserve
keep FIPS STATE
duplicates drop
sort FIPS STATE
quietly bysort FIPS: gen dup=cond(_N==1, 0, _n)
drop if dup==1
drop dup
rename STATE STATE_CODE
save ".\Cleaned data\state codes.dta", replace
restore

merge m:1 FIPS using ".\Cleaned data\state codes.dta"
order YEAR LEAID STATE FIPS STATE_CODE

//// Collapse to state level //////

*Choosing option 2 from above
keep if insample_2==1 
	
collapse (sum) ENR_AI ENR_AS ENR_BL ENR_HI ENR_WH ENR_HP ENR_MR ENR_sumrace OSS_AI OSS_AS OSS_HI OSS_BL OSS_WH OSS_HP OSS_MR OSS_sumrace, by(YEAR STATE_CODE)
reshape long OSS_ ENR_, i(YEAR STATE_CODE) j(race) string

/*
*round all numbers to nearest 5 for disclosure purposes
foreach var in ENR_ OSS_ {    
    replace `var' = 5*round(`var'/5)
}
*/

gen pct_ = 100 * ( OSS_ / ENR_ )
replace pct_ = . if pct_ == 0
replace race="total" if race=="sumrace"

//Produce table
export excel using ".\Outputs\Suspension outputs\suspensions_72to21_bystate.xlsx", firstrow(variables) replace

///These excel tables are then used as inputs into the R Data preparation and Visuals code////
