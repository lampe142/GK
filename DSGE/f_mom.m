function diff = f_mom(XX,params,starting,moments, switches)

%Calculates difference from a vector of predetermined moments 
%Output:    diff: difference from the predetermined vector of moments
%Input:     XX: vector of starting values
%           params: structure of parameters

%Created by Peter Karadi
%June 2010

%Obtaining the starting values
chi     =   XX(1);

%Creating new structure for submitted parameters for f_KL
params_f    =   params;

%Adding the values to the parameters
params_f.chi      =   chi;

[vars_ss,varexo_ss]   =   f_simul(params_f,starting,switches);

%Getting the moments
L       =   vars_ss.L;

%Obtaining moments
moments_names   =   fieldnames(moments);
kk  =   length(moments_names);
for ii=1:kk
    eval([moments_names{ii} '=moments.' moments_names{ii} ';']);
end;

%Setting the differences
diff(1)     =   log(L/L_mom);
