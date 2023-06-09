# -----------------------------------------------------------------------------
# This program shows how to link the MEPS-HC Medical Conditions file 
# to the Prescribed Medicines (PMED/RX) file for data year 2020 to estimate:
#
# National totals:
#   - Total number of people w PMED purchase for hyperlipidemia (HL)
#   - Total PMED fills for HL
#   - Total PMED expenditures for HL 
#
# Per-person averages among ppl with any PMED for hyperlipidemia (HL)
#   - Avg PMED fills for hyperlipidemia, by SEX and Poverty (POVCAT)
#   - Avg PMED exp for HL per person w/ HL fills, by SEX and Poverty (POVCAT)
# 
# Input files:
#   - h220a.dta        (2020 Prescribed Medicines file)
#   - h222.dta         (2020 Conditions file)
#   - h220if1.dta      (2020 CLNK: Condition-Event Link file)
#   - h224.dta         (2020 Full-Year Consolidated file)
# 
# Resources:
#   - CCSR codes: 
#   https://github.com/HHS-AHRQ/MEPS/blob/master/Quick_Reference_Guides/meps_ccsr_conditions.csv
# 
#   - MEPS-HC Public Use Files: 
#   https://meps.ahrq.gov/mepsweb/data_stats/download_data_files.jsp
# 
#   - MEPS-HC online data tools: 
#   https://datatools.ahrq.gov/meps-hc
#
# -----------------------------------------------------------------------------


# Install/load packages and set global options --------------------------------

# Can skip this part if already installed
  install.packages("survey")   # for survey analysis
  install.packages("haven")    # for loading Stata (.dta) files
  install.packages("dplyr")    # for data manipulation
  install.packages("tidyr")    # for data manipulation
  install.packages("devtools") # for loading "MEPS" package from GitHub
  
  devtools::install_github("e-mitchell/meps_r_pkg/MEPS") # easier file import


# Load libraries (run this part each time you re-start R)

  
  


# Set survey option for lonely PSUs

  
  
  
# Load datasets ---------------------------------------------------------------
#  PMED/RX = Prescribed medicines file (record = rx fill or refill)
#  COND    = Medical conditions file (record = medical condition)
#  CLNK    = Conditions-event link file (crosswalk between conditions and 
#             events, including PMED events)
#  FYC     = Full-year-consolidated file (record = MEPS sample person)

  
# Option 1 - load data files using read_MEPS from the MEPS package
#  >> For PMED file, rename LINKIDX to EVNTIDX to merge with Conditions
    

  
  
  
  
# Option 2 - load Stata data files using read_dta from the haven package 
#  >> Replace "C:/MEPS" below with the directory you saved the files to.

  # pmed20 <- read_dta("C:/MEPS/h220a.dta") %>% rename(EVNTIDX=LINKIDX)
  # cond20 <- read_dta("C:/MEPS/h222.dta")
  # clnk20 <- read_dta("C:/MEPS/h220if1.dta")
  # fyc20  <- read_dta("C:/MEPS/h224.dta")
  

# Keep only needed variables ------------------------------------------------


  
  
  
  

# Prepare data for estimation -------------------------------------------------

# Subset condition records to hyperlipidemia (any CCSR = "END010") 


  
  
  # QC
 
  
  
  # >> Note that the same person can have 'duplicate' hyperlipidemia conditions. 
  #    This can happen when the full ICD10s are different (e.g. E78.1 and E78.5) 
  #    but the collapsed 3-digit ICD10CDX is the same (E78)
  
  # >> Example: DUPERSID == '2320134102'

  
   

# Merge hyperlipidemia conditions with PMED file, using CLNK as crosswalk -----

# 1. Merge COND with CLNK file

  
    
  # >> View example person: 
  #   - same condition (CONDIDX), multiple events (EVNTIDX) 
  #   - same event (EVNTIDX), multiple conditions (CONDIDX)
  

  
   
  
# 2. De-duplicate on EVNTIDX (so we don't 'double-count' events)

  
  
  # QC: should be 0 duplicate EVNTIDX

    
  
  # >> View example person: 

  
  
  
# 3. Merge HL-CLNK with PMED file

  
    
  
  # >> View example person: 

    
  
  # QC: check that EVENTYPE = 8 PRESCRIBED MEDICINE for all rows

  
    
  # QC: View top PMEDS for hyperlipidemia

  
  


# Roll up to person-level data ------------------------------------------------
# >> For each person:
#    - n_hl_fills: number of unique fills for hyperlipidemia
#    - hl_drug_exp: sum of PMED expenditures for hyperlipidemia
#    - hl_pmed_flag: make a flag for people with a PMED purchase 
  

  
   

  # >> View example person: 

    
  
  
# Merge onto FYC file ---------------------------------------------------------
#  >> Need to capture all Strata (VARSTR) and PSUs (VARPSU) for all MEPS sample 
#     persons for correct variance estimation

  
  
  
  

  # QC: should have same number of rows as FYC file

    
  # QC: hl_pmed_flag counts should be equal to rows in drugs_by_pers

     
  
  
# BONUS!! Compare people ever diagnosed with hyperlipidemia (CHOLDX == 1) with 
# those that have hyperlipidemia PMED purchases

  
  
  

  
# Define the survey design ----------------------------------------------------

  
  
  

# Calculate estimates ---------------------------------------------------------

# >> National Totals:

  
  
    
# >> Per-person average expenditures among people with at least 
#    one PMED fill for hyperlipidemia (hl_pmed_flag = 1)

  
  

# >> By SEX
#    1: MALE
#    2: FEMALE

  

# >> By POVCAT
#    1: Poor/negative
#    2: Near poor
#    3: Low income
#    4: Middle income
#    5: High income

  
