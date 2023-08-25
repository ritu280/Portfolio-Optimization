%% Reading the data 
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

return_mean = round(mean(pc_Stocks,"omitnan"),5)   %calculating mean of the expected returns

%% Problem settings
lb = zeros(1,q);      % Lower bound
ub = ones(1,q);       % Upper bound

prob = @functionfile; 
nvars= length(lb);
Aeq = ones(1,q);
beq = 1;
options = optimoptions('gamultiobj','PlotFcn',@gaplotpareto);
[x,fval,exitflag] = gamultiobj(@(x)functionfile(x,C,return_mean),nvars,[],[],Aeq,beq,lb,ub,options);
plot(fval(:,1),fval(:,2),'b*')
xlabel('Risk')
ylabel('Return')

[minrisk,idx] = min(fval(:,1));
[maxreturn,id] = max(fval(:,2));

%% Display results 
fprintf('Minimum Risk: %.4f\n', minrisk);
fprintf('Weights for minimum risk: %.4f %.4f %.4f %.4f\n', x(idx,:).*100);
fprintf('Maximum return: %.4f\n', maxreturn);
fprintf('Weights for maximum return: %.4f %.4f %.4f %.4f\n', x(id,:).*100);





