%Get map of cambridge bay coastline
clc;  clear all ; close all; %reset workspace
addpath('c:\Users\rps207\Documents\Matlab\Functions');
addpath('c:\Users\rps207\Documents\Matlab\Functions\Add_Axis');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cbdate');
addpath('c:\Users\rps207\Documents\Matlab\Functions\m_map');
addpath('c:\Users\rps207\Documents\Matlab\Functions\mixing_library');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cm_and_cb_utilities');
mfileDir = 'C:\Users\rps207\Documents\Matlab\CO2 NSOP output analysis\'; %path for main matlab analysis

load('C:\Users\rps207\Documents\Data\Coastline and bathymetry data/bathymetry_cambay.mat')


degree_symbol= sprintf('%c', char(176));
micro_symbol= sprintf('%c', char(0181));
tau_symbol= sprintf('%c', char(0964));

%%% Custom RGB colour vectors

colour_teal = [18 150 155] ./ 255;
colour_lightgreen = [94 250 81] ./ 255;
colour_green = [12 195 82] ./ 255;
colour_lightblue = [8 180 238] ./ 255;
colour_darkblue = [1 17 181] ./ 255;
colour_yellow = [251 250 48] ./ 255;
colour_peach = [251 111 66] ./ 255;
colour_crimson = [220,20,60] ./ 255;
colour_verylightblue = [204 255 229] ./ 255;
colour_peachback = [255 255 204] ./ 255;
colour_yellowlight = [255 255 100] ./ 255;
colour_rose = [253 153 153] ./ 255;
colour_greyshade= [192 192 192] ./ 255;
colour_violet = [238,130,238] ./ 255;
colour_orangelight = [255,178,102] ./ 255;


colour_indigo = [75,0,130] ./ 255;
colour_mustard = [204 204 0] ./ 255;
colour_firebrick = [178,34,34] ./ 255;
colour_darkkhaki = [189,183,107] ./ 255;
colour_darkgrey = [169,169,169] ./ 255;
colour_rosybrown = [188,143,143] ./ 255;
colour_aquamarine = [127,255,212] ./ 255;
colour_olivedrab= [107,142,35] ./ 255;
colour_goldenrod= [218,165,32] ./ 255;
colour_brown = [165,42,42] ./ 255;
colour_purple = [76,0,153] ./ 255;
colour_lightred = [255,51,51] ./ 255;
colour_indianred = [205,92,92] ./ 255;
colour_darksalmon = [233,150,122] ./ 255;
colour_darkorange = [255,140,0] ./ 255;
colour_forestgreen= [34,139,34] ./ 255;
colour_limegreen= [50,205,50] ./ 255;
colour_springgreen = [0,250,154] ./ 255;
colour_mediumseagreen = [60,179,113] ./ 255;
colour_siennna = [160,82,45] ./ 255;
colour_sandybrown = [244,164,96] ./ 255;


colour_orchid = [218,112,214] ./ 255;
colour_cornflowerblue = [100,149,237] ./ 255;
colour_mediumturquoise= [72,209,204] ./ 255;
colour_coral= [255,127,80] ./ 255;
colour_orange = [255,165,0] ./ 255;
colour_khaki = [240,230,140] ./ 255;

%get latitude and longitude of B,R,G,Y,O lines and other sites
%lat/long as deg min sec
[~, ~, raw] = xlsread('C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\CTD\Bergmann\Station_coords.xls','Sheet1','A3:C43');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[1,2,3]);
Site_degmin = cellVectors(:,1);
Lat_degmin = char(cellVectors(:,2));
Long_degmin = char(cellVectors(:,3));
clearvars data raw cellVectors;
%convert to decimal degrees
Lat=str2num(Lat_degmin(:,1:2))+(str2num(Lat_degmin(:,4:9))/60);
Long=str2num(Long_degmin(:,1:3))+(str2num(Long_degmin(:,5:10))/60);
%lat/long as deg decimal
[~, ~, raw] = xlsread('C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\CTD\Bergmann\Station_coords.xls','Sheet1','E3:G75');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,1);
raw = raw(:,[2,3]);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));
Site_degdec = cellVectors(:,1);
Lat_degdec = data(:,1);
Long_degdec = data(:,2);
clearvars data raw cellVectors R;
Site_name=[Site_degmin ; Site_degdec];
Site_lat=[Lat; Lat_degdec];
Site_long=[-1*Long; Long_degdec];

clearvars ans lat Lat Lat_degdec Lat_degmin long Long Long_degdec Long_degmin Site_degdec Site_degmin



figure(1)
m_proj('Sinusoidal','lon',[-110 -103],'lat',[68.7 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',22)
hold on
p=m_contour(longcambridge,latcambridge,bathymetrycambridge',[-80:1:-15],'ShowText','on');
m_gshhs_f('patch',[.5 .5 .5]);

figure(2)
m_proj('Sinusoidal','lon',[-107 -103],'lat',[68 69.6]);  
m_grid('linestyle','none','tickdir','out','fontsize',22)
hold on
% p=m_contour(longcambridge,latcambridge,bathymetrycambridge',[-80:5:-15],'ShowText','on');
m_gshhs_f('patch',colour_greyshade);

%add flux tower
[C,D]=m_ll2xy( -105.834386,68.984157);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
[CC,D]=m_ll2xy( -105.834386,68.984157);
text(CC,D,['Finlayson' char(10) 'Islands'],'HorizontalAlignment', 'right','VerticalAlignment', 'bottom','fontsize',11);

%add Cmbridge Bay
[C,D]=m_ll2xy( -105.059401,69.124070);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
[CC,D]=m_ll2xy( -105.55401,69.084070);
text(CC,D,['Cambridge' char(10) '  Bay'],'HorizontalAlignment', 'left','VerticalAlignment', 'bottom','fontsize',11);

%add Greiner
[C,D]=m_ll2xy( -104.925246,69.190907);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
[CC,D]=m_ll2xy( -104.925246,69.190907);
text(CC,D,'Greiner Lake','HorizontalAlignment', 'left','VerticalAlignment', 'bottom','fontsize',11);

%add site labels
for i=1:3
[C,D]=m_ll2xy( Site_long(i),Site_lat(i));
line(C,D,'marker','square','markersize',4,'MarkerFaceColor','b','color','b');
[CC,D]=m_ll2xy(Site_long(i)+0.05,Site_lat(i));
text(CC,D,Site_name(i),'HorizontalAlignment', 'left','VerticalAlignment', 'Middle', 'Color','b','fontsize',10,'FontWeight','Bold');
end
%add site labels
for i=4:8
[C,D]=m_ll2xy( Site_long(i),Site_lat(i));
line(C,D,'marker','square','markersize',4,'MarkerFaceColor','r','color','r');
[CC,D]=m_ll2xy(Site_long(i),Site_lat(i));
text(CC,D,Site_name(i),'HorizontalAlignment', 'left','VerticalAlignment', 'top', 'Color','r','fontsize',10,'FontWeight','Bold');
end
%add site labels
for i=9:13
[C,D]=m_ll2xy( Site_long(i),Site_lat(i));
line(C,D,'marker','square','markersize',4,'MarkerFaceColor','g','color','g');
[CC,D]=m_ll2xy(Site_long(i),Site_lat(i));
text(CC,D,Site_name(i),'HorizontalAlignment', 'left','VerticalAlignment', 'bottom', 'Color','g','fontsize',10,'FontWeight','Bold');
end
%add site labels
for i=14:18
[C,D]=m_ll2xy( Site_long(i),Site_lat(i));
line(C,D,'marker','square','markersize',4,'MarkerFaceColor','y','color','y');
[CC,D]=m_ll2xy(Site_long(i),Site_lat(i));
text(CC,D,Site_name(i),'HorizontalAlignment', 'left','VerticalAlignment', 'top', 'Color','y','fontsize',10,'FontWeight','Bold');
end
%add site labels
for i=19:23
[C,D]=m_ll2xy( Site_long(i),Site_lat(i));
line(C,D,'marker','square','markersize',4,'MarkerFaceColor',colour_orange,'color',colour_orange);
[CC,D]=m_ll2xy(Site_long(i),Site_lat(i));
text(CC,D,Site_name(i),'HorizontalAlignment', 'left','VerticalAlignment', 'top', 'Color',colour_orange,'fontsize',10,'FontWeight','Bold');
end
set(gca,'fontsize',22)
y=ylabel('Latitude');
set(y,'Units','Normalized','Position',[-0.15,0.5,0]);
set(gca,'fontsize',22)
xlabel('Longitude');
set(gca,'fontsize',22)






w=genpath('c:\Users\rps207\Documents\Matlab\Functions');
addpath(w)
addpath('c:\Users\rps207\Documents\Matlab\Functions');
addpath('c:\Users\rps207\Documents\Matlab\Functions\Add_Axis');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cbdate');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cbrewer');
addpath('c:\Users\rps207\Documents\Matlab\Functions\m_map');
addpath('c:\Users\rps207\Documents\Matlab\Functions\mixing_library');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cm_and_cb_utilities');
p=genpath('C:\Users\rps207\Documents\MATLAB\Functions\contourfcmap');
addpath(p)



figure3=figure(3);
set(gcf, 'Position', get(0, 'Screensize'));
m_proj('Sinusoidal','lon',[-117 -92],'lat',[66.6 70.25]);
clf
m_grid('linestyle','none','tickdir','out','fontsize',22,'backcolor',[[0.0392200000000000 0 0.474510000000000]])
hold on
[CS,CH]=m_contourf(longcambridge,latcambridge,bathymetrycambridge',[-400 -350 -300 -250 -200 -150 -100 -80 -60 -40 -20 0],'edgecolor','n','ShowText','on');
m=colormap([ m_colmap('water')]);
% newNum = 128; % new number of elements in the "buffed" vector
% col1 = interp1( linspace(0,1,numel(m(:,1))), m(:,1), linspace(0,1,newNum) )';
% col2 = interp1( linspace(0,1,numel(m(:,2))), m(:,2), linspace(0,1,newNum) )';
% col3 = interp1( linspace(0,1,numel(m(:,3))), m(:,3), linspace(0,1,newNum) )';
% new_cmap=[col1 , col2,col3];
% colormap(new_cmap);
hold on
[ax,h]=m_contfbar([.25 .75],.9,CS,CH,'levels','match','endpiece','yes','axfrac',.03);
title(ax,'Depth (m)')
set(ax,'XTick',[-400 -350 -300 -250 -200 -150 -100 -80 -60 -40 -20 0])
caxis([-400 000]);
set(gcf,'color','w');
hold on;
set(gca,'color',[0.737250000000000 0.901960000000000 1]);
m_gshhs_f('patch',colour_darkkhaki);
m_gshhs('fr');              % full resolution rivers


%add flux tower
[C,D]=m_ll2xy( -105.834386,68.984157);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
% [CC,D]=m_ll2xy( -105.204386,68.684157);
% text(CC,D,['Qikirtaarjuk ' char(10) 'Island'],'HorizontalAlignment', 'right','VerticalAlignment', 'bottom','fontsize',11);
annotation(figure3,'textarrow',[0.485416666666667 0.480729166666667],...
    [0.46969696969697 0.597979797979798],'TextBackgroundColor',[1 1 1],...
    'String',{'Qikirtaajuk','Island'},'LineWidth',2,'HorizontalAlignment','center');

%add Cambridge Bay
[C,D]=m_ll2xy( -105.059401,69.124070);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
% [CC,D]=m_ll2xy( -105.70401,69.144070);
% text(CC,D,['Cambridge' char(10) '  Bay'],'HorizontalAlignment', 'left','VerticalAlignment', 'bottom','fontsize',11);
annotation(figure3,'textarrow',[0.476041666666667 0.501041666666667],...
    [0.702020202020202 0.63030303030303],'TextBackgroundColor',[1 1 1],...
    'String',{'Cambridge',' Bay'},'LineWidth',2,'HorizontalAlignment', 'center');

%add ONC mooring
[C,D]=m_ll2xy( -105.062700,69.113548);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
% [CC,D]=m_ll2xy( -104.862700,68.973548);
% text(CC,D,['ONC' char(10) 'mooring'],'HorizontalAlignment', 'left','VerticalAlignment', 'bottom','fontsize',11);
annotation(figure3,'textarrow',[0.526041666666667 0.504166666666667],...
    [0.626262626262626 0.62020202020202],'TextBackgroundColor',[1 1 1],...
    'String',{'ONC','mooring'},'LineWidth',2,'HorizontalAlignment', 'center');

%add Kugluktuk
[C,D]=m_ll2xy( -115.097547,67.829095);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
% [CC,D]=m_ll2xy( -115.997547,67.709095);
% text(CC,D,['Kugluktuk '],'HorizontalAlignment', 'left','VerticalAlignment', 'bottom','fontsize',11);
annotation(figure3,'textarrow',[0.213541666666667 0.206770833333333],...
    [0.365656565656566 0.421212121212121],'TextBackgroundColor',[1 1 1],...
    'String',{'Kugluktuk'},'LineWidth',2,'HorizontalAlignment', 'center');

%add GJOA Haven
[C,D]=m_ll2xy(-95.888118,68.634140);
line(C,D,'marker','o','markersize',4,'MarkerFaceColor','k','color','k');
% [CC,D]=m_ll2xy(-95.838118,68.674140);
% text(CC,D,['Gjoa' char(10) 'Haven'],'HorizontalAlignment', 'left','VerticalAlignment', 'bottom','fontsize',11);
annotation(figure3,'textarrow',[0.740625 0.7609375],...
    [0.582828282828283 0.553535353535354],'TextBackgroundColor',[1 1 1],...
    'String',{'Gjoa','Haven'},'LineWidth',2,'HorizontalAlignment', 'center');

%wellington bay
annotation(figure3,'textarrow',[0.380729166666667 0.459375],...
    [0.719191919191919 0.661616161616162],'TextBackgroundColor',[1 1 1],...
    'String',{'Wellington','Bay'},'LineWidth',2,'HorizontalAlignment', 'center');


%add location text lbels
m_text(-108.003176,68.752776,'Dease Strait','fontsize',11,'Rotation',35,'color','k','Fontweight','bold','BackgroundColor',[1 1 1]);
m_text( -111.347961,68.002500,'Coronation Gulf','fontsize',11,'Rotation',32,'color','k','Fontweight','bold','BackgroundColor',[1 1 1]);
m_text(-102.849481,68.308981,'Queen Maud Gulf','fontsize',11,'color','k','Fontweight','bold','BackgroundColor',[1 1 1]);
m_text(-107.856297,66.856182,'Bathurst Inlet','fontsize',11,'color','k','Fontweight','bold','BackgroundColor',[1 1 1]);
m_text(-95.859351,67.581034,'Chantrey Inlet','fontsize',11,'color','k','Fontweight','bold','BackgroundColor',[1 1 1]);
m_text( -116.763608,69.356196,'Dolphin and Union Strait','fontsize',11,'Rotation',323,'color','k','Fontweight','bold','BackgroundColor',[1 1 1]);
m_text(-101.252728,69.027542,'Victoria Strait','fontsize',11,'Rotation',35,'color','k','Fontweight','bold','BackgroundColor',[1 1 1]);
 
set(gca,'fontsize',22)
y=ylabel(['Latitude (' degree_symbol 'N)']);
set(y,'Units','Normalized','Position',[-0.065,0.5,0]);
set(gca,'fontsize',22)
x=xlabel(['Longitude (' degree_symbol 'W)']);
set(gca,'fontsize',22)
set(x,'Units','Normalized','Position',[0.5,-0.13,0]);


export_fig('jpg','C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Kitikmeot map')