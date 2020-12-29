function [disp, sCostCube] = SGM(left_raw, right_raw, lateral_paths_num, Dmax)
%input:
%   left: left image(gray)
%   right: right image(gray)
%   lateral_paths_num: lateral cost aggregation paths number
%   Dmax: disparity range of the dataset
%return:
%   disp: disparity image(without postprocessing)
%   sCostCube: aggregated cost cube

[H,W] = size(left_raw);
window_size = 9;
quadratic_interpolation = false;

w = (window_size-1)/2;%padding width
%%padding
left = zeros(H+2*w,W+2*w);
right = zeros(H+2*w,W+2*w);
left(w+1:H+w,w+1:W+w) = left_raw;
right(w+1:H+w,w+1:W+w) = right_raw;

%%raw cost computation
rawCostCube = Inf(H,W,Dmax+1);%the third index denotes disparity-1(1 means disparity is 0)
cube = zeros(W,window_size*window_size);
for i = 1:H   
    for k = 1:W
        cube(k,:) = reshape((right(i:i+window_size-1, k:k+window_size-1)>right(i+w,k+w)),[1,window_size*window_size]);
    end
    for j = 1:W
        if j-1 <= Dmax
            top = j-1;
        else
            top = Dmax;
        end
        center = left(i+w,j+w);
        c1 = reshape(left(i:i+window_size-1, j:j+window_size-1)>center,[1,window_size*window_size]);
        for d = 0:top          
            c2 = cube(j-d,:);
            rawCostCube(i,j,d+1) = sum(sum(xor(c1,c2)));
        end
%         center1 = left(i+w,j+w);
%         for d = 0:top
%             center2 = right(i+w,j+w-d);
%             patch1 = left(i:i+window_size-1, j:j+window_size-1);
%             patch2 = right(i:i+window_size-1, j-d:j-d+window_size-1);                
%             rawCostCube(i,j,d+1) = sum(sum(xor(patch1>center1,patch2>center2)));
%         end
    end
end

%%cost aggregation
L1 = SGM_left2right_aggregation(rawCostCube);
L2 = SGM_right2left_aggregation(rawCostCube);
L3 = SGM_top2bottom_aggregation(rawCostCube);
L4 = flipud(SGM_top2bottom_aggregation(flipud(rawCostCube)));
if lateral_paths_num == 4 
    sCostCube = L1 + L2 + L3 + L4;
elseif lateral_paths_num == 8
    L5 = SGM_diagonal_1_aggregation(rawCostCube);%left top to right bottom
    L6 = SGM_diagonal_2_aggregation(rawCostCube);%right top to left bottom
    L7 = flipud(SGM_diagonal_1_aggregation(flipud(rawCostCube)));%left bottom to right top        
    L8 = flipud(SGM_diagonal_2_aggregation(flipud(rawCostCube)));%right bottom to left top
    sCostCube = L1 + L2 + L3 + L4 + L5 + L6 + L7 + L8;
end

%%disparity computation
disp = SGM_disp_select(sCostCube, quadratic_interpolation);

end

    





