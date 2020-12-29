function [L] = DDR_SGM_left2right_aggregation(rawCostCube, ddr, left, right, TH)

H = size(ddr,1);
W = size(ddr,2);
Dmax = size(rawCostCube,3)-1;
width = (size(left,1)-H)/2;
window_size = 2*width+1;
L = Inf(H,W,Dmax+1);
L(:,1,:) = rawCostCube(:,1,:);

for i = 1:H
    for j = 2:W                                         
        min_r = ddr(i,j,1);
        max_r = ddr(i,j,2);     
        priorCost = L(i,j-1,:);
        priorCostMin = min(priorCost);
        for d = min_r:max_r                                                 
            L(i,j,d) = rawCostCube(i,j,d)+SGM_L_eval(priorCost,d,priorCostMin)-priorCostMin;
        end
        if min(L(i,j,:))>TH
            if j-1<Dmax
                top = j-1;
            else
                top = Dmax;
            end
            patch1 = left(i:i+window_size-1, j:j+window_size-1)-left(i+width,j+width);           
            for k = 1:top+1              
                if (k<min_r)||(k>max_r)                  
                    patch2 = right(i:i+window_size-1, j-k+1:j-k+window_size)-right(i+width,j+width-k+1);                
                    rawCostCube(i,j,k) = sum(sum(xor(patch1>0,patch2>0))); 
                    L(i,j,k) = rawCostCube(i,j,k)+SGM_L_eval(priorCost,k,priorCostMin)-priorCostMin;
                end
           end 
        end
    end
end

end

