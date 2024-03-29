%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This function segment the raw DICOM file
%
%    [M,center] = im_segmentation(path1) returns the segmented images and the centriod of the 
%    segmented images with the input of the directory of the image file  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [M,center] = im_segmentation(path1)

%% define file directory%
currentFolder = pwd
projectdir = strcat(currentFolder,'/',path1)
cd (projectdir)
files = dir('*.DCM');
test = dicomread(files(1).name);
M=[];
number=2000; % define the number of images
center=zeros(number,2);
M=uint16(zeros(length(test),length(test),number));

%% image segmentation
parfor ijk=1:number%length(files)    
filename=files(ijk+300).name
info = dicominfo(filename);
ori = dicomread(info);
max_density=max(max(ori));
Y = dicomread(info);
Y = imgaussfilt(Y,3);
ind= Y<3000;
Y(ind)=0;
BW = Y > 100;
[y, x] = ndgrid(1:size(BW, 1), 1:size(BW, 2));
cen = mean([x(logical(BW)), y(logical(BW))]);
BW = bwconvhull(BW);
dim = size(BW);
col = round(cen(1));%round(dim(2)/2);
if isempty(min(find(BW(:,col))))==1
row = round(cen(1));
col = min(find(BW(row,:)));
boundary = bwtraceboundary(BW,[row, col],'N');
else 
row = min(find(BW(:,col)));
boundary = bwtraceboundary(BW,[row, col],'N');    
end

%% add a mask
BWmask = poly2mask(boundary(:,2),boundary(:,1),  length(test),length(test) );
boundary_out=boundary;
center_diacom=mean(boundary);
center(ijk,:)=center_diacom;
HU  = 0.5150646 *ori-1000;
den = 0.3801    *HU	-7.3744;
den=den.*int16(BWmask);
M(:,:,ijk) = den;
end

% M = uint16(M);
%% go back to main file folder
cd (currentFolder)
end



