clear all
close all

load('B1_Lead2_IF1.mat')
load('Currents_Lead2.mat')

INull = AveINullAmpRel .* exp(1j * AveINullPhaRel * pi/180);
NullSpaceINull= null(INull);

load('INullSpace_Lead1.mat')

ExNullSpaceINull = ExNullSpaceINull * NullSpaceINull;

save INullSpace.mat ExNullSpaceINull -v7.3

