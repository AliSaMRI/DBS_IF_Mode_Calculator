clear all
close all
clc

FolderName2 = uigetdir('./','Select the directory of dicom files containing Lead2 B1-maps'); 	%Directory of dicom files (Lead 2 B1-mapping directory)

load('B1_Lead1_Chs.mat')
load('INullSpace_Lead1.mat')

cd(FolderName2);
filePattern = fullfile('./', '*.dcm');
files = dir(filePattern);

%% Plane P1 (%Incident B1_lead2_Channels)
for ii = 1:N
	B1mag1(:,:,ii) = double(dicomread([files(ii).name]));
end

for ii = 1:N
	B1phase1(:,:,ii) = double(dicomread([files(2*N+ii).name]));
end
B1phase1 = (B1phase1)/4096*2*pi;

%% Plane P2 (%Total B1_lead2_Channels)
for ii = 1:N
	B1mag2(:,:,ii) = double(dicomread([files(N+ii).name]));
end

for ii = 1:N
	B1phase2(:,:,ii) = double(dicomread([files(3*N+ii).name]));
end
B1phase2 = (B1phase2)/4096*2*pi;

B1cmplx1 = B1mag1 .* exp(1j .* B1phase1);      %Total B1_lead2_Channels
B1cmplx2 = B1mag2 .* exp(1j .* B1phase2);      %Incident B1_lead2_Channels

%% Plot & Save
M = size(ExNullSpaceINull,2);         %Number of IF vectors for Lead1

for ii = 1:M
    temp1 = 0;
    temp2 = 0;
    for jj = 1:N 
        temp1 = temp1 + B1cmplx1(:,:,jj) * ExNullSpaceINull(jj,ii);         %Incident B1_lead2_IFModes1
        temp2 = temp2 + B1cmplx2(:,:,jj) * ExNullSpaceINull(jj,ii);         %Total B1_lead2_IFModes1
    end
    B1cmplx3(:,:,ii) = temp1;
    B1cmplx4(:,:,ii) = temp2;
end
B1mag3 = abs(B1cmplx3);
B1phase3 = angle(B1cmplx3);
B1mag4 = abs(B1cmplx4);
B1phase4 = angle(B1cmplx4);


close all

ColorbarMax1 = mean2(B1mag3(:,:,1)) + 5*std2(B1mag3(:,:,1));
ColorbarMax2 = mean2(B1mag4(:,:,1)) + 5*std2(B1mag4(:,:,1));

figure(1)
for ii = 1:M
    subplot(4,4,ii), imagesc(abs(B1cmplx3(:,:,ii))), caxis([0 ColorbarMax1]), axis equal, axis off
end

figure('Name','Select the location of Lead 2','NumberTitle','off');
for ii = 1:M
    subplot(4,4,ii), imagesc(abs(B1cmplx4(:,:,ii))), caxis([0 ColorbarMax2]), axis equal, axis off
end

[yi , xi , ~] = ginput(1);
x02 = round(xi);
y02 = round(yi);

cd(FolderName3);
save B1_Lead2_IF1.mat N M B1cmplx3 B1cmplx4 x02 y02 pxl_size -v7.3

