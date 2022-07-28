%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This function calculate the effective torsional constant
%
%    [tor_const] =j_eff(rho_uct) returns the effective torsional constant with the 
%    of the density cutpff
%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tor_const] =j_eff(rho_uct)

currentFolder = pwd;
loc =  strcat(currentFolder,'\image'); 
cd (loc)

%% read all the image data for all the images
Files=dir('*.mat*');
for k=1:length(Files)
   path1{k}=Files(k).name;
end

%% define some variables
tor_const=zeros(length(path1),1);
for ijk=1:length(path1)
	load(path1{ijk});
	test=length(M(:,:,1));
	x = 1:test;
	y = 1:test;
	[X,Y] = meshgrid(x,y);
	J=ones(size(M,3),2);
	J(:,1) = [1:size(M,3)]';
	
%% calculate j_eff
	for i=1:size(M,3)
   	logical= double(M(:,:,i));
   	logical(logical < rho_uct) = 0;
   	cen=center(i,:);
   	Dis_matrix  =  (((X-cen(:,2))*0.06e-3).^2  +  ((Y-cen(:,1))*0.06e-3).^2   )  .*(0.06e-3).^2;
   	J(i,2)=sum(double(logical).*Dis_matrix,'all');
	end

	J(:,1)=0.06e-3*J(:,1);
	J(:,2)=1./J(:,2);
	tor_const(ijk)=(0.06e-3 * length(J(:,1))) / trapz(J(:,1),J(:,2));

end

cd(currentFolder);
end
