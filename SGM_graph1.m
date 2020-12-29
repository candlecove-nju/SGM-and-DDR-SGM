% x = 3:2:11;
% y1 = [17.29,18.31,20.34,21.41,27.39];
% y2 = [58.81,60.22,60.62,62.23,67.39];
% plot(x,y1,'-b',x,y2,'-r','LineWidth',2);
% xlabel('window size');
% ylabel('time/s');
% title('BT和Census计算时间比较');
% legend('Census-time','BT-time');
clear;
frame_num = 41;
f = 1:frame_num;
r = zeros(frame_num,6);
Dmax = 63;
H = 300;
W = 400;
R = 10;%dynamic disparity range
TH = 30;%threshold of S(p,d)
w = 1.5;%coefficient of Lt
L = 4;
T = false;

file_path = 'E:\CV2020\book';
LtCube_left_pre = zeros(H, W, Dmax+1);%Lt(p,d) of previous frame
D = zeros(frame_num,H,W);

for frame = 1:frame_num
    frame
    if frame<10
        left_path = sprintf('\\L000%d.png',frame);
        right_path = sprintf('\\R000%d.png',frame);
        gt_path = sprintf('\\TL000%d.png',frame);
    else
        left_path = sprintf('\\L00%d.png',frame);
        right_path = sprintf('\\R00%d.png',frame);
        gt_path = sprintf('\\TL00%d.png',frame);
    end
    left = rgb2gray(imread(strcat(file_path, left_path)));
    right = rgb2gray(imread(strcat(file_path, right_path)));
    Db_true = rgb2gray(imread(strcat(file_path, gt_path)))/4;
    if frame == 1        
        t = clock;
        [Db_pre, LtCube_left_pre] = SGM(left, right, L, Dmax);
        [Dm_pre, LtCube_right_pre] = SGM(fliplr(right), fliplr(left), L, Dmax);               
        Db_pre = SGM_postprocessing(Db_pre,fliplr(Dm_pre));
        r(frame,3) = etime(clock,t);
        r(frame,6) = r(frame,3);
        [~,r(frame,1),r(frame,2),~] = SGM_eval(Db_pre, Db_true);
        r(frame,4:5) = r(frame,1:2)
        D(frame,:,:) = Db_pre;    
        continue;
    end
    %SGM
    t = clock;
    [Db, ~] = SGM(left, right, L, Dmax);
    [Dm, ~] = SGM(fliplr(right), fliplr(left), L, Dmax);
    Db = SGM_postprocessing(Db,fliplr(Dm));
    r(frame,6) = etime(clock,t);
    [~,r(frame,4),r(frame,5)] = SGM_eval(Db, Db_true)
    %DDR-SGM
    t = clock;
    [Db, LtCube_left] = DDR_SGM(left, right, Db_pre, L, T, R, TH, w, LtCube_left_pre);
    [Dm, LtCube_right] = DDR_SGM(fliplr(right), fliplr(left), Db_pre, L, T, R, TH, w, fliplr(LtCube_right_pre));
    Db = SGM_postprocessing(Db,fliplr(Dm)); 
    r(frame,3) = etime(clock,t);
    [~,r(frame,1),r(frame,2),~] = SGM_eval(Db, Db_true)
    D(frame,:,:) = Db;
    Db_pre = Db;%disparity for previous frame
    LtCube_left_pre = LtCube_left;
    LtCube_right_pre = LtCube_right;    
end



% DDR_SGM_b4 = [0.89,1.34,1.35,1.49,1.27,1.51,1.51,1.64,1.62,1.92,2.15,2.16,2.30,2.81,3.36,3.30,3.76,4.10,3.85,4.05...
% ,4.17,4.65,3.71,3.29,4.57,4.88,3.78,2.86,1.75,1.40,1.38,1.18,1.40,1.38,1.3,1.15,1.21,1.21,1.10,0.96,1.08];
% SGM_b4 = [0.89,0.91,0.94,1.00,0.97,1.02,1.05,1.25,1.23,1.56,1.94,2.19,2.27,2.30,2.38,2.49,2.47,2.58,2.51,2.53...
% ,2.48,2.74,2.19,1.69,1.74,1.75,1.63,1.55,1.32,1.20,1.12,1.11,1.11,1.08,1.03,0.99,0.96,0.92,0.85,0.83,0.82];
% DDR_SGM_b2 = [3.40,3.73,4.11,3.71,3.80,3.80,4.01,3.89,4.43,4.56,4.89,4.88,5.09,6.07,6.14,6.52,6.81,6.72,6.64,6.75,...
% 6.94,7.12,6.62,5.92,7.30,7.51,6.69,5.62,4.45,4.07,4.11,3.95,4.14,3.77,3.97,3.65,3.80,3.52,3.80,3.58,3.79];
% SGM_b2 = [3.40,3.40,3.41,3.43,3.39,3.44,3.51,3.76,3.95,4.35,4.54,4.70,4.75,4.73,4.85,4.93,4.91,5.03,4.95,5.05,5.07,...
% 5.34,4.90,4.32,4.13,4.11,4.00,3.91,3.70,3.58,3.56,3.53,3.52,3.51,3.45,3.38,3.33,3.33,3.32,3.31,3.31];
plot(f,r(:,2)','-r',f,r(:,5)','-b',f,r(:,1)','-c',f,r(:,4)','-g','LineWidth',2);
xlabel('Frame index');
ylabel('Error rate/%');
xlim([1,42]);
legend('DDR-SGM b-4','SGM b-4','DDR-SGM b-2','SGM b-2');


figure;
% DDR_SGM_time = [330,159,156,157,160,159,160,160,160,166,171,172,170,172,180,177,173,179,177,171,172,170,172,165,...
% 169,168,168,163,162,160,160,160,159,161,160,161,161,161,162,160,157];
% SGM_time = [319,319,319,373,419,415,413,374,355,387,349,379,337,329,330,326,331,352,385,353,339,337,338,347,351,...
% 348,343,363,359,350,382,350,346,356,346,339,355,342,330,340,338];
plot(f,r(:,3)','-r',f,r(:,6)','-b','LineWidth',2);
xlabel('Frame index');
ylabel('Computational time/s');
xlim([1,42]);
ylim([0,500]);
legend('DDR-SGM time ','SGM time ');




