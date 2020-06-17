function gridElec = spikeArray2Grid_PC(params)

%Get Mapfile from server
if strcmpi(params.monkey,'Han')
    filepath = 'L:\limblab\lab_folder\Animal-Miscellany\Han_13B1\map files\Left S1';
    data = readtable([filepath filesep 'SN 6251-001459.txt'],'HeaderLines',14);
    
elseif strcmpi(params.monkey,'Duncan')
    filepath = 'L:\limblab\lab_folder\Animal-Miscellany\Duncan_17L1\mapfiles\left S1 20190205';
    data = readtable([filepath filesep 'SN 6251-002087.txt'],'HeaderLines',14,'Format','%f%f%s%f%s');
%     data = tdfread([filepath filesep 'SN 6251-002087.txt']);
    
elseif strcmpi(params.monkey,'Lando')
    filepath = ['/Volumes/L_MillerLab/limblab-archive/'...
        'Retired Animal Logs/Monkeys/Lando_13B2/Map files/LeftS1'];
    data = readtable([filepath filesep 'SN 6251-001701.txt'],'HeaderLines',14);
    
elseif strcmpi(params.monkey,'Kramer')
    filepath = ['/Volumes/L_MillerLab/limblab-archive/'...
        'Retired Animal Logs/Monkeys/Kramer 10I1/Kramer sept 2012 implant array mapping'];
    data = readtable([filepath filesep '6251-0922 MAP.txt'],'HeaderLines',14);
    
elseif strcmpi(params.monkey,'Chips')
    filepath = ['\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\' ...
    'Basic_Sciences\Phys\L_MillerLab\limblab-archive\Retired Animal Logs\' ...
    'Monkeys\Chips_12H1\map_files\left S1'];
    data = readtable([filepath filesep 'SN 6251-001455.txt'],'HeaderLines',14);
    
elseif strcmpi(params.monkey,'Chewie')
    filepath = ['\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\' ...
        'Basic_Sciences\Phys\L_MillerLab\limblab-archive\' ... 
        'Retired Animal Logs\Monkeys\Chewie 8I2'];
    
    data = readtable([filepath filesep 'Chewie_leftPMd_copy.txt']);


end


%Convert Blackrock numbering to something useful
col = data.Var1 + 1;
row = data.Var2 + 1;
bank = data.Var3;
elec = data.Var4;

for i = 1:96
    if strcmpi(bank{i},'A')
        bankNum(i) = 0;
    elseif strcmpi(bank{i},'B')
        bankNum(i) = 32;
    elseif strcmpi(bank{i},'C')
        bankNum(i) = 64;
    end
    
    elecNum(i) = bankNum(i) + elec(i);
end

gridElec = zeros(10,10);

for i = 1:96
    gridElec(row(i),col(i)) = elecNum(i);
end


gridElec = flip(gridElec);

end




