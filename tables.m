%Creates LaTeX tables about the parameters and the steady state values
clc;
%run the code calculating steady states and creating params file
run FA/FA_ss.m;
%Loads the parameter values
load 'data/FA_ss.mat' params_ss vars_ss;

fprintf('\n');
%fprintf('\\begin{table}[h]\n');
%fprintf('\\caption{Parameter values}\n');
fprintf('\\begin{tabular}{c|c|l}\n');
fprintf('\\hline\\hline\n');
%fprintf('Symbol & Value & Description \\\\ \\hline \n');

fprintf('\\multicolumn{3}{c}{Households}\\\\ \\hline \n');
fprintf('$\\beta$ & %1.3f & Discount rate \\\\\n', params_ss.betta);
fprintf('$\\sigma$ & %1.3f & Intertemporal elasticity of substitution \\\\\n', params_ss.sig);
fprintf('$h$ & %1.3f & Habit parameter \\\\\n', params_ss.hh);
fprintf('$\\chi$ & %1.3f & Relative utility weight of labor \\\\\n', params_ss.chi);
fprintf('$\\varphi$ & %1.3f & Inverse Frisch elasticity of labor supply \\\\ \\hline \n', params_ss.varphi);

fprintf('\\multicolumn{3}{c}{Financial Intermediaries}\\\\ \\hline \n');
fprintf('$\\lambda$ & %1.3f & Fraction of capital that can be diverted \\\\\n', params_ss.lambda);
fprintf('$\\omega$ & %1.3f & Proportional transfer to the entering bankers \\\\\n', params_ss.omega);
fprintf('$\\theta$ & %1.3f & Survival rate of the bankers \\\\\n',params_ss.theta);

fprintf('\\multicolumn{3}{c}{Intermediate good firms}\\\\ \\hline \n');
fprintf('$\\alpha$ & %1.3f & Capital share \\\\\n', params_ss.alfa);
fprintf('$\\delta$ & %1.3f & Depreciation rate \\\\ \\hline \n', vars_ss.delta);

fprintf('\\multicolumn{3}{c}{Capital Producing Firms} \\\\ \\hline \n');
fprintf('$\\eta_i$ & %1.3f & Inverse elasticity of net investment to the price of capital\\\\ \\hline \n', params_ss.eta_i);

fprintf('\\multicolumn{3}{c}{Retail Firms} \\\\ \\hline \n');
fprintf('$\\epsilon$ & %1.3f & Elasticity of substitution \\\\\n', params_ss.epsilon);
fprintf('$\\gamma$ & %1.3f & Probability of keeping the price constant\\\\ \\hline \n', params_ss.gam);
fprintf('$\\gamma_P$ & %1.3f & Price indexation parameter\\\\ \\hline \n', params_ss.gam_P);

fprintf('\\multicolumn{3}{c}{Government} \\\\ \\hline \n');
fprintf('$\\frac{G}{Y}$ & %1.3f & Steady state proportion of government expenditures \\\\\n', 0.2);
fprintf('$\\rho_i$ & %1.3f & Interest rate smoothing parameter \\\\\n', params_ss.rho_i);
fprintf('$\\kappa_\\pi$ & %1.3f & Inflation coefficient in the Taylor rule \\\\\n', params_ss.kappa_pi);
fprintf('$\\kappa_X$ & %1.3f & Markup coefficient in the Taylor rule \\\\\n', params_ss.kappa_y);
%fprintf('$\\xi$ & %1.4f & Interest penalty for government credit \\\\\n', params_ss.ksi);
%fprintf('$\\tau$ & %1.4f & Proportional efficiency loss of government credit \\\\ \n', params_ss.tau);
%fprintf('$\\iota$ & %1.4f & Steady state interest subsidy for intermediate credit \\\\ \n', params_ss.iota);
fprintf('\\hline\\hline\n');
fprintf('\\end{tabular}\n');
%fprintf('\\end{table}\n');
