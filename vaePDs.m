TDparams.out_signals = 'S1_spikes';
TDparams.in_signals = 'vel';
TDparams.num_boots = 1;
% trial_data = trial_data(1:end-1); %Problem with last trial(s)?

VAE_pdTable = getTDPDs(trial_data,TDparams);