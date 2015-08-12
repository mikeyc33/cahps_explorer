library(sas7bdat)
library(plyr)
library(dplyr)
library(ggplot2)
library(reshape2)
library(shiny)

#read CAHPS individual-level SAS dataset
df1 <- read.sas7bdat("./data/cahps_data.sas7bdat")

var_titles <- data.frame(var = names(df1), var_title = c("Education-Level","Age","Self-Reported General Health","Self-Reported Mental Health",
                                                         "Health Plan ID", "Patient ID","Doctor Rating (0-100)","Getting Timely Care (0-100)",
                                                         "How Well Doctor Communicates (0-100)","Access to Specialists (0-100)",
                                                         "Health Promotion and Education (0-100)","Health and Functional Status (0-100)",
                                                         "Shared-Decision Making (0-100)","Age < 64 Dummy","Age 65-69 Dummy",
                                                         "Age 75-79 Dummy", "Age > 80 Dummy", "Education High School Dummy",
                                                         "Education Some College Dummy","Education College Dummy","Education More than College Dummy",
                                                         "Excellent Self-Reported Health Dummy","Very Good Self-Reported Health Dummy",
                                                         "Fair Self-Reported Health Dummy","Poor Self-Reported Health Dummy",
                                                         "Excellent Self-Reported Mental Health Dummy","Very Good Self-Reported Mental Health Dummy",
                                                         "Fair Self-Reported Mental Health Dummy","Poor Self-Reported Mental Health Dummy"))

#Selection Inputs for UI
CAHPS_scores <- c("Getting Timely Care" = "c_access",
                  "Provider Communication" = "c_comm",
                  "Doctor Rating" = "rate_md",
                  "Health Promotion and Education" = "m_hlth_promo",
                  "Shared-Decision Making" = "m_sdm",
                  "Access to Specialists" = "c_spec",
                  "Health Status and Functional Status" = "m_func")

wrap_vars <- c("None" = "None",
               "Self-Reported Health" = "ghs",
               "Self-Reported Mental Health" = "mhs",
               "Education-Level" = "educ",
               "Age Category" = "age",
               "Health Plan ID" = "plan")

Overlay_vars <- c("None" = "None", CAHPS_scores)

predictors <- c("Getting Timely Care" = "c_access",
                "Provider Communication" = "c_comm",
                "Doctor Rating" = "rate_md",
                "Health Promotion and Education" = "m_hlth_promo",
                "Shared-Decision Making" = "m_sdm",
                "Access to Specialists" = "c_spec",
                "Health Status and Functional Status" = "m_func",
                "Age < 65 (Dummy Variable)" = "age64",
                "Age 65-69 (Dummy Variable)" = "age6569",
                "Age 75-79 (Dummy Variable)" = "age7579",
                "Age 80 or older (Dummy Variable)" = "age80",
                "Education: High School (Dummy Variable)" = "educ_hs",
                "Education: Some College (Dummy Variable)" = "educ_somecol",
                "Education: College (Dummy Variable)" = "educ_coll",
                "Education: More than College (Dummy Variable)" = "educ_collmore",
                "Self-Rated Health: Excellent (Dummy Variable)" = "ghs_excel",
                "Self-Rated Health: Very Good (Dummy Variable)" = "ghs_vgood",
                "Self-Rated Health: Fair (Dummy Variable)" = "ghs_fair",
                "Self-Rated Health: Poor (Dummy Variable)"= "ghs_poor",
                "Self-Rated Mental Health: Excellent (Dummy Variable)" = "mhs_excel",
                "Self-Rated Mental Health: Very Good (Dummy Variable)" = "mhs_vgood",
                "Self-Rated Mental Health: Fair (Dummy Variable)" = "mhs_fair",
                "Self-Rated Mental Health: Poor (Dummy Variable)" = "mhs_poor")

#Correlation Plot gradient colors
red=rgb(1,0,0); green=rgb(0,1,0); blue=rgb(0,0,1); white=rgb(1,1,1)
RtoWrange<-colorRampPalette(c(red, white ) )
WtoGrange<-colorRampPalette(c(white, green) ) 
