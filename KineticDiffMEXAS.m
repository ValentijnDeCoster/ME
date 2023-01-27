function [inphaseangles_MAX] = KineticDiffMEXAS(Xperiodic,periods,deltaphi,Energy,E1,E2,kindex)
%This function is part of the ME(XAS)-PSD Analysis Toolbox (LCT, Ghent University)
%v 1.0.1 - 13 December 2022
%Valentijn De Coster
%
%[inphaseangles_MAX] = KineticDiffMEXAS(Xperiodic,periods,deltaphi,Energy,E1,E2,kindex)
%
%Performs PSD and kinetic differentiation of given data. Plots the in-phase 
%angle map plot and gives as output the in-phase angles.
%
%Calculates the time-resolved average of the “Xperiodic” dataset, containing 
%reversible data, over “periods”, i.e. the number of periods; 
%“Energy” is the matrix with corresponding energy values of the collected spectra.
%
% PSD is performed over this averaged dataset with demodulation index “kindex” 
%and using “deltaphi” as sampling interval to generate phase-resolved spectra 
%from 0° till (360-deltaphi)°. For each value in “Energy”, the phase angle which 
%gives maximum amplitude in the phase-resolved spectra, is calculated, i.e. the 
%in-phase angle. These are collected in the output “inphaseangles_MAX”. 
%
%Additionally, the function yields a plot of these in-phase angles as a function 
%of the Energy for the energy range [“E1”, “E2”].

Xphi=getPSDdata_increaspingperiods_noplot(Xperiodic,periods,deltaphi,Energy,E1,E2,kindex); %phis AND PSD data for all angles
phispectraperperiod=360/deltaphi;
Xphi=Xphi((end-phispectraperperiod+1):end,:); %only last avg period dataset
phis=Xphi(:,1);
XphiDRIFTSSpectra=Xphi(:,2:end);

nrphis=size(Xphi,1);
[~,I] = max(XphiDRIFTSSpectra,[],1); %has indices of in phase angles

for i=1:size(XphiDRIFTSSpectra,2);
   inphaseangles_MAX(i)=phis(I(i)); 
end

figure
box on
scatter(Energy,inphaseangles_MAX,25,'black','filled');
ylim([0 360])
xlim([E1 E2])
xlabel('Energy [eV]')
ylabel('In-phase angle [°]')
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca, 'FontSize', 14,'fontweight','bold','linewidth',1)
set(gca,'TickLength',[0.018, 0.01])
%TRICK TO MAKE SURE energy values at x axis are integers (no decimals)
x_labels = get(gca, 'XTick');
% set(gca, 'XDir','reverse')
set(gca, 'XTickLabel', x_labels)

box on
end

