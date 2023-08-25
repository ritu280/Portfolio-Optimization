function Fronts = non_dominated_fronts(P,fitvals)
% NON_DOM_FRONTS Returns the non-dominated fronts of a population
%
%   Fronts = NON_DOM_FRONTS(P,fitvals) returns a cell array of fronts, where each front
%   is an array of indices of the solutions in that front.
%
%   Inputs:
%       P: the population
%       fitvals: the fitness values of the population
%
%   Outputs:
%       Fronts: a cell array of fronts, where each front is an array of indices of the
%       solutions in that front.

    n = size(P,1);
    dominated = false(n,1);
    dominates = false(n);
    fronts = cell(n,1);
    n_fronts = 0;

    for i = 1:n
        for j = i+1:n
            better = dominates(i,j) || all(P(i,:) == P(j,:));
            worse = dominates(j,i) || all(P(i,:) == P(j,:));
            if ~better && ~worse
                if fitvals(i,:) < fitvals(j,:)
                    dominates(i,j) = true;
                    dominated(j) = true;
                elseif fitvals(j,:) < fitvals(i,:)
                    dominates(j,i) = true;
                    dominated(i) = true;
                end
            end
        end
    end

    while true
        f = find(~dominated);
        if isempty(f)
            break;
        end
        n_fronts = n_fronts + 1;
        fronts{n_fronts} = f;
        for i = f
            dominated(i) = true;
        end
        for i = f
            for j = find(dominates(:,i))
                dominates(j,i) = false;
            end
        end
    end

    Fronts = fronts(1:n_fronts);
end
