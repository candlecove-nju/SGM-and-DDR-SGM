function [disp] = SGM_disp_select(costCube, quadratic_interpolation)
%select the best disparity for each pixel
cube_size = size(costCube);
H = cube_size(1);
W = cube_size(2);
Dmax = cube_size(3)-1;
disp = zeros(H,W);

for i = 1:H
    for j = 1:W      
        slice = costCube(i,j,:);
        index = find(slice==min(slice));       
        if quadratic_interpolation == false
            disp(i,j) = index(1)-1;
        else
            for k = 1:length(index)
                d = index(k);
                if  (d==1)||(d==Dmax+1)              
                    disp(i,j) = d-1;
                    break;
                else
                    if (slice(d)==Inf)||(slice(d+1)==Inf)
                        disp(i,j) = d-1;
                    else
                        c0 = slice(d);
                        c1 = slice(d-1);
                        c2 = slice(d+1);
                        disp(i,j) = round(d + (c1-c2)/2/(c1+c2-2*c0))-1;
                    end
                end
            end
        end
    end
end

end

