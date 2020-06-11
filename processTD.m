function td = processTD(td,params)

% Smooth spikes, get split TD, get movement onsets, get rid of unsorted units

%Smooth spikes
smoothParams.signals = {'S1_spikes'};
smoothParams.width = 0.05;
smoothParams.calc_rate = true;
td.S1_spikes_bins = td.S1_spikes;
td = smoothSignals(td,smoothParams);


%Get speed
td.speed = sqrt(td.vel(:,1).^2 + td.vel(:,2).^2);

%Get traj
td.traj = atan2(td.vel(:,2),td.vel(:,1));

%Get rectified velocity
td.vel_rect = [td.vel(:,1) td.vel(:,2) -td.vel(:,1) -td.vel(:,2)];
td.vel_rect(td.vel_rect < 0) = 0;

%Get accel
td.acc = diff(td.vel)./td.bin_size;
td.acc(end+1,:) = td.acc(end,:);

%Remove offset
td.pos(:,1) = td.pos(:,1)+0;
td.pos(:,2) = td.pos(:,2)+32;

% Smooth kinematic variables
smoothParams.signals = {'pos','vel','acc','force'};
smoothParams.width = 0.03;
smoothParams.calc_rate = false;
td = smoothSignals(td,smoothParams);

%Get rid of unsorted units
sorted_idx = find(td.S1_unit_guide(:,2)~=0);
td.S1_spikes = td.S1_spikes(:,sorted_idx);
td.S1_spikes_bins = td.S1_spikes_bins(:,sorted_idx);
td.S1_unit_guide = td.S1_unit_guide(sorted_idx,:);

%Split TD
splitParams.split_idx_name = 'idx_startTime';
splitParams.linked_fields = {'result','trialID','bumpDir','tgtDir'};
td = splitTD(td,splitParams);


td([td.result] == 'A') = [];

moveParams.start_idx = 'idx_goCueTime';
moveParams.which_field = 'speed';
td = getMoveOnsetAndPeak(td,moveParams);

end