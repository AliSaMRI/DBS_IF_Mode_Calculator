clear all
close all
clc

%********USER INPUT********************
N = 16;         %Number of Tx channels
%**************************************

FolderName1 = uigetdir('./','Select the directory of dicom files containing Lead1 B1-maps'); 	%Directory of dicom files (Lead 1 B1-mapping directory)

pwd;
FolderName3 = pwd;	%Main directory of the Analysis

cd(FolderName1);
filePattern = fullfile('./', '*.dcm');
files = dir(filePattern);

%% Plane P1 (%Incident B1_lead1_Channels)
for ii = 1:N
	B1mag1(:,:,ii) = double(dicomread([files(ii).name]));
end

for ii = 1:N
	B1phase1(:,:,ii) = double(dicomread([files(2*N+ii).name]));
end
B1phase1 = (B1phase1)/4096*2*pi;

%% Plane P2 (%Total B1_lead1_Channels)
for ii = 1:N
	B1mag2(:,:,ii) = double(dicomread([files(N+ii).name]));
end

for ii = 1:N
	B1phase2(:,:,ii) = double(dicomread([files(3*N+ii).name]));
end
B1phase2 = (B1phase2)/4096*2*pi;

%% Plot & Save

B1cmplx1 = B1mag1 .* exp(1j .* B1phase1 );      %Incident B1_lead1
B1cmplx2 = B1mag2 .* exp(1j .* B1phase2 );      %Total B1_lead1

close all

ColorbarMax1 = mean2(B1mag1(:,:,1)) + 5*std2(B1mag1(:,:,1));
ColorbarMax2 = mean2(B1mag2(:,:,1)) + 5*std2(B1mag2(:,:,1));

figure(1)
for ii = 1:N
    subplot(4,4,ii), imagesc(abs(B1cmplx1(:,:,ii))), caxis([0 ColorbarMax1]), axis equal, axis off
end

figure('Name','Select the location of Lead 1','NumberTitle','off');
for ii = 1:N
    subplot(4,4,ii), imagesc(abs(B1cmplx2(:,:,ii))), caxis([0 ColorbarMax2]), axis equal, axis off
end

[yi , xi , ~] = ginput(1);
x01 = round(xi);
y01 = round(yi);

Dcm_Info = dicominfo([files(1).name]);
pxl_size = round(Dcm_Info.PixelSpacing(1));

cd(FolderName3);
save B1_Lead1_Chs.mat N FolderName3 B1cmplx1 B1cmplx2 x01 y01 pxl_size -v7.3
