% Minimum Spanning Tree using kruskal's algorithm
% coded by Jose Fiel

clear all; close all; clc;
band ='alpha1'; % theta, alpha1, alpha2, beta, logamma 
 
uigetfile % load dwpli_control_band file
uigetfile % load dwpli_exp_band file

%% to plot the group averages, uncomment the next two lines
dwpli_control = mean(dwpli_control,3);
dwpli_exp = mean(dwpli_exp,3);

%% to plot a particular participants, uncomment the next two lines
% dwpli_control = squeeze(dwpli_control(:,:,6));
% dwpli_exp = squeeze(dwpli_exp(:,:,5));

%%
G_control= graph(dwpli_control)
G_exp= graph(dwpli_exp)

cd('.\MST_Kruskal\MST_Kruskal')

[w_control T_control] = kruskal(table2array(G_control.Edges));
[w_exp T_exp] = kruskal(table2array(G_exp.Edges));

load('labels1020_new.mat');
node_names=labels1020;

G_mst_control = graph(T_control,node_names)
G_mst_exp = graph(T_exp,node_names)

%%
subplot(121)
plot(G_mst_control,'MarkerSize',6,'NodeColor',[0 0 0],...
    'LineWidth',2,...
    'EdgeColor',[0 0 0],...
    'EdgeLabel',{},...
    'NodeLabelMode','auto',...
    'Layout',...
    'layered')
title('Control','FontSize',8)
set(gca, 'XTick', [],'YTick', [],'XColor',[1 1 1],'XTick',[],'YColor',[1 1 1],'YTick',[],...
    'ZColor',[1 1 1]); hold on
ylim([0 12])
% axis tight
subplot(122)
plot(G_mst_exp,'MarkerSize',6,'NodeColor',[0 0 0],...%[1 0 1]
    'LineWidth',2,...
    'EdgeColor',[0 0 0],... %[1 0 1]
    'EdgeLabel',{},...
    'NodeLabelMode','auto',...
    'Layout',...
    'layered')
title('RE','FontSize',8)
set(gca, 'XTick', [],'YTick', [],'XColor',[1 1 1],'XTick',[],'YColor',[1 1 1],'YTick',[],...
    'ZColor',[1 1 1]);
ylim([0 12])
% axis tight
%%
% cd(['.\' band '_dwpli_all\'])
% save(['mst_average_' band])
% 
% saveas(gcf,['mst_average_' band],'tif')
