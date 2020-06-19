%% Load in Data

clear, clc

if ~ispc
    datadir = fullfile('~','Koofr','Limblab','Data','S1-topography','Data');
else
    datadir = fullfile();
    error('you have not set your Koofr path in this script yet!');
end

filenames = {'chips_neighborhood.mat',...
             'han_neighborhood.mat',...
             'duncan_neighborhood.mat',...
             'monkeyPDs.mat'};
         
for i = 1:length(filenames)
    load(fullfile(datadir,filenames{i}));
end


%% Make monkey PD histogram

allPDs = [chipsPDs; hanPDs; duncanPDs];

nbins = 36;

figure; set(gcf, 'Color', 'White')
polaraxes; hold on; 
polarhistogram(allPDs,nbins,'Normalization','probability','DisplayStyle','stairs')
polarhistogram(hanPDs,nbins,'Normalization','probability','DisplayStyle','stairs')
polarhistogram(chipsPDs,nbins,'Normalization','probability','DisplayStyle','stairs')
polarhistogram(duncanPDs,nbins,'Normalization','probability','DisplayStyle','stairs')

legend('all monkeys','monkey h','monkey c','monkey d')

%% Make monkey PD 
allNeighbors = [chipsDiffNeighbors; hanDiffNeighbors; duncanDiffNeighbors];
allNeighbors = rad2deg(abs(wrapToPi(allNeighbors)));

allDistant = [chipsDiffOthers; hanDiffOthers; duncanDiffOthers];
allDistant = rad2deg(abs(wrapToPi(allDistant)));

chipsNeighbors = rad2deg(abs(wrapToPi(chipsDiffNeighbors)));
hanNeighbors = rad2deg(abs(wrapToPi(hanDiffNeighbors)));
duncanNeighbors = rad2deg(abs(wrapToPi(duncanDiffNeighbors)));

chipsDistant = rad2deg(abs(wrapToPi(chipsDiffOthers)));
hanDistant = rad2deg(abs(wrapToPi(hanDiffOthers)));
duncanDistant = rad2deg(abs(wrapToPi(duncanDiffOthers)));

nbins = 15;
figure; set(gcf,'Color','white')

subplot(6,1,1:3); hold on;
set(gca,'XTick',[],'TickDir','out','FontName','Helvetica','FontSize',10)
[allNN, allEdges] = histcounts(allNeighbors,nbins,'Normalization','probability');
[allND, ~] = histcounts(allDistant,nbins,'Normalization','probability');

histogram('BinEdges',allEdges,'BinCounts',allNN)
histogram('BinEdges',allEdges,'BinCounts',allND)

subplot(6,1,4); hold on;
set(gca,'XTick',[],'TickDir','out','FontName','Helvetica','FontSize',10)
[chipsNN, chipsEdges] = histcounts(chipsNeighbors,nbins,'Normalization','probability');
[chipsND, ~] = histcounts(chipsDistant,nbins,'Normalization','probability');

histogram('BinEdges',allEdges,'BinCounts',chipsNN)
histogram('BinEdges',allEdges,'BinCounts',chipsND)

subplot(6,1,5); hold on;
set(gca,'XTick',[],'TickDir','out','FontName','Helvetica','FontSize',10)
[hanNN, hanEdges] = histcounts(hanNeighbors,nbins,'Normalization','probability');
[hanND, ~] = histcounts(hanDistant,nbins,'Normalization','probability');

histogram('BinEdges',allEdges,'BinCounts',hanNN)
histogram('BinEdges',allEdges,'BinCounts',hanND)

subplot(6,1,6); hold on;
set(gca,'TickDir','out','FontName','Helvetica','FontSize',10)
[duncanNN, duncanEdges] = histcounts(duncanNeighbors,nbins,'Normalization','probability');
[duncanND, ~] = histcounts(duncanDistant,nbins,'Normalization','probability');

histogram('BinEdges',allEdges,'BinCounts',duncanNN)
histogram('BinEdges',allEdges,'BinCounts',duncanND)
