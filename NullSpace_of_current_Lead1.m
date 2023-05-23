clear all
close all

load('Currents_Lead1.mat')

INull = AveINullAmpRel .* exp(1j * AveINullPhaRel * pi/180);
NullSpaceINull= null(INull);

ExNullSpaceINull = NullSpaceINull;

save INullSpace_Lead1.mat ExNullSpaceINull -v7.3

