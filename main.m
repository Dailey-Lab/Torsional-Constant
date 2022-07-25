clc
clear all

%% specific the image file folders
path1={'P00441_MSRU_86_07_RT',...
    'P00441_MSRU_86_13_TR',...
};

%% image segementation
for i=1:length(path1) 
    [M,center]=imsegmentation(path1{i});
    filename= strcat(path1{i},'.mat');
    save(filename,'M','center', '-v7.3')
end


%% define some varialbes
j_eff=[];
t=1;

%% get j_eff at density cutoffs i
for i= 675
  j_eff(:,t) = get_jeff(i);   
  t=t+1;
end

%% save the results file
save('jeff.mat','j_eff')
