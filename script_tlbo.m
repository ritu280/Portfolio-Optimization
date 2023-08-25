%% Reading the data 
clc;
clear;

AAPL = readmatrix('AAPL.csv', 'Range','F2:F252');
AMZN = readmatrix('AMZN.csv','Range','F2:F252');
MSFT = readmatrix('MSFT.csv','Range','F2:F252');
GOOG = readmatrix('GOOG.csv','Range','F2:F252');
[m,n] = size(AMZN);

stocks = [AAPL AMZN MSFT GOOG];
pc_Stocks = NaN(m,4);   

%% Expected returns
for i = 2:m
  for j = 1:4
      pc_Stocks(i,j) = (stocks(i,j) - stocks(i-1,j))/stocks(i,j);
  end
end
[p,q] = size(pc_Stocks);

C = cov(pc_Stocks,"omitrows").*252                 %252 is the number for trading days in a year

return_mean = round(mean(pc_Stocks,"omitnan"),5)

lb = zeros(1,q);       % Lower bound
ub = ones(1,q);           % Upper bound

prob = @functionfile; 
 
%% Algorithm parameters
Np = 5;                            % Population Size(Number of portfolios)
T = 100;                             % No. of iterations

[bestsol,bestfitness,BestFitIter,P,f,pareto_front] = tlbo_multiobj(prob,lb,ub,Np,T,C,return_mean)

[minrisk,idx] = min(f(:,1));
[maxreturn,id] = max(f(:,2));


%% Display results 
fprintf('Minimum Risk: %.4f\n', minrisk);
fprintf('Weights for minimum risk: %.4f %.4f %.4f %.4f\n', bestsol(idx,:).*100);
fprintf('Maximum return: %.4f\n', maxreturn);
fprintf('Weights for maximum return: %.4f %.4f %.4f %.4f\n', bestsol(id,:).*100);



