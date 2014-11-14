%Open economy GK model
%Calculates the FA steady state

%Created by Peter Karadi
%June 2010

%clc; clear all; close all;

run ../FA/FA_ss;

%Loading the parameters and the variables
load ../data/FA_ss.mat params_ss vars_ss vars_nolog_ss varexo_ss;

%adding new parameters
params_ss.RkmR_ss  =   log(vars_ss.Rk/vars_ss.R);

%adding new exogenous variables
varexo_ss.e_psi     =   0;

%adding new variables
vars_nolog_cell     =   {'psi';'shock_psi';'QKg_Y'};
nn_vars_nolog   =   length(vars_nolog_cell);
for ii=1:nn_vars_nolog
    eval(['vars_nolog_ss.' vars_nolog_cell{ii} '=0;']);
end;

%Saving the parameters and the variables
save ../data/FA_CP_ss.mat params_ss vars_ss vars_nolog_ss varexo_ss;
