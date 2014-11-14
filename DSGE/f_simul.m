function [vars,vars_nolog,varexo]=f_simul(params,starting,switches)

%Calculates steady state values using the parameters
%Input:     params: structure of parameters
%Output:    vars: structure of steady state values

%Creating variables from the params structure
params_names     =   fieldnames(params);
nn=length(params_names);
for ii=1:nn
    eval([params_names{ii} '=params.' params_names{ii} ';']);
end;

%Obtaining starting values
K0  =   starting.K0;
L0  =   starting.L0;

%Calculating the equilibrium K and N values given the parameters
switch switches.switch_print
    case 'test'
        options     =   optimset('Display','iter');
    otherwise
        options     =   optimset('Display','off');
end;
[XX_ss,fval,exitf]  =   fsolve(@f_KL,[K0 L0],options,params);

K    =   XX_ss(1);
L    =   XX_ss(2);

switch switches.switch_print
    case 'test'
        fprintf('\n K_ss: %2.2f\n',K);
        fprintf('L_ss: %2.2f\n',L);
        fprintf('diff: %1.8f, %1.8f\n',[fval(1) fval(2)]);
        fprintf('exitf: %1.0f\n',exitf);        
end;


%Calculating steady state values

%prices
Q   =   1;
Pm  =   (epsilon-1)/epsilon;
X   =   1/Pm;
D   =   1;

%Macrovariables
Y  =   K^alfa*L^(1-alfa);
Ym =   Y;
I   =   delta*K;
In  =   0;
G   =   G_over_Y*Y;
C   =   Y-I-G;
varrho  =   (1-betta*hh)*((1-hh)*C)^(-sig);
Lambda  =   1;
R       =   1/betta;
Rk      =   Pm*alfa*Y/K+1-delta;
w       =   Pm*(1-alfa)*Y/L;
VMPK    =   Pm*alfa*Y/K;
if sig==1
    Welf    =   (log((1-hh)*C)-chi*L^(1+varphi)/(1+varphi))/(1-betta);
else
    Welf    =   (((1-hh)*C)^(1-sig)/(1-sig)-chi*L^(1+varphi)/(1+varphi))/(1-betta);
end;


Keff    =   K;          %Effective capital

%Pricing variables
F   =   Y*Pm/(1-betta*gam);
Z   =   Y/(1-betta*gam);
infl  =   0;
inflstar =0;
i   =   R;

%Variable capacity utilization parameters
U  =   1;
b  =   Pm*alfa*Y/K;
delta_c=delta-b/(1+zetta);

%shock variables
a       =   0;
ksi     =   0;
g       =   0;

%shocks
e_a     =   0;
e_ksi   =   0;
e_g     =   0;
e_Ne    =   0;
e_i     =   0;

%Creating cell array of variables
vars_cell   =   {'Y';'Ym'; 'K';  'Keff'; 'L'; 'I'; 'C'; 'G'; 'Q'; 'varrho'; 'Lambda'; 'Rk'; 'R'; 'Pm'; 'U'; 'D'; 'X';'F';'Z';'i'; 'w'; 'VMPK';'b';'delta_c'};
nn_vars     =   length(vars_cell);

%Creating cell array of exogenous variables
varexo_cell =  {'e_a'; 'e_ksi'; 'e_g';'e_i'};
nn_varexo   =   length(varexo_cell);

%Creating a structure with the variables
nn_vars      =  length(vars_cell);
for ii=1:nn_vars
    eval(['vars.' vars_cell{ii} '=' vars_cell{ii} ';']);
end;

%Creating structure with variables that are linearized
vars_nolog_cell     =   {'In';'Welf';'a';'ksi';'g';'infl';'inflstar'};
nn_vars_nolog   =   length(vars_nolog_cell);
for ii=1:nn_vars_nolog
    eval(['vars_nolog.' vars_nolog_cell{ii} '=' vars_nolog_cell{ii} ';']);
end;

%Creating a structure with the variables
nn_varexo      =  length(varexo_cell);
for ii=1:nn_varexo
    eval(['varexo.' varexo_cell{ii} '=' varexo_cell{ii} ';']);
end;
