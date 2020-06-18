% trial_data = td;
clear, clc
params.monkey = 'chips';
if ~ispc
    gridElec = spikeArray2Grid(params);
else
    gridElec = spikeArray2Grid_PC(params);
end
%Load TD
if ~ispc
    pathname = '~/Koofr/Limblab/Data/S1-topography/Data/';
else
    pathname = 'F:\Koofr\My desktop sync\Limblab\Data\S1-topography\Data\';
end

if strcmpi(params.monkey,'chips')
    filename{1} = [pathname 'Chips_20151211_S1-topography.mat'];
%     filename{2} = [pathname 'Chips_20170913_S1-topography.mat'];
elseif strcmpi(params.monkey,'han')
    filename{1} = [pathname 'Han_20160325_S1-topography.mat'];
    filename{2} = [pathname 'Han_20171106_S1-topography.mat'];
elseif strcmpi(params.monkey,'duncan')
    filename{1} = [pathname 'Duncan_20190515_S1-topography.mat'];
    filename{2} = [pathname 'Duncan_20190524_S1-topography.mat'];
elseif strcmpi(params.monkey,'allS1')
    filename{1} = [pathname 'Chips_20151211_S1-topography.mat'];
    filename{2} = [pathname 'Chips_20170913_S1-topography.mat'];
    filename{3} = [pathname 'Han_20160325_S1-topography.mat'];
    filename{4} = [pathname 'Han_20171106_S1-topography.mat'];
    filename{5} = [pathname 'Duncan_20190515_S1-topography.mat'];
    filename{6} = [pathname 'Duncan_20190524_S1-topography.mat'];
elseif strcmpi(params.monkey,'chewie')
    filename{1} = [pathname 'Chewie_20160915_M1_PMd-topography.mat'];
    filename{2} = [pathname 'Chewie_20161013_M1_PMd-topography.mat'];
    which_array = 'M1';
end

catPDTable = table;

for filenum = 1:numel(filename)
    
    load(filename{filenum});
    %Smooth spikes
    smoothParams.signals = {'M1_spikes'};
    smoothParams.width = 0.05;
    smoothParams.calc_rate = true;
    try
        trial_data = smoothSignals(trial_data,smoothParams);
    catch
        try
            smoothParams.signals = {'S1_spikes'};
            trial_data = smoothSignals(trial_data,smoothParams);
        catch
            if strcmpi(which_array,'PMd')
                smoothParams.signals = {'PMd_spikes'};
                trial_data = smoothSignals(trial_data,smoothParams);
            else
                smoothParams.signals = {'M1_spikes'};
                trial_data = smoothSignals(trial_data,smoothParams);
            end
        end
    end
    %Get speed
    trial_data.vel_norm = sqrt(trial_data.vel(:,1).^2 + trial_data.vel(:,2).^2);
    
%     %Remove offset
%     trial_data.pos(:,1) = trial_data.pos(:,1)+0;
%     trial_data.pos(:,2) = trial_data.pos(:,2)+32;
    
    %Split TD
    splitParams.split_idx_name = 'idx_startTime';
    splitParams.linked_fields = {'result'};
    trial_data = splitTD(trial_data,splitParams);
    
%     trial_data(isnan([trial_data.idx_goCueTime])) = [];
%     trial_data(strfind([trial_data.result],'I')) = [];
%     trial_data(strfind([trial_data.result],'F')) = [];
    
    PDparams.in_signals = {'vel',1:2};
    PDparams.num_boots = 50;
    
%     moveOnParams.start_idx = 'idx_goCueTime';
%     moveOnParams.end_idx = 'idx_endTime';
%     trial_data = getMoveOnsetAndPeak(trial_data,moveOnParams);
    
    trial_data = trimTD(trial_data,{'idx_startTime',0},{'idx_startTime',50});
    
    for i = 1:numel(trial_data)
        try
            trial_data(i).S1_spikes(:,trial_data(i).S1_unit_guide(:,2)<1) = [];
            trial_data(i).S1_unit_guide(trial_data(i).S1_unit_guide(:,2)<1,:) = [];
        catch
            try
                trial_data(i).area2_spikes(:,trial_data(i).area2_unit_guide(:,2)<1) = [];
                trial_data(i).area2_unit_guide(trial_data(i).area2_unit_guide(:,2)<1,:) = [];
            catch
                if strcmpi(which_array,'PMd')
                    trial_data(i).PMd_spikes(:,trial_data(i).PMd_unit_guide(:,2)<1) = [];
                    trial_data(i).PMd_unit_guide(trial_data(i).PMd_unit_guide(:,2)<1,:) = [];
                else
                    trial_data(i).M1_spikes(:,trial_data(i).M1_unit_guide(:,2)<1) = [];
                    trial_data(i).M1_unit_guide(trial_data(i).M1_unit_guide(:,2)<1,:) = [];
                end
            end
        end
    end
    
%     try
        PDparams.out_signals = {'S1_spikes'};
        arrayInfo = trial_data(1).S1_unit_guide;
        pdTable = getTDPDs(trial_data,PDparams);
%     catch
%         try
%             PDparams.out_signals = {'area2_spikes'};
%             arrayInfo = trial_data(1).area2_unit_guide;
%             pdTable = getTDPDs(trial_data,PDparams);
%         catch
%             if strcmpi(which_array,'PMd')
%                 PDparams.out_signals = {'PMd_spikes'};
%                 arrayInfo = trial_data(1).PMd_unit_guide;
%                 pdTable = getTDPDs(trial_data,PDparams);
%             else
%                 PDparams.out_signals = {'M1_spikes'};
%                 arrayInfo = trial_data(1).M1_unit_guide;
%                 pdTable = getTDPDs(trial_data,PDparams);
%             end
%         end
%     end

    pdTable.filenum(1:size(pdTable,1)) = filenum;
    pdTable.elec = arrayInfo(:,1);

    row = []; col = [];
    for i = 1:numel(pdTable.elec)
        [row(i),col(i)] = find(gridElec==pdTable.elec(i));
    end
    
    pdTable.gridIdx = [row' + (filenum-1)*200, col' + (filenum-1)*200]; 
    
    
    
    
    
    catPDTable = [catPDTable; pdTable];

end

pdTable = catPDTable;
%% Plotting Map
% musVel_pdTable = pdTable(end-37:end,:);



if strcmp(PDparams.in_signals{1},'vel')
    
    include = rad2deg(diff(pdTable.velPDCI')') < 10 & pdTable.velTuned;
    
    S1_pds = pdTable.velPD(include);
    S1_mds = pdTable.velModdepth(include);
    S1_CIs = pdTable.velPDCI(include,:);
 
    
    S1_boots = cell2mat(pdTable.velboostraps(include)');
    
elseif strcmp(PDparams.in_signals{1},'force')
    S1_pds = pdTable.forcePD(:);
    S1_mds = pdTable.forceModdepth(:);
elseif strcmp(PDparams.in_signals{1},'planar_force')
    S1_pds = pdTable.planar_forcePD(:);
    S1_mds = pdTable.planar_forceModdepth(:);
end
% musVel_pds = musVel_pdTable.velPD(:);

% figure; plot(S1_pds,S1_mds,'.')



% hfig = figure; PD_MAP = heatmap(VAE_grid);
%
%
% PD_MAP.ColorLimits = [-pi pi];
% PD_MAP.GridVisible = 'off';
% PD_MAP.XDisplayLabels = repmat({''},40,1);
% PD_MAP.YDisplayLabels = repmat({''},40,1);

% hfig.Color = 'white';

% kylemap = [0.6 1 0.6; 0.0 0.4 0.9; 1 0.5 1; 0.9 0.3 0.0; 0.6 1 0.6];
% x = linspace(-pi,pi,5);
% xq = -pi:0.01:pi;
% v = kylemap;
% vq = interp1(x,v,xq);
% colormap(vq)


%figure;
%testMAP = heatmap(VAE_testGrid); colormap(vq);


% hfig3 = figure; polarhistogram(S1_pds,36)
% hfig4 = figure; polarhistogram(musVel_pds,50)




%% Calculate distances
j = 0;
for nh_shape = [0.1 1 2] %Neighborhood shape (2x2 square)
    j = j+1;
    allDiffNeighborPDs = [];
    allDiffOtherPDs = [];
    
    neighborIdx1 = nchoosek(-nh_shape:nh_shape,2);
    neighborIdx2 = fliplr(neighborIdx1);
    neighborIdx = [neighborIdx1; neighborIdx2];
    
    gridIdx = pdTable.gridIdx;
    for unit = 1:size(S1_pds)
        neighborPDs = [];
        thisPD = S1_pds(unit);
        thisIdx = pdTable.gridIdx(unit,:);
        gridRelIdx = gridIdx - thisIdx;
        posNeighborhood = [];
        
        neighborhood = [neighborIdx(:,1)+thisIdx(1), neighborIdx(:,2)+thisIdx(2)];
        neighborhood = [neighborhood; thisIdx];
        
        for i = 1:size(neighborhood,1)
            if pdTable.filenum(unit) == 1
                if neighborhood(i,1) > 0 && neighborhood(i,2) > 0 ...
                        && neighborhood(i,1) <=10 && neighborhood(i,2)<=10
                    posNeighborhood = [posNeighborhood; neighborhood(i,:)];
                end
            elseif pdTable.filenum(unit) == 2
                if neighborhood(i,1) > 200 && neighborhood(i,2) > 200 ...
                        && neighborhood(i,1) <=210 && neighborhood(i,2)<=210
                    posNeighborhood = [posNeighborhood; neighborhood(i,:)];
                end
            end
        end
        
        neighborPDs = [];
        otherPDs = [];
        
        for i = 1:size(posNeighborhood,1)
            thisNeighbor = posNeighborhood(i,:);
            neighborPDs = [neighborPDs; S1_pds(gridIdx(:,1)==thisNeighbor(1) & gridIdx(:,2)==thisNeighbor(2))];
            otherPDs = [otherPDs; S1_pds(gridIdx(:,1)~=thisNeighbor(1) | gridIdx(:,2)~=thisNeighbor(2))];
            
            neighborPDs(neighborPDs==thisPD) = []; %Need to remove this unit from "neighborhood"
        end
        
        
        allDiffNeighborPDs = [allDiffNeighborPDs; abs(neighborPDs - thisPD)];
        allDiffOtherPDs = [allDiffOtherPDs; abs(otherPDs - thisPD)];
    end
    
    %
    
    
    %Create Figure
    edges = 0:10:180;
    
    figure(9); hold on; set(gcf,'Color','White'); 
    set(gcf,'Units','Normalized','PaperUnits','normalized',...
        'Position',[0 0 0.5 1.0],'PaperPosition',[0 0 1 1])
    if j == 1
        axes('Position', [0, 0.98, 1, 0.05])
        set( gca, 'Color', 'None', 'XColor', 'White', 'YColor', 'White' ) ;
        text(0.5,0.0,['PD similarities across array - ' params.monkey],...
            'FontName','Helvetica','FontSize',16,'FontWeight','bold',...
            'HorizontalAlignment','center','VerticalAlignment','top')
    end
        
    if j == 6
        xlabel('Difference in PD (radians)');
    end
    
    subplot(6,3,j*3-1), hold on, %axis([0 180 0 0.2])
    set(gca,'FontName','Helvetica','FontSize',14,'box','off')

    [nNeighbors(j,:)] = histcounts(rad2deg(acos(cos(allDiffNeighborPDs))),edges);
    
    if j == 1    %Circular neighborhoods (including center)
        histogram(rad2deg(acos(cos(allDiffNeighborPDs))),edges,'Normalization','probability'); hold on
    else   %Concentric ring neighborhood (excluding center)
        histogram('bincounts',nNeighbors(j,:) - nNeighbors(j-1,:),'binedges',edges,'Normalization','probability'); hold on
    end
      
    [nOthers(j,:)] = histcounts(rad2deg(acos(cos(allDiffOtherPDs))),edges);
    
    if j == 1  %Circular others (including center)
        histogram(rad2deg(acos(cos(allDiffOtherPDs))),edges,'Normalization','probability'); hold on
    else %Concentric ring others (excluding center)
        histogram('bincounts',nOthers(j,:) - nOthers(j-1,:),'binedges',edges,'Normalization','probability'); hold on
    end

    
    % Draw "neighborhoods"
    subplot(6,3,j*3-2), hold on, axis([-5000 5000 -2000 2000]); axis equal
    set(gca,'xtick',[],'ytick',[])
    set(gca,'FontName','Helvetica','FontSize',14,'box','off')
    ylabel([num2str((j-1)*400) 'um'])
    if j > 1
        r = (j-1)*400;
    else
        r = 100;
    end
    rectangle('Position',[1e3-(r-400) -r 2*r 2*r], 'Curvature', [1 1], 'FaceColor', [0.0 0.45 0.74])
    if j > 2
        rectangle('Position',[1e3-(r-800) -r+400 2*(j-2)*400 2*(j-2)*400], 'Curvature',[1 1],'FaceColor',[1 1 1])
    elseif j == 2
        rectangle('Position',[1e3-(r-700) -100 200 200], 'Curvature',[1 1],'FaceColor',[1 1 1])

    end
    

    
   % Bootstrap
   numBoots = 10;
   bootOthers = bootstrp(numBoots,@(x) x, rad2deg(acos(cos(allDiffOtherPDs))));
   bootNeighbors = bootstrp(numBoots,@(x) x,  rad2deg(acos(cos(allDiffNeighborPDs))));
   
   
   for i = 1:numBoots
       boot_nOthers(i,:,j) = histcounts(bootOthers(i,:),edges);
       boot_nNeighbors(i,:,j) = histcounts(bootNeighbors(i,:),edges);
       
       if j == 1
           boot_pOthers(i,:,j) = boot_nOthers(i,:,j)./sum(boot_nOthers(i,:,j));
           boot_pNeighbors(i,:,j) = boot_nNeighbors(i,:,j)./sum(boot_nNeighbors(i,:,j));
       else
           boot_pOthers(i,:,j) = (boot_nOthers(i,:,j) - boot_nOthers(i,:,j-1))./sum(boot_nOthers(i,:,j));
           boot_pNeighbors(i,:,j) = (boot_nNeighbors(i,:,j) - boot_nNeighbors(i,:,j-1))./sum(boot_nNeighbors(i,:,j));
       end
   end
   
   %Probability differences
   subplot(6,3,j*3), hold on
   set(gca,'FontName','Helvetica','FontSize',14,'box','off','xticklabel',[],'Clipping','off')
%    axis([0 180 -0.15 0.15])
   
   line(0:180,zeros(size(0:180)),'LineStyle','-')
 
   boot_pDiff = boot_pNeighbors(:,:,j) - boot_pOthers(:,:,j);
   notBoxPlot(boot_pDiff,edges(1:end-1)+5,5,'patch')  
   
end


%% 
binnedPDs = zeros(size(S1_pds,1),length(0:0.1:359.9)); %Preallocate array for binnedPDs

edges = round(rad2deg(wrapTo2Pi(S1_CIs))*10)/10; % This gets first and last bin for PD CIs

edgesIdx = edges' * 10 + 1;
tranEdges = edges';

normDeg = mod(diff(tranEdges)',360);
  
   
heights = 1./normDeg;

for i = 1:size(binnedPDs,1)
    binnedPDs(i,edgesIdx(1,i):edgesIdx(1,i)+normDeg(i)*10+1) = heights(i);  % I'm using the first idx and the width to avoid the wrapping issues
end

wrappedPDs = binnedPDs(:,1:3600);
rmd = length(binnedPDs) - 3600; %remainder
wrappedPDs(:,1:rmd) = wrappedPDs(:,1:rmd) + binnedPDs(:,3601:end);

figure; 
polarplot(linspace(0,2*pi,length(sum(wrappedPDs))),smooth(sum(wrappedPDs),1));
% hold on
% polarplot(linspace(0,2*pi,length(sum(wrappedPDs))),smooth(sum(wrappedPDs),15));
% polarplot(linspace(0,2*pi,length(sum(wrappedPDs))),smooth(sum(wrappedPDs),1));



cmvWrappedPDs = sum(wrappedPDs); %cumulative wrapped PDs
cmvWrappedPD_counts = round(cmvWrappedPDs * 1e5);

counts = [];
numBins = 72;
binSize = length(cmvWrappedPD_counts)/numBins;
for k = 1:numBins
    ctIdx = binSize*(k-1) + 1 : binSize*(k);
    counts(k) = sum(cmvWrappedPD_counts(ctIdx));
end

figure;
polarhistogram('BinEdges',deg2rad(0:360/numBins:360),'BinCounts',counts,'Normalization','pdf')

% Use PD bootstrap samples instead
figure;
polarhistogram(S1_boots,18,'Normalization','pdf','EdgeColor','none'); hold on
polarhistogram(S1_boots,36,'Normalization','pdf','EdgeColor','none'); hold on
polarhistogram(S1_boots,72,'Normalization','pdf','DisplayStyle','Stairs','EdgeAlpha',0.8)
% polarhistogram(S1_boots,1152,'Normalization','pdf','DisplayStyle','Stairs','EdgeAlpha',0.3)



% Classical visualization
figure;
polarhistogram(S1_pds,18,'normalization','pdf');
polarhistogram(S1_pds,36,'normalization','pdf');
polarhistogram(S1_pds,72,'normalization','pdf');
