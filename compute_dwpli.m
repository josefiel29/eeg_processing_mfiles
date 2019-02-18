% Coded by Jose Fiel
% this code requires fieldtrip toolbox
clear all; clc;

% add fieldtrip to path
dir_fieldtrip = uigetdir;
addpath(dir_fieldtrip) 
ft_defaults

%%
id = '017'; % change participant id: 001,002,003,...,017
load('.\Participants\labels1020.mat');
cd(['.\Participants\' id]);
load(['subj' id '.mat']);

%% hit control + f to change the participant id faster

data =[]; % We are spliting the 9min EEG recording into N trials
N = 2*9; % number of trials
data.fsample = subj017.srate; % sampling frequency 

% please, uncomment the next line only for subj009
% subj009.data=reshape(subj009.data(:,1:end-1),20,[],N); 

data.data = reshape(subj017.data,20,[],N); % create 3D matrix
data.trial = squeeze(num2cell(data.data,[1 2]))';
data.time = num2cell(repmat(0:1/data.fsample:(floor((subj017.pnts*subj017.trials-2)/N))/data.fsample,N,1),[2])';
data.label = labels1020; % labels used in the EEG recording

%% Performing fft
cfg = [];
cfg.tapsmofrq = 2; % should always be 1 to get tf
cfg.keeptrials = 'yes';
cfg.toi = data.time{1}; % time of interest
cfg.foilim = [4 90]; % frequency of interest

% frequency analysis
cfg.method = 'mtmfft'; % implements multitaper frequency transformation
cfg.output = 'fourier'; % return the complex Fourier-spectra

freq = ft_freqanalysis(cfg,data); 
mkdir('Matrizes');
save('.\Matrizes\freq.mat','freq');

%% Connectivity
%path to matrixcon
path_matrices_mCon = strcat('.\Matrizes\Con_Matrices\','wpli_debiased\subj',id);
mkdir(path_matrices_mCon);

%dWPLI ---------------------------------------------
cfg = [];
cfg.method = 'wpli_debiased';
wpli_data = ft_connectivityanalysis(cfg, freq);

m = abs(wpli_data.wpli_debiasedspctrm);
m(isnan(m))=0;
wpli_data.wpli_debiasedspctrm = m;
save(strcat(path_matrices_mCon,'\wpli_data.mat'),'wpli_data');

C = wpli_data.wpli_debiasedspctrm;
save(strcat(path_matrices_mCon,'\C.mat'),'C');
wpli_spctrm = squeeze(C);% spectral coherence
S.wpli_spctrm = wpli_spctrm;

wpli_freq = squeeze(wpli_data.freq);
S.wpli_freq = wpli_freq;
save(strcat(path_matrices_mCon,'wpli_freq.mat'),'wpli_freq');

%% Connectivity per bandwidth
% teta -> 4  - 8Hz
% alfa1-> 8  - 10Hz
% alfa2-> 10 - 13Hz
% beta -> 13 - 30Hz
%logam -> 30 - 45Hz

%Array of bandwidths
bdw = {'teta','alpha1','alpha2','beta','lo_gam','hi_gam','gam'};
% Matrix of each bandwidth
dwpli_all = wpli_spctrm(:,:,(1:end));
dwpli_teta  = wpli_spctrm(:,:,(1:find((freq.freq==8)>0)));
dwpli_alfa1 = wpli_spctrm(:,:,(find((freq.freq==8)>0)+1:find((freq.freq==10)>0)));
dwpli_alfa2 = wpli_spctrm(:,:,(find((freq.freq==10)>0)+1:find((freq.freq==13)>0)));
dwpli_alfa = wpli_spctrm(:,:,(find((freq.freq==8)>0)+1:find((freq.freq==13)>0)));
dwpli_beta = wpli_spctrm(:,:,(find((freq.freq==13)>0)+1:find((freq.freq==30)>0)));     
dwpli_logam = wpli_spctrm(:,:,(find((freq.freq==30)>0)+1:find((freq.freq==45)>0)));
% dwpli_higam = wpli_spctrm(:,:,(find((freq.freq==65)>0)+1:end));
dwpli_gam = wpli_spctrm(:,:,(find((freq.freq==30)>0)+1:end));

%Saving .mat
save(strcat(path_matrices_mCon,'dwpli_all.mat'),'dwpli_all');
save(strcat(path_matrices_mCon,'dwpli_teta.mat'),'dwpli_teta');
save(strcat(path_matrices_mCon,'dwpli_alfa1.mat'),'dwpli_alfa1');
save(strcat(path_matrices_mCon,'dwpli_alfa2.mat'),'dwpli_alfa2');
save(strcat(path_matrices_mCon,'dwpli_alfa.mat'),'dwpli_alfa');
save(strcat(path_matrices_mCon,'dwpli_beta.mat'),'dwpli_beta');
save(strcat(path_matrices_mCon,'dwpli_logam.mat'),'dwpli_logam');
% save(strcat(path_matrices_mCon,'dwpli_higam.mat'),'dwpli_higam');
save(strcat(path_matrices_mCon,'dwpli_gam.mat'),'dwpli_gam');

