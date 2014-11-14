%Gertler-Karadi model
%Sets the parameters, saves them to data/params.mat file

%Created by Peter Karadi
%June 2010

%clc; clear all; close all;

switch_print    =   'no';  %'test' for too many details, 'details', 'yes', 'no'

%Setting parameters
betta   =   0.99;           %Discount rate
sig     =   1;              %Intertemporal elasticity of substitution
hh      =   0.815;          %Habit formation parameters
chi0    =   3.4;            %Starting value for the labor utility weight
varphi  =   0.276;          %Inverse Frisch elasticity of labor supply       
zetta   =   7.2;            %Elasticity of marginal depreciation wrt the utilization rate

lambda0  =  0.3815;          %Starting value divertable fraction 
omega0   =  0.002;           %Starting value of proportional starting up funds
theta   =   0.97155955;     %The survival probability

alfa    =   0.33;           %Capital share
delta   =   0.025;          %Depreciation rate
G_over_Y=   0.2;            %Government expenditures over GDP
eta_i   =   1.728;          %elasticity of investment adjusment cost

%Retail firms
epsilon =   4.167;          %Elasticity of substitution between goods %problem with 1: C-D
gam     =   0.779;          %Calvo parameter
gam_P   =   0.241;          %Price indexation parameter

%Monetary Policy parameters
rho_i   =   0.; %0.8            %Interest rate smoothing parameter
kappa_pi=   1.5;            %Inflation coefficient
kappa_y =   -0.5/4;          %Output gap coefficient

%Shocks
sigma_ksi   =   0.05;       %size of the capital quality shock
rho_ksi     =   0.66;       %persistence of the capital quality shock
sigma_a     =   0.01;       %size of the TFP shock
rho_a       =   0.95;       %persistence of the TFP shock
sigma_g     =   0.01;       %size of the government expenditure shock
rho_g       =   0.95;       %persistence of the government expenditure shock
sigma_Ne    =   0.01;       %wealth shock
sigma_i     =   0.01;       %monetary policy shock
rho_shock_psi=  0.66;       %persistence of the CP shock
sigma_psi   =   0.072;      %size of the CP shock


%Targeted moments
L_mom    =   1/3;       %Steady state labor supply
RkmR_mom =   0.01/4;    %steady state premium
phi_mom  =   4;         %steady state leverage

%Credit policy parameters
kappa      =   10;     %Credit policy coefficient
tau        =   0.001;  %Costs of credit policy

%Starting values for some steady state values
L0      =   L_mom;
K0      =   9.5;      

%Creating a structure for the parameters
params.betta     =   betta;
params.sig       =   sig;
params.hh        =   hh;
params.varphi    =   varphi;
params.zetta      =   zetta;

params.theta     =   theta;

params.alfa      =   alfa;
params.delta     =   delta;
params.G_over_Y  =   G_over_Y;
params.eta_i     =   eta_i;

params.epsilon   =   epsilon;
params.gam       =   gam;
params.gam_P     =   gam_P;

params.kappa_pi  =   kappa_pi;
params.kappa_y   =   kappa_y;
params.rho_i     =   rho_i;

params.rho_ksi   =   rho_ksi;
params.sigma_ksi =   sigma_ksi;
params.rho_a     =   rho_a;
params.sigma_a   =   sigma_a;
params.rho_g     =   rho_g;
params.sigma_g   =   sigma_g;
params.sigma_Ne  =   sigma_Ne;
params.sigma_i   =   sigma_i;
params.rho_shock_psi   =   rho_shock_psi;
params.sigma_psi =   sigma_psi;


params.kappa     =   kappa;
params.tau       =   tau;

%Setting starting values for the calibrated parameters
starting.chi0    =   chi0;
starting.lambda0 =   lambda0;
starting.omega0  =   omega0;
starting.K0      =   K0;
starting.L0      =   L0;

%Setting target moments
moments.L_mom    =   L_mom;
moments.RkmR_mom =   RkmR_mom;
moments.phi_mom  =   phi_mom;

switches.switch_print   =   switch_print;

save data/params.mat params starting moments switches;