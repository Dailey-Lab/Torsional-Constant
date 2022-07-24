function [f] =j_eff(rho_uct)

% load('vtr.mat');

currentFolder = pwd;
loc =  strcat(currentFolder,'\intact'); 
cd (loc)

Files=dir('*.mat*');
for k=1:length(Files)
   path1{k}=Files(k).name;
end

tor_const=zeros(length(path1),1);
for ijk=1:length(path1)
load(path1{ijk});
test=length(M(:,:,1));
x = 1:test;
y = 1:test;
[X,Y] = meshgrid(x,y);

J=ones(size(M,3),2);
J(:,1) = [1:size(M,3)]';
%%
for i=1:size(M,3)
logical= double(M(:,:,i));
% logical(logical < rho_uct) = 0;
% logical=  logical./3500;
logical(logical < rho_uct) = 0;
cen=center(i,:);
Dis_matrix  =  (     ((X-cen(:,2))*0.06e-3).^2  +  ((Y-cen(:,1))*0.06e-3).^2   )  .*(0.06e-3).^2;

J(i,2)=sum(double(logical).*Dis_matrix,'all');

end
%%

 J(:,1)=0.06e-3*J(:,1);
 J(:,2)=1./J(:,2);
 tor_const(ijk)=(0.06e-3 * length(J(:,1))) / trapz(J(:,1),J(:,2));


end

% mdl = fitlm(tor_const,bradan);
% f = mdl.Rsquared.Ordinary;
f=tor_const;
cd(currentFolder);
end
