function [extend_map] = DDR_SGM_extend_detect(rawCostCube, ddr, extend_map, H, W, TH, opt)

Dmax = size(rawCostCube,3)-1;
L = Inf(H,W,Dmax+1);

if opt==1
    L(:,1,:) = rawCostCube(:,1,:);
    for i = 1:H
        for j = 2:W             
            priorCost = L(i,j-1,:);
            priorCostMin = min(priorCost);       
            min_r = ddr(i,j,1);
            max_r = ddr(i,j,2);
            for d = min_r:max_r                                                 
                L(i,j,d) = rawCostCube(i,j,d)+SGM_L_eval(priorCost,d,priorCostMin)-priorCostMin;
            end
            slice = L(i,j,:);         
            if min(slice)>TH %extend to full disparity range
                extend_map(i,j) = 1;
            end
        end
    end
end

if opt==2
    L(1,:,:) = rawCostCube(1,:,:);
    for i = 2:H
        for j = 1:W         
            priorCost = L(i-1,j,:);
            priorCostMin = min(priorCost);       
            min_r = ddr(i,j,1);
            max_r = ddr(i,j,2);
            for d = min_r:max_r                                                 
                L(i,j,d) = rawCostCube(i,j,d)+SGM_L_eval(priorCost,d,priorCostMin)-priorCostMin;
            end
            slice = L(i,j,:);         
            if min(slice)>TH%extend to full disparity range
                extend_map(i,j) = 1;
            end
        end
    end
end

if opt==3
    L(:,1,:) = rawCostCube(:,1,:);
    L(1,:,:) = rawCostCube(1,:,:);
    for i = 2:H
        for j = 2:W            
            priorCost = L(i-1,j-1,:);
            priorCostMin = min(priorCost);       
            min_r = ddr(i,j,1);
            max_r = ddr(i,j,2);
            for d = min_r:max_r                                                 
                L(i,j,d) = rawCostCube(i,j,d)+SGM_L_eval(priorCost,d,priorCostMin)-priorCostMin;
            end
            slice = L(i,j,:);         
            if min(slice)>TH%extend to full disparity range
                extend_map(i,j) = 1;
            end
        end
    end
end


end

