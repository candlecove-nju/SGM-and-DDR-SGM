function [bad1, bad2, bad4, rmse] = SGM_eval(disp, disp_true)
%bad1 means percentage of 'bad' pixels whose error is greater than 1
%rmse means root mean square erro
[m,n] = size(disp);
disp_true = double(disp_true);
bad1 = roundn(100*sum(sum(abs(disp-disp_true)>1))/m/n,-2);
bad2 = roundn(100*sum(sum(abs(disp-disp_true)>2))/m/n,-2);
bad4 = roundn(100*sum(sum(abs(disp-disp_true)>4))/m/n,-2);
rmse = sqrt(sum(sum((disp-disp_true).^2))/m/n);


