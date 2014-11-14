function FA_func(switch_model)
%The function to create and run the FA dynare codes
%Input:     switch_model: 'DSGE' for baseline DSGE model
%                         'FA' for the financial accelerator model
%Uses:      FA_ss: to calculate the steady state of the FA model
%           DSGE_ss: to calculate the steady state of the DSGE model

%Calculate the steady state and loading the parameters and variables
switch switch_model
    case 'DSGE' %International RBC model
        run DSGE/DSGE_ss.m;
        load data/DSGE_ss.mat params_ss vars_ss vars_nolog_ss varexo_ss;
    case 'FA'   %Open economy financial accelerator model
        run FA/FA_ss.m;
        load data/FA_ss.mat params_ss vars_ss vars_nolog_ss varexo_ss;
    case 'FA_CP'   %Open economy financial accelerator model
        run FA_CP/FA_CP_ss.m;
        load data/FA_CP_ss.mat params_ss vars_ss vars_nolog_ss varexo_ss;
end;
        
params_names    =   fieldnames(params_ss);  %cell array of parameter names
vars_names      =   fieldnames(vars_ss);    %cell array of variable names
vars_nolog_names=   fieldnames(vars_nolog_ss);    %cell array of variable names
varexo_names    =   fieldnames(varexo_ss);  %cell array of exogenous variable names

nn_params       =   length(params_names);   %number of parameters
nn_vars         =   length(vars_names);     %number of endogenous variables
nn_vars_nolog   =   length(vars_nolog_names);     %number of endogenous variables
nn_varexo       =   length(varexo_names);   %number of exogenous variables

%Creating a string with the parameter names
params_string   =   [];
for ii=1:nn_params
    params_string   =   [params_string params_names{ii} ' '];
end;
%adding G related variables
params_string   =   [params_string 'G_ss I_ss'];     %adding G, I to parameters variables

vars_string     =   [];
for ii=1:nn_vars
    vars_string     =   [vars_string vars_names{ii} ' '];
end;
for ii=1:nn_vars_nolog
    vars_string     =   [vars_string vars_nolog_names{ii} ' '];
end;

varexo_string     =   [];
for ii=1:nn_varexo
    varexo_string     =   [varexo_string varexo_names{ii} ' '];
end;

%Creating dynare file
cd dynare;

%Creating the '.mod' file and starting writing in it
eval(['fid  =   fopen(''' switch_model '.mod'',''w'');']);

fprintf(fid,'// Dynare model file to calculate the GK model\n');
fprintf(fid,'// Created by Peter Karadi\n');
fprintf(fid,'// July 2010\n\n');

%defining the parameters, exogenous and endogenous variables
fprintf(fid,['parameters ' params_string ';\n']);
fprintf(fid,['var ' vars_string ';\n']);
fprintf(fid,['varexo ' varexo_string ';\n\n']);

%Writing the parameter values
for ii=1:nn_params
    eval(['fprintf(fid,''' params_names{ii} '=%2.8f;\n'',' 'params_ss.' params_names{ii} ');']);
end;
fprintf(fid,'G_ss       =   %2.8f;\n',vars_ss.G);
fprintf(fid,'I_ss       =   %2.8f;\n',vars_ss.I);
fprintf(fid,'\n');

%Opening the model file and copying the model into the dynare file
fprintf(fid,'\n\nmodel;\n');

%Opening the model file as readable
eval(['fid_mod     =   fopen(''../' switch_model '/' switch_model '_model.m'',''r'');']);

while (1>0)
    modelline = fgetl(fid_mod);
        if (modelline==-1)  %end of file
            break 
        end;
    fprintf(fid,[modelline '\n']);
end;
fprintf(fid,'end;\n');
fclose(fid_mod);        %closing the model file

%Writing the steady state endogenous and exogenous variables as starting
%values
fprintf(fid,'\n\ninitval;\n');
for ii=1:nn_vars
    eval(['fprintf(fid,''' vars_names{ii} '=log(%2.8f);\n'',' 'vars_ss.' vars_names{ii} ');']);
end;
for ii=1:nn_vars_nolog
    eval(['fprintf(fid,''' vars_nolog_names{ii} '=%2.8f;\n'',' 'vars_nolog_ss.' vars_nolog_names{ii} ');']);
end;
for ii=1:nn_varexo
    eval(['fprintf(fid,''' varexo_names{ii} '=%2.8f;\n'',' 'varexo_ss.' varexo_names{ii} ');']);
end;
fprintf(fid,'end;\n');  %ending it

%Defining the variances of the shocks
fprintf(fid,'\nshocks;\n');
for ii=1:nn_varexo    
    varexo_end  = varexo_names{ii}(3:length(varexo_names{ii})); %shock names
    eval(['fprintf(fid,''' 'var ' varexo_names{ii} '=sigma_' varexo_end '^2;\n''' ');']);
end;
fprintf(fid,'end;\n');

%Checking the solution and making it calculate the steady state
fprintf(fid,'\ncheck;\n');
fprintf(fid,'\nsteady;\n');


%Solving the model
fprintf(fid,'\nstoch_simul(order=1, periods=2000, irf=40,nograph);'); %,nograph

%Saving the created impulse responses
fprintf(fid,'\n\n// Saving the impulse responses');
eval(['fprintf(fid,''\nsave ../data/' switch_model '_1.mat '');']);        
for ii=1:nn_vars
    for jj=1:nn_varexo
            fprintf(fid,[vars_names{ii} '_' varexo_names{jj} ' ']);    
    end;
end;
for ii=1:nn_vars_nolog
    for jj=1:nn_varexo
            fprintf(fid,[vars_nolog_names{ii} '_' varexo_names{jj} ' ']);    
    end;
end;
fprintf(fid,';\n');


%Closing the dynare file
fclose(fid);
cd ..

%running the dynare file
cd dynare;
eval(['dynare ' switch_model '.mod noclearall;']);
cd ..;