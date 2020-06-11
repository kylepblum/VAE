clear, clc
pathname = '/Users/kylepblum/Koofr/Limblab/Data/S1-topography/Data/';
filename{1} = [pathname 'Chips_20170913_S1-topography.mat'];

load(filename{1});
trial_data = processTD(trial_data,[]);

catSpeeds = vertcat(trial_data.speed);
catTraj = vertcat(trial_data.traj);
catFRs = vertcat(trial_data.S1_spikes);

vels = 0:2.5:51;
trajs = -pi:pi/10:pi+pi/25;

trial_data = trimTD(trial_data,{'idx_movement_on',0},{'idx_movement_on',10});

for nCell = 1:size(catFRs,2)
   for idxVel = 1:numel(vels)-1
       for idxTraj = 1:numel(trajs)-1
           
           FR(nCell,idxVel,idxTraj) = ...
               mean(catFRs(catSpeeds > vels(idxVel) & catSpeeds < vels(idxVel+1) ...
                    & catTraj > trajs(idxTraj) & catTraj < trajs(idxTraj+1),nCell));
       end
   end
end

for i = 1:10
    figure;
    heatmap(squeeze(FR(i,:,:)))
end