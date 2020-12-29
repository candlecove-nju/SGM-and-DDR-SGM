function [Db_final] = SGM_postprocessing(Db, Dm)
%input:
%   Db: disparity image using base image as left image
%   Dm: disparity image using match image as left image
%return:
%   Db_final: final disparity image after postprocessing

%factor = 4;
[H,W] = size(Db);
%true occlusion and Db
% occlusion_true = double(imread('E:\cones\occl.png'));
% Db_true = double(imread('E:\cones\disp2.png')/factor);

%%LR check
invalid_map = ones(H,W);%0(black) denotes invalid pixel(mismatched or occluded)
occlusion_map = ones(H,W);
mismatched_map = ones(H,W);
for i = 1:H
    for j = 1:W     
        Dbp = Db(i,j);                     
        Dmq = Dm(i,j-Dbp);
        if abs(Dbp-Dmq)>1
             invalid_map(i,j)=0;
             if Db(i,j-Dbp+Dmq)>Dbp
                 occlusion_map(i,j)=0;
             else
                 mismatched_map(i,j)=0;
             end
        end        
    end
end
%imshow(invalid_map);
Db_rec = Db.*invalid_map;
% imshow(uint8(factor*Db_rec));
% [bad1, bad2, bad4, rmse] = SGM_eval(Db_rec, Db_true.*occlusion_true); %evaluate

%%invalid(mismatched and occluded) region filling
Db_fill = Db_rec;
for i = 1:H
    for j = 1:W
        if Db_rec(i,j)==0
            if occlusion_map(i,j)==0
                Db_fill(i,j) = round(SGM_filling_search(i,j,Db_fill,'occluded'));
            else                
                Db_fill(i,j) = round(SGM_filling_search(i,j,Db_fill,'mismatched'));
            end        
        end
    end
end

%imshow(uint8(factor*Db_fill));
%[bad1, bad2, bad4, rmse] = SGM_eval(Db_fill, Db_true); %evaluate

%%median filtering
Db_final = round(medfilt2(Db_fill,[5 5],'symmetric'));
% imshow(uint8(factor*Db_final));
% [bad1, bad2, bad4, rmse] = SGM_eval(Db_final, Db_true); %evaluate

%[bad1, bad2, bad4, rmse] = SGM_eval(Db_final.*occlusion_map, Db_true.*occlusion_true)

end

