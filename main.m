clc
clear all

%% define some varialbes
j_eff=[];
t=1;

%% density cutoffs i
for i= 675
  j_eff(:,t) = get_jeff(i);   
  t=t+1;
end

%% save the results file
save('jeff.mat','j_eff')
