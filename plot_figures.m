function plot_figures(switch_figure,M)
%Plotting figures
%Input:     switch_figure: switch determining the plot type
%           M: number of the figure

switch switch_figure
    case 'FA'
        models_cell     =   {'DSGE';'FA'};  %Cell array for models
        models_cell_names=   {'DSGE';'FA'};  %Cell array for models        
        vars_both_cell     =   {'Y'; 'K'; 'L'; 'C'; 'I'; 'Q'; 'R'; 'Rk'; 'w';'infl';'i'};
        vars_both_cell_names    =   {'Y'; 'K'; 'L'; 'C'; 'I'; 'Q'; 'R'; 'R_k'; 'w'; '\pi';'i'};
        vars_2_cell       =   {'prem'; 'N'};
        vars_2_cell_names =   {'Premium';'N'};

    
        varexo_cell_both     =   {'e_a'; 'e_ksi'; 'e_i'}; 
        varexo_cell_both_names   =   {'a'; '\xi'; 'monpol'};
        varexo_cell_2      =   {'e_Ne'}; 
        varexo_cell_2_names=   {'Net worth'};

    case 'FA_CP'
        models_cell             =   {'FA';'FA_CP'};  %Cell array for models
        models_cell_names     =   {'FA';'FA_{CP}'};  %Cell array for models
        vars_both_cell     =   {'Y'; 'K'; 'L'; 'C'; 'I'; 'Q'; 'R'; 'Rk'; 'w';'prem'; 'N';'infl';'i'};
        vars_both_cell_names    =   {'Y'; 'K'; 'L'; 'C'; 'I'; 'Q'; 'R'; 'R_k'; 'w';'Premium';'N';'\pi';'i'};
        vars_2_cell       =   {'QKg_Y'};
        vars_2_cell_names =   {'QKg_Y'};
        varexo_cell_both     =   {'e_a'; 'e_ksi'; 'e_i'; 'e_Ne'}; 
        varexo_cell_both_names   =   {'a'; '\xi'; 'monpol';'Net worth'}; 
        varexo_cell_2      =   {'e_psi'}; 
        varexo_cell_2_names=   {'e_\psi'};
end;

%Variables to plot
nn_vars_both     =   length(vars_both_cell);

%Variables only in the second model
nn_vars_2     =   length(vars_2_cell);

%Shocks to plot
nn_varexo_both       =   length(varexo_cell_both);

nn_varexo_2        =   length(varexo_cell_2);

%Loading the impulse responses  
%Creating a cell array with the impulse response names
for kk  =   1:length(models_cell)
    IRF_cell    =   {}; uu=1;
%adding the shock processes
    for jj=1:nn_varexo_both
        IRF_cell{uu}    =   [varexo_cell_both{jj}(3:length(varexo_cell_both{jj})) '_' varexo_cell_both{jj}];
        uu  =   uu+1;
    end;
    if kk>1
        for jj=1:nn_varexo_2
            IRF_cell{uu}    =   [varexo_cell_2{jj}(3:length(varexo_cell_2{jj})) '_' varexo_cell_2{jj}];
            uu  =   uu+1;
        end;
    end;
    
%adding variables that are in both models
    for ii=1:nn_vars_both
        for jj=1:nn_varexo_both
            IRF_cell{uu}    =   [vars_both_cell{ii} '_' varexo_cell_both{jj}];
            uu=uu+1;
        end;
        if kk>1
            for jj=1:nn_varexo_2
                IRF_cell{uu}    =   [vars_both_cell{ii} '_' varexo_cell_2{jj}];
                uu=uu+1;
            end;
        end;
    end;
    if kk>1 
        for ii=1:nn_vars_2
            for jj=1:nn_varexo_both
                IRF_cell{uu}    =   [vars_2_cell{ii} '_' varexo_cell_both{jj}]; 
                uu  =   uu+1;
            end;
            for jj=1:nn_varexo_2
                IRF_cell{uu}    =   [vars_2_cell{ii} '_' varexo_cell_2{jj}]; 
                uu  =   uu+1;
            end;
        end;
    end;

%Creating the command string for loading data
    eval(['load_cmd    =   ''load data/' models_cell{kk} '_1.mat '';']);
    for yy=1:uu-1
        load_cmd    =   [load_cmd IRF_cell{yy} ' '];
    end;
    load_cmd    =   [load_cmd ';'];
    eval(load_cmd);
    
    %Multiplying the Rk, R, premium IRF-s by 4 if they exist (yearly interest rates)
    for yy=1:uu-1  %for each IRF
        if or(or(strcmp('R_',IRF_cell{yy}(1:2)),strcmp('Rk_',IRF_cell{yy}(1:3))),strcmp('prem',IRF_cell{yy}(1:4))) %
            eval([IRF_cell{yy} '=4*' IRF_cell{yy} ';']);            
        end;
        if or(strcmp('i_',IRF_cell{yy}(1:3)),strcmp('infl',IRF_cell{yy}(1:4))) %
            eval([IRF_cell{yy} '=4*' IRF_cell{yy} ';']);
        end;
    end;

%Creating impulse responses with model name extensions
    for yy=1:uu-1
        eval([IRF_cell{yy} '_' models_cell{kk} '=' IRF_cell{yy} ';']);
    end;
end;

%Length of the impulse response functions
eval(['IRF_len     =   length(' vars_both_cell{1} '_' varexo_cell_both{1} ');']);

%Creating plots
nn_row  =   4;
nn_column = 4;

%Calculating the number of plots necessary
nn_plot     =   ceil((nn_vars_both+nn_vars_2+1)/(nn_row*nn_column));

for ii=1:nn_varexo_both  %shocks
    nn_fig =    M+(ii-1)*nn_plot;
    figure(nn_fig);   %Opening a figure
    %First figure plots the shock
    eval(['subplot(' num2str(nn_row) ',' num2str(nn_column) ',1); plot(1:IRF_len,' varexo_cell_both{ii}(3:length(varexo_cell_both{ii})) '_' varexo_cell_both{ii} '_' models_cell{1} '(1:IRF_len),''r--'',1:IRF_len,' varexo_cell_both{ii}(3:length(varexo_cell_both{ii})) '_' varexo_cell_both{ii} '_' models_cell{2} '(1:IRF_len),''k''); legend(''' models_cell_names{1} ''',''' models_cell_names{2} '''); title(''' varexo_cell_both_names{ii} ''');']);%First the shock process
    yy  =   2;
    for jj=1:nn_vars_both
            eval(['subplot(' num2str(nn_row) ',' num2str(nn_column) ',' num2str(yy) '); plot(1:IRF_len,' vars_both_cell{jj} '_' varexo_cell_both{ii} '_' models_cell{1} '(1:IRF_len),''r--'',1:IRF_len,' vars_both_cell{jj} '_' varexo_cell_both{ii} '_' models_cell{2} '(1:IRF_len),''k''); title(''' vars_both_cell_names{jj} ''');']);
            yy  =   yy+1; 
            if and(yy>(nn_row*nn_column),jj<nn_vars_both);     %Starting new figure if necessary 
                yy=1; 
                nn_fig=nn_fig+1; 
                figure(nn_fig); 
            end;
    end;
    for jj=1:nn_vars_2  %Figures with only functions in the second model
        eval(['subplot(' num2str(nn_row) ',' num2str(nn_column) ',' num2str(yy) '); plot(1:IRF_len,' vars_2_cell{jj} '_' varexo_cell_both{ii} '_' models_cell{2} '(1:IRF_len),''k''); title(''' vars_2_cell_names{jj} ''');']);
        yy=yy+1;
        if and(yy>(nn_row*nn_column),jj<nn_vars_2);     %Starting new figure if necessary 
            yy=1; 
            nn_fig=nn_fig+1;
            figure(nn_fig); 
        end;
    end;
    
end;

for ii=1:nn_varexo_2  %shocks only in the second model
    nn_fig =    nn_fig+1;
    figure(nn_fig);   %Opening a figure
    %First figure plots the shock
    eval(['subplot(' num2str(nn_row) ',' num2str(nn_column) ',1); plot(1:IRF_len,' varexo_cell_2{ii}(3:length(varexo_cell_2{ii})) '_' varexo_cell_2{ii} '_' models_cell{2} '(1:IRF_len),''k''); legend(''' models_cell_names{2} '''); title(''' varexo_cell_2_names{ii} ''');']);%First the shock process
    yy  =   2;
    for jj=1:nn_vars_both
            eval(['subplot(' num2str(nn_row) ',' num2str(nn_column) ',' num2str(yy) '); plot(1:IRF_len,' vars_both_cell{jj} '_' varexo_cell_2{ii} '_' models_cell{2} '(1:IRF_len),''k''); title(''' vars_both_cell_names{jj} ''');']);
            yy  =   yy+1; 
            if and(yy>(nn_row*nn_column),jj<nn_vars_both);     %Starting new figure if necessary 
                yy=1; 
                nn_fig=nn_fig+1; 
                figure(nn_fig); 
            end;
    end;
    for jj=1:nn_vars_2 
        eval(['subplot(' num2str(nn_row) ',' num2str(nn_column) ',' num2str(yy) '); plot(1:IRF_len,' vars_2_cell{jj} '_' varexo_cell_2{ii} '_' models_cell{2} '(1:IRF_len),''k''); title(''' vars_2_cell_names{jj} ''');']);
        yy=yy+1;
        if and(yy>(nn_row*nn_column),jj<nn_vars_2);     %Starting new figure if necessary 
            yy=1; 
            nn_fig=nn_fig+1;
            figure(nn_fig); 
        end;
    end;
end;
