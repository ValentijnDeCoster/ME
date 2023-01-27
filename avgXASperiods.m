function [Xavgd] = avgXASperiods(Xreprod,periods)
%%This function is part of the ME(XAS)-PSD Analysis Toolbox (LCT, Ghent University)
%v 1.0.1 - 13 December 2022
%Valentijn De Coster
%
%[Xavgd] = avgXASperiods(Xreprod,periods)
% 
% This function takes a XAS data matrix "Xreprod", which MUST contain only 
%the reversible/reproducible data part from MEXAS experiments, wherein each 
%row is a data measurement at a given time and each column represents an 
%absorbance value at a certain energy value, and averages this over the total
%number of periods "periods" that are present within this data matrix. 
%The output “Xavgd” is an averaged time-resolved period of data.
%
%For example, if you have data corresponding to 20 periods (each with 30 time 
%instances measured and 1000 energy points = 600 x 1000 matrix) in a reversible
%regime, you use Xavgd = avgXASperiods(Xreprod, 20). The output is then 1 
%period of 30 time instances (30 x 1000 matrix).
% 
periodavgnrv2=floor(size(Xreprod,1)/periods); %e.g. if 23.33 or 23.7 --> 23
XX=zeros(periodavgnrv2,size(Xreprod,2));
for i=1:periodavgnrv2
    for j=1:periods
        XX(i,:)= XX(i,:)+Xreprod(i+periodavgnrv2*(j-1),:);
    end
    XX(i,:)=XX(i,:)/periods;
end
Xavgd=XX;        
end

