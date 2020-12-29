function [value] = SGM_filling_search(m, n, Db, invalid_type)
%start from position(m,n), collect first valid disparity along 8
%different paths, return second lowest value
[H,W] = size(Db);
vec = zeros(8,1);
threshold = 1;
%to left
for j = n-1:-1:1
    if Db(m,j)>threshold
        vec(1) = Db(m,j);
        break;
    end
end
%to right
for j = n+1:W
    if Db(m,j)>threshold
        vec(2) = Db(m,j);
        break;
    end
end
%to bottom
for i = m+1:H
    if Db(i,n)>threshold
        vec(3) = Db(i,n);
        break;
    end
end
%to top
for i = m-1:-1:1
    if Db(i,n)>threshold
        vec(4) = Db(i,n);
        break;
    end
end
%to left top
falg = 0;
for i = m-1:-1:1
    for j = n-1:-1:1
        if Db(i,j)>threshold
            vec(5) = Db(i,j);
            flag = 1;
            break;
        end
    end
    if falg == 0
        break;
    end
end
%to right bottom
flag = 0;
for i = m+1:H
    for j = n+1:W
        if Db(i,j)>threshold
            vec(6) = Db(i,j);
            flag = 1;
            break;
        end
    end
    if flag == 1
        break;
    end
end
%to left bottom
flag = 0;
for i = m+1:H
    for j = n-1:-1:1
        if Db(i,j)>threshold
            vec(7) = Db(i,j);
            flag = 1;
            break;
        end
    end
    if flag == 1
        break;
    end
end
%to right top
flag = 0;
for i = m-1:-1:1
    for j = n+1:W
        if Db(i,j)>threshold
            vec(8) = Db(i,j);
            flag = 1;
            break;
        end
    end
    if flag == 1
        break;
    end
end

if strcmp(invalid_type, 'occluded')
    value = vec(2);
elseif strcmp(invalid_type, 'mismatched')
    value = median(vec);
    if value<=0   
        value = max(vec);
    end
end



