function [Xphi] = PSD_data(XXnew,delphi,Energy,E1,E2,demodindex)
%This function is part of the ME(XAS)-PSD Analysis Toolbox (LCT, Ghent University)
%v 1.0.1 - 13 December 2022
%Valentijn De Coster
%
%[Xphi] = PSD_data(XXnew,delphi,Energy,E1,E2,demodindex)
% The same function as “PSD”, i.e. does PSD of pre-averaged data and plots results, 
%BUT ALSO gives the demodulated data as output “Xphi”, %where each row represents 
%a demodulated spectrum at a certain phase angle %and each column represents 
%(demodulated) absorbance values at a certain %energy value (corresponding to
% “Energy” matrix) for the generated phase angles.

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
%plot(EnergyPt,sdiff_Pt_PtmonoPtIn*0.015,'-black','LineWidth',1.5)
hold off
xlabel('Energy [eV]')
ylabel('Normalized absorbance [/]')
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca, 'FontSize', 12)
xlim([E1 E2])
xlabel('Energy [eV]')
ylabel('Normalized absorbance [/]')
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
%plot(EnergyPt,sdiff_Pt_PtmonoPtIn*0.015,'-black','LineWidth',1.5)
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
ylabel('Normalized absorbance [/]')
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

