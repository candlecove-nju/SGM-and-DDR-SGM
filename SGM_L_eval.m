function [Lr_min] = SGM_L_eval(priorCost, d, priorCostMin)
Lr0 = priorCost(d);
priorCost(d) = Inf;
if d ~= 1
    Lr1 = priorCost(d-1)+10;
    %priorCost(d-1) = Inf;
else
    Lr1 = Inf;
end
if d ~= 64
    Lr2 = priorCost(d+1)+10;
    %priorCost(d+1) = Inf;
else
    Lr2 = Inf;
end           
Lr3 = priorCostMin + 100; 
%Lr3 = min(priorCost) + 100;

Lr_min = min([Lr0,Lr1,Lr2,Lr3]);




