function diff=f_KL(XX,params)

%Calculates the steady state capital and labor for the DSGE model 
%Output:    diff: difference between the lhs and rhs of the equilibrium
%                   condition (needs to be 0)
%Input:     XX: vector of capital and labor (K,N)
%           params: structure of parameters

%Created by Peter Karadi
%June 2010

K   =   XX(1);
L   =   XX(2);

%Creating variables from the params structure
params_names     =   fieldnames(params);
nn=length(params_names);
for ii=1:nn
    eval([params_names{ii} '=params.' params_names{ii} ';']);
end;

%Calculating steady state values
Y   =   K^alfa*L^(1-alfa);
G   =   G_over_Y*Y;
I   =   delta*K;
C   =   Y-I-G;
R   =   1/betta;
Pm  =   (epsilon-1)/epsilon;
Rk  =   Pm*alfa*Y/K+1-delta;

diff(1)     =   chi*L^varphi-(1-betta*hh)*((1-hh)*C)^(-sig)*Pm*(1-alfa)*Y/L;
diff(2)     =   Rk-R;