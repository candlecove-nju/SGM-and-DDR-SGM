function [L] = SGM_top2bottom_aggregation(rawCostCube)
%cost aggregation from top to bottom, return cost increment L for each pixel
H = size(rawCostCube,1);
W = size(rawCostCube,2);
Dmax = size(rawCostCube,3)-1;

L = Inf(H,W,Dmax+1);
L(1,:,:) = rawCostCube(1,:,:);

for i = 2:H
    for j = 1:W
        priorCost = L(i-1,j,:);
        priorCostMin = min(priorCost);
        for d = 1:Dmax+1            
            if rawCostCube(i,j,d)==Inf               
                continue;%L(i,j,d)=Inf
            end                                  
            L(i,j,d) = rawCostCube(i,j,d)+SGM_L_eval(priorCost,d,priorCostMin)-priorCostMin;
        end
    end
end


end

