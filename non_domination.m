function  rank_distance = non_domination( fitness, M)

x=fitness;
[N, ~] = size(x);
clear m
  
individual = []; rank_distance=[];

for i = 1 : N
    individual(i).n = 0;        % Number of individuals that dominate this individual
    individual(i).p = [];       % Individuals which this individual dominate
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M
            if (x(i,k) < x(j,k))
                dom_less = dom_less + 1;
            elseif (x(i, k) == x(j,k))
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M
            individual(i).n = individual(i).n + 1;
        elseif dom_more == 0 && dom_equal ~= M
            individual(i).p = [individual(i).p j];%this method that make j become a element in individual(i).p.
        end
    end
    if individual(i).n == 0
        rank_distance=[rank_distance i];
    end
end
end