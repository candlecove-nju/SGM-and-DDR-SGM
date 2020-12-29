function [cost] = SGM_cost_calculate(left, right, i, j, d, w)
%compute raw cost using method 'Census', with window size 2*w+1
%input:
%   left:left image(padded)
%   right:right image(padded)
%   i:Y axis coordinate
%   j:X axis coordinate
%   w:(window_size-1)/2
%return:
%   cost:Census cost for (i,j,d)
window_size = 2*w+1;
patch1 = left(i:i+window_size-1, j:j+window_size-1)-left(i+w,j+w);
patch2 = right(i:i+window_size-1, j-d:j-d+window_size-1)-right(i+w,j+w-d);                
cost = sum(sum(xor(patch1>0,patch2>0)));

end