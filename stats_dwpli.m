% dWPLI statistical analysis
clear all; clc; close all;

band = ''; % theta, alpha1, alpha2, beta, logamma

load('labels1020_new')
% load 3D matrices (chan x chan x participants = 20 x 20 x 7) 
uigetfile;
uigetfile;
control = (dwpli_control);
exp = (dwpli_exp);

%%
idxF = find(contains(labels1020,'F')); % F-frontal, 
idxC = find(contains(labels1020,'C') | contains(labels1020,'T')); % C-central, and T-temporal,
idxP = find(contains(labels1020,'P')); % P-parietal, 
idxO = find(contains(labels1020,'O')); % O-occipital 

%%
FC = struct; 

FC.ctrl = reshape(control(idxF,idxC,:),[],1);
FC.exp = reshape(exp(idxF,idxC,:),[],1);

[FC.p,FC.h] = ranksum(FC.ctrl,FC.exp,0.01); % This test is equivalent to a Mann-Whitney U-test
											% for more info about it check :
											% https://www.mathworks.com/help/stats/ranksum.html	
figure
boxplot([FC.ctrl,FC.exp],'Labels',{'CONTROL','TLE'},'Widths',0.2)
title('FC')
cd('D:\Diss_Dados\StatsTests\')
saveas(gcf,strcat(band,'_FC'),'tif')

%% 
FP = struct; 

FP.ctrl = reshape(control(idxF,idxP,:),[],1);
FP.exp = reshape(exp(idxF,idxP,:),[],1);

[FP.p,FP.h] = ranksum(FP.ctrl,FP.exp,0.01);

figure
boxplot([FP.ctrl,FP.exp],'Labels',{'CONTROL','TLE'},'Widths',0.2)
title('FP')
saveas(gcf,strcat(band,'_FP'),'tif')

%% 
FO = struct; 

FO.ctrl = reshape(control(idxF,idxO,:),[],1);
FO.exp = reshape(exp(idxF,idxO,:),[],1);

[FO.p,FO.h] = ranksum(FO.ctrl,FO.exp,0.01);

figure
boxplot([FO.ctrl,FO.exp],'Labels',{'CONTROL','TLE'},'Widths',0.2)
title('FO')
saveas(gcf,strcat(band,'_FO'),'tif')

%%
CP = struct; 

CP.ctrl = reshape(control(idxC,idxP,:),[],1);
CP.exp = reshape(exp(idxC,idxP,:),[],1);

[CP.p,CP.h] = ranksum(CP.ctrl,CP.exp,0.01);

figure
boxplot([CP.ctrl,CP.exp],'Labels',{'CONTROL','TLE'},'Widths',0.2)
title('CP')
saveas(gcf,strcat(band,'_CP'),'tif')

%% 
CO = struct; 

CO.ctrl = reshape(control(idxC,idxO,:),[],1);
CO.exp = reshape(exp(idxC,idxO,:),[],1);

[CO.p,CO.h] = ranksum(CO.ctrl,CO.exp,0.01);

figure
boxplot([CO.ctrl,CO.exp],'Labels',{'CONTROL','TLE'},'Widths',0.2)
title('CO')
saveas(gcf,strcat(band,'_CO'),'tif')

%% 
PO = struct; 

PO.ctrl = reshape(control(idxP,idxO,:),[],1);
PO.exp = reshape(exp(idxP,idxO,:),[],1);

[PO.p,PO.h] = ranksum(PO.ctrl,PO.exp,0.01);

figure
boxplot([PO.ctrl,PO.exp],'Labels',{'CONTROL','TLE'},'Widths',0.2)
title('PO')
saveas(gcf,strcat(band,'_PO'),'tif')

