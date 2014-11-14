%Open economy GK model
%Calculates the IRBC steady state

%Created by Peter Karadi
%June 2010

%clc; clear all; close all;

%Setting the parameters, starting values and moments to hit
run ../params_set;

%Loading parameters and creating structure for easy transfer
load ../data/params.mat params starting moments switches;

%creating variables from the structures
params_names     =   fieldnames(params);
nn=length(params_names);
for ii=1:nn
    eval([params_names{ii} '=params.' params_names{ii} ';']);
end;

starting_names   =   fieldnames(starting);
mm  =   length(starting_names);
for ii=1:mm
    eval([starting_names{ii} '=starting.' starting_names{ii} ';']);
end;


switches_names   =   fieldnames(switches);
ll  =   length(switches_names);
for ii=1:ll
    eval([switches_names{ii} '=switches.' switches_names{ii} ';']);
end;

%Calibrating the parameters to hit the moments
switch switch_print
    case 'details'
        options     =   optimset('Display','iter');
    case 'test'
        options     =   optimset('Display','iter');
    otherwise
        options     =   optimset('Display','off');
end;
[XX,diff,exitf]     =   fsolve(@f_mom,chi0,options,params,starting,moments,switches);

chi     =   XX;

switch switch_print
    case 'test'
        fprintf('chi: %1.6f\n',chi);
end;
%Creating structures for parameters and variables used by dynare
params_ss   =   params;
extrafields     =   {'theta'; 'sigma_Ne'};
params_ss       =   rmfield(params_ss,extrafields);

params_ss.chi       =   chi;

%Getting the variables
[vars_ss,vars_nolog_ss,varexo_ss]   =   f_simul(params_ss,starting,switches);

%Taking the variable capacity utilization parameters from vars and putting it to
%parameters
params_ss.b     =   vars_ss.b;
params_ss.delta_c=  vars_ss.delta_c;
vars_ss     =   rmfield(vars_ss,{'b';'delta_c'});

%Taking delta from parameters and putting it to variables
vars_ss.delta   =   params_ss.delta;
params_ss       =   rmfield(params_ss,'delta');

%Saving the parameters and the variables
save ../data/DSGE_ss.mat params_ss vars_ss vars_nolog_ss varexo_ss;