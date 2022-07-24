clc
clear all

%% define some varialbes
j_eff=[];
t=1;

%% density cutoffs
for i= 675
  
  j_eff(:,t) = get_jeff(i);   
  t=t+1;

end

save('jeff.mat','j_eff')
