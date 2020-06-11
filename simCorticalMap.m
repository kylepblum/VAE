
clear, clc; 
for run = 1:100
    clearvars -except numUnits diffPDs PDs run diffPDbins
% dimensions of pinwheel
r = 0.3; %mm

p = 1600/20; %neurons/mm^2 divided by fraction of column you can record

n = round(pi*r^2*p); %number of neurons to simulate
rho = r*sqrt(rand(n,1));
theta = rand(n,1)*2*pi;

if run == 1
    figure;
    polarplot(theta,rho,'.','MarkerSize',10); hold on
end

%generate random electrode locations
rElec = 0.075;
nElec = 100;

for elec = 1:100
    rhoElec(elec) = r*sqrt(rand);
    thetaElec(elec) = rand*2*pi;
    distances(:,elec) = sqrt(rho.^2 + rhoElec(elec)^2 - 2.*rho.*rhoElec(elec).*cos(theta - thetaElec(elec)));
    
    %     polar(rhoElec(elec),thetaElec(elec)+zeros(size(rhoElec(elec))))
    
    [x,y] = pol2cart(thetaElec(elec),rhoElec(elec));
    thetaRec = 0:pi/50:2*pi;
    xpos = rElec * cos(thetaRec) + x;
    ypos = rElec * sin(thetaRec) + y;
    [thetaRecCenter,rhoRecCenter] = cart2pol(xpos,ypos);
    
    if run == 1
        hElec = polarplot(thetaRecCenter,rhoRecCenter);
        hElec.Color = 'k';
    end
    
    PDs{elec,run} = theta(distances(:,elec)<=rElec);
    diffPDs{elec,run} = diff(PDs{elec,run});
    numUnits(elec,run) = numel(PDs{elec,run});
end


diffPDarray = vertcat(diffPDs{:,run});

diffPDbins(run,:) = histcounts(acos(cos(diffPDarray)),20);

edges = 0:pi/100:pi;
figure(2); set(gcf,'Color','white')
histogram(acos(cos(diffPDarray)),edges,'Normalization','probability',...
    'FaceAlpha',0.05,'EdgeAlpha',0.0); hold on
set(gca,'Xtick',[0 pi/2 pi],'XTickLabel',{'0','pi/2','pi'},...
    'Box','off','FontName','Helvetica')


if run == 1
    figure; set(gcf,'Color','White') 
    histogram(acos(cos(diffPDarray)),20,'Normalization','probability'); hold on;
    title('Example PD similarity from 1 simulation','FontName','Helvetica')
    set(gca,'FontName','Helvetica','box','off')
    
    figure; set(gcf,'Color','white'); hold on;
    [N, EDGES] = histcounts(distances);
    histogram('bincounts',N(1:3),'binedges',EDGES(1:4));
    histogram('bincounts',N(4:end),'binedges',EDGES(4:end));

    xlabel('distances of neurons from electrodes (mm)'), ylabel('number')
    set(gca,'FontName','Helvetica','box','off')
end
end

diffPDbins = diffPDbins./nElec;
x = linspace(0,pi,20);
figure; set(gcf,'Color','white')
notBoxPlot(diffPDbins,x,x(2)/2,'patch')
set(gca,'Xtick',[0 pi/2 pi],'XTickLabel',{'0','pi/2','pi'},...
    'Box','off','FontName','Helvetica')


%% plot simulated pinwheel (lots of many neurons)
kylemap = [0.6 1 0.6; 0.0 0.4 0.9; 1 0.5 1; 0.9 0.3 0.0; 0.6 1 0.6];
x = linspace(0,2*pi,5);
% xq = -pi:0.01:pi;
v = kylemap;
vq = interp1(x,v,xq);

for i = 1:10000
    rho = r*sqrt(rand);
    theta = rand*2*pi;
    vq = interp1(x,v,theta);
    polarplot(theta,rho,'.','MarkerSize',10,'Color',vq); hold on;
end

