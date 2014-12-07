# CalibrationEst.R
# zhanli86@bu.edu
#
# Purpose: estimate the calibration constand and telescope efficiency parameters
# in a given model with Differential Evolutionary optimization method.
# Input data points: range, return intensity and target reflectance.
# Two models are used here: 1) EVI model with its own telescope efficiency model;
# 2) DWEL model with the telescope efficiency model from Ewan Douglas. 

# load DEoptim library to use DE optimization method
library(DEoptim)

# Error function of fitting data points to EVI telescope efficiency model
ErrFun.EVI <- function(calp, r, pr, rho){
    # calp: the calibration parameters.
    # For EVI model, calp=[C_p(calibration constant), b(range factor), C_k(telescope efficiency parameter)]
    # r: range
    # pr: the return intensity in DN or voltage or joules
    # rho:
    pr.model = calp[1]*rho/r^calp[2]*(1-exp(-1*r^2/calp[3]))
    tmp = sum((pr.model - pr)^2)/length(r)
    return(tmp)
}

# Error function of fitting data points to DWEL telescope efficiency model
ErrFun.DWEL <- function(r, pr, rho){
    # r: range
    # pr: the return intensity in DN or voltage or joules
    # rho: reflectance
    return(err <- function(calp){
        # calp: the calibration parameters.
        # For DWEL model, calp=[C_0(calibration constant), C_1(first telescope efficiency parameter), C_2(second telescope efficiency parameter)]
        pr.model = calp[1]*rho/r^2*(calp[2]+r)^2*(1-exp(-1*(calp[3]*r/(calp[2]+r))^2))
        tmp = sum((pr.model - pr)^2)
        return(tmp)
    })
}

# csv file name of calibration data for wavelength 1548 nm
CalFile1548='/projectnb/echidna/lidar/zhanli86/Programs/CalibrationEstimate/DWEL_Calibration_ESP_1548.csv'

# read calibration data of 1548 nm
CalData1548 = read.csv(CalFile1548, skip = 1)

# define lower and upper boundary of EVI model parameters
EVI.lower = c(1e5, 1.5, 0)
EVI.upper = c(1e6,2.5, 1e5)
# call DEoptim function to estimate model parameters
EVI.Est = DEoptim(ErrFun.EVI, EVI.lower, EVI.upper, control = list(itermax=4000, strategy='6'),
        CalData1548[,1], CalData1548[,2], CalData1548[,3])

## # define lower and upper boundary of DWEL model parameters
## DWEL.lower = c(0, 0, 0)
## DWEL.upper = c(1e6, 1e2, 1e2)
## # call DEoptim function to estimate model parameters
## DWEL.Est = DEoptim(ErrFun.DWEL(CalData1548[,1], CalData1548[,2], CalData1548[,3]), DWEL.lower, DWEL.upper,
##     control = list(itermax=20000))
