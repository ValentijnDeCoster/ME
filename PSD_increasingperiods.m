function [] = PSD_increasingperiods(Xreprod,periods,delphi,Energy,E1,E2,pngsavename,demodindex)
%This function is part of the ME(XAS)-PSD Analysis Toolbox (LCT, Ghent University)
%v 1.0.1 - 13 December 2022
%Valentijn De Coster
%
%PSD_increasingperiods(Xreprod,periods,delphi,Energy,E1,E2,pngsavename,demodindex)
%
%This function performs PSD of a given XAS data matrix "Xreprod" - which
%should contain only the periodic changes (and preferably thus also
%reproducible - though this script can check reversibility if PSDs are
%similar shape) MEXAS data - for incremental averages over the periods,
%STARTING FROM THE FIRST PERIOD (e.g. PSD of first period, first 2
%periods, etc...). To this, the total number of periods in the data
%"periods" have to be given, as well as "delphi", i.e. the intervals of phase angles for which PSD will be
%performed, the "Energy" matrix, containing the energy
%values corresponding to "Xreprod", "E1", and "E2", which are limits for
%plotting the results. "pngsavename" allows creating unique names, as
%all the phase-resolved spectra of x periods will be saved in png AND INTERACTIVE .fig files titled 'Last_x_periods_pngsavename'.
%demodindex is the demodulation index used in PSD, and an OPTIONAL input
%argument. If it's absent, a standard demodulation index of k = 1 will be
%used, if it is specified (an integer), then that demod index will be used.
%
%NOTE: this function requires the PSD.m and avgXASperiods.m functions

close all
periodavgnrv2=floor(size(Xreprod,1)/periods);
for i=1:periods 
    Xiperiods=Xreprod(1:periodavgnrv2*i,:);
    Xiperiodsavg=avgXASperiods(Xiperiods,i);
    if ~exist('demodindex','var')
     % demodindex parameter does not exist, so default it to something
      PSD(Xiperiodsavg,delphi,Energy,E1,E2);
    else PSD(Xiperiodsavg,delphi,Energy,E1,E2,demodindex);
    
end  

if i==1
    title(strcat('First period ',{' '},pngsavename));
    savename=strcat('First_period_',pngsavename,'.png');
saveas(gcf,savename);
savenamefig=strcat('First_period_',pngsavename,'.fig');
saveas(gcf,savenamefig);
else
formatspec='First %d periods';
name=sprintf(formatspec,i);
title(strcat(name,{' '},pngsavename));
savename='First_%d_periods_%s.png';
savename2=sprintf(savename,i,pngsavename);
%savename3=strcat(savename2,pgnsavename,'.png');
saveas(gcf,savename2)
savenamefig='First_%d_periods_%s.fig';
savenamefig2=sprintf(savenamefig,i,pngsavename);
saveas(gcf,savenamefig2);
end
end
end
