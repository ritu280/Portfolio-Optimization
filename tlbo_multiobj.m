function [bestsol,bestfitness,BestFitIter,P,f,pareto_front] = tlbo_multiobj(prob,lb,ub,Np,T,C,avg_return_mean)

%% Starting of TLBO
f = NaN(Np,2);                      % Matrix to store the fitness function values of the population members
BestFitIter = NaN(T,1);           % Vector to store the best fitness function value in every iteration

D = length(lb);                     % Determining the number of decision variables in the problem

P = repmat(lb,Np,1) + repmat((ub-lb),Np,1).*rand(Np,D);  % Generation of the initial population
P = P./sum(P,2);

for p = 1:Np
    f(p,:) = prob(P(p,:),C,avg_return_mean);            % Evaluating the fitness function of the initial population
end

BestFitIter(1) = min(f(:,1));

%% Iteration loop
for t = 1: T
    for i = 1:Np
        %% Teacher Phase
        Xmean = mean(P);            % Determining mean of the population
        
        [~,ind] = min(f(:,1));           % Detemining the location of the teacher
        Xbest = P(ind,:);           % Copying the solution acting as teacher
        
        TF = randi([1 2],1,1);      % Generating either 1 or 2 randomly for teaching factor
        
        Xnew = P(i,:) + rand(1,D).*(Xbest - TF*Xmean);  % Generating the new solution
        
        Xnew = min(ub, Xnew);       % Bounding the violating variables to their upper bound
        Xnew = max(lb, Xnew);       % Bounding the violating variables to their lower bound
        
        Xnew = Xnew./sum(Xnew,2);
        
        fnew = prob(Xnew,C,avg_return_mean);          % Evaluating the fitness of the newly generated solution
        
        %% Non-dominated sorting
         non_dom_index = non_dominated_fronts(P,f);
         non_dom_index = cell2mat(non_dom_index); % convert cell array to numeric array
         non_dom_set = P(non_dom_index,:);
         non_dom_fitness = f(non_dom_index,:);
        
        %% Greedy selection from non-dominated solutions
        if any(all(fnew <= non_dom_fitness, 2))
            P(i,:) = Xnew;
            f(i,:) = fnew;
        else
            j = randi(size(non_dom_set,1),1,1);
            P(i,:) = non_dom_set(j,:);
            f(i,:) = non_dom_fitness(j,:);
        end
        
        %% Learner Phase
        
        p = randi([1 Np],1,1);      % Selection of random parter
        
        %% Ensuring that the current member is not the partner
        while i == p
            p = randi([1 Np],1,1);  % Selection of random parter
        end
        
        if f(i,1)< f(p,1)    % Select the appropriate equation to be used in Learner phase
            Xnew = P(i,:) + rand(1, D).*(P(i,:) - P(p,:));  % Generating the new solution
        else
            Xnew = P(i,:) - rand(1, D).*(P(i,:) - P(p,:));  % Generating the new solution
        end
        
        Xnew = min(ub, Xnew);       % Bounding the violating variables to their upper bound
        Xnew = max(lb, Xnew);       % Bounding the violating variables to their lower bound
        
        Xnew = Xnew./sum(Xnew,2);
    
        fnew = prob(Xnew,C,avg_return_mean);          % Evaluating the fitness of the newly generated solution
    
    %% Non-dominated sorting
       non_dom_index = non_dominated_fronts(P,f);
       non_dom_index = cell2mat(non_dom_index);
       non_dom_set = P(non_dom_index,:);
       non_dom_fitness = f(non_dom_index,:);
    
    %% Greedy selection from non-dominated solutions
       if any(all(fnew <= non_dom_fitness, 2))
           P(i,:) = Xnew;
           f(i,:) = fnew;
       else
           j = randi(size(non_dom_set,1),1,1);
           P(i,:) = non_dom_set(j,:);
           f(i,:) = non_dom_fitness(j,:);
       end
   end

%% Storing the best fitness in every iteration
   BestFitIter(t) = min(f(:,1));
   

%% Plot the Pareto front

pareto_front = P(cell2mat(non_dominated_fronts(P,f)), :);
pareto_fitvals = f(cell2mat(non_dominated_fronts(P,f)), :);
hold on
scatter(pareto_fitvals(:, 1), pareto_fitvals(:, 2));
xlabel('Risk');
ylabel('Return');
title('Pareto Front');
hold off
end      

%% Extracting the best solution from the final Pareto front
non_dom_index = non_dominated_fronts(f);
non_dom_index = cell2mat(non_dom_index);
non_dom_set = P(non_dom_index,:);
non_dom_fitness = f(non_dom_index,:);

[~,idx] = min(non_dom_fitness(:,2)); % Choosing the solution with the minimum value of the second objective function
bestsol = non_dom_set(idx,:);
bestfitness = non_dom_fitness(idx,:);

end