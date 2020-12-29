% %clear;
% L = 4;
% T = false;
% w = 1.5;
% Dmax = 63;
% index = 8;
% 
% file_path = 'E:\CV2020\book';
% % left_path = sprintf('\\L000%d.png',index);
% % right_path = sprintf('\\R000%d.png',index);
% % left = rgb2gray(imread(strcat(file_path, left_path)));
% % right = rgb2gray(imread(strcat(file_path, right_path)));
% % 
% % [Db_pre, LtCube_left_pre] = SGM(left, right, L, Dmax);
% % %[Dm_pre, LtCube_right_pre] = SGM(fliplr(right), fliplr(left), L, Dmax);
% % %Db_pre = SGM_postprocessing(Db_pre,fliplr(Dm_pre));
% 
% 
% left_path = sprintf('\\L000%d.png',index+1);
% right_path = sprintf('\\R000%d.png',index+1);
% gt_path = sprintf('\\TL000%d.png',index+1);
% left = rgb2gray(imread(strcat(file_path, left_path)));
% right = rgb2gray(imread(strcat(file_path, right_path)));
% Db_true = rgb2gray(imread(strcat(file_path, gt_path)))/4;
% 
% R_TH = zeros(12,10);
% for TH = 60:-10:20
%     for R = 2:2:24
%         TH,R
%         t = clock;
%         [Db, ~] = DDR_SGM(left, right, Db_pre, L, T, R, TH, w, LtCube_left_pre);
%         %[Dm, ~] = DDR_SGM(fliplr(right), fliplr(left), Db_pre, L, T, R, TH, w, fliplr(LtCube_right_pre));
%         %Db = SGM_postprocessing(Db,fliplr(Dm));
%         R_TH(R/2,2*TH/10-2) = etime(clock,t);
%         [~,~,R_TH(R/2,2*TH/10-3),~] = SGM_eval(Db, Db_true)
%     end
% end

R = 2:2:24;
plot(R,R_TH(:,2)','-b',R,R_TH(:,4)','-g',R,R_TH(:,6)','-c',R,R_TH(:,8)','-r',R,R_TH(:,10)','-m','LineWidth',2);
xlabel('Dynamic disparity range (R)');
ylabel('Computational time/s');
legend('TH = 20','TH = 30','TH = 40','TH = 50','TH = 60');
%ylim([70,200]);

figure
plot(R,R_TH(:,1)','-b',R,R_TH(:,3)','-g',R,R_TH(:,5)','-c',R,R_TH(:,7)','-r',R,R_TH(:,9)','-m','LineWidth',2); 
xlabel('Dynamic disparity range (R)');
ylabel('Bad-4 error rate/%');
legend('TH = 20','TH = 30','TH = 40','TH = 50','TH = 60');
%ylim([0.2,1.5]);

