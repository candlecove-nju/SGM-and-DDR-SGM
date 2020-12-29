function [Db, LtCube] = DDR_SGM(left_raw, right_raw, D_pre, L_num, T, R, TH, w, LtCube_pre)
%input:
%   left:left image
%   right:right image
%   D_pre:disparty image of previous frame
%   L_num:number of lateral paths
%   T:use temporal path or not
%   R:dynamic disparity range
%   TH:threshold of S(p,d), if min(S)>TH, extend to full disparity range
%   w:coefficient of Lt
%   sCostCube_pre:S(p,d) of previous frame
%return:
%   Db:disparity image
%   LtCube:Lt cost
D_pre = double(D_pre);
r = R/2;
[H,W] = size(left_raw);
Dmax = size(LtCube_pre,3)-1;
window_size = 11;
rawCostCube = Inf(H,W,Dmax+1);
ddr = zeros(H,W,2);%store min_r and max_r
width = (window_size-1)/2;%padding width

%%padding
left = zeros(H+2*width,W+2*width);
right = zeros(H+2*width,W+2*width);
left(width+1:H+width,width+1:W+width) = left_raw;
right(width+1:H+width,width+1:W+width) = right_raw;

%%compute raw cost
for i = 1:H
    for j = 1:W
        if j-1 <= Dmax
            top = j-1;
        else
            top = Dmax;
        end       
        min_r = max(0, D_pre(i,j)-r);
        max_r = min(top, D_pre(i,j)+r);
        if min_r > max_r
            min_r = 0;
            max_r = top;
        end
        ddr(i,j,1) = min_r+1;
        ddr(i,j,2) = max_r+1;
        center1 = left(i+width,j+width);
        patch1 = left(i:i+window_size-1, j:j+window_size-1);
        for d = min_r:max_r           
            center2 = right(i+width,j+width-d);        
            patch2 = right(i:i+window_size-1, j-d:j-d+window_size-1);
            rawCostCube(i,j,d+1) = sum(sum(xor(patch1>center1,patch2>center2)));
        end       
    end
end

%%lateral path aggregation
L1 = DDR_SGM_left2right_aggregation(rawCostCube, ddr, left, right, TH);
L2 = DDR_SGM_right2left_aggregation(rawCostCube, ddr, left, right, TH);
L3 = DDR_SGM_top2bottom_aggregation(rawCostCube, ddr, left, right, TH);
L4 = flipud(DDR_SGM_top2bottom_aggregation(flipud(rawCostCube), flipud(ddr), flipud(left), flipud(right), TH));
%L4 = DDR_SGM_bottom2top_aggregation(rawCostCube, ddr, left, right, TH);
if L_num == 4 
    sCostCube = L1 + L2 + L3 + L4;
elseif L_num == 8   
    L5 = DDR_SGM_diagonal_1_aggregation(rawCostCube, ddr, left, right, TH);%left top to right bottom
    L6 = DDR_SGM_diagonal_2_aggregation(rawCostCube, ddr, left, right, TH);%right top to left bottom
    L7 = flipud(DDR_SGM_diagonal_1_aggregation(flipud(rawCostCube), flipud(ddr), flipud(left), flipud(right), TH));%left bottom to right top        
    L8 = flipud(DDR_SGM_diagonal_2_aggregation(flipud(rawCostCube), flipud(ddr), flipud(left), flipud(right), TH));%right bottom to left top    
    sCostCube = L1 + L2 + L3 + L4 + L5 + L6 + L7 + L8;
end

%%temporal path aggregation
LtCube = Inf(H,W,Dmax+1);
if T==true 
    for i = 1:H
        for j = 1:W
            patch1 = left(i:i+window_size-1, j:j+window_size-1)-left(i+width,j+width);
            priorCost = LtCube_pre(i,j,:);
            priorCostMin = min(priorCost);
            for d = 1:Dmax+1
                if sCostCube(i,j,d)==Inf
                    continue;
                end
                if rawCostCube(i,j,d) == Inf
                    patch2 = right(i:i+window_size-1, j-d+1:j-d+window_size)-right(i+width,j+width-d+1);                
                    rawCostCube(i,j,d) = sum(sum(xor(patch1>0,patch2>0)));
                end
                LtCube(i,j,d) = rawCostCube(i,j,d)+SGM_L_eval(priorCost,d,priorCostMin)-priorCostMin;
            end
        end
    end
    sCostCube = sCostCube + w*LtCube;
end

%Db = SGM_disp_select(sCostCube, false);
Db = SGM_disp_select(sCostCube, false);

end

