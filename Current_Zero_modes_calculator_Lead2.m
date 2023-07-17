clear all
close all
clc

%********USER INPUT********************
ROI_size = 30;         %Size of the square around the lead 2 for calculating the scattered field (Default: 30mm)
%**************************************

load('B1_Lead2_IF1.mat')

pxl_N = round(ROI_size/pxl_size/2) - 1;

options = optimset('MaxIter',2000);
AveINullAmpRel(1,1) = 1;
AveINullPhaRel(1,1) = 0;
B1cmplx3_vec = reshape(B1cmplx3,[size(B1cmplx3,1)*size(B1cmplx3,2),size(B1cmplx3,3)]);
B1cmplx4_vec = reshape(B1cmplx4,[size(B1cmplx4,1)*size(B1cmplx4,2),size(B1cmplx4,3)]);
mask = zeros(size(B1cmplx3,1),size(B1cmplx3,2));
mask(x02-pxl_N:x02+pxl_N,y02-pxl_N:y02+pxl_N) = 1;
mask(x02,y02) = 0;
ind = find(mask);

for mm = 2:size(B1cmplx3_vec,2)
    for ii = 1:2000
        display(['Channel = ',num2str(mm)])
        fun = @(c)max(abs(  (B1cmplx4_vec(ind,1) + B1cmplx4_vec(ind,mm) * c(1,1)   -   ...
            (B1cmplx3_vec(ind,1) + B1cmplx3_vec(ind,mm) * c(1,1))   )...
            /sqrt(sum(abs([1 , c(1,1)]).^2))  ));
        
        c0 = rand(1) + 1j*(-1).^(randi(2,1,1)).*rand(1);
        c = fminsearch(fun,c0);
        
        Cost(ii) = max(abs(  (B1cmplx4_vec(ind,1) + B1cmplx4_vec(ind,mm) * c(1,1)   -   ...
            (B1cmplx3_vec(ind,1) + B1cmplx3_vec(ind,mm) * c(1,1))   )...
            /sqrt(sum(abs([1 , c(1,1)]).^2))  ));
        X(ii) = c;
        
    end
    
    [~,q] = min(Cost);
    
    AveINullAmpRel(1,mm) = 1/abs(X(q));
    AveINullPhaRel(1,mm) = 180 - angle(X(q)) * 180/pi;
end


%%
save Currents_Lead2.mat AveINullAmpRel AveINullPhaRel -v7.3