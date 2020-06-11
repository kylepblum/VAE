TDparams.out_signals = {'VAE_spikes', 'S1_spikes'};
TDparams.in_signals = 'vel';
TDparams.num_boots = 1;
% trial_data = trial_data(1:end-1); %Problem with last trial(s)?

pdTable = getTDPDs(trial_data,TDparams);



%% Plotting Map
% musVel_pdTable = pdTable(end-37:end,:);
S1_pdTable = pdTable(1601:end,:);
VAE_pdTable = pdTable(1:1600,:);                                                                                                                                                                                                                                                                                                                                                                                                           

S1_pds = S1_pdTable.velPD(:);
S1_mds = S1_pdTable.velModdepth(:);
% musVel_pds = musVel_pdTable.velPD(:);

VAE_pds = VAE_pdTable.velPD(:);
VAE_mds = VAE_pdTable.velModdepth(:);

figure; plot(VAE_pds,VAE_mds,'.')
figure; plot(S1_pds,S1_mds,'.')

VAE_grid = reshape(VAE_pds,sqrt(numel(VAE_pds)),sqrt(numel(VAE_pds)));

% VAE_grid(randperm(1600,1200)) = NaN;

% VAE_testGrid = VAE_grid(7:15,12:20);

hfig = figure; PD_MAP = heatmap(VAE_grid);
PD_MAP.ColorLimits = [-pi pi];
PD_MAP.GridVisible = 'off';
PD_MAP.XDisplayLabels = repmat({''},40,1);
PD_MAP.YDisplayLabels = repmat({''},40,1);

hfig.Color = 'white';

kylemap = [0.6 1 0.6; 0.0 0.4 0.9; 1 0.5 1; 0.9 0.3 0.0; 0.6 1 0.6];
x = linspace(-pi,pi,5);
xq = -pi:0.01:pi;
v = kylemap;
vq = interp1(x,v,xq);
colormap(vq)


%figure; 
%testMAP = heatmap(VAE_testGrid); colormap(vq);


hfig2 = figure; polarhistogram(VAE_pds,50)
hfig3 = figure; polarhistogram(S1_pds,50)
% hfig4 = figure; polarhistogram(musVel_pds,50)


%% Calculate distances

nh_shape = 1; %Neighborhood shape (2x2 square)
allDiffNeighborPDs = [];
allDiffOtherPDs = [];

neighborIdx1 = nchoosek(-nh_shape:nh_shape,2);
neighborIdx2 = fliplr(neighborIdx1);
neighborIdx = [neighborIdx1; neighborIdx2];

a = randperm(40,10);
b = randperm(40,10);

for row = 1:40
    for column = 1:40

        neighborsPDs = [];
        thisPD = VAE_grid(row,column);
        
        neighborhood = [neighborIdx(:,1)+row, neighborIdx(:,2)+column];
        posNeighborhood = [];
        for i = 1:size(neighborhood,1)
            if neighborhood(i,1) > 0 && neighborhood(i,2) > 0 && neighborhood(i,1) <=40 && neighborhood(i,2)<=40
                posNeighborhood = [posNeighborhood; neighborhood(i,:)];
            end
        end
        
        for i = 1:size(posNeighborhood,1)
            neighborsPDs(end+1) = VAE_grid(posNeighborhood(i,1),posNeighborhood(i,2));
        end
        
        othersPDs = VAE_pds(randi(900,100,1));
        
        allDiffNeighborPDs = [allDiffNeighborPDs abs(neighborsPDs - thisPD)];
        allDiffOtherPDs = [allDiffOtherPDs abs(othersPDs - thisPD)];

    end
end

figure; histogram(acos(cos(allDiffNeighborPDs)),20,'Normalization','probability')
figure; histogram(acos(cos(allDiffOtherPDs)),20,'Normalization','probability')

%% Orientation difference as a function of horizontal distance

for row = 1:40

neighborsPDs = VAE_grid(row,:);

diffPDs(row,:) = abs(neighborsPDs(2:end) - neighborsPDs(1));


end

figure; plot((acos(cos(diffPDs))))
%% Plot data distributions
pos = vertcat(trial_data.pos);
vel = vertcat(trial_data.vel);

%HAND POS
dataFigPos = figure; hold on;
dataFigPos.Color = 'white';

posYax = subplot(4,4,[1 5 9]); 
histogram(pos(:,2),'Orientation','horizontal','EdgeColor','none')
posYax.Box = 'off';
% posYax.XTick = [];
% posYax.YTick = [];

posXax = subplot(4,4,[14:16]); 
histogram(pos(:,1),'Orientation','vertical','EdgeColor','none')
posXax.Box = 'off';
% posXax.YTick = [];
% posXax.XTick = [];

posTotal = subplot(4,4,[2:4 6:8 10:12]); 
plot(pos(:,1),pos(:,2))
% posTotal.YTick = [];
% posTotal.XTick = [];

%HAND VEL
dataFigVel = figure; hold on;
dataFigVel.Color = 'white';

velYax = subplot(4,4,[1 5 9]); 
histogram(vel(:,2),'Orientation','horizontal','EdgeColor','none')
velYax.Box = 'off';
% velYax.XTick = [];
% velYax.YTick = [];

velXax = subplot(4,4,[14:16]); 
histogram(vel(:,1),'Orientation','vertical','EdgeColor','none')
velXax.Box = 'off';
% velXax.YTick = [];
% velXax.XTick = [];

velTotal = subplot(4,4,[2:4 6:8 10:12]); 
plot(vel(:,1),vel(:,2))
% velTotal.YTick = [];
% velTotal.XTick = [];

