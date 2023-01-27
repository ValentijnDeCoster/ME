function [Xphidata] = getPSDdata_increaspingperiods_noplot(Xreprod,periods,delphi,Energy,E1,E2,demodindex)
%This function is part of the ME(XAS)-PSD Analysis Toolbox (LCT, Ghent University)
%v 1.0.1 - 13 December 2022
%Valentijn De Coster
%
%[Xphidata] = getPSDdata_increaspingperiods_noplot(Xreprod,periods,delphi,Energy,E1,E2,demodindex)
%
%This function generates phase-resolved data WITHOUT plotting the data. 
%Similar to the “PSD_increasingperiods” function, "Xreprod" is given – 
%which should contain only the periodic MEXAS data – and PSD is performed 
%for incremental averages over the number periods in this data matrix, i.e. “periods”,
%STARTING FROM THE FIRST PERIOD (e.g. PSD of first period, first 2 periods, etc...).
%To do this, the total number of periods in the data "periods" has to be given, 
%as well as "delphi", i.e. the intervals of phase angles for which PSD will 
%be performed, the "Energy" matrix, containing the energy values corresponding 
%to "Xreprod". "E1" and "E2", ‘old’ energy ranges for plots, have to be
%provided, even though no plots are made. This is because this code is
%derived from the variant which does plot the data
%(getPSDdata_increasingperiods)
%
%The output matrix “Xphidata” thus contains phase-resolved data for each of 
%the incremental averages, concatenated under each other. That is, 1st period’s 
%PSD results are on top, subsequently the PSD results for the average of the first 
%2 periods PSD, followed by PSD results for the average of the first 3 periods PSD, ….
%
%NOTE 1: corresponding phase angles for which phase-resolved spectra are generated are 
%put as a column in front of this matrix. 
%For example, if “nperiods”=20, “delphi”=30 and “Energy” contains 1000 points, 
%then “Xphidata” is a 400 x 1001 matrix. 400 rows, because steps of 30° are 
%being used for PSD ? 20 phase-resolved spectra per averaged dataset. 
%1001 columns because 1000 energy points are sampled and +1 column is added, 
%containing the phase angles.
%
%NOTE 2: This function uses the “avgXASperiods” and “PSD_data_noplot” custom codes.
% 


periodavgnrv2=floor(size(Xreprod,1)/periods);
for i=1:periods 
    %first make an averaged version of the XAS data over certain nr. of
    %periods
    Xiperiods=Xreprod(1:periodavgnrv2*i,:);
    Xiperiodsavg=avgXASperiods(Xiperiods,i);
    %this saves it as cell data, whereby each cell data Xhpi{1} or ~{2} is
    %a matrix that contains the PSD data per period avg
    Xphi{i}=PSD_data_noplot(Xiperiodsavg,delphi,Energy,E1,E2,demodindex);
       
end 
%convert to non-cell element with all PSD data in rows, take them per 12 to
%have each period
phivalues=[0:delphi:(360-delphi)]';
phirepeated=repmat(phivalues,periods,1);
Xphi_periods=cell2mat(Xphi');
Xphidata=[phirepeated,Xphi_periods];
end

