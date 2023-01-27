function [] = PSD(XXnew,delphi,Energy,E1,E2,demodindex)
%This function is part of the ME(XAS)-PSD Analysis Toolbox (LCT, Ghent University)
%v 1.0.1 - 13 December 2022
%Valentijn De Coster
%
%PSD(XXnew,delphi,Energy,E1,E2,demodindex)
%
%This function performs and plots results of phase-sensitive detection (PSD) 
%on a pre-averaged XAS spectrum matrix "XXnew", of which an element “XXnew(i,j)” 
%represents a measurement at a certain time “i” in the (averaged, time-resolved) 
%period at energy value “j”. “delphi” represents the sampling step at which 
%phase-resolved spectra will be plotted from phase angle 0° to 359°. 
%So, if 30 is chosen, the plotted values will be 0°, 30°, 60°… 330°. 
%A data matrix "Energy" containing the energy values corresponding with XXnew 
%has to be provided, as well as 2 energy values, "E1" and "E2", which represent 
%the bottom and top limit for which the data will be plotted, respectively. 
%“demodindex” (integer, starting from 0) represents the demodulation index used 
%in PSD.
%

pnr=size(XXnew,1); 
nrofphis= 360/delphi;
Xphi=zeros(nrofphis,size(XXnew,2));


%Simpson's rule; only IF pnr is uneven/ got even nr. of subintervals
% s=zeros(1,pnr);
% for i=1:pnr
%     if(rem(i-1,2)==1 && (i-1)~=0 && i~=pnr)
%         s(i)=4
%     else if(rem(i-1,2)==0 && (i-1)~=0 && i~=pnr)
%             s(i)=2
%         else s(i)=1
%         end
%     end
% end

%trapzoid rule
s=zeros(1,pnr);
for i=1:pnr
    if(i==1 || i==pnr)
       s(i)=1;
    else s(i)=2;
    end
end

%demod index
if ~exist('demodindex','var')
     % third parameter does not exist, so default it to something
      k = 1;
else k = demodindex;
end  
%delphi=30; %choice phase angle
nrofphis= 360/delphi;
for phii=1:nrofphis
    for i=1:pnr
        
    Xphi(phii,:)=Xphi(phii,:)+s(i)*XXnew(i,:)*sin(2*pi*k*(i-1)/(pnr-1)+(phii-1)*delphi*pi/180);
    end
    Xphi(phii,:)=Xphi(phii,:)/pnr;
end


figure
ccnew=jet(size(XXnew,1));
box on
hold on
for j=1:size(XXnew,1)
plot(Energy,XXnew(j,:),'color',ccnew(j,:),'LineWidth',1)
end
hold off
xlabel('Energy [eV]')
ylabel('Normalized absorbance [a.u.]')
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca, 'FontSize', 12)
xlim([E1 E2])
xlabel('Energy [eV]')
ylabel('Normalized absorbance [a.u.]')
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca, 'FontSize', 14,'fontweight','bold','linewidth',1)
set(gca,'TickLength',[0.018, 0.01])
%TRICK TO MAKE SURE energy values at x axis are integers (no decimals)
x_labels = get(gca, 'XTick');
set(gca, 'XTickLabel', x_labels)
% set(gca,'XTick', [11550 11600 11650 11700]) %xticks is a double vector with the tick positions
% set(gca,'YTick', [-0.015:0.005:0.015]) %ytick is a double vector with the tick positions
%If wanna set tickmarks outside:
%set(gca,'TickDir','out');

figure
ccphi=jet(size(Xphi,1));

box on
hold on
for m=1:size(Xphi,1)
plot(Energy,Xphi(m,:),'color',ccphi(m,:),'LineWidth',2)
end
hold off
%degree=strings(1,nrofphis);
for m=1:size(Xphi,1)
formatSpec = '%d°';
leg{m} = sprintf(formatSpec,(m-1)*delphi);
%=join(sprintf('%d',(m-1)*delphi),'°');
end
legend(leg,'NumColumns',2);
xlim([E1 E2])
xlabel('Energy [eV]')
ylabel('Absorbance [a.u.]')
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca, 'FontSize', 14,'fontweight','bold','linewidth',1)
set(gca,'TickLength',[0.018, 0.01])
%TRICK TO MAKE SURE energy values at x axis are integers (no decimals)
x_labels = get(gca, 'XTick');
set(gca, 'XTickLabel', x_labels)
% set(gca,'XTick', [E1:50:E2]) %xticks is a double vector with the tick positions
% set(gca,'YTick', [-0.015:0.005:0.015]) %ytick is a double vector with the tick positions
%If wanna set tickmarks outside:
%set(gca,'TickDir','out');
end

