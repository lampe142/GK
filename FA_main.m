%The main code to create and run the FA dynare code
%Uses:      FA_func to create and run dynare files   
%           FA_ss: to calculate the steady state of the FA model
%           DSGE_ss: to calculate the steady state of the DSGE model

clc; clear all; close all;

%Defining a cell array for models
models_cell     =   {'DSGE';'FA';'FA_CP'}; %
nn_models       =   length(models_cell);

%Calling FA_func with the model files to create and run dynare files
for ii=1:nn_models
    save temp.mat models_cell nn_models ii;
    clear all;
    load temp.mat models_cell nn_models ii;
    eval(['FA_func(''' models_cell{ii} ''');']);
end;

%Creating plots
plot_figures('FA',1);
plot_figures('FA_CP',5);