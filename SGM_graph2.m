frame_num = 41;
f = 1:frame_num;
% eval = zeros(frame_num,4);
% L4 = Sequence_DDR_SGM(4,false);
% eval(:,1) = L4(:,2)
% L4_T = Sequence_DDR_SGM(4,true);
% eval(:,2) = L4_T(:,2)
% L8 = Sequence_DDR_SGM(8,false);
% eval(:,3) = L8(:,2)
L8_T = Sequence_DDR_SGM(8,true);
eval(:,4) = L8_T(:,2)
plot(f,L4(:,2)','-r',f,L4_T(:,2)','-b',f,L8(:,2)','-g',f,L8_T(:,2)','-c','LineWidth',2);
xlabel('Frame index');
xlim([1,42]);
ylabel('b-4 error Rate/%');
%ylim([9.81,12.10])
legend('4L','4L + T','8L','8L + T');