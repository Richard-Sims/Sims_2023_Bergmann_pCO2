%plots and analysis script for Kitikmeot Bergmann pCO2

%% set the Matlab workspace and add all required functions
clc;  clear all ; close all; %reset workspace
addpath('c:\Users\rps207\Documents\Matlab\Functions');
addpath('c:\Users\rps207\Documents\Matlab\Functions\Add_Axis');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cbdate');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cbrewer');
addpath('c:\Users\rps207\Documents\Matlab\Functions\mixing_library');
addpath('c:\Users\rps207\Documents\Matlab\Functions\despiking_tooblox');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cm_and_cb_utilities');
addpath('c:\Users\rps207\Documents\Matlab\Functions\tsplot');
addpath('c:\Users\rps207\Documents\Matlab\Functions\m_map');
mfileDir = 'C:\Users\rps207\Documents\MATLAB\2019 - Bergmann pCO2 2016 -2019\'; %path for main matlab analysis
addpath('C:\Users\rps207\Documents\MATLAB\Functions\Colormaps\Colormaps (5)\Colormaps');
% [cm_data]=inferno();
% set(groot,'DefaultFigureColormap',cm_data)
p=genpath('C:\Users\rps207\Documents\MATLAB\Functions\contourfcmap');
addpath(p)


% Load in data from all sources
%% load in Custom RGB colour vectors and symbols used for plotting
degree_symbol= sprintf('%c', char(176));
micro_symbol= sprintf('%c', char(0181));
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
colour_purple = [128,0,128] ./ 255;
colour_lightred = [255,51,51] ./ 255;
colour_indianred = [205,92,92] ./ 255;
colour_siennna = [233,150,122] ./ 255;
colour_darkorange = [255,140,0] ./ 255;
colour_forestgreen= [34,139,34] ./ 255;
colour_siennna= [50,205,50] ./ 255;
colour_springgreen = [0,250,154] ./ 255;
colour_mediumseagreen = [60,179,113] ./ 255;
colour_siennna = [160,82,45] ./ 255;
colour_siennna = [244,164,96] ./ 255;
colour_navajowhite=[255,222,173]./ 255;
colour_azure=[240,255,255]./ 255;
colour_saddlebrown=[139,69,19]./ 255;
colour_orchid = [218,112,214] ./ 255;
colour_cornflowerblue = [100,149,237] ./ 255;
colour_mediumturquoise= [72,209,204] ./ 255;
colour_coral= [255,127,80] ./ 255;
colour_orange = [255,165,0] ./ 255;
colour_khaki = [240,230,140] ./ 255;
%% loads in sites
%this 
path_site_locations=('C:\Users\rps207\Documents\Postdoc - Calgary\Site Locations.txt');
dataimp=dlmread(path_site_locations,'\t',0, 1); %open licor text file
site_longitudes=dataimp(:,1);
site_latitudes=dataimp(:,2);
delimiter = '\t';formatSpec = '%s%*s%*s%[^\n\r]';fileID = fopen(path_site_locations,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);
sitenames = dataArray{:, 1};
clearvars filename delimiter formatSpec fileID dataArray ans;
%% load in cambridge bay bathymetry data
load('C:\Users\rps207\Documents\Data\Coastline and bathymetry data/bathymetry_cambay.mat')
%% load in processed CO2 data files 
load('2016_undpCO2_proc.mat')
load('2017_undpCO2_proc.mat')
load('2018_undpCO2_proc.mat')
load('2019_undpCO2_proc.mat')
%% combine pCO2 data for every year
dt_all=[Berg16_co2_dt; Berg17_co2_dt; Berg18_co2_dt; Berg19_co2_dt];
TSG_T_all=[Berg16_co2_TSG_t; Berg17_co2_TSG_t; Berg18_co2_TSG_t; Berg19_co2_TSG_t];
equtemp_all=[Berg16_co2_equtemp; Berg17_co2_equtemp; Berg18_co2_equtemp; Berg19_co2_equtemp];
Skin_temp_all=[Berg16_co2_Skin_temp; Berg17_co2_Skin_temp; Berg18_co2_Skin_temp; Berg19_co2_Skin_temp];
Sea_temp_all=[Berg16_co2_SST_1m; Berg17_co2_Sea_temp; Berg18_co2_Sea_temp; Berg19_co2_SST_1m];
all_pco2_surface=[Berg16_co2_pco2_surface;Berg17_co2_pco2_surface;Berg18_co2_pco2_surface;Berg19_co2_pco2_surface];
%% load in tower CO2 and smooth
load('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/pco2.mat')
Island_pco2=pco2;
Island_tmaster=tmaster;
%smooth further to dampen noise from the outliers
Island_pco2_smoothed=smooth(Island_pco2,80);
%% load in ONC CO2 from Patrick
load('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2\Patricks ONC data/dailydata17.mat')
ONC_17_dt=dailydata17(:,1);
ONC_17_pCO2=dailydata17(:,2);
load('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2\Patricks ONC data/dailydata16.mat')
ONC_16_dt=dailydata16(:,1);
ONC_16_pCO2=dailydata16(:,2);
load('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2\Patricks ONC data/dailydata15.mat')
ONC_15_dt=dailydata15(:,1);
ONC_15_pCO2=dailydata15(:,2);
%Data columns in dailydata{yy}.mat
% 1 Time
% 2 pCO2 Pro-Oceanus [µatm]
% 3 pH SeaFET int
% 4 DIC [µmol/kg SW]
% 5 TA [µmol/kg SW]
% 6 O2 Concentration [µmol/kg SW]
% 7 Salinity [PSU]
% 8 Temperature [deg C]
% 9 Pressure [decibar]
% 10 Density [kg/m^{3}]
% 11 Wind Speed [m/s]
% 12 PAR [µmol/m^{2}s]
% 13 Chlorophyll [µg/l]
% 14 Ice Thickness [m]
% 15 Revelle Factor
% 16 Omega Ca
% 17 Omega Ar
% 18 CO_{3}^{-2} [µmol/kg SW]
% 19 Turbidity [NTU]
%% define data subregions
%find Bathurst data
[Bathurst_16_index, ~]=find(Berg16_co2_Longitude< -107 & Berg16_co2_Longitude>-110 & Berg16_co2_Latitude>66.5 & Berg16_co2_Latitude<68.5);
[Bathurst_17_index, ~]=find(Berg17_co2_Longitude< -107 & Berg17_co2_Longitude>-110 & Berg17_co2_Latitude>66.5 & Berg17_co2_Latitude<68.5);
[Bathurst_18_index, ~]=find(Berg18_co2_Longitude< -107 & Berg18_co2_Longitude>-110 & Berg18_co2_Latitude>66.5 & Berg18_co2_Latitude<68.5);
[Bathurst_19_index, ~]=find(Berg19_co2_Longitude< -107 & Berg19_co2_Longitude>-110 & Berg19_co2_Latitude>66.5 & Berg19_co2_Latitude<68.5);
%find dease strait west data
[Dease_strait_w_16_index, ~]=find(Berg16_co2_Longitude< -106.25 & Berg16_co2_Longitude>-110 & Berg16_co2_Latitude>68.5 & Berg16_co2_Latitude<69);
[Dease_strait_w_17_index, ~]=find(Berg17_co2_Longitude< -106.25 & Berg17_co2_Longitude>-110 & Berg17_co2_Latitude>68.5 & Berg17_co2_Latitude<69);
[Dease_strait_w_18_index, ~]=find(Berg18_co2_Longitude< -106.25 & Berg18_co2_Longitude>-110 & Berg18_co2_Latitude>68.5 & Berg18_co2_Latitude<69);
[Dease_strait_w_19_index, ~]=find(Berg19_co2_Longitude< -106.25 & Berg19_co2_Longitude>-110 & Berg19_co2_Latitude>68.5 & Berg19_co2_Latitude<69);
%Wellington Box
[Wellington_16_index, ~]=find(Berg16_co2_Longitude< -106.25 & Berg16_co2_Longitude>-108 & Berg16_co2_Latitude>69 & Berg16_co2_Latitude<69.5);
[Wellington_17_index, ~]=find(Berg17_co2_Longitude< -106.25 & Berg17_co2_Longitude>-108 & Berg17_co2_Latitude>69 & Berg17_co2_Latitude<69.5);
[Wellington_18_index, ~]=find(Berg18_co2_Longitude< -106.25 & Berg18_co2_Longitude>-108 & Berg18_co2_Latitude>69 & Berg18_co2_Latitude<69.5);
[Wellington_19_index, ~]=find(Berg19_co2_Longitude< -106.25 & Berg19_co2_Longitude>-108 & Berg19_co2_Latitude>69 & Berg19_co2_Latitude<69.5);
%find island data
[island16_index, ~]=find(Berg16_co2_Longitude<-105.5 & Berg16_co2_Longitude>-106.25 & Berg16_co2_Latitude>68.75 & Berg16_co2_Latitude<69.25);
[island17_index, ~]=find(Berg17_co2_Longitude<-105.5 & Berg17_co2_Longitude>-106.25 & Berg17_co2_Latitude>68.75 & Berg17_co2_Latitude<69.25);
[island18_index, ~]=find(Berg18_co2_Longitude<-105.5 & Berg18_co2_Longitude>-106.25 & Berg18_co2_Latitude>68.75 & Berg18_co2_Latitude<69.25);
[island19_index, ~]=find(Berg19_co2_Longitude<-105.5 & Berg19_co2_Longitude>-106.25 & Berg19_co2_Latitude>68.75 & Berg19_co2_Latitude<69.25);
%find cam bay data
[cambay16_index, ~]=find(Berg16_co2_Longitude< -104.75 & Berg16_co2_Longitude>-105.5 & Berg16_co2_Latitude>69 & Berg16_co2_Latitude<69.25);
[cambay17_index, ~]=find(Berg17_co2_Longitude< -104.75 & Berg17_co2_Longitude>-105.5 & Berg17_co2_Latitude>69 & Berg17_co2_Latitude<69.25);
[cambay18_index, ~]=find(Berg18_co2_Longitude< -104.75 & Berg18_co2_Longitude>-105.5 & Berg18_co2_Latitude>69 & Berg18_co2_Latitude<69.25);
[cambay19_index, ~]=find(Berg19_co2_Longitude< -104.75 & Berg19_co2_Longitude>-105.5 & Berg19_co2_Latitude>69 & Berg19_co2_Latitude<69.25);
%Queem ,aud Gulf
[QMG_16_index, ~]=find(Berg16_co2_Longitude< -99 & Berg16_co2_Longitude>-105.5 & Berg16_co2_Latitude>68 & Berg16_co2_Latitude<69);
[QMG_17_index, ~]=find(Berg17_co2_Longitude< -99 & Berg17_co2_Longitude>-105.5 & Berg17_co2_Latitude>68 & Berg17_co2_Latitude<69);
[QMG_18_index, ~]=find(Berg18_co2_Longitude< -99 & Berg18_co2_Longitude>-105.5 & Berg18_co2_Latitude>68 & Berg18_co2_Latitude<69);
[QMG_19_index, ~]=find(Berg19_co2_Longitude< -99 & Berg19_co2_Longitude>-105.5 & Berg19_co2_Latitude>68 & Berg19_co2_Latitude<69);
%chantry inlet
[Chantry_16_index, ~]=find(Berg16_co2_Longitude< -95 & Berg16_co2_Longitude>-97 & Berg16_co2_Latitude>67.5 & Berg16_co2_Latitude<69);
[Chantry_17_index, ~]=find(Berg17_co2_Longitude< -95 & Berg17_co2_Longitude>-97 & Berg17_co2_Latitude>67.5 & Berg17_co2_Latitude<69);
[Chantry_18_index, ~]=find(Berg18_co2_Longitude< -95 & Berg18_co2_Longitude>-97 & Berg18_co2_Latitude>67.5 & Berg18_co2_Latitude<69);
[Chantry_19_index, ~]=find(Berg19_co2_Longitude< -95 & Berg19_co2_Longitude>-97 & Berg19_co2_Latitude>67.5 & Berg19_co2_Latitude<69);

%%     Create summary data tables for 2016


Region_name_2016={'Dease Strait West';'Wellington Bay';'Finlayson Islands';'Cambridge Bay';'Queen Maud Gulf';'Average'};

pco2_num_obsv_2016=[sum(  ~isnan((Berg16_co2_pco2_surface(Dease_strait_w_16_index))));sum(  ~isnan((Berg16_co2_pco2_surface(Wellington_16_index))));sum(  ~isnan((Berg16_co2_pco2_surface(island16_index))));sum(  ~isnan((Berg16_co2_pco2_surface(cambay16_index))));sum(  ~isnan((Berg16_co2_pco2_surface(QMG_16_index))));sum(  ~isnan((Berg16_co2_pco2_surface)))];
pCO2_mean_2016=[nanmean(Berg16_co2_pco2_surface(Dease_strait_w_16_index));nanmean(Berg16_co2_pco2_surface(Wellington_16_index));nanmean(Berg16_co2_pco2_surface(island16_index));nanmean(Berg16_co2_pco2_surface(cambay16_index));nanmean(Berg16_co2_pco2_surface(QMG_16_index));nanmean(Berg16_co2_pco2_surface)];
pco2_std_2016=[nanstd(Berg16_co2_pco2_surface(Dease_strait_w_16_index));nanstd(Berg16_co2_pco2_surface(Wellington_16_index));nanstd(Berg16_co2_pco2_surface(island16_index));nanstd(Berg16_co2_pco2_surface(cambay16_index));nanstd(Berg16_co2_pco2_surface(QMG_16_index));nanstd(Berg16_co2_pco2_surface)];
pco2_min_2016=[min(Berg16_co2_pco2_surface(Dease_strait_w_16_index));min(Berg16_co2_pco2_surface(Wellington_16_index));min(Berg16_co2_pco2_surface(island16_index));min(Berg16_co2_pco2_surface(cambay16_index));min(Berg16_co2_pco2_surface(QMG_16_index));min(Berg16_co2_pco2_surface)];
pco2_max_2016=[max(Berg16_co2_pco2_surface(Dease_strait_w_16_index));max(Berg16_co2_pco2_surface(Wellington_16_index));max(Berg16_co2_pco2_surface(island16_index));max(Berg16_co2_pco2_surface(cambay16_index));max(Berg16_co2_pco2_surface(QMG_16_index));max(Berg16_co2_pco2_surface)];

Summary_table_pco2_2016 = table(Region_name_2016,pco2_num_obsv_2016,pCO2_mean_2016,pco2_std_2016,pco2_min_2016,pco2_max_2016)

%format so that mean +/- std then min-max beneath
vec1 = round(pCO2_mean_2016,2);
vec2 = round(pco2_std_2016,2);
vec3 = round(pco2_min_2016,2);
vec4 = round(pco2_max_2016,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
pco2_mean_std_min_max_2016 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

sal_num_obsv_2016=[sum(  ~isnan((Berg16_co2_TSG_s(Dease_strait_w_16_index))));sum(  ~isnan((Berg16_co2_TSG_s(Wellington_16_index))));sum(  ~isnan((Berg16_co2_TSG_s(island16_index))));sum(  ~isnan((Berg16_co2_TSG_s(cambay16_index))));sum(  ~isnan((Berg16_co2_TSG_s(QMG_16_index))));sum(  ~isnan((Berg16_co2_TSG_s)))];
sal_mean_2016=[nanmean(Berg16_co2_TSG_s(Dease_strait_w_16_index));nanmean(Berg16_co2_TSG_s(Wellington_16_index));nanmean(Berg16_co2_TSG_s(island16_index));nanmean(Berg16_co2_TSG_s(cambay16_index));nanmean(Berg16_co2_TSG_s(QMG_16_index));nanmean(Berg16_co2_TSG_s)];
sal_std_2016=[nanstd(Berg16_co2_TSG_s(Dease_strait_w_16_index));nanstd(Berg16_co2_TSG_s(Wellington_16_index));nanstd(Berg16_co2_TSG_s(island16_index));nanstd(Berg16_co2_TSG_s(cambay16_index));nanstd(Berg16_co2_TSG_s(QMG_16_index));nanstd(Berg16_co2_TSG_s)];
sal_min_2016=[min(Berg16_co2_TSG_s(Dease_strait_w_16_index));min(Berg16_co2_TSG_s(Wellington_16_index));min(Berg16_co2_TSG_s(island16_index));min(Berg16_co2_TSG_s(cambay16_index));min(Berg16_co2_TSG_s(QMG_16_index));min(Berg16_co2_TSG_s)];
sal_max_2016=[max(Berg16_co2_TSG_s(Dease_strait_w_16_index));max(Berg16_co2_TSG_s(Wellington_16_index));max(Berg16_co2_TSG_s(island16_index));max(Berg16_co2_TSG_s(cambay16_index));max(Berg16_co2_TSG_s(QMG_16_index));max(Berg16_co2_TSG_s)];
Summary_table_sal_2016 = table(Region_name_2016,sal_num_obsv_2016,sal_mean_2016,sal_std_2016,sal_min_2016,sal_max_2016)

%format so that mean +/- std then min-max beneath
vec1 = round(sal_mean_2016,2);
vec2 = round(sal_std_2016,2);
vec3 = round(sal_min_2016,2);
vec4 = round(sal_max_2016,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sal_mean_std_min_max_2016 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

sst_num_obsv_2016=[sum(  ~isnan((Berg16_co2_SST_1m(Dease_strait_w_16_index))));sum(  ~isnan((Berg16_co2_SST_1m(Wellington_16_index))));sum(  ~isnan((Berg16_co2_SST_1m(island16_index))));sum(  ~isnan((Berg16_co2_SST_1m(cambay16_index))));sum(  ~isnan((Berg16_co2_SST_1m(QMG_16_index))));sum(  ~isnan((Berg16_co2_SST_1m)))];
sst_mean_2016=[nanmean(Berg16_co2_SST_1m(Dease_strait_w_16_index));nanmean(Berg16_co2_SST_1m(Wellington_16_index));nanmean(Berg16_co2_SST_1m(island16_index));nanmean(Berg16_co2_SST_1m(cambay16_index));nanmean(Berg16_co2_SST_1m(QMG_16_index));nanmean(Berg16_co2_SST_1m)];
sst_std_2016=[nanstd(Berg16_co2_SST_1m(Dease_strait_w_16_index));nanstd(Berg16_co2_SST_1m(Wellington_16_index));nanstd(Berg16_co2_SST_1m(island16_index));nanstd(Berg16_co2_SST_1m(cambay16_index));nanstd(Berg16_co2_SST_1m(QMG_16_index));nanstd(Berg16_co2_SST_1m)];
sst_min_2016=[min(Berg16_co2_SST_1m(Dease_strait_w_16_index));min(Berg16_co2_SST_1m(Wellington_16_index));min(Berg16_co2_SST_1m(island16_index));min(Berg16_co2_SST_1m(cambay16_index));min(Berg16_co2_SST_1m(QMG_16_index));min(Berg16_co2_SST_1m)];
sst_max_2016=[max(Berg16_co2_SST_1m(Dease_strait_w_16_index));max(Berg16_co2_SST_1m(Wellington_16_index));max(Berg16_co2_SST_1m(island16_index));max(Berg16_co2_SST_1m(cambay16_index));max(Berg16_co2_SST_1m(QMG_16_index));max(Berg16_co2_SST_1m)];
Summary_table_sal_2016 = table(Region_name_2016,sal_num_obsv_2016,sal_mean_2016,sal_std_2016,sal_min_2016,sal_max_2016)

%format so that mean +/- std then min-max beneath
vec1 = round(sst_mean_2016,2);
vec2 = round(sst_std_2016,2);
vec3 = round(sst_min_2016,2);
vec4 = round(sst_max_2016,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sst_mean_std_min_max_2016 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])


u10_num_obsv_2016=[sum(  ~isnan((Berg16_co2_u10(Dease_strait_w_16_index))));sum(  ~isnan((Berg16_co2_u10(Wellington_16_index))));sum(  ~isnan((Berg16_co2_u10(island16_index))));sum(  ~isnan((Berg16_co2_u10(cambay16_index))));sum(  ~isnan((Berg16_co2_u10(QMG_16_index))));sum(  ~isnan((Berg16_co2_u10)))];
u10_mean_2016=[nanmean(Berg16_co2_u10(Dease_strait_w_16_index));nanmean(Berg16_co2_u10(Wellington_16_index));nanmean(Berg16_co2_u10(island16_index));nanmean(Berg16_co2_u10(cambay16_index));nanmean(Berg16_co2_u10(QMG_16_index));nanmean(Berg16_co2_u10)];
u10_std_2016=[nanstd(Berg16_co2_u10(Dease_strait_w_16_index));nanstd(Berg16_co2_u10(Wellington_16_index));nanstd(Berg16_co2_u10(island16_index));nanstd(Berg16_co2_u10(cambay16_index));nanstd(Berg16_co2_u10(QMG_16_index));nanstd(Berg16_co2_u10)];
u10_min_2016=[min(Berg16_co2_u10(Dease_strait_w_16_index));min(Berg16_co2_u10(Wellington_16_index));min(Berg16_co2_u10(island16_index));min(Berg16_co2_u10(cambay16_index));min(Berg16_co2_u10(QMG_16_index));min(Berg16_co2_u10)];
u10_max_2016=[max(Berg16_co2_u10(Dease_strait_w_16_index));max(Berg16_co2_u10(Wellington_16_index));max(Berg16_co2_u10(island16_index));max(Berg16_co2_u10(cambay16_index));max(Berg16_co2_u10(QMG_16_index));max(Berg16_co2_u10)];
Summary_table_u10_2016 = table(Region_name_2016,u10_num_obsv_2016,u10_mean_2016,u10_std_2016,u10_min_2016,u10_max_2016)

%format so that mean +/- std then min-max beneath
vec1 = round(u10_mean_2016,2);
vec2 = round(u10_std_2016,2);
vec3 = round(u10_min_2016,2);
vec4 = round(u10_max_2016,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
u10_mean_std_min_max_2016 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

flux_num_obsv_2016=[sum(  ~isnan((Berg16_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_16_index))));sum(  ~isnan((Berg16_co2_FCO2_mmol_per_m2_per_d(Wellington_16_index))));sum(  ~isnan((Berg16_co2_FCO2_mmol_per_m2_per_d(island16_index))));sum(  ~isnan((Berg16_co2_FCO2_mmol_per_m2_per_d(cambay16_index))));sum(  ~isnan((Berg16_co2_FCO2_mmol_per_m2_per_d(QMG_16_index))));sum(  ~isnan((Berg16_co2_FCO2_mmol_per_m2_per_d)))];
flux_mean_2016=[nanmean(Berg16_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_16_index));nanmean(Berg16_co2_FCO2_mmol_per_m2_per_d(Wellington_16_index));nanmean(Berg16_co2_FCO2_mmol_per_m2_per_d(island16_index));nanmean(Berg16_co2_FCO2_mmol_per_m2_per_d(cambay16_index));nanmean(Berg16_co2_FCO2_mmol_per_m2_per_d(QMG_16_index));nanmean(Berg16_co2_FCO2_mmol_per_m2_per_d)];
flux_std_2016=[nanstd(Berg16_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_16_index));nanstd(Berg16_co2_FCO2_mmol_per_m2_per_d(Wellington_16_index));nanstd(Berg16_co2_FCO2_mmol_per_m2_per_d(island16_index));nanstd(Berg16_co2_FCO2_mmol_per_m2_per_d(cambay16_index));nanstd(Berg16_co2_FCO2_mmol_per_m2_per_d(QMG_16_index));nanstd(Berg16_co2_FCO2_mmol_per_m2_per_d)];
flux_min_2016=[min(Berg16_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_16_index));min(Berg16_co2_FCO2_mmol_per_m2_per_d(Wellington_16_index));min(Berg16_co2_FCO2_mmol_per_m2_per_d(island16_index));min(Berg16_co2_FCO2_mmol_per_m2_per_d(cambay16_index));min(Berg16_co2_FCO2_mmol_per_m2_per_d(QMG_16_index));min(Berg16_co2_FCO2_mmol_per_m2_per_d)];
flux_max_2016=[max(Berg16_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_16_index));max(Berg16_co2_FCO2_mmol_per_m2_per_d(Wellington_16_index));max(Berg16_co2_FCO2_mmol_per_m2_per_d(island16_index));max(Berg16_co2_FCO2_mmol_per_m2_per_d(cambay16_index));max(Berg16_co2_FCO2_mmol_per_m2_per_d(QMG_16_index));max(Berg16_co2_FCO2_mmol_per_m2_per_d)];
Summary_table_flux_2016 = table(Region_name_2016,flux_num_obsv_2016,flux_mean_2016,flux_std_2016,flux_min_2016,flux_max_2016)

%format so that mean +/- std then min-max beneath
vec1 = round(flux_mean_2016,2);
vec2 = round(flux_std_2016,2);
vec3 = round(flux_min_2016,2);
vec4 = round(flux_max_2016,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
flux_mean_std_min_max_2016 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])
%%     Create summary data tables for 2017


Region_name_2017={'Bathurst Inlet';'Dease Strait West';'Wellington Bay';'Finlayson Islands';'Cambridge Bay';'Queen Maud Gulf';'Chantry Inlet';'Average'};

pco2_num_obsv_2017=[sum(~isnan((Berg17_co2_pco2_surface(Bathurst_17_index))));sum(  ~isnan((Berg17_co2_pco2_surface(Dease_strait_w_17_index))));sum(  ~isnan((Berg17_co2_pco2_surface(Wellington_17_index))));sum(  ~isnan((Berg17_co2_pco2_surface(island17_index))));sum(  ~isnan((Berg17_co2_pco2_surface(cambay17_index))));sum(  ~isnan((Berg17_co2_pco2_surface(QMG_17_index))));sum(  ~isnan((Berg17_co2_pco2_surface(Chantry_17_index))));sum(  ~isnan((Berg17_co2_pco2_surface)))];
pCO2_mean_2017=[nanmean(Berg17_co2_pco2_surface(Bathurst_17_index));nanmean(Berg17_co2_pco2_surface(Dease_strait_w_17_index));nanmean(Berg17_co2_pco2_surface(Wellington_17_index));nanmean(Berg17_co2_pco2_surface(island17_index));nanmean(Berg17_co2_pco2_surface(cambay17_index));nanmean(Berg17_co2_pco2_surface(QMG_17_index));nanmean(Berg17_co2_pco2_surface(Chantry_17_index));nanmean(Berg17_co2_pco2_surface)];
pco2_std_2017=[nanstd(Berg17_co2_pco2_surface(Bathurst_17_index));nanstd(Berg17_co2_pco2_surface(Dease_strait_w_17_index));nanstd(Berg17_co2_pco2_surface(Wellington_17_index));nanstd(Berg17_co2_pco2_surface(island17_index));nanstd(Berg17_co2_pco2_surface(cambay17_index));nanstd(Berg17_co2_pco2_surface(QMG_17_index));nanstd(Berg17_co2_pco2_surface(Chantry_17_index));nanstd(Berg17_co2_pco2_surface)];
pco2_min_2017=[min(Berg17_co2_pco2_surface(Bathurst_17_index));min(Berg17_co2_pco2_surface(Dease_strait_w_17_index));min(Berg17_co2_pco2_surface(Wellington_17_index));min(Berg17_co2_pco2_surface(island17_index));min(Berg17_co2_pco2_surface(cambay17_index));min(Berg17_co2_pco2_surface(QMG_17_index));min(Berg17_co2_pco2_surface(Chantry_17_index));min(Berg17_co2_pco2_surface)];
pco2_max_2017=[max(Berg17_co2_pco2_surface(Bathurst_17_index));max(Berg17_co2_pco2_surface(Dease_strait_w_17_index));max(Berg17_co2_pco2_surface(Wellington_17_index));max(Berg17_co2_pco2_surface(island17_index));max(Berg17_co2_pco2_surface(cambay17_index));max(Berg17_co2_pco2_surface(QMG_17_index));max(Berg17_co2_pco2_surface(Chantry_17_index));max(Berg17_co2_pco2_surface)];

Summary_table_pco2_2017 = table(Region_name_2017,pco2_num_obsv_2017,pCO2_mean_2017,pco2_std_2017,pco2_min_2017,pco2_max_2017)

%format so that mean +/- std then min-max beneath
vec1 = round(pCO2_mean_2017,2);
vec2 = round(pco2_std_2017,2);
vec3 = round(pco2_min_2017,2);
vec4 = round(pco2_max_2017,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
pco2_mean_std_min_max_2017 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

sal_num_obsv_2017=[sum(~isnan((Berg17_co2_TSG_s(Bathurst_17_index))));sum(  ~isnan((Berg17_co2_TSG_s(Dease_strait_w_17_index))));sum(  ~isnan((Berg17_co2_TSG_s(Wellington_17_index))));sum(  ~isnan((Berg17_co2_TSG_s(island17_index))));sum(  ~isnan((Berg17_co2_TSG_s(cambay17_index))));sum(  ~isnan((Berg17_co2_TSG_s(QMG_17_index))));sum(  ~isnan((Berg17_co2_TSG_s(Chantry_17_index))));sum(  ~isnan((Berg17_co2_TSG_s)))];
sal_mean_2017=[nanmean(Berg17_co2_TSG_s(Bathurst_17_index));nanmean(Berg17_co2_TSG_s(Dease_strait_w_17_index));nanmean(Berg17_co2_TSG_s(Wellington_17_index));nanmean(Berg17_co2_TSG_s(island17_index));nanmean(Berg17_co2_TSG_s(cambay17_index));nanmean(Berg17_co2_TSG_s(QMG_17_index));nanmean(Berg17_co2_TSG_s(Chantry_17_index));nanmean(Berg17_co2_TSG_s)];
sal_std_2017=[nanstd(Berg17_co2_TSG_s(Bathurst_17_index));nanstd(Berg17_co2_TSG_s(Dease_strait_w_17_index));nanstd(Berg17_co2_TSG_s(Wellington_17_index));nanstd(Berg17_co2_TSG_s(island17_index));nanstd(Berg17_co2_TSG_s(cambay17_index));nanstd(Berg17_co2_TSG_s(QMG_17_index));nanstd(Berg17_co2_TSG_s(Chantry_17_index));nanstd(Berg17_co2_TSG_s)];
sal_min_2017=[min(Berg17_co2_TSG_s(Bathurst_17_index));min(Berg17_co2_TSG_s(Dease_strait_w_17_index));min(Berg17_co2_TSG_s(Wellington_17_index));min(Berg17_co2_TSG_s(island17_index));min(Berg17_co2_TSG_s(cambay17_index));min(Berg17_co2_TSG_s(QMG_17_index));min(Berg17_co2_TSG_s(Chantry_17_index));min(Berg17_co2_TSG_s)];
sal_max_2017=[max(Berg17_co2_TSG_s(Bathurst_17_index));max(Berg17_co2_TSG_s(Dease_strait_w_17_index));max(Berg17_co2_TSG_s(Wellington_17_index));max(Berg17_co2_TSG_s(island17_index));max(Berg17_co2_TSG_s(cambay17_index));max(Berg17_co2_TSG_s(QMG_17_index));max(Berg17_co2_TSG_s(Chantry_17_index));max(Berg17_co2_TSG_s)];
Summary_table_sal_2017 = table(Region_name_2017,sal_num_obsv_2017,sal_mean_2017,sal_std_2017,sal_min_2017,sal_max_2017)

%format so that mean +/- std then min-max beneath
vec1 = round(sal_mean_2017,2);
vec2 = round(sal_std_2017,2);
vec3 = round(sal_min_2017,2);
vec4 = round(sal_max_2017,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sal_mean_std_min_max_2017 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

sst_num_obsv_2017=[sum(~isnan((Berg17_co2_SST_1m(Bathurst_17_index))));sum(  ~isnan((Berg17_co2_SST_1m(Dease_strait_w_17_index))));sum(  ~isnan((Berg17_co2_SST_1m(Wellington_17_index))));sum(  ~isnan((Berg17_co2_SST_1m(island17_index))));sum(  ~isnan((Berg17_co2_SST_1m(cambay17_index))));sum(  ~isnan((Berg17_co2_SST_1m(QMG_17_index))));sum(  ~isnan((Berg17_co2_SST_1m(Chantry_17_index))));sum(  ~isnan((Berg17_co2_SST_1m)))];
sst_mean_2017=[nanmean(Berg17_co2_SST_1m(Bathurst_17_index));nanmean(Berg17_co2_SST_1m(Dease_strait_w_17_index));nanmean(Berg17_co2_SST_1m(Wellington_17_index));nanmean(Berg17_co2_SST_1m(island17_index));nanmean(Berg17_co2_SST_1m(cambay17_index));nanmean(Berg17_co2_SST_1m(QMG_17_index));nanmean(Berg17_co2_SST_1m(Chantry_17_index));nanmean(Berg17_co2_SST_1m)];
sst_std_2017=[nanstd(Berg17_co2_SST_1m(Bathurst_17_index));nanstd(Berg17_co2_SST_1m(Dease_strait_w_17_index));nanstd(Berg17_co2_SST_1m(Wellington_17_index));nanstd(Berg17_co2_SST_1m(island17_index));nanstd(Berg17_co2_SST_1m(cambay17_index));nanstd(Berg17_co2_SST_1m(QMG_17_index));nanstd(Berg17_co2_SST_1m(Chantry_17_index));nanstd(Berg17_co2_SST_1m)];
sst_min_2017=[min(Berg17_co2_SST_1m(Bathurst_17_index));min(Berg17_co2_SST_1m(Dease_strait_w_17_index));min(Berg17_co2_SST_1m(Wellington_17_index));min(Berg17_co2_SST_1m(island17_index));min(Berg17_co2_SST_1m(cambay17_index));min(Berg17_co2_SST_1m(QMG_17_index));min(Berg17_co2_SST_1m(Chantry_17_index));min(Berg17_co2_SST_1m)];
sst_max_2017=[max(Berg17_co2_SST_1m(Bathurst_17_index));max(Berg17_co2_SST_1m(Dease_strait_w_17_index));max(Berg17_co2_SST_1m(Wellington_17_index));max(Berg17_co2_SST_1m(island17_index));max(Berg17_co2_SST_1m(cambay17_index));max(Berg17_co2_SST_1m(QMG_17_index));max(Berg17_co2_SST_1m(Chantry_17_index));max(Berg17_co2_SST_1m)];
Summary_table_sal_2017 = table(Region_name_2017,sal_num_obsv_2017,sal_mean_2017,sal_std_2017,sal_min_2017,sal_max_2017)

%format so that mean +/- std then min-max beneath
vec1 = round(sst_mean_2017,2);
vec2 = round(sst_std_2017,2);
vec3 = round(sst_min_2017,2);
vec4 = round(sst_max_2017,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sst_mean_std_min_max_2017 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

chl_num_obsv_2017=[sum(~isnan((Berg17_co2_Chl_despike(Bathurst_17_index))));sum(  ~isnan((Berg17_co2_Chl_despike(Dease_strait_w_17_index))));sum(  ~isnan((Berg17_co2_Chl_despike(Wellington_17_index))));sum(  ~isnan((Berg17_co2_Chl_despike(island17_index))));sum(  ~isnan((Berg17_co2_Chl_despike(cambay17_index))));sum(  ~isnan((Berg17_co2_Chl_despike(QMG_17_index))));sum(  ~isnan((Berg17_co2_Chl_despike(Chantry_17_index))));sum(  ~isnan((Berg17_co2_Chl_despike)))];
chl_mean_2017=[nanmean(Berg17_co2_Chl_despike(Bathurst_17_index));nanmean(Berg17_co2_Chl_despike(Dease_strait_w_17_index));nanmean(Berg17_co2_Chl_despike(Wellington_17_index));nanmean(Berg17_co2_Chl_despike(island17_index));nanmean(Berg17_co2_Chl_despike(cambay17_index));nanmean(Berg17_co2_Chl_despike(QMG_17_index));nanmean(Berg17_co2_Chl_despike(Chantry_17_index));nanmean(Berg17_co2_Chl_despike)];
chl_std_2017=[nanstd(Berg17_co2_Chl_despike(Bathurst_17_index));nanstd(Berg17_co2_Chl_despike(Dease_strait_w_17_index));nanstd(Berg17_co2_Chl_despike(Wellington_17_index));nanstd(Berg17_co2_Chl_despike(island17_index));nanstd(Berg17_co2_Chl_despike(cambay17_index));nanstd(Berg17_co2_Chl_despike(QMG_17_index));nanstd(Berg17_co2_Chl_despike(Chantry_17_index));nanstd(Berg17_co2_Chl_despike)];
chl_min_2017=[min(Berg17_co2_Chl_despike(Bathurst_17_index));min(Berg17_co2_Chl_despike(Dease_strait_w_17_index));min(Berg17_co2_Chl_despike(Wellington_17_index));min(Berg17_co2_Chl_despike(island17_index));min(Berg17_co2_Chl_despike(cambay17_index));min(Berg17_co2_Chl_despike(QMG_17_index));min(Berg17_co2_Chl_despike(Chantry_17_index));min(Berg17_co2_Chl_despike)];
chl_max_2017=[max(Berg17_co2_Chl_despike(Bathurst_17_index));max(Berg17_co2_Chl_despike(Dease_strait_w_17_index));max(Berg17_co2_Chl_despike(Wellington_17_index));max(Berg17_co2_Chl_despike(island17_index));max(Berg17_co2_Chl_despike(cambay17_index));max(Berg17_co2_Chl_despike(QMG_17_index));max(Berg17_co2_Chl_despike(Chantry_17_index));max(Berg17_co2_Chl_despike)];
Summary_table_chl_2017 = table(Region_name_2017,chl_num_obsv_2017,chl_mean_2017,chl_std_2017,chl_min_2017,chl_max_2017)

%format so that mean +/- std then min-max beneath
vec1 = round(chl_mean_2017,2);
vec2 = round(chl_std_2017,2);
vec3 = round(chl_min_2017,2);
vec4 = round(chl_max_2017,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
chl_mean_std_min_max_2017 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

u10_num_obsv_2017=[sum(~isnan((Berg17_co2_u10(Bathurst_17_index))));sum(  ~isnan((Berg17_co2_u10(Dease_strait_w_17_index))));sum(  ~isnan((Berg17_co2_u10(Wellington_17_index))));sum(  ~isnan((Berg17_co2_u10(island17_index))));sum(  ~isnan((Berg17_co2_u10(cambay17_index))));sum(  ~isnan((Berg17_co2_u10(QMG_17_index))));sum(  ~isnan((Berg17_co2_u10(Chantry_17_index))));sum(  ~isnan((Berg17_co2_u10)))];
u10_mean_2017=[nanmean(Berg17_co2_u10(Bathurst_17_index));nanmean(Berg17_co2_u10(Dease_strait_w_17_index));nanmean(Berg17_co2_u10(Wellington_17_index));nanmean(Berg17_co2_u10(island17_index));nanmean(Berg17_co2_u10(cambay17_index));nanmean(Berg17_co2_u10(QMG_17_index));nanmean(Berg17_co2_u10(Chantry_17_index));nanmean(Berg17_co2_u10)];
u10_std_2017=[nanstd(Berg17_co2_u10(Bathurst_17_index));nanstd(Berg17_co2_u10(Dease_strait_w_17_index));nanstd(Berg17_co2_u10(Wellington_17_index));nanstd(Berg17_co2_u10(island17_index));nanstd(Berg17_co2_u10(cambay17_index));nanstd(Berg17_co2_u10(QMG_17_index));nanstd(Berg17_co2_u10(Chantry_17_index));nanstd(Berg17_co2_u10)];
u10_min_2017=[min(Berg17_co2_u10(Bathurst_17_index));min(Berg17_co2_u10(Dease_strait_w_17_index));min(Berg17_co2_u10(Wellington_17_index));min(Berg17_co2_u10(island17_index));min(Berg17_co2_u10(cambay17_index));min(Berg17_co2_u10(QMG_17_index));min(Berg17_co2_u10(Chantry_17_index));min(Berg17_co2_u10)];
u10_max_2017=[max(Berg17_co2_u10(Bathurst_17_index));max(Berg17_co2_u10(Dease_strait_w_17_index));max(Berg17_co2_u10(Wellington_17_index));max(Berg17_co2_u10(island17_index));max(Berg17_co2_u10(cambay17_index));max(Berg17_co2_u10(QMG_17_index));max(Berg17_co2_u10(Chantry_17_index));max(Berg17_co2_u10)];
Summary_table_u10_2017 = table(Region_name_2017,u10_num_obsv_2017,u10_mean_2017,u10_std_2017,u10_min_2017,u10_max_2017)

%format so that mean +/- std then min-max beneath
vec1 = round(u10_mean_2017,2);
vec2 = round(u10_std_2017,2);
vec3 = round(u10_min_2017,2);
vec4 = round(u10_max_2017,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
u10_mean_std_min_max_2017 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

flux_num_obsv_2017=[sum(~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d(Bathurst_17_index))));sum(  ~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_17_index))));sum(  ~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d(Wellington_17_index))));sum(  ~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d(island17_index))));sum(  ~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d(cambay17_index))));sum(  ~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d(QMG_17_index))));sum(  ~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d(Chantry_17_index))));sum(  ~isnan((Berg17_co2_FCO2_mmol_per_m2_per_d)))];
flux_mean_2017=[nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d(Bathurst_17_index));nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_17_index));nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d(Wellington_17_index));nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d(island17_index));nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d(cambay17_index));nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d(QMG_17_index));nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d(Chantry_17_index));nanmean(Berg17_co2_FCO2_mmol_per_m2_per_d)];
flux_std_2017=[nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d(Bathurst_17_index));nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_17_index));nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d(Wellington_17_index));nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d(island17_index));nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d(cambay17_index));nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d(QMG_17_index));nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d(Chantry_17_index));nanstd(Berg17_co2_FCO2_mmol_per_m2_per_d)];
flux_min_2017=[min(Berg17_co2_FCO2_mmol_per_m2_per_d(Bathurst_17_index));min(Berg17_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_17_index));min(Berg17_co2_FCO2_mmol_per_m2_per_d(Wellington_17_index));min(Berg17_co2_FCO2_mmol_per_m2_per_d(island17_index));min(Berg17_co2_FCO2_mmol_per_m2_per_d(cambay17_index));min(Berg17_co2_FCO2_mmol_per_m2_per_d(QMG_17_index));min(Berg17_co2_FCO2_mmol_per_m2_per_d(Chantry_17_index));min(Berg17_co2_FCO2_mmol_per_m2_per_d)];
flux_max_2017=[max(Berg17_co2_FCO2_mmol_per_m2_per_d(Bathurst_17_index));max(Berg17_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_17_index));max(Berg17_co2_FCO2_mmol_per_m2_per_d(Wellington_17_index));max(Berg17_co2_FCO2_mmol_per_m2_per_d(island17_index));max(Berg17_co2_FCO2_mmol_per_m2_per_d(cambay17_index));max(Berg17_co2_FCO2_mmol_per_m2_per_d(QMG_17_index));max(Berg17_co2_FCO2_mmol_per_m2_per_d(Chantry_17_index));max(Berg17_co2_FCO2_mmol_per_m2_per_d)];
Summary_table_flux_2017 = table(Region_name_2017,flux_num_obsv_2017,flux_mean_2017,flux_std_2017,flux_min_2017,flux_max_2017)

%format so that mean +/- std then min-max beneath
vec1 = round(flux_mean_2017,2);
vec2 = round(flux_std_2017,2);
vec3 = round(flux_min_2017,2);
vec4 = round(flux_max_2017,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
flux_mean_std_min_max_2017 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])
%%     Create summary data tables for 2018


Region_name_2018={'Bathurst Inlet';'Dease Strait West';'Wellington Bay';'Finlayson Islands';'Cambridge Bay';'Queen Maud Gulf';'Average'};

pco2_num_obsv_2018=[sum(~isnan((Berg18_co2_pco2_surface(Bathurst_18_index))));sum(  ~isnan((Berg18_co2_pco2_surface(Dease_strait_w_18_index))));sum(  ~isnan((Berg18_co2_pco2_surface(Wellington_18_index))));sum(  ~isnan((Berg18_co2_pco2_surface(island18_index))));sum(  ~isnan((Berg18_co2_pco2_surface(cambay18_index))));sum(  ~isnan((Berg18_co2_pco2_surface(QMG_18_index))));sum(  ~isnan((Berg18_co2_pco2_surface)))];
pCO2_mean_2018=[nanmean(Berg18_co2_pco2_surface(Bathurst_18_index));nanmean(Berg18_co2_pco2_surface(Dease_strait_w_18_index));nanmean(Berg18_co2_pco2_surface(Wellington_18_index));nanmean(Berg18_co2_pco2_surface(island18_index));nanmean(Berg18_co2_pco2_surface(cambay18_index));nanmean(Berg18_co2_pco2_surface(QMG_18_index));nanmean(Berg18_co2_pco2_surface)];
pco2_std_2018=[nanstd(Berg18_co2_pco2_surface(Bathurst_18_index));nanstd(Berg18_co2_pco2_surface(Dease_strait_w_18_index));nanstd(Berg18_co2_pco2_surface(Wellington_18_index));nanstd(Berg18_co2_pco2_surface(island18_index));nanstd(Berg18_co2_pco2_surface(cambay18_index));nanstd(Berg18_co2_pco2_surface(QMG_18_index));nanstd(Berg18_co2_pco2_surface)];
pco2_min_2018=[min(Berg18_co2_pco2_surface(Bathurst_18_index));min(Berg18_co2_pco2_surface(Dease_strait_w_18_index));min(Berg18_co2_pco2_surface(Wellington_18_index));min(Berg18_co2_pco2_surface(island18_index));min(Berg18_co2_pco2_surface(cambay18_index));min(Berg18_co2_pco2_surface(QMG_18_index));min(Berg18_co2_pco2_surface)];
pco2_max_2018=[max(Berg18_co2_pco2_surface(Bathurst_18_index));max(Berg18_co2_pco2_surface(Dease_strait_w_18_index));max(Berg18_co2_pco2_surface(Wellington_18_index));max(Berg18_co2_pco2_surface(island18_index));max(Berg18_co2_pco2_surface(cambay18_index));max(Berg18_co2_pco2_surface(QMG_18_index));max(Berg18_co2_pco2_surface)];

Summary_table_pco2_2018 = table(Region_name_2018,pco2_num_obsv_2018,pCO2_mean_2018,pco2_std_2018,pco2_min_2018,pco2_max_2018)

%format so that mean +/- std then min-max beneath
vec1 = round(pCO2_mean_2018,2);
vec2 = round(pco2_std_2018,2);
vec3 = round(pco2_min_2018,2);
vec4 = round(pco2_max_2018,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
pco2_mean_std_min_max_2018 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])


sal_num_obsv_2018=[sum(~isnan((Berg18_co2_TSG_s(Bathurst_18_index))));sum(  ~isnan((Berg18_co2_TSG_s(Dease_strait_w_18_index))));sum(  ~isnan((Berg18_co2_TSG_s(Wellington_18_index))));sum(  ~isnan((Berg18_co2_TSG_s(island18_index))));sum(  ~isnan((Berg18_co2_TSG_s(cambay18_index))));sum(  ~isnan((Berg18_co2_TSG_s(QMG_18_index))));sum(  ~isnan((Berg18_co2_TSG_s)))];
sal_mean_2018=[nanmean(Berg18_co2_TSG_s(Bathurst_18_index));nanmean(Berg18_co2_TSG_s(Dease_strait_w_18_index));nanmean(Berg18_co2_TSG_s(Wellington_18_index));nanmean(Berg18_co2_TSG_s(island18_index));nanmean(Berg18_co2_TSG_s(cambay18_index));nanmean(Berg18_co2_TSG_s(QMG_18_index));nanmean(Berg18_co2_TSG_s)];
sal_std_2018=[nanstd(Berg18_co2_TSG_s(Bathurst_18_index));nanstd(Berg18_co2_TSG_s(Dease_strait_w_18_index));nanstd(Berg18_co2_TSG_s(Wellington_18_index));nanstd(Berg18_co2_TSG_s(island18_index));nanstd(Berg18_co2_TSG_s(cambay18_index));nanstd(Berg18_co2_TSG_s(QMG_18_index));nanstd(Berg18_co2_TSG_s)];
sal_min_2018=[min(Berg18_co2_TSG_s(Bathurst_18_index));min(Berg18_co2_TSG_s(Dease_strait_w_18_index));min(Berg18_co2_TSG_s(Wellington_18_index));min(Berg18_co2_TSG_s(island18_index));min(Berg18_co2_TSG_s(cambay18_index));min(Berg18_co2_TSG_s(QMG_18_index));min(Berg18_co2_TSG_s)];
sal_max_2018=[max(Berg18_co2_TSG_s(Bathurst_18_index));max(Berg18_co2_TSG_s(Dease_strait_w_18_index));max(Berg18_co2_TSG_s(Wellington_18_index));max(Berg18_co2_TSG_s(island18_index));max(Berg18_co2_TSG_s(cambay18_index));max(Berg18_co2_TSG_s(QMG_18_index));max(Berg18_co2_TSG_s)];

Summary_table_pco2_2018 = table(Region_name_2018,sal_num_obsv_2018,sal_mean_2018,sal_std_2018,sal_min_2018,sal_max_2018)

%format so that mean +/- std then min-max beneath
vec1 = round(sal_mean_2018,2);
vec2 = round(sal_std_2018,2);
vec3 = round(sal_min_2018,2);
vec4 = round(sal_max_2018,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sal_mean_std_min_max_2018 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

sst_num_obsv_2018=[sum(~isnan((Berg18_co2_SST_1m(Bathurst_18_index))));sum(  ~isnan((Berg18_co2_SST_1m(Dease_strait_w_18_index))));sum(  ~isnan((Berg18_co2_SST_1m(Wellington_18_index))));sum(  ~isnan((Berg18_co2_SST_1m(island18_index))));sum(  ~isnan((Berg18_co2_SST_1m(cambay18_index))));sum(  ~isnan((Berg18_co2_SST_1m(QMG_18_index))));sum(  ~isnan((Berg18_co2_SST_1m)))];
sst_mean_2018=[nanmean(Berg18_co2_SST_1m(Bathurst_18_index));nanmean(Berg18_co2_SST_1m(Dease_strait_w_18_index));nanmean(Berg18_co2_SST_1m(Wellington_18_index));nanmean(Berg18_co2_SST_1m(island18_index));nanmean(Berg18_co2_SST_1m(cambay18_index));nanmean(Berg18_co2_SST_1m(QMG_18_index));nanmean(Berg18_co2_SST_1m)];
sst_std_2018=[nanstd(Berg18_co2_SST_1m(Bathurst_18_index));nanstd(Berg18_co2_SST_1m(Dease_strait_w_18_index));nanstd(Berg18_co2_SST_1m(Wellington_18_index));nanstd(Berg18_co2_SST_1m(island18_index));nanstd(Berg18_co2_SST_1m(cambay18_index));nanstd(Berg18_co2_SST_1m(QMG_18_index));nanstd(Berg18_co2_SST_1m)];
sst_min_2018=[min(Berg18_co2_SST_1m(Bathurst_18_index));min(Berg18_co2_SST_1m(Dease_strait_w_18_index));min(Berg18_co2_SST_1m(Wellington_18_index));min(Berg18_co2_SST_1m(island18_index));min(Berg18_co2_SST_1m(cambay18_index));min(Berg18_co2_SST_1m(QMG_18_index));min(Berg18_co2_SST_1m)];
sst_max_2018=[max(Berg18_co2_SST_1m(Bathurst_18_index));max(Berg18_co2_SST_1m(Dease_strait_w_18_index));max(Berg18_co2_SST_1m(Wellington_18_index));max(Berg18_co2_SST_1m(island18_index));max(Berg18_co2_SST_1m(cambay18_index));max(Berg18_co2_SST_1m(QMG_18_index));max(Berg18_co2_SST_1m)];
Summary_table_sst_2018 = table(Region_name_2018,sst_num_obsv_2018,sst_mean_2018,sst_std_2018,sst_min_2018,sst_max_2018)

%format so that mean +/- std then min-max beneath
vec1 = round(sst_mean_2018,2);
vec2 = round(sst_std_2018,2);
vec3 = round(sst_min_2018,2);
vec4 = round(sst_max_2018,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sst_mean_std_min_max_2018 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

chl_num_obsv_2018=[sum(~isnan((Berg18_co2_Chl_despike(Bathurst_18_index))));sum(  ~isnan((Berg18_co2_Chl_despike(Dease_strait_w_18_index))));sum(  ~isnan((Berg18_co2_Chl_despike(Wellington_18_index))));sum(  ~isnan((Berg18_co2_Chl_despike(island18_index))));sum(  ~isnan((Berg18_co2_Chl_despike(cambay18_index))));sum(  ~isnan((Berg18_co2_Chl_despike(QMG_18_index))));sum(  ~isnan((Berg18_co2_Chl_despike)))];
chl_mean_2018=[nanmean(Berg18_co2_Chl_despike(Bathurst_18_index));nanmean(Berg18_co2_Chl_despike(Dease_strait_w_18_index));nanmean(Berg18_co2_Chl_despike(Wellington_18_index));nanmean(Berg18_co2_Chl_despike(island18_index));nanmean(Berg18_co2_Chl_despike(cambay18_index));nanmean(Berg18_co2_Chl_despike(QMG_18_index));nanmean(Berg18_co2_Chl_despike)];
chl_std_2018=[nanstd(Berg18_co2_Chl_despike(Bathurst_18_index));nanstd(Berg18_co2_Chl_despike(Dease_strait_w_18_index));nanstd(Berg18_co2_Chl_despike(Wellington_18_index));nanstd(Berg18_co2_Chl_despike(island18_index));nanstd(Berg18_co2_Chl_despike(cambay18_index));nanstd(Berg18_co2_Chl_despike(QMG_18_index));nanstd(Berg18_co2_Chl_despike)];
chl_min_2018=[min(Berg18_co2_Chl_despike(Bathurst_18_index));min(Berg18_co2_Chl_despike(Dease_strait_w_18_index));min(Berg18_co2_Chl_despike(Wellington_18_index));min(Berg18_co2_Chl_despike(island18_index));min(Berg18_co2_Chl_despike(cambay18_index));min(Berg18_co2_Chl_despike(QMG_18_index));min(Berg18_co2_Chl_despike)];
chl_max_2018=[max(Berg18_co2_Chl_despike(Bathurst_18_index));max(Berg18_co2_Chl_despike(Dease_strait_w_18_index));max(Berg18_co2_Chl_despike(Wellington_18_index));max(Berg18_co2_Chl_despike(island18_index));max(Berg18_co2_Chl_despike(cambay18_index));max(Berg18_co2_Chl_despike(QMG_18_index));max(Berg18_co2_Chl_despike)];
Summary_table_chl_2018 = table(Region_name_2018,chl_num_obsv_2018,chl_mean_2018,chl_std_2018,chl_min_2018,chl_max_2018)

%format so that mean +/- std then min-max beneath
vec1 = round(chl_mean_2018,2);
vec2 = round(chl_std_2018,2);
vec3 = round(chl_min_2018,2);
vec4 = round(chl_max_2018,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
chl_mean_std_min_max_2018 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

u10_num_obsv_2018=[sum(~isnan((Berg18_co2_u10(Bathurst_18_index))));sum(  ~isnan((Berg18_co2_u10(Dease_strait_w_18_index))));sum(  ~isnan((Berg18_co2_u10(Wellington_18_index))));sum(  ~isnan((Berg18_co2_u10(island18_index))));sum(  ~isnan((Berg18_co2_u10(cambay18_index))));sum(  ~isnan((Berg18_co2_u10(QMG_18_index))));sum(  ~isnan((Berg18_co2_u10)))];
u10_mean_2018=[nanmean(Berg18_co2_u10(Bathurst_18_index));nanmean(Berg18_co2_u10(Dease_strait_w_18_index));nanmean(Berg18_co2_u10(Wellington_18_index));nanmean(Berg18_co2_u10(island18_index));nanmean(Berg18_co2_u10(cambay18_index));nanmean(Berg18_co2_u10(QMG_18_index));nanmean(Berg18_co2_u10)];
u10_std_2018=[nanstd(Berg18_co2_u10(Bathurst_18_index));nanstd(Berg18_co2_u10(Dease_strait_w_18_index));nanstd(Berg18_co2_u10(Wellington_18_index));nanstd(Berg18_co2_u10(island18_index));nanstd(Berg18_co2_u10(cambay18_index));nanstd(Berg18_co2_u10(QMG_18_index));nanstd(Berg18_co2_u10)];
u10_min_2018=[min(Berg18_co2_u10(Bathurst_18_index));min(Berg18_co2_u10(Dease_strait_w_18_index));min(Berg18_co2_u10(Wellington_18_index));min(Berg18_co2_u10(island18_index));min(Berg18_co2_u10(cambay18_index));min(Berg18_co2_u10(QMG_18_index));min(Berg18_co2_u10)];
u10_max_2018=[max(Berg18_co2_u10(Bathurst_18_index));max(Berg18_co2_u10(Dease_strait_w_18_index));max(Berg18_co2_u10(Wellington_18_index));max(Berg18_co2_u10(island18_index));max(Berg18_co2_u10(cambay18_index));max(Berg18_co2_u10(QMG_18_index));max(Berg18_co2_u10)];
Summary_table_u10_2018 = table(Region_name_2018,u10_num_obsv_2018,u10_mean_2018,u10_std_2018,u10_min_2018,u10_max_2018)

%format so that mean +/- std then min-max beneath
vec1 = round(u10_mean_2018,2);
vec2 = round(u10_std_2018,2);
vec3 = round(u10_min_2018,2);
vec4 = round(u10_max_2018,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
u10_mean_std_min_max_2018 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

flux_num_obsv_2018=[sum(~isnan((Berg18_co2_FCO2_mmol_per_m2_per_d(Bathurst_18_index))));sum(  ~isnan((Berg18_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_18_index))));sum(  ~isnan((Berg18_co2_FCO2_mmol_per_m2_per_d(Wellington_18_index))));sum(  ~isnan((Berg18_co2_FCO2_mmol_per_m2_per_d(island18_index))));sum(  ~isnan((Berg18_co2_FCO2_mmol_per_m2_per_d(cambay18_index))));sum(  ~isnan((Berg18_co2_FCO2_mmol_per_m2_per_d(QMG_18_index))));sum(  ~isnan((Berg18_co2_FCO2_mmol_per_m2_per_d)))];
flux_mean_2018=[nanmean(Berg18_co2_FCO2_mmol_per_m2_per_d(Bathurst_18_index));nanmean(Berg18_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_18_index));nanmean(Berg18_co2_FCO2_mmol_per_m2_per_d(Wellington_18_index));nanmean(Berg18_co2_FCO2_mmol_per_m2_per_d(island18_index));nanmean(Berg18_co2_FCO2_mmol_per_m2_per_d(cambay18_index));nanmean(Berg18_co2_FCO2_mmol_per_m2_per_d(QMG_18_index));nanmean(Berg18_co2_FCO2_mmol_per_m2_per_d)];
flux_std_2018=[nanstd(Berg18_co2_FCO2_mmol_per_m2_per_d(Bathurst_18_index));nanstd(Berg18_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_18_index));nanstd(Berg18_co2_FCO2_mmol_per_m2_per_d(Wellington_18_index));nanstd(Berg18_co2_FCO2_mmol_per_m2_per_d(island18_index));nanstd(Berg18_co2_FCO2_mmol_per_m2_per_d(cambay18_index));nanstd(Berg18_co2_FCO2_mmol_per_m2_per_d(QMG_18_index));nanstd(Berg18_co2_FCO2_mmol_per_m2_per_d)];
flux_min_2018=[min(Berg18_co2_FCO2_mmol_per_m2_per_d(Bathurst_18_index));min(Berg18_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_18_index));min(Berg18_co2_FCO2_mmol_per_m2_per_d(Wellington_18_index));min(Berg18_co2_FCO2_mmol_per_m2_per_d(island18_index));min(Berg18_co2_FCO2_mmol_per_m2_per_d(cambay18_index));min(Berg18_co2_FCO2_mmol_per_m2_per_d(QMG_18_index));min(Berg18_co2_FCO2_mmol_per_m2_per_d)];
flux_max_2018=[max(Berg18_co2_FCO2_mmol_per_m2_per_d(Bathurst_18_index));max(Berg18_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_18_index));max(Berg18_co2_FCO2_mmol_per_m2_per_d(Wellington_18_index));max(Berg18_co2_FCO2_mmol_per_m2_per_d(island18_index));max(Berg18_co2_FCO2_mmol_per_m2_per_d(cambay18_index));max(Berg18_co2_FCO2_mmol_per_m2_per_d(QMG_18_index));max(Berg18_co2_FCO2_mmol_per_m2_per_d)];
Summary_table_flux_2018 = table(Region_name_2018,flux_num_obsv_2018,flux_mean_2018,flux_std_2018,flux_min_2018,flux_max_2018)

%format so that mean +/- std then min-max beneath
vec1 = round(flux_mean_2018,2);
vec2 = round(flux_std_2018,2);
vec3 = round(flux_min_2018,2);
vec4 = round(flux_max_2018,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
flux_mean_std_min_max_2018 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])
%%     Create summary data tables for 2019


Region_name_2019={'Wellington Bay';'Finlayson Islands';'Cambridge Bay';'Queen Maud Gulf';'Average'};

pco2_num_obsv_2019=[sum(  ~isnan((Berg19_co2_pco2_surface(Wellington_19_index))));sum(  ~isnan((Berg19_co2_pco2_surface(island19_index))));sum(  ~isnan((Berg19_co2_pco2_surface(cambay19_index))));sum(  ~isnan((Berg19_co2_pco2_surface(QMG_19_index))));sum(  ~isnan((Berg19_co2_pco2_surface)))];
pCO2_mean_2019=[nanmean(Berg19_co2_pco2_surface(Wellington_19_index));nanmean(Berg19_co2_pco2_surface(island19_index));nanmean(Berg19_co2_pco2_surface(cambay19_index));nanmean(Berg19_co2_pco2_surface(QMG_19_index));nanmean(Berg19_co2_pco2_surface)];
pco2_std_2019=[nanstd(Berg19_co2_pco2_surface(Wellington_19_index));nanstd(Berg19_co2_pco2_surface(island19_index));nanstd(Berg19_co2_pco2_surface(cambay19_index));nanstd(Berg19_co2_pco2_surface(QMG_19_index));nanstd(Berg19_co2_pco2_surface)];
pco2_min_2019=[min(Berg19_co2_pco2_surface(Wellington_19_index));min(Berg19_co2_pco2_surface(island19_index));min(Berg19_co2_pco2_surface(cambay19_index));min(Berg19_co2_pco2_surface(QMG_19_index));min(Berg19_co2_pco2_surface)];
pco2_max_2019=[max(Berg19_co2_pco2_surface(Wellington_19_index));max(Berg19_co2_pco2_surface(island19_index));max(Berg19_co2_pco2_surface(cambay19_index));max(Berg19_co2_pco2_surface(QMG_19_index));max(Berg19_co2_pco2_surface)];

Summary_table_pco2_2019 = table(Region_name_2019,pco2_num_obsv_2019,pCO2_mean_2019,pco2_std_2019,pco2_min_2019,pco2_max_2019)

%format so that mean +/- std then min-max beneath
vec1 = round(pCO2_mean_2019,2);
vec2 = round(pco2_std_2019,2);
vec3 = round(pco2_min_2019,2);
vec4 = round(pco2_max_2019,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
pco2_mean_std_min_max_2019 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])


sal_num_obsv_2019=[sum(  ~isnan((Berg19_co2_TSG_s(Wellington_19_index))));sum(  ~isnan((Berg19_co2_TSG_s(island19_index))));sum(  ~isnan((Berg19_co2_TSG_s(cambay19_index))));sum(  ~isnan((Berg19_co2_TSG_s(QMG_19_index))));sum(  ~isnan((Berg19_co2_TSG_s)))];
sal_mean_2019=[nanmean(Berg19_co2_TSG_s(Wellington_19_index));nanmean(Berg19_co2_TSG_s(island19_index));nanmean(Berg19_co2_TSG_s(cambay19_index));nanmean(Berg19_co2_TSG_s(QMG_19_index));nanmean(Berg19_co2_TSG_s)];
sal_std_2019=[nanstd(Berg19_co2_TSG_s(Wellington_19_index));nanstd(Berg19_co2_TSG_s(island19_index));nanstd(Berg19_co2_TSG_s(cambay19_index));nanstd(Berg19_co2_TSG_s(QMG_19_index));nanstd(Berg19_co2_TSG_s)];
sal_min_2019=[min(Berg19_co2_TSG_s(Wellington_19_index));min(Berg19_co2_TSG_s(island19_index));min(Berg19_co2_TSG_s(cambay19_index));min(Berg19_co2_TSG_s(QMG_19_index));min(Berg19_co2_TSG_s)];
sal_max_2019=[max(Berg19_co2_TSG_s(Wellington_19_index));max(Berg19_co2_TSG_s(island19_index));max(Berg19_co2_TSG_s(cambay19_index));max(Berg19_co2_TSG_s(QMG_19_index));max(Berg19_co2_TSG_s)];

Summary_table_sal_2019 = table(Region_name_2019,sal_num_obsv_2019,sal_mean_2019,sal_std_2019,sal_min_2019,sal_max_2019)

%format so that mean +/- std then min-max beneath
vec1 = round(sal_mean_2019,2);
vec2 = round(sal_std_2019,2);
vec3 = round(sal_min_2019,2);
vec4 = round(sal_max_2019,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sal_mean_std_min_max_2019 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

sst_num_obsv_2019=[sum(  ~isnan((Berg19_co2_SST_1m(Wellington_19_index))));sum(  ~isnan((Berg19_co2_SST_1m(island19_index))));sum(  ~isnan((Berg19_co2_SST_1m(cambay19_index))));sum(  ~isnan((Berg19_co2_SST_1m(QMG_19_index))));sum(  ~isnan((Berg19_co2_SST_1m)))];
sst_mean_2019=[nanmean(Berg19_co2_SST_1m(Wellington_19_index));nanmean(Berg19_co2_SST_1m(island19_index));nanmean(Berg19_co2_SST_1m(cambay19_index));nanmean(Berg19_co2_SST_1m(QMG_19_index));nanmean(Berg19_co2_SST_1m)];
sst_std_2019=[nanstd(Berg19_co2_SST_1m(Wellington_19_index));nanstd(Berg19_co2_SST_1m(island19_index));nanstd(Berg19_co2_SST_1m(cambay19_index));nanstd(Berg19_co2_SST_1m(QMG_19_index));nanstd(Berg19_co2_SST_1m)];
sst_min_2019=[min(Berg19_co2_SST_1m(Wellington_19_index));min(Berg19_co2_SST_1m(island19_index));min(Berg19_co2_SST_1m(cambay19_index));min(Berg19_co2_SST_1m(QMG_19_index));min(Berg19_co2_SST_1m)];
sst_max_2019=[max(Berg19_co2_SST_1m(Wellington_19_index));max(Berg19_co2_SST_1m(island19_index));max(Berg19_co2_SST_1m(cambay19_index));max(Berg19_co2_SST_1m(QMG_19_index));max(Berg19_co2_SST_1m)];
Summary_table_sst_2019 = table(Region_name_2019,sst_num_obsv_2019,sst_mean_2019,sst_std_2019,sst_min_2019,sst_max_2019)

%format so that mean +/- std then min-max beneath
vec1 = round(sst_mean_2019,2);
vec2 = round(sst_std_2019,2);
vec3 = round(sst_min_2019,2);
vec4 = round(sst_max_2019,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
sst_mean_std_min_max_2019 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])


chl_num_obsv_2019=[sum(  ~isnan((Berg19_co2_Chl_despike(Wellington_19_index))));sum(  ~isnan((Berg19_co2_Chl_despike(island19_index))));sum(  ~isnan((Berg19_co2_Chl_despike(cambay19_index))));sum(  ~isnan((Berg19_co2_Chl_despike(QMG_19_index))));sum(  ~isnan((Berg19_co2_Chl_despike)))];
chl_mean_2019=[nanmean(Berg19_co2_Chl_despike(Wellington_19_index));nanmean(Berg19_co2_Chl_despike(island19_index));nanmean(Berg19_co2_Chl_despike(cambay19_index));nanmean(Berg19_co2_Chl_despike(QMG_19_index));nanmean(Berg19_co2_Chl_despike)];
chl_std_2019=[nanstd(Berg19_co2_Chl_despike(Wellington_19_index));nanstd(Berg19_co2_Chl_despike(island19_index));nanstd(Berg19_co2_Chl_despike(cambay19_index));nanstd(Berg19_co2_Chl_despike(QMG_19_index));nanstd(Berg19_co2_Chl_despike)];
chl_min_2019=[min(Berg19_co2_Chl_despike(Wellington_19_index));min(Berg19_co2_Chl_despike(island19_index));min(Berg19_co2_Chl_despike(cambay19_index));min(Berg19_co2_Chl_despike(QMG_19_index));min(Berg19_co2_Chl_despike)];
chl_max_2019=[max(Berg19_co2_Chl_despike(Wellington_19_index));max(Berg19_co2_Chl_despike(island19_index));max(Berg19_co2_Chl_despike(cambay19_index));max(Berg19_co2_Chl_despike(QMG_19_index));max(Berg19_co2_Chl_despike)];
Summary_table_chl_2019 = table(Region_name_2019,chl_num_obsv_2019,chl_mean_2019,chl_std_2019,chl_min_2019,chl_max_2019)

%format so that mean +/- std then min-max beneath
vec1 = round(chl_mean_2019,2);
vec2 = round(chl_std_2019,2);
vec3 = round(chl_min_2019,2);
vec4 = round(chl_max_2019,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
chl_mean_std_min_max_2019 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

u10_num_obsv_2019=[sum(  ~isnan((Berg19_co2_u10(Wellington_19_index))));sum(  ~isnan((Berg19_co2_u10(island19_index))));sum(  ~isnan((Berg19_co2_u10(cambay19_index))));sum(  ~isnan((Berg19_co2_u10(QMG_19_index))));sum(  ~isnan((Berg19_co2_u10)))];
u10_mean_2019=[nanmean(Berg19_co2_u10(Wellington_19_index));nanmean(Berg19_co2_u10(island19_index));nanmean(Berg19_co2_u10(cambay19_index));nanmean(Berg19_co2_u10(QMG_19_index));nanmean(Berg19_co2_u10)];
u10_std_2019=[nanstd(Berg19_co2_u10(Wellington_19_index));nanstd(Berg19_co2_u10(island19_index));nanstd(Berg19_co2_u10(cambay19_index));nanstd(Berg19_co2_u10(QMG_19_index));nanstd(Berg19_co2_u10)];
u10_min_2019=[min(Berg19_co2_u10(Wellington_19_index));min(Berg19_co2_u10(island19_index));min(Berg19_co2_u10(cambay19_index));min(Berg19_co2_u10(QMG_19_index));min(Berg19_co2_u10)];
u10_max_2019=[max(Berg19_co2_u10(Wellington_19_index));max(Berg19_co2_u10(island19_index));max(Berg19_co2_u10(cambay19_index));max(Berg19_co2_u10(QMG_19_index));max(Berg19_co2_u10)];
Summary_table_u10_2019 = table(Region_name_2019,u10_num_obsv_2019,u10_mean_2019,u10_std_2019,u10_min_2019,u10_max_2019)

%format so that mean +/- std then min-max beneath
vec1 = round(u10_mean_2019,2);
vec2 = round(u10_std_2019,2);
vec3 = round(u10_min_2019,2);
vec4 = round(u10_max_2019,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
u10_mean_std_min_max_2019 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])

flux_num_obsv_2019=[sum(  ~isnan((Berg19_co2_FCO2_mmol_per_m2_per_d(Wellington_19_index))));sum(  ~isnan((Berg19_co2_FCO2_mmol_per_m2_per_d(island19_index))));sum(  ~isnan((Berg19_co2_FCO2_mmol_per_m2_per_d(cambay19_index))));sum(  ~isnan((Berg19_co2_FCO2_mmol_per_m2_per_d(QMG_19_index))));sum(  ~isnan((Berg19_co2_FCO2_mmol_per_m2_per_d)))];
flux_mean_2019=[nanmean(Berg19_co2_FCO2_mmol_per_m2_per_d(Wellington_19_index));nanmean(Berg19_co2_FCO2_mmol_per_m2_per_d(island19_index));nanmean(Berg19_co2_FCO2_mmol_per_m2_per_d(cambay19_index));nanmean(Berg19_co2_FCO2_mmol_per_m2_per_d(QMG_19_index));nanmean(Berg19_co2_FCO2_mmol_per_m2_per_d)];
flux_std_2019=[nanstd(Berg19_co2_FCO2_mmol_per_m2_per_d(Wellington_19_index));nanstd(Berg19_co2_FCO2_mmol_per_m2_per_d(island19_index));nanstd(Berg19_co2_FCO2_mmol_per_m2_per_d(cambay19_index));nanstd(Berg19_co2_FCO2_mmol_per_m2_per_d(QMG_19_index));nanstd(Berg19_co2_FCO2_mmol_per_m2_per_d)];
flux_min_2019=[min(Berg19_co2_FCO2_mmol_per_m2_per_d(Wellington_19_index));min(Berg19_co2_FCO2_mmol_per_m2_per_d(island19_index));min(Berg19_co2_FCO2_mmol_per_m2_per_d(cambay19_index));min(Berg19_co2_FCO2_mmol_per_m2_per_d(QMG_19_index));min(Berg19_co2_FCO2_mmol_per_m2_per_d)];
flux_max_2019=[max(Berg19_co2_FCO2_mmol_per_m2_per_d(Wellington_19_index));max(Berg19_co2_FCO2_mmol_per_m2_per_d(island19_index));max(Berg19_co2_FCO2_mmol_per_m2_per_d(cambay19_index));max(Berg19_co2_FCO2_mmol_per_m2_per_d(QMG_19_index));max(Berg19_co2_FCO2_mmol_per_m2_per_d)];
Summary_table_flux_2019 = table(Region_name_2019,flux_num_obsv_2019,flux_mean_2019,flux_std_2019,flux_min_2019,flux_max_2019)

%format so that mean +/- std then min-max beneath
vec1 = round(flux_mean_2019,2);
vec2 = round(flux_std_2019,2);
vec3 = round(flux_min_2019,2);
vec4 = round(flux_max_2019,2);
tmp = [num2cell(vec1)';num2cell(vec2)';num2cell(vec3)';num2cell(vec4)'];
flux_mean_std_min_max_2019 = sprintf('%0.2f ± %0.2f \n %0.2f — %0.2f \n \n',[tmp{:}])
%%     Inside vs outside the Bay analysis

%Inside the Bay

%2016
x=datevec(Berg16_co2_dt(2056:2493))
x=datevec(Berg16_co2_dt(3657:4292))
x=datevec(Berg16_co2_dt(4562:5535))

[Inside_Bay_16_value5thAug, ~]=find(Berg16_co2_Longitude(2056:2493)< -105.04 & Berg16_co2_Longitude(2056:2493)>-105.08 & Berg16_co2_Latitude(2056:2493)>69.095 & Berg16_co2_Latitude(2056:2493)<69.115);
[Inside_Bay_16_value7thAug,~ ]=find(Berg16_co2_Longitude(3657:4292)< -105.04 & Berg16_co2_Longitude(3657:4292)>-105.08 & Berg16_co2_Latitude(3657:4292)>69.095 & Berg16_co2_Latitude(3657:4292)<69.115);
[Inside_Bay_16_value9thAug,~ ]=find(Berg16_co2_Longitude(4562:5535)< -105.04 & Berg16_co2_Longitude(4562:5535)>-105.08 & Berg16_co2_Latitude(4562:5535)>69.095 & Berg16_co2_Latitude(4562:5535)<69.115);

mean(Berg16_co2_pco2_surface(Inside_Bay_16_value5thAug))
mean(Berg16_co2_pco2_surface(Inside_Bay_16_value7thAug))
mean(Berg16_co2_pco2_surface(Inside_Bay_16_value9thAug))

[Outside_Bay_16_value5thAug, ~]=find(Berg16_co2_Longitude(2056:2493)< -105.08 & Berg16_co2_Longitude(2056:2493)>-105.12 & Berg16_co2_Latitude(2056:2493)>69.035 & Berg16_co2_Latitude(2056:2493)<69.055);
[Outside_Bay_16_value7thAug,~ ]=find(Berg16_co2_Longitude(3657:4292)< -105.08 & Berg16_co2_Longitude(3657:4292)>-105.12 & Berg16_co2_Latitude(3657:4292)>69.035 & Berg16_co2_Latitude(3657:4292)<69.055);
[Outside_Bay_16_value9thAug,~ ]=find(Berg16_co2_Longitude(4562:5535)< -105.08 & Berg16_co2_Longitude(4562:5535)>-105.12 & Berg16_co2_Latitude(4562:5535)>69.035 & Berg16_co2_Latitude(4562:5535)<69.055);

mean(Berg16_co2_pco2_surface(Outside_Bay_16_value5thAug))
mean(Berg16_co2_pco2_surface(Outside_Bay_16_value7thAug))
mean(Berg16_co2_pco2_surface(Outside_Bay_16_value9thAug))


%2017
x=datevec(Berg17_co2_dt(1492:1728))%4-5th?
x=datevec(Berg17_co2_dt(3070:3572))% 6 7 
x=datevec(Berg17_co2_dt(3573:4428))% 8 9
x=datevec(Berg17_co2_dt(4428:4528))% 17
x=datevec(Berg17_co2_dt([6460:6529,7140:7366]))% 19 20th
x=datevec(Berg17_co2_dt([15505:15542,16274:16397]))% 29th

[Inside_Bay_17_value4thAug, ~]=find(Berg17_co2_Longitude(1492:1728)< -105.04 & Berg17_co2_Longitude(1492:1728)>-105.08 & Berg17_co2_Latitude(1492:1728)>69.095 & Berg17_co2_Latitude(1492:1728)<69.115);
[Inside_Bay_17_value6thAug,~ ]=find(Berg17_co2_Longitude(3070:3572)< -105.04 & Berg17_co2_Longitude(3070:3572)>-105.08  & Berg17_co2_Latitude(3070:3572)>69.095 & Berg17_co2_Latitude(3070:3572)<69.115);
[Inside_Bay_17_value8thAug,~ ]=find(Berg17_co2_Longitude(3573:4428)< -105.04 & Berg17_co2_Longitude(3573:4428)>-105.08 & Berg17_co2_Latitude(3573:4428)>69.095 & Berg17_co2_Latitude(3573:4428)<69.115);
[Inside_Bay_17_value17thAug, ~]=find(Berg17_co2_Longitude(4428:4528)< -105.04 & Berg17_co2_Longitude(4428:4528)>-105.08 & Berg17_co2_Latitude(4428:4528)>69.095 & Berg17_co2_Latitude(4428:4528)<69.115);
[Inside_Bay_17_value19thAug,~ ]=find(Berg17_co2_Longitude([6460:6529,7140:7366])< -105.04 & Berg17_co2_Longitude([6460:6529,7140:7366])>-105.08 & Berg17_co2_Latitude([6460:6529,7140:7366])>69.095 & Berg17_co2_Latitude([6460:6529,7140:7366])<69.115);
[Inside_Bay_17_value29thAug,~ ]=find(Berg17_co2_Longitude([15505:15542,16274:16397])< -105.04 & Berg17_co2_Longitude([15505:15542,16274:16397])>-105.08 & Berg17_co2_Latitude([15505:15542,16274:16397])>69.095 & Berg17_co2_Latitude([15505:15542,16274:16397])<69.115);

mean(Berg17_co2_pco2_surface(Inside_Bay_17_value4thAug))
mean(Berg17_co2_pco2_surface(Inside_Bay_17_value6thAug))
mean(Berg17_co2_pco2_surface(Inside_Bay_17_value8thAug))
mean(Berg17_co2_pco2_surface(Inside_Bay_17_value17thAug))
mean(Berg17_co2_pco2_surface(Inside_Bay_17_value19thAug))
mean(Berg17_co2_pco2_surface(Inside_Bay_17_value29thAug))

[Outside_Bay_17_value4thAug, ~]=find(Berg17_co2_Longitude(1492:1728)< -105.08 & Berg17_co2_Longitude(1492:1728)>-105.12 & Berg17_co2_Latitude(1492:1728)>69.035 & Berg17_co2_Latitude(1492:1728)<69.055);
[Outside_Bay_17_value6thAug,~ ]=find(Berg17_co2_Longitude(3070:3572)< -105.08 & Berg17_co2_Longitude(3070:3572)>-105.12 & Berg17_co2_Latitude(3070:3572)>69.035 & Berg17_co2_Latitude(3070:3572)<69.055);
[Outside_Bay_17_value8thAug,~ ]=find(Berg17_co2_Longitude(3573:4428)< -105.08 & Berg17_co2_Longitude(3573:4428)>-105.12 & Berg17_co2_Latitude(3573:4428)>69.035 & Berg17_co2_Latitude(3573:4428)<69.055);
[Outside_Bay_17_value17thAug, ~]=find(Berg17_co2_Longitude(4428:4528)< -105.08 & Berg17_co2_Longitude(4428:4528)>-105.12 & Berg17_co2_Latitude(4428:4528)>69.035 & Berg17_co2_Latitude(4428:4528)<69.055);
[Outside_Bay_17_value19thAug,~ ]=find(Berg17_co2_Longitude([6460:6529,7140:7366])< -105.08 & Berg17_co2_Longitude([6460:6529,7140:7366])>-105.12 & Berg17_co2_Latitude([6460:6529,7140:7366])>69.035 & Berg17_co2_Latitude([6460:6529,7140:7366])<69.055);
[Outside_Bay_17_value29thAug,~ ]=find(Berg17_co2_Longitude([15505:15542,16274:16397])< -105.08 & Berg17_co2_Longitude([15505:15542,16274:16397])>-105.12 & Berg17_co2_Latitude([15505:15542,16274:16397])>69.035 & Berg17_co2_Latitude([15505:15542,16274:16397])<69.055);

mean(Berg17_co2_pco2_surface(Outside_Bay_17_value4thAug))
mean(Berg17_co2_pco2_surface(Outside_Bay_17_value6thAug))
mean(Berg17_co2_pco2_surface(Outside_Bay_17_value8thAug))
mean(Berg17_co2_pco2_surface(Outside_Bay_17_value17thAug))
mean(Berg17_co2_pco2_surface(Outside_Bay_17_value19thAug))
mean(Berg17_co2_pco2_surface(Outside_Bay_17_value29thAug))


%2018
x=datevec(Berg18_co2_dt(1:176))%31 1st
x=datevec(Berg18_co2_dt(1437:1987))%  2md 3rd
x=datevec(Berg18_co2_dt(4082:4143))% 8

[Inside_Bay_18_value31stJuly, ~]=find(Berg18_co2_Longitude(1:176)< -105.04 & Berg18_co2_Longitude(1:176)>-105.08 & Berg18_co2_Latitude(1:176)>69.095 & Berg18_co2_Latitude(1:176)<69.115);
[Inside_Bay_18_value2ndAug,~ ]=find(Berg18_co2_Longitude(1437:1987)< -105.04 & Berg18_co2_Longitude(1437:1987)>-105.08  & Berg18_co2_Latitude(1437:1987)>69.095 & Berg18_co2_Latitude(1437:1987)<69.115);
[Inside_Bay_18_value8thAug,~ ]=find(Berg18_co2_Longitude(4082:4143)< -105.04 & Berg18_co2_Longitude(4082:4143)>-105.08 & Berg18_co2_Latitude(4082:4143)>69.095 & Berg18_co2_Latitude(4082:4143)<69.115);

mean(Berg18_co2_pco2_surface(Inside_Bay_18_value31stJuly))
mean(Berg18_co2_pco2_surface(Inside_Bay_18_value2ndAug))
mean(Berg18_co2_pco2_surface(Inside_Bay_18_value8thAug))

[Outside_Bay_18_value31stJuly, ~]=find(Berg18_co2_Longitude(1:176)< -105.08 & Berg18_co2_Longitude(1:176)>-105.12 & Berg18_co2_Latitude(1:176)>69.035 & Berg18_co2_Latitude(1:176)<69.055);
[Outside_Bay_18_value2ndAug,~ ]=find(Berg18_co2_Longitude(1437:1987)< -105.08 & Berg18_co2_Longitude(1437:1987)>-105.12 & Berg18_co2_Latitude(1437:1987)>69.035 & Berg18_co2_Latitude(1437:1987)<69.055);
[Outside_Bay_18_value8thAug,~ ]=find(Berg18_co2_Longitude(4082:4143)< -105.08 & Berg18_co2_Longitude(4082:4143)>-105.12 & Berg18_co2_Latitude(4082:4143)>69.035 & Berg18_co2_Latitude(4082:4143)<69.055);

mean(Berg18_co2_pco2_surface(Outside_Bay_18_value31stJuly))
mean(Berg18_co2_pco2_surface(Outside_Bay_18_value2ndAug))
mean(Berg18_co2_pco2_surface(Outside_Bay_18_value8thAug))


%2019
x=datevec(Berg19_co2_dt(1:122))% 9 TH
x=datevec(Berg19_co2_dt(8331:9066))% 18-19
x=datevec(Berg19_co2_dt(10880:11058))% 21ST

[Inside_Bay_19_value9thAug, ~]=find(Berg19_co2_Longitude(1:122)< -105.04 & Berg19_co2_Longitude(1:122)>-105.08 & Berg19_co2_Latitude(1:122)>69.095 & Berg19_co2_Latitude(1:122)<69.115);
[Inside_Bay_19_value18thAug,~ ]=find(Berg19_co2_Longitude(8331:9066)< -105.04 & Berg19_co2_Longitude(8331:9066)>-105.08 & Berg19_co2_Latitude(8331:9066)>69.095 & Berg19_co2_Latitude(8331:9066)<69.115);
[Inside_Bay_19_value21stAug,~ ]=find(Berg19_co2_Longitude(10880:11058)< -105.04 & Berg19_co2_Longitude(10880:11058)>-105.08 & Berg19_co2_Latitude(10880:11058)>69.095 & Berg19_co2_Latitude(10880:11058)<69.115);

mean(Berg19_co2_pco2_surface(Inside_Bay_19_value9thAug))
mean(Berg19_co2_pco2_surface(Inside_Bay_19_value18thAug))
mean(Berg19_co2_pco2_surface(Inside_Bay_19_value21stAug))

[Outside_Bay_19_value9thAug, ~]=find(Berg19_co2_Longitude(1:122)< -105.08 & Berg19_co2_Longitude(1:122)>-105.12 & Berg19_co2_Latitude(1:122)>69.035 & Berg19_co2_Latitude(1:122)<69.055);
[Outside_Bay_19_value18thAug,~ ]=find(Berg19_co2_Longitude(8331:9066)< -105.08 & Berg19_co2_Longitude(8331:9066)>-105.12 & Berg19_co2_Latitude(8331:9066)>69.035 & Berg19_co2_Latitude(8331:9066)<69.055);
[Outside_Bay_19_value21stAug,~ ]=find(Berg19_co2_Longitude(10880:11058)< -105.08 & Berg19_co2_Longitude(10880:11058)>-105.12 & Berg19_co2_Latitude(10880:11058)>69.035 & Berg19_co2_Latitude(10880:11058)<69.055);

mean(Berg19_co2_pco2_surface(Outside_Bay_19_value9thAug))
mean(Berg19_co2_pco2_surface(Outside_Bay_19_value18thAug))
mean(Berg19_co2_pco2_surface(Outside_Bay_19_value21stAug))
%%
%figure plotting 
%%     Figure 1 - map of Kitikmeot Sea

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
%%     Misc exploratory plots

%plot timseries of temperature
% close all 
h1 = figure('Position', get(0, 'Screensize'));
subtightplot(1,4,1,[],[0.15 0.025],[0.03 0.015])
plot(Berg16_co2_dt,Berg16_co2_TSG_t,'*b','MarkerSize',0.5)
hold on
plot(Berg16_co2_dt,Berg16_co2_equtemp,'*k','MarkerSize',0.5)
plot(Berg16_co2_dt,Berg16_co2_SST_1m,'*m','MarkerSize',0.5)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 23])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
title('2016','FontSize',12)
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',16); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
% Construct a Legend with the data from the sub-plots
[hL,icons]=legend('TSG','T equ','T insitu','Location','SouthEast');
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',20);

subtightplot(1,4,2,[],[0.15 0.025],[0.03 0.015])
plot(Berg17_co2_dt,Berg17_co2_TSG_t,'*b','MarkerSize',0.5)
hold on
plot(Berg17_co2_dt,Berg17_co2_equtemp,'*k','MarkerSize',0.5)
plot(Berg17_co2_dt,Berg17_co2_SST_1m,'*m','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])
% Construct a Legend with the data from the sub-plots
[hL,icons]=legend('TSG','T equ','T insitu extrapolated','Location','SouthEast');
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',20);

subtightplot(1,4,3,[],[0.15 0.025],[0.03 0.015])
plot(Berg18_co2_dt,Berg18_co2_TSG_t,'*b','MarkerSize',0.5)
hold on
plot(Berg18_co2_dt,Berg18_co2_equtemp,'*k','MarkerSize',0.5)
plot(Berg18_co2_dt,Berg18_co2_SST_1m,'*m','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])
% Construct a Legend with the data from the sub-plots
[hL,icons]=legend('TSG','T equ','T insitu extrapolated','Location','SouthEast');
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',20);

subtightplot(1,4,4,[],[0.15 0.025],[0.03 0.015])
plot(Berg19_co2_dt,Berg19_co2_TSG_t,'*b','MarkerSize',0.5)
hold on
plot(Berg19_co2_dt,Berg19_co2_equtemp,'*k','MarkerSize',0.5)
plot(Berg19_co2_dt,Berg19_co2_SST_1m,'*m','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
% Construct a Legend with the data from the sub-plots
[hL,icons]=legend('TSG','T equ','T insitu','Location','SouthEast');
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',20);          

% saveas(h1,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_temp_timeseries.jpg')

%plot timseries of salinity
% close all 
h2 = figure('Position', get(0, 'Screensize'));
subtightplot(1,4,1,[],[0.15 0.025],[0.03 0.015])
plot(Berg16_co2_dt,Berg16_co2_TSG_s,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([12 29])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
title('2016','FontSize',12)
ylabel({['Salinity (PSU)']},'fontsize',16); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)

subtightplot(1,4,2,[],[0.15 0.025],[0.03 0.015])
plot(Berg17_co2_dt,Berg17_co2_TSG_s,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([12 29])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(1,4,3,[],[0.15 0.025],[0.03 0.015])
plot(Berg18_co2_dt,Berg18_co2_TSG_s,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([12 29])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(1,4,4,[],[0.15 0.025],[0.03 0.015])
plot(Berg19_co2_dt,Berg19_co2_TSG_s,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([12 29])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
 
% saveas(h2,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_sal_timeseries.jpg')

%plot timseries of Pco2
% close all 
h3 = figure('Position', get(0, 'Screensize'));
subtightplot(1,4,1,[],[0.15 0.025],[0.03 0.015])
plot(Berg16_co2_dt,Berg16_co2_pco2_surface,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([190 600])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
title('2016','FontSize',12)
ylabel({['pCO2 SW']},'fontsize',16); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)

subtightplot(1,4,2,[],[0.15 0.025],[0.03 0.015])
plot(Berg17_co2_dt,Berg17_co2_pco2_surface,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([190 600])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(1,4,3,[],[0.15 0.025],[0.03 0.015])
plot(Berg18_co2_dt,Berg18_co2_pco2_surface,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([190 600])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(1,4,4,[],[0.15 0.025],[0.03 0.015])
plot(Berg19_co2_dt,Berg19_co2_pco2_surface,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([190 600])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
 
% saveas(h3,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_co2_timeseries.jpg')


%plot timseries of chloro
% close all 
h4 = figure('Position', get(0, 'Screensize'));
% subtightplot(1,4,1,[],[0.15 0.025],[0.03 0.015])
% plot(Berg16_co2_dt,Berg16_co2_Chl_despike,'*b','MarkerSize',0.5)
% set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
% rotateXLabels( gca(), 90 )
% datetick('x','mmm-dd-yyyy', 'keepticks') 
% % ylim([190 600])
% xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
% title('2016','FontSize',12)
% ylabel({['chloophyll']},'fontsize',16); 
% set(gca,'FontSize',12)
% set(gca,'FontSize',12)

subtightplot(1,4,2,[],[0.15 0.025],[0.03 0.015])
plot(Berg17_co2_dt,Berg17_co2_Chl_despike,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
% ylim([190 600])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(1,4,3,[],[0.15 0.025],[0.03 0.015])
plot(Berg18_co2_dt,Berg18_co2_Chl_despike,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
% ylim([190 600])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(1,4,4,[],[0.15 0.025],[0.03 0.015])
plot(Berg19_co2_dt,Berg19_co2_u10,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
% ylim([190 600])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])

% saveas(h4,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_chl_timeseries.jpg')

%plot timseries of flux 
h5 = figure('Position', get(0, 'Screensize'));
subtightplot(1,4,1,[],[0.15 0.025],[0.03 0.015])
plot(Berg16_co2_dt,Berg16_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
title('2016','FontSize',12)
ylabel({['Flux CO2 mmol m-2 d-1']},'fontsize',16); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)

subtightplot(1,4,2,[],[0.15 0.025],[0.03 0.015])
plot(Berg17_co2_dt,Berg17_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(1,4,3,[],[0.15 0.025],[0.03 0.015])
plot(Berg18_co2_dt,Berg18_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(1,4,4,[],[0.15 0.025],[0.03 0.015])
plot(Berg19_co2_dt,Berg19_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])

% saveas(h5,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_flux_timeseries.jpg')


%plot timseries of wind 
h6 = figure('Position', get(0, 'Screensize'));
subtightplot(1,4,1,[],[0.15 0.025],[0.03 0.015])
plot(Berg16_co2_dt,Berg16_co2_u10,'-b','MarkerSize',0.5)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 20])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
title('2016','FontSize',12)
ylabel({['Flux CO2 mmol m-2 d-1']},'fontsize',16); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)

subtightplot(1,4,2,[],[0.15 0.025],[0.03 0.015])
plot(Berg17_co2_dt,Berg17_co2_u10,'-b','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 20])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(1,4,3,[],[0.15 0.025],[0.03 0.015])
plot(Berg18_co2_dt,Berg18_co2_u10,'-b','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 20])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(1,4,4,[],[0.15 0.025],[0.03 0.015])
plot(Berg19_co2_dt,Berg19_co2_u10,'-b','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([0 20])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])

% saveas(h6,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_wind_timeseries.jpg')


%plot timseries of deltapco2 
h7 = figure('Position', get(0, 'Screensize'));
subtightplot(1,4,1,[],[0.15 0.025],[0.03 0.015])
plot(Berg16_co2_dt,Berg16_co2_pco2_surface-Berg16_co2_atmCO2,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-200 200])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
title('2016','FontSize',12)
ylabel({['delta pco2']},'fontsize',16); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)

subtightplot(1,4,2,[],[0.15 0.025],[0.03 0.015])
plot(Berg17_co2_dt,Berg17_co2_pco2_surface-Berg17_co2_atmCO2,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-200 200])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(1,4,3,[],[0.15 0.025],[0.03 0.015])
plot(Berg18_co2_dt,Berg18_co2_pco2_surface-Berg18_co2_atmCO2,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-200 200])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(1,4,4,[],[0.15 0.025],[0.03 0.015])
plot(Berg19_co2_dt,Berg19_co2_pco2_surface-Berg19_co2_atmCO2,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-200 200])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])

% saveas(h7,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_deltapco2_timeseries.jpg')
%%     all timeseries data on 1 plot
h201 = figure('Position', get(0, 'Screensize'));
subtightplot(4,4,1,[],[0.15 0.025],[0.25 0.25]);
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
plot(Berg16_co2_dt,Berg16_co2_equtemp,'*','MarkerSize',0.5);
hold on
plot(Berg16_co2_dt,Berg16_co2_TSG_t,'*','MarkerSize',0.5);
plot(Berg16_co2_dt,Berg16_co2_SST_1m,'*','MarkerSize',0.5);
set(gca, 'XTick', []);
ylim([0 23])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])]);
title('2016','FontSize',12)
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
% Construct a Legend with the data from the sub-plots
% Construct a Legend with the data from the sub-plots
[hL1,icons]=legend('T_(_e_q_u_)','SST_(_t_s_g_)','SST_(_1_m_)','Location','NorthWest');
hL1.FontSize = 10;
set(hL1,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
set(hL1,'Position',[0.243576388888287 0.881499285533218 0.0595052091156443 0.0996260705921383]);
set(hL1,'color','none');

subtightplot(4,4,2,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg17_co2_dt,Berg17_co2_equtemp,'*','MarkerSize',0.5)
hold on
plot(Berg17_co2_dt,Berg17_co2_TSG_t,'*','MarkerSize',0.5)
plot(Berg17_co2_dt,Berg17_co2_SST_1m,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2017','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])
% Construct a Legend with the data from the sub-plots
% Construct a Legend with the data from the sub-plots
[hL2,icons]=legend('T_(_e_q_u_)','SST_(_t_s_g_)','SST_(_1_m_)','Location','NorthWest');
hL2.FontSize = 10;
set(hL2,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
set(hL2,'Position',[0.37065972222162 0.881499285533219 0.0595052091156443 0.0996260705921383]);
set(hL2,'color','none');


subtightplot(4,4,3,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg18_co2_dt,Berg18_co2_equtemp,'*','MarkerSize',0.5)
hold on
plot(Berg18_co2_dt,Berg18_co2_TSG_t,'*','MarkerSize',0.5)
plot(Berg18_co2_dt,Berg18_co2_SST_1m,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2018','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])
% Construct a Legend with the data from the sub-plots
% Construct a Legend with the data from the sub-plots
[hL3,icons]=legend('T_(_e_q_u_)','SST_(_t_s_g_)','SST_(_1_m_)','Location','NorthWest');
hL3.FontSize = 10;
set(hL3,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
set(hL3,'Position',[0.499826388888287 0.867302355258567 0.0595052091156444 0.115898719020232]);
set(hL3,'color','none');

subtightplot(4,4,4,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg19_co2_dt,Berg19_co2_equtemp,'*','MarkerSize',0.5)
hold on
plot(Berg19_co2_dt,Berg19_co2_TSG_t,'*','MarkerSize',0.5)
plot(Berg19_co2_dt,Berg19_co2_SST_1m,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2019','FontSize',12)
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
% Construct a Legend with the data from the sub-plots
[hL4,icons]=legend('T_(_e_q_u_)','SST_(_t_s_g_)','SST_(_1_m_)','Location','NorthWest');
hL4.FontSize = 10;
set(hL4,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
set(hL4,'Position',[0.627430555554954 0.881499285533218 0.0595052091156444 0.0996260705921383]);
set(hL4,'color','none');

subtightplot(4,4,5,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg16_co2_dt,Berg16_co2_TSG_s,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([12 29])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
ylabel({['Salinity (PSU)']},'fontsize',12); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)

subtightplot(4,4,6,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg17_co2_dt,Berg17_co2_TSG_s,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([12 29])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(4,4,7,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg18_co2_dt,Berg18_co2_TSG_s,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([12 29])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(4,4,8,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg19_co2_dt,Berg19_co2_TSG_s,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([12 29])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
 
subtightplot(4,4,9,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg16_co2_dt,Berg16_co2_pco2_surface,'*','MarkerSize',0.5)
hold on
plot(Berg16_co2_dt,Berg16_co2_atmCO2,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
ylabel({['pCO_2 (ppm)']},'fontsize',12); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
% Construct a Legend with the data from the sub-plots
[hL5,icons]=legend('pCO_2 _(_s_w_)','pCO_2 _(_a_t_m_)','Location','SouthWest');
hL5.FontSize = 10;
set(hL5,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
set(hL5,'Position',[0.248263888888889 0.363299663299663 0.0688802093391617 0.0642676781644727]);
set(hL5,'color','none');

subtightplot(4,4,10,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg17_co2_dt,Berg17_co2_pco2_surface,'*','MarkerSize',0.5)
hold on
plot(Berg17_co2_dt,Berg17_co2_atmCO2,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])
% Construct a Legend with the data from the sub-plots
[hL6,icons]=legend('pCO_2 _(_s_w_)','pCO_2 _(_a_t_m_)','Location','NorthEast');
hL6.FontSize = 10;
set(hL6,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
% set(hL6,'Position',[0.248263888888889 0.363299663299663 0.0688802093391617 0.0642676781644727]);
set(hL6,'color','none');


subtightplot(4,4,11,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg18_co2_dt,Berg18_co2_pco2_surface,'*','MarkerSize',0.5)
hold on
plot(Berg18_co2_dt,Berg18_co2_atmCO2,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])
% Construct a Legend with the data from the sub-plots
[hL7,icons]=legend('pCO_2 _(_s_w_)','pCO_2 _(_a_t_m_)','Location','NorthEast');
hL7.FontSize = 10;
set(hL7,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
% set(hL5,'Position',[0.248263888888889 0.363299663299663 0.0688802093391617 0.0642676781644727]);
set(hL7,'color','none');


subtightplot(4,4,12,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder)
plot(Berg19_co2_dt,Berg19_co2_pco2_surface,'*','MarkerSize',0.5)
hold on
plot(Berg19_co2_dt,Berg19_co2_atmCO2,'*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
% Construct a Legend with the data from the sub-plots
[hL8,icons]=legend('pCO_2 _(_s_w_)','pCO_2 _(_a_t_m_)','Location','NorthEast');
hL8.FontSize = 10;
set(hL8,'Box','off')
% % Programatically move the Legend
% newPosition = [0.9 0.8 0.1 0.1];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);
% Find the 'line' objects
icons = findobj(icons,'Type','line');
% Find lines that use a marker
icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
set(icons,'MarkerSize',8);          
% set(hL5,'Position',[0.248263888888889 0.363299663299663 0.0688802093391617 0.0642676781644727]);
set(hL8,'color','none');

% subtightplot(4,4,13,[],[0.15 0.025],[0.25 0.25])
% myColorOrder=magma(3);
% set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
% colormap(myColorOrder);
% plot(Berg16_co2_dt,Berg16_co2_Chl_despike,'*','MarkerSize',0.5)
% set(gca, 'XTick', [])
% % ylim([190 600])
% xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
% ylabel({['Chlorophyll-a' char(10),'fluorescence',' (' , num2str(micro_symbol),'g L^{-1})']},'fontsize',12); 
% set(gca,'FontSize',12)
% set(gca,'FontSize',12)
% set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
% rotateXLabels( gca(), 90 )
% datetick('x','mmm-dd-yyyy', 'keepticks') 
% xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
% set(gca,'FontSize',12)

subtightplot(4,4,14,[],[0.15 0.025],[0.25 0.25]);
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
plot(Berg17_co2_dt,Berg17_co2_Chl_despike,'*','MarkerSize',0.5);
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
set(gca, 'XTick', []);
% ylim([190 600])
set(gca,'Yticklabel',[]) ;
set(gca,'FontSize',12);
set(gca,'FontSize',12);
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])]);
set(gca, 'XTick', [Berg17_co2_dt(1):4:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])
set(gca,'FontSize',12)

subtightplot(4,4,15,[],[0.15 0.025],[0.25 0.25]);
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
plot(Berg18_co2_dt,Berg18_co2_Chl_despike,'*','MarkerSize',0.5);
set(gca, 'XTick', []);
% ylim([190 600])
set(gca,'Yticklabel',[]) ;
set(gca,'FontSize',12);
set(gca,'FontSize',12);
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])]);
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])
set(gca,'FontSize',12)

subtightplot(4,4,16,[],[0.15 0.025],[0.25 0.25])
myColorOrder=magma(3);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
plot(Berg19_co2_dt,Berg19_co2_Chl_despike,'*','MarkerSize',0.5)
set(gca, 'XTick', []);
ylim([0 2]);
set(gca,'Yticklabel',[]) ;
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
set(gca,'FontSize',12)

saveas(h201,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_timeseries_all.jpg')

h10=figure(10)
subtightplot(5,4,17,[],[0.15 0.025],[0.25 0.25])
plot(Berg16_co2_dt,Berg16_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
ylabel({['Flux CO2 ' char(10) 'mmol m-2 d-1']},'fontsize',16); 
set(gca,'FontSize',12)
set(gca,'FontSize',12)

subtightplot(5,4,18,[],[0.15 0.025],[0.25 0.25])
plot(Berg17_co2_dt,Berg17_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg17_co2_dt(1):2:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(5,4,19,[],[0.15 0.025],[0.25 0.25])
plot(Berg18_co2_dt,Berg18_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(5,4,20,[],[0.15 0.025],[0.25 0.25])
plot(Berg19_co2_dt,Berg19_co2_FCO2_mmol_per_m2_per_d,'*b','MarkerSize',0.5)
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd-yyyy', 'keepticks') 
ylim([-60 20])
set(gca,'Yticklabel',[]) 
set(gca,'FontSize',12)
set(gca,'FontSize',12)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
%%     map of Kitikmeot Sea with subregions as boxes
figure(7000)
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
title('2019')

%bathurst box
m_line([-110 -107],[66.5 66.5],'color',colour_olivedrab,'linewidth',3);
m_line([-110 -107],[68.5 68.5],'color',colour_olivedrab,'linewidth',3);
m_line([-110 -110],[66.5 68.5],'color',colour_olivedrab,'linewidth',3);
m_line([-107 -107],[66.5 68.5],'color',colour_olivedrab,'linewidth',3);

%Wellington Box
m_line([-108 -106.25],[69 69],'color',colour_siennna,'linewidth',3);
m_line([-108 -106.25],[69.5 69.5],'color',colour_siennna,'linewidth',3);
m_line([-108 -108],[69 69.5],'color',colour_siennna,'linewidth',3);
m_line([-106.25 -106.25],[69 69.5],'color',colour_siennna,'linewidth',3);

%Dease strait West
m_line([-110 -106.25],[68.5 68.5],'color',colour_darkblue,'linewidth',3);
m_line([-110 -106.25],[69 69],'color',colour_darkblue,'linewidth',3);
m_line([-110 -110],[68.5 69],'color',colour_darkblue,'linewidth',3);
m_line([-106.25 -106.25],[68.5 69],'color',colour_darkblue,'linewidth',3);

%Tower islands
m_line([-106.25 -105.5],[68.75 68.75],'color',colour_firebrick,'linewidth',3);
m_line([-106.25 -105.5],[69.25 69.25],'color',colour_firebrick,'linewidth',3);
m_line([-106.25 -106.25],[68.75 69.25],'color',colour_firebrick,'linewidth',3);
m_line([-105.5 -105.5],[68.75 69.25],'color',colour_firebrick,'linewidth',3);

%Cambay 
m_line([-105.5 -104.75],[69 69],'color',colour_goldenrod,'linewidth',3);
m_line([-105.5 -104.75],[69.25 69.25],'color',colour_goldenrod,'linewidth',3);
m_line([-105.5 -105.5],[69 69.25],'color',colour_goldenrod,'linewidth',3);
m_line([-104.75 -104.75],[69 69.25],'color',colour_goldenrod,'linewidth',3);

%Queem ,aud Gulf
m_line([-105.5 -99],[68 68],'color',colour_forestgreen,'linewidth',3);
m_line([-105.5 -99],[69 69],'color',colour_forestgreen,'linewidth',3);
m_line([-105.5 -105.5],[68 69],'color',colour_forestgreen,'linewidth',3);
m_line([-99 -99],[68 69],'color',colour_forestgreen,'linewidth',3);

%chantry inlet
m_line([-97 -95],[67.5 67.5],'color',colour_teal,'linewidth',3);
m_line([-97 -95],[69 69],'color',colour_teal,'linewidth',3);
m_line([-97 -97],[67.5 69],'color',colour_teal,'linewidth',3);
m_line([-95 -95],[67.5 69],'color',colour_teal,'linewidth',3);
%%     Figure 4 - all timeseries data on 1 plot with Kitikmeot Sea map at top
h9 = figure('Position', get(0, 'Screensize'));
subtightplot(9,4,[1:12],[0.14 0.01],[0.12 0.01],[0.25 0.25]);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'fontsize',11)
set(gca,'fontsize',11)
m_gshhs_f('patch',[.5 .5 .5]);
%bathurst box
L(1)=m_line([-110 -107],[66.5 66.5],'color',colour_indianred,'linewidth',3);
m_line([-110 -107],[68.45 68.45],'color',colour_indianred,'linewidth',3);
m_line([-110 -110],[66.5 68.5],'color',colour_indianred,'linewidth',3);
m_line([-107 -107],[66.5 68.5],'color',colour_indianred,'linewidth',3);
%Dease strait West
L(2)=m_line([-110 -106.25],[68.5 68.5],'color',colour_mustard,'linewidth',3);
m_line([-110 -106.25],[69 69],'color',colour_mustard,'linewidth',3);
m_line([-110 -110],[68.5 69],'color',colour_mustard,'linewidth',3);
m_line([-106.30 -106.30],[68.5 69],'color',colour_mustard,'linewidth',3);
%Wellington Box
L(3)=m_line([-108 -106.25],[69.05 69.05],'color',colour_darkblue,'linewidth',3);
m_line([-108 -106.25],[69.5 69.5],'color',colour_darkblue,'linewidth',3);
m_line([-108 -108],[69 69.5],'color',colour_darkblue,'linewidth',3);
m_line([-106.3 -106.3],[69 69.5],'color',colour_darkblue,'linewidth',3);
%Tower islands
L(4)=m_line([-106.25 -105.5],[68.75 68.75],'color',colour_mediumturquoise,'linewidth',3);
m_line([-106.25 -105.5],[69.25 69.25],'color',colour_mediumturquoise,'linewidth',3);
m_line([-106.20 -106.20],[68.75 69.25],'color',colour_mediumturquoise,'linewidth',3);
m_line([-105.55 -105.55],[68.75 69.25],'color',colour_mediumturquoise,'linewidth',3);
%Cambay 
L(5)=m_line([-105.5 -104.75],[69 69],'color',colour_rose,'linewidth',3);
m_line([-105.5 -104.75],[69.25 69.25],'color',colour_rose,'linewidth',3);
m_line([-105.45 -105.45],[69 69.25],'color',colour_rose,'linewidth',3);
m_line([-104.75 -104.75],[69 69.25],'color',colour_rose,'linewidth',3);
%Queem ,aud Gulf
L(6)=m_line([-105.5 -99],[68 68],'color',colour_siennna,'linewidth',3);
m_line([-105.5 -99],[68.95 68.95],'color',colour_siennna,'linewidth',3);
m_line([-105.45 -105.45],[68 69],'color',colour_siennna,'linewidth',3);
m_line([-99 -99],[68 69],'color',colour_siennna,'linewidth',3);
%chantry inlet
L(7)=m_line([-97 -95],[67.5 67.5],'color',colour_orchid,'linewidth',3);
m_line([-97 -95],[69 69],'color',colour_orchid,'linewidth',3);
m_line([-97 -97],[67.5 69],'color',colour_orchid,'linewidth',3);
m_line([-95 -95],[67.5 69],'color',colour_orchid,'linewidth',3);
y=ylabel(['Latitude (' degree_symbol 'N)'],'Fontsize',16);
set(y,'Units','Normalized','Position',[-0.13,0.5,0]);
x=xlabel(['Longitude (' degree_symbol 'W)'],'Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.14,0]); 
text(-0.2,1.03,'(a)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 
[hL1,icons]=legend(L([1:7]),'Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on')
% % Programatically move the Legend
newPosition = [0.65 0.85 0.1 0.1];
newUnits = 'normalized';
set(hL1,'Position', newPosition,'Units', newUnits);     
set(hL1,'color','w');

subtightplot(9,4,13,[],[0.15 0.025],[0.25 0.25]);
plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_SST_1m(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_SST_1m(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_SST_1m(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_dt(island16_index),Berg16_co2_SST_1m(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_dt(cambay16_index),Berg16_co2_SST_1m(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_SST_1m(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_SST_1m(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([0 23])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 11 00 00 00])]);
title('2016','fontsize',11)
ylabel({['SST _(_1_m_)' char(10) '(',num2str(degree_symbol),'C)']},'fontsize',11); 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
text(-0.63,1.1,'(b)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 
box on

subtightplot(9,4,14,[],[0.15 0.025],[0.25 0.25])
plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_SST_1m(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_SST_1m(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_SST_1m(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_dt(island17_index),Berg17_co2_SST_1m(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_dt(cambay17_index),Berg17_co2_SST_1m(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_SST_1m(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_SST_1m(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2017','fontsize',11)
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(9,4,15,[],[0.15 0.025],[0.25 0.25])
plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_SST_1m(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_SST_1m(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_SST_1m(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_dt(island18_index),Berg18_co2_SST_1m(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_dt(cambay18_index),Berg18_co2_SST_1m(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_SST_1m(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_dt(Chantry_18_index),Berg18_co2_SST_1m(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2018','fontsize',11)
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(9,4,16,[],[0.15 0.025],[0.25 0.25])
plot(Berg19_co2_dt(Bathurst_19_index),Berg19_co2_SST_1m(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg19_co2_dt(Dease_strait_w_19_index),Berg19_co2_SST_1m(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_dt(Wellington_19_index),Berg19_co2_SST_1m(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_dt(island19_index),Berg19_co2_SST_1m(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_dt(cambay19_index),Berg19_co2_SST_1m(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_dt(QMG_19_index),Berg19_co2_SST_1m(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_dt(Chantry_19_index),Berg19_co2_SST_1m(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([0 23])
set(gca,'Yticklabel',[]) 
title('2019','fontsize',11)
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
box on;

subtightplot(9,4,17,[],[0.15 0.025],[0.25 0.25])
plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_TSG_s(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_TSG_s(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_TSG_s(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_dt(island16_index),Berg16_co2_TSG_s(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_dt(cambay16_index),Berg16_co2_TSG_s(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_TSG_s(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_TSG_s(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([12 29])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 11 00 00 00])])
ylabel({['Salinity']},'fontsize',11); 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
text(-0.63,1.1,'(c)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 
box on

subtightplot(9,4,18,[],[0.15 0.025],[0.25 0.25])
plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_TSG_s(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_TSG_s(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_TSG_s(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_dt(island17_index),Berg17_co2_TSG_s(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_dt(cambay17_index),Berg17_co2_TSG_s(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_TSG_s(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_TSG_s(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([12 29])
set(gca,'Yticklabel',[]) 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])

subtightplot(9,4,19,[],[0.15 0.025],[0.25 0.25])
plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_TSG_s(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_TSG_s(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_TSG_s(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_dt(island18_index),Berg18_co2_TSG_s(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_dt(cambay18_index),Berg18_co2_TSG_s(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_TSG_s(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_dt(Chantry_18_index),Berg18_co2_TSG_s(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([12 29])
set(gca,'Yticklabel',[]) 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(9,4,20,[],[0.15 0.025],[0.25 0.25])
plot(Berg16_co2_dt(Bathurst_19_index),Berg19_co2_TSG_s(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg19_co2_dt(Dease_strait_w_19_index),Berg19_co2_TSG_s(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_dt(Wellington_19_index),Berg19_co2_TSG_s(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_dt(island19_index),Berg19_co2_TSG_s(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_dt(cambay19_index),Berg19_co2_TSG_s(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_dt(QMG_19_index),Berg19_co2_TSG_s(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_dt(Chantry_19_index),Berg19_co2_TSG_s(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([12 29])
set(gca,'Yticklabel',[]) 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
box on;
 
subtightplot(9,4,21,[],[0.15 0.025],[0.25 0.25])
plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_pco2_surface(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_pco2_surface(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_pco2_surface(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_dt(island16_index),Berg16_co2_pco2_surface(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_dt(cambay16_index),Berg16_co2_pco2_surface(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_pco2_surface(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_pco2_surface(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);
hold on
plot(Berg16_co2_dt,Berg16_co2_atmCO2,'k*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 11 00 00 00])])
ylabel({['pCO_2 ' char(10) '(ppm)']},'fontsize',11); 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
text(-0.63,1.1,'(d)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 
box on

subtightplot(9,4,22,[],[0.15 0.025],[0.25 0.25])
plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_pco2_surface(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_pco2_surface(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_pco2_surface(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_dt(island17_index),Berg17_co2_pco2_surface(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_dt(cambay17_index),Berg17_co2_pco2_surface(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_pco2_surface(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_pco2_surface(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
hold on
plot(Berg17_co2_dt,Berg17_co2_atmCO2,'k*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
set(gca,'Yticklabel',[]) 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])


subtightplot(9,4,23,[],[0.15 0.025],[0.25 0.25])
plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_pco2_surface(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_pco2_surface(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_pco2_surface(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_dt(island18_index),Berg18_co2_pco2_surface(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_dt(cambay18_index),Berg18_co2_pco2_surface(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_pco2_surface(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_dt(Chantry_18_index),Berg18_co2_pco2_surface(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);
hold on
plot(Berg18_co2_dt,Berg18_co2_atmCO2,'k*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
set(gca,'Yticklabel',[]) 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])

subtightplot(9,4,24,[],[0.15 0.025],[0.25 0.25])
plot(Berg19_co2_dt(Bathurst_19_index),Berg19_co2_pco2_surface(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg19_co2_dt(Dease_strait_w_19_index),Berg19_co2_pco2_surface(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_dt(Wellington_19_index),Berg19_co2_pco2_surface(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_dt(island19_index),Berg19_co2_pco2_surface(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_dt(cambay19_index),Berg19_co2_pco2_surface(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_dt(QMG_19_index),Berg19_co2_pco2_surface(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_dt(Chantry_19_index),Berg19_co2_pco2_surface(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
hold on
plot(Berg19_co2_dt,Berg19_co2_atmCO2,'k*','MarkerSize',0.5)
set(gca, 'XTick', [])
ylim([190 600])
set(gca,'Yticklabel',[]) 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
box on;

subtightplot(9,4,25,[],[0.15 0.025],[0.25 0.25])
% plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_Chl_despike(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
% hold on
% plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_Chl_despike(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
% plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_Chl_despike(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
% plot(Berg16_co2_dt(island16_index),Berg16_co2_Chl_despike(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
% plot(Berg16_co2_dt(cambay16_index),Berg16_co2_Chl_despike(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
% plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_Chl_despike(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
% plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_Chl_despike(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([0 1.4])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 11 00 00 00])])
ylabel({['Fluorescence' char(10),'(' , num2str(micro_symbol),'g L^{-1})']},'fontsize',11); 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
set(gca,'fontsize',11)
text(-0.63,1.1,'(e)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 
box on

subtightplot(9,4,26,[],[0.15 0.025],[0.25 0.25]);
plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_Chl_despike(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_Chl_despike(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_Chl_despike(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_dt(island17_index),Berg17_co2_Chl_despike(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_dt(cambay17_index),Berg17_co2_Chl_despike(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_Chl_despike(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_Chl_despike(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([0 1.4])
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11);
set(gca,'fontsize',11);
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])]);
set(gca,'fontsize',11)

subtightplot(9,4,27,[],[0.15 0.025],[0.25 0.25]);
plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_Chl_despike(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_Chl_despike(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_Chl_despike(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_dt(island18_index),Berg18_co2_Chl_despike(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_dt(cambay18_index),Berg18_co2_Chl_despike(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_Chl_despike(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_dt(Chantry_18_index),Berg18_co2_Chl_despike(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([0 1.4])
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11);
set(gca,'fontsize',11);
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])]);
set(gca,'fontsize',11)

subtightplot(9,4,28,[],[0.15 0.025],[0.25 0.25])
plot(Berg19_co2_dt(Bathurst_19_index),Berg19_co2_Chl_despike(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg19_co2_dt(Dease_strait_w_19_index),Berg19_co2_Chl_despike(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_dt(Wellington_19_index),Berg19_co2_Chl_despike(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_dt(island19_index),Berg19_co2_Chl_despike(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_dt(cambay19_index),Berg19_co2_Chl_despike(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_dt(QMG_19_index),Berg19_co2_Chl_despike(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_dt(Chantry_19_index),Berg19_co2_Chl_despike(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([0 1.4]);
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
set(gca,'fontsize',11)
box on;

subtightplot(9,4,29,[],[0.15 0.025],[0.25 0.25])
plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_u10(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_u10(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_u10(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_dt(island16_index),Berg16_co2_u10(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_dt(cambay16_index),Berg16_co2_u10(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_u10(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_u10(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([0 15])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 11 00 00 00])])
ylabel({['  U_1_0' char(10),' (m s^{-1})']},'fontsize',11); 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
set(gca,'fontsize',11)
text(-0.63,1.1,'(f)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 
box on

subtightplot(9,4,30,[],[0.15 0.025],[0.25 0.25]);
plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_u10(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_u10(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_u10(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_dt(island17_index),Berg17_co2_u10(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_dt(cambay17_index),Berg17_co2_u10(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_u10(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_u10(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([0 15])
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11);
set(gca,'fontsize',11);
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])]);
set(gca,'fontsize',11)

subtightplot(9,4,31,[],[0.15 0.025],[0.25 0.25]);
plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_u10(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_u10(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_u10(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_dt(island18_index),Berg18_co2_u10(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_dt(cambay18_index),Berg18_co2_u10(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_u10(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_dt(Chantry_18_index),Berg18_co2_u10(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([0 15])
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11);
set(gca,'fontsize',11);
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])]);
set(gca,'fontsize',11)

subtightplot(9,4,32,[],[0.15 0.025],[0.25 0.25])
plot(Berg19_co2_dt(Bathurst_19_index),Berg19_co2_u10(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg19_co2_dt(Dease_strait_w_19_index),Berg19_co2_u10(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_dt(Wellington_19_index),Berg19_co2_u10(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_dt(island19_index),Berg19_co2_u10(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_dt(cambay19_index),Berg19_co2_u10(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_dt(QMG_19_index),Berg19_co2_u10(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_dt(Chantry_19_index),Berg19_co2_u10(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([0 15]);
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
set(gca,'fontsize',11)
box on

subtightplot(9,4,33,[],[0.15 0.025],[0.25 0.25])
zerolinex=(datenum([2016 08 2 14 13 00]):datenum([0 0 0 1 0 0]):datenum([2016 08 11 00 00 00]))
zeroliney=zerolinex*0;
plot(zerolinex,zeroliney,'--','color','k')
plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_FCO2_mmol_per_m2_per_d(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_FCO2_mmol_per_m2_per_d(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_dt(island16_index),Berg16_co2_FCO2_mmol_per_m2_per_d(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_dt(cambay16_index),Berg16_co2_FCO2_mmol_per_m2_per_d(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_FCO2_mmol_per_m2_per_d(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_FCO2_mmol_per_m2_per_d(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', [])
ylim([-60 30])
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 11 00 00 00])])
ylabel({['Flux of CO_2' char(10),'(mmol m^{-2}d^{-1})   ']},'fontsize',11); 
set(gca,'fontsize',11)
set(gca,'fontsize',11)
set(gca, 'XTick', [Berg16_co2_dt(1):2:Berg16_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd', 'keepticks') 
xlim([datenum([2016 08 2 14 13 00]) datenum([2016 08 11 00 00 00])])
set(gca,'fontsize',11)
text(-0.63,1.1,'(g)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 
box on

subtightplot(9,4,34,[],[0.15 0.025],[0.25 0.25]);
zerolinex=(datenum([2017 08 2 15 15 00]):datenum([0 0 0 1 0 0]):datenum([2017 09 14 10 48 00]))
zeroliney=zerolinex*0;
plot(zerolinex,zeroliney,'--','color','k')
hold on
plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_FCO2_mmol_per_m2_per_d(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_FCO2_mmol_per_m2_per_d(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_dt(island17_index),Berg17_co2_FCO2_mmol_per_m2_per_d(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_dt(cambay17_index),Berg17_co2_FCO2_mmol_per_m2_per_d(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_FCO2_mmol_per_m2_per_d(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_FCO2_mmol_per_m2_per_d(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([-60 30])
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11);
set(gca,'fontsize',11);
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])]);
set(gca, 'XTick', [Berg17_co2_dt(1):4:Berg17_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd', 'keepticks') 
xlim([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])
set(gca,'fontsize',11)

subtightplot(9,4,35,[],[0.15 0.025],[0.25 0.25]);
zerolinex=(datenum([2018 07 31 22 22 00]):datenum([0 0 0 1 0 0]):datenum([2018 08 21 10 37 00]))
zeroliney=zerolinex*0;
plot(zerolinex,zeroliney,'--','color','k')
hold on
plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_FCO2_mmol_per_m2_per_d(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_FCO2_mmol_per_m2_per_d(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_dt(island18_index),Berg18_co2_FCO2_mmol_per_m2_per_d(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_dt(cambay18_index),Berg18_co2_FCO2_mmol_per_m2_per_d(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_FCO2_mmol_per_m2_per_d(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_dt(Chantry_18_index),Berg18_co2_FCO2_mmol_per_m2_per_d(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([-60 30])
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11);
set(gca,'fontsize',11);
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])]);
set(gca, 'XTick', [Berg18_co2_dt(1):2:Berg18_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd', 'keepticks') 
xlim([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])
set(gca,'fontsize',11)

subtightplot(9,4,36,[],[0.15 0.025],[0.25 0.25])
zerolinex=(datenum([2019 08 9 18 21 00]):datenum([0 0 0 1 0 0]):datenum([2019 08 21 03 44 00]))
zeroliney=zerolinex*0;
plot(zerolinex,zeroliney,'--','color','k')
plot(Berg19_co2_dt(Bathurst_19_index),Berg19_co2_FCO2_mmol_per_m2_per_d(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg19_co2_dt(Dease_strait_w_19_index),Berg19_co2_FCO2_mmol_per_m2_per_d(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_dt(Wellington_19_index),Berg19_co2_FCO2_mmol_per_m2_per_d(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_dt(island19_index),Berg19_co2_FCO2_mmol_per_m2_per_d(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_dt(cambay19_index),Berg19_co2_FCO2_mmol_per_m2_per_d(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_dt(QMG_19_index),Berg19_co2_FCO2_mmol_per_m2_per_d(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_dt(Chantry_19_index),Berg19_co2_FCO2_mmol_per_m2_per_d(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
set(gca, 'XTick', []);
ylim([-60 30])
set(gca,'Yticklabel',[]) ;
set(gca,'fontsize',11)
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
set(gca, 'XTick', [Berg19_co2_dt(1):2:Berg19_co2_dt(end)])
rotateXLabels( gca(), 90 )
datetick('x','mmm-dd', 'keepticks') 
xlim([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
set(gca,'fontsize',11)
box on;



saveas(h9,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Figure4_Berg_timeseries_all_inc_map.jpg')
%%     Figure 3 - map of 2016 to 2019 cruise tracks
h3= figure('Position', get(0, 'Screensize'));
m_proj('Sinusoidal','lon',[-110 -95],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',22)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
h11=m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,10,colour_cornflowerblue,'filled')
hold on
h12=m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,10,colour_green,'filled')
h13=m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,10,colour_purple,'filled')
h14=m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,10,colour_navajowhite,'filled')

m_gshhs_f('patch',[.5 .5 .5]);
% caxis([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
set(gca,'fontsize',22)
y=ylabel(['Latitude (' degree_symbol 'N)']);
set(y,'Units','Normalized','Position',[-0.045,0.5,0]);
set(gca,'fontsize',22)
set(gca,'fontsize',22)
set(x,'Units','Normalized','Position',[0.5,-0.13,0]);
x=xlabel(['Longitude (' degree_symbol 'W)']);
set(x,'Units','Normalized','Position',[0.5,-0.075,0]);
legend([h11,h12,h13,h14],'2016','2017','2018','2019','Location','SouthEast');
saveas(h3,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Figure3_Berg_cruisetrack_map.jpg')
%%     Figure S2 - map subplots of datetime for 2016 to 2019 cruises
h1001= figure('Position', get(0, 'Screensize'));
subtightplot(2,2,1,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,10,Berg16_co2_dt,'filled')
u=colorbar; 
set(u, 'YTick',datenum([2016 08 2 14 13 00]) :2:datenum([2016 08 22 05 17 00]))
cbdate(u,'mmm-dd');
title(u,'Date (mmm-dd)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2016')
% caxis([datenum([2016 08 2 14 13 00]) datenum([2016 08 22 05 17 00])])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(a)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,2,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,10,Berg17_co2_dt,'filled')
u=colorbar; 
set(u, 'YTick',datenum([2017 08 2 15 15 00]) :4:datenum([2017 09 14 10 48 00]))
cbdate(u,'mmm-dd');
title(u,'Date (mmm-dd)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2017')
caxis([datenum([2017 08 2 15 15 00]) datenum([2017 09 14 10 48 00])])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.055,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(b)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,3,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,10,Berg18_co2_dt,'filled')
u=colorbar;
set(u, 'YTick',datenum([2018 07 31 22 22 00]) :2:datenum([2018 08 21 10 37 00]))
cbdate(u,'mmm-dd');
title(u,'Date (mmm-dd)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2018')
caxis([datenum([2018 07 31 22 22 00]) datenum([2018 08 21 10 37 00])])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(c)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,4,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,10,Berg19_co2_dt,'filled')
u=colorbar; 
set(u, 'YTick',datenum([2019 08 9 18 21 00]) :2:datenum([2019 08 21 03 44 00]));
cbdate(u,'mmm-dd');
title(u,'Date (mmm-dd)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2019')
caxis([datenum([2019 08 9 18 21 00]) datenum([2019 08 21 03 44 00])])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.055,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(d)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

saveas(h1001,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/FigureS2_Berg_dt_map.jpg')
%%     Figure S3 - map subplots of SST for 2016 to 2019 cruises 
h1003 = figure('Position', get(0, 'Screensize'));
subtightplot(2,2,1,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,10,Berg16_co2_SST_1m,'filled')
y=colorbar;
title(y,['Temperature(',num2str(degree_symbol),'C)'],'fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2016','fontsize',16)
caxis([0 22])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(a)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,2,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,10,Berg17_co2_SST_1m,'filled')
y=colorbar;
title(y,['Temperature(',num2str(degree_symbol),'C)'],'fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2017','fontsize',16)
caxis([0 22])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(b)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,3,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,10,Berg18_co2_SST_1m,'filled')
y=colorbar;
title(y,['Temperature(',num2str(degree_symbol),'C)'],'fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2018','fontsize',16)
caxis([0 22])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(c)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,4,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,10,Berg19_co2_SST_1m,'filled')
y=colorbar;
title(y,['Temperature(',num2str(degree_symbol),'C)'],'fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2019','fontsize',16)
caxis([0 22])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(d)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

saveas(h1003,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/FigureS2_Berg_temp_map.jpg')
%%     Figure S4 - map subplots of salinity for 2016 to 2019 cruises
h1002 = figure('Position', get(0, 'Screensize'));
subtightplot(2,2,1,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,10,Berg16_co2_TSG_s,'filled')
y=colorbar;
title(y,'Salinity (PSU)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2016','Fontsize',16)
caxis([12 29])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(a)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,2,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,10,Berg17_co2_TSG_s,'filled')
y=colorbar;
title(y,'Salinity (PSU)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2017','Fontsize',16)
caxis([12 29])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(b)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,3,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,10,Berg18_co2_TSG_s,'filled')
y=colorbar;
title(y,'Salinity (PSU)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2018','Fontsize',16)
caxis([12 29])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(c)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,4,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,10,Berg19_co2_TSG_s,'filled')
y=colorbar;
title(y,'Salinity (PSU)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2019','Fontsize',16)
caxis([12 29])
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(d)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

saveas(h1002,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2//FigureS3_Berg_sal_map.jpg')
%%     Figure S5 - map subplots of pCO2 for 2016 to 2019 cruises
h1000= figure('Position', get(0, 'Screensize'));
subtightplot(2,2,1,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,10,Berg16_co2_pco2_surface,'filled')
y=colorbar;
title(y,'pCO_2_(_s_w_)(ppm)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2016')
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(a)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,2,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,10,Berg17_co2_pco2_surface,'filled')
y=colorbar;
title(y,'pCO_2_(_s_w_)(ppm)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2017')
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(b)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,3,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,10,Berg18_co2_pco2_surface,'filled')
y=colorbar;
title(y,'pCO_2_(_s_w_)(ppm)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2018')
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(c)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

subtightplot(2,2,4,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,10,Berg19_co2_pco2_surface,'filled')
y=colorbar;
title(y,'pCO_2_(_s_w_)(ppm)','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
m_gshhs('fr');              % full resolution rivers
title('2019')
y=ylabel('Latitude','Fontsize',16);
set(y,'Units','Normalized','Position',[-0.07,0.5,0]);
x=xlabel('Longitude','Fontsize',16);
set(x,'Units','Normalized','Position',[0.5,-0.12,0]); 
text(-0.06,1.03,'(d)','color','k','Fontsize',16,'Fontweight','bold','BackgroundColor','none','units','normalized'); 

saveas(h1000,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/FigureS4_Berg_co2_map.jpg');
%%     Figure S6 - map subplots of CHL-A for 2016 to 2019 cruises
h1004 = figure('Position', get(0, 'Screensize'));
% subtightplot(2,2,1,[],[],[0.05 0.07])
% m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
% m_grid('linestyle','none','tickdir','out','fontsize',14)
% hold on
% %add data
% set(gca,'FontSize',12)
% set(gca,'FontSize',12)
% m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,2,Berg16_co2_Chl_despike,'filled')
% y=colorbar;
% title(y,'chlorophyll','fontsize',16);
% m_gshhs_f('patch',[.5 .5 .5]);
% title('2016')
% caxis([1 2])

subtightplot(2,2,2,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,2,Berg17_co2_Chl_despike,'filled')
y=colorbar;
title(y,'chlorophyll','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
title('2017')
caxis([0 1.3])

subtightplot(2,2,3,[],[],[0.05 0.07])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,2,Berg18_co2_Chl_despike,'filled')
y=colorbar;
title(y,'chlorophyll','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
title('2018')
caxis([0 1.3])

subtightplot(2,2,4,[],[],[0.095 0.025])
myColorOrder=inferno;
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
colormap(myColorOrder);
m_proj('Sinusoidal','lon',[-111 -94],'lat',[66.5 69.5]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,2,Berg19_co2_Chl_despike,'filled')
y=colorbar;
title(y,'chlorophyll','fontsize',16);
m_gshhs_f('patch',[.5 .5 .5]);
title('2019')
caxis([0 1.3])
saveas(h1004,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/FigureS5_Berg_chl_map.jpg')
%%     map of pCO2 around finlayson islands
figure(7001)
subplot(2,2,1)
m_proj('Sinusoidal','lon',[-106.25 -105.5],'lat',[68.75 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,2,Berg16_co2_pco2_surface,'filled')
colorbar

subplot(2,2,2)
m_proj('Sinusoidal','lon',[-106.25 -105.5],'lat',[68.75 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,2,Berg17_co2_pco2_surface,'filled')
colorbar

subplot(2,2,3)
m_proj('Sinusoidal','lon',[-106.25 -105.5],'lat',[68.75 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,2,Berg18_co2_pco2_surface,'filled')
colorbar

subplot(2,2,4)
m_proj('Sinusoidal','lon',[-106.25 -105.5],'lat',[68.75 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,2,Berg19_co2_pco2_surface,'filled')
colorbar
%%     map of pCO2 around Cambridge Bay
figure(7002)
subplot(2,2,1)
m_proj('Sinusoidal','lon',[-105.5 -104.75],'lat',[69 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,2,Berg16_co2_pco2_surface,'filled')
colorbar
title('2016')

subplot(2,2,2)
m_proj('Sinusoidal','lon',[-105.5 -104.75],'lat',[69 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,2,Berg17_co2_pco2_surface,'filled')
colorbar
title('2017')

subplot(2,2,3)
m_proj('Sinusoidal','lon',[-105.5 -104.75],'lat',[69 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,2,Berg18_co2_pco2_surface,'filled')
colorbar
title('2018')

subplot(2,2,4)
m_proj('Sinusoidal','lon',[-105.5 -104.75],'lat',[69 69.25]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,2,Berg19_co2_pco2_surface,'filled')
colorbar
title('2019')

%Dease strait West
m_line([-110 -106.25],[68.5 68.5],'color','b');
m_line([-110 -106.25],[69 69],'color','b');
m_line([-110 -110],[68.5 69],'color','b');
m_line([-106.25 -106.25],[68.5 69],'color','b');
%%     map of pCO2 around Dease Strait West
figure(7003)
subplot(2,2,1)
m_proj('Sinusoidal','lon',[-110 -106.25],'lat',[68.5 69]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,2,Berg16_co2_pco2_surface,'filled')
colorbar

subplot(2,2,2)
m_proj('Sinusoidal','lon',[-110 -106.25],'lat',[68.5 69]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,2,Berg17_co2_pco2_surface,'filled')
colorbar

subplot(2,2,3)
m_proj('Sinusoidal','lon',[-110 -106.25],'lat',[68.5 69]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,2,Berg18_co2_pco2_surface,'filled')
colorbar

subplot(2,2,4)
m_proj('Sinusoidal','lon',[-110 -106.25],'lat',[68.5 69]);  
m_grid('linestyle','none','tickdir','out','fontsize',14)
hold on
%add data
set(gca,'FontSize',12)
set(gca,'FontSize',12)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,2,Berg19_co2_pco2_surface,'filled')
colorbar
%%     Figure 7 pco2 as a function of icebreakup by year
h900=figure(900)
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'color','w');
ax1=subtightplot(3,1,1,[0.015 0.015],[0.08 0.01],[0.2 0.2]);
plot(Berg16_days_since_ice/7,Berg16_co2_pco2_surface,'o','color',colour_cornflowerblue,'MarkerFaceColor',colour_cornflowerblue,'Markersize',4);
hold on
plot(Berg17_days_since_ice/7,Berg17_co2_pco2_surface,'o','color',colour_green,'MarkerFaceColor',colour_green,'Markersize',4);
plot(Berg18_days_since_ice/7,Berg18_co2_pco2_surface,'o','color',colour_purple,'MarkerFaceColor',colour_purple,'Markersize',4);
plot(Berg19_days_since_ice/7,Berg19_co2_pco2_surface,'o','color',colour_navajowhite,'MarkerFaceColor',colour_navajowhite,'Markersize',4);
x=1:0.01:20;
y=(-0.57*x.^2)+(14.43*x)+286;
p=plot(x,y,'k');
p(1).LineWidth = 1.5;
% xlabel('Weeks since ice breakup (when sea ice <85%)','fontsize',14);
ylabel({['pCO_2 (ppm)']},'fontsize',12); 
xlim([2 16]);
ylim([180 550]);
set(gca,'FontSize',12);
set(gca,'FontSize',12);
legend('Bergmann 2016','Bergmann 2017','Bergmann 2018','Bergmann 2019','Ahmed19 fit','Location','EastOutside');
 set(gca,'Xticklabel',[]) ;

ax2=subtightplot(3,1,2,[0.015 0.015],[0.08 0.01],[0.2 0.2]);
plot(Berg16_days_since_ice/7,Berg16_co2_SST_1m,'o','color',colour_cornflowerblue,'MarkerFaceColor',colour_cornflowerblue,'Markersize',4);
hold on
plot(Berg17_days_since_ice/7,Berg17_co2_SST_1m,'o','color',colour_green,'MarkerFaceColor',colour_green,'Markersize',4);
plot(Berg18_days_since_ice/7,Berg18_co2_SST_1m,'o','color',colour_purple,'MarkerFaceColor',colour_purple,'Markersize',4);
plot(Berg19_days_since_ice/7,Berg19_co2_SST_1m,'o','color',colour_navajowhite,'MarkerFaceColor',colour_navajowhite,'Markersize',4);
x=1:0.01:20;
y=(-0.04*x.^2)+(0.92*x)+1.46;
p=plot(x,y,'k');
p(1).LineWidth = 1.5;
% xlabel('Weeks since ice breakup (when sea ice <85%)','fontsize',14)
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
xlim([2 16])
ylim([-2 22])
set(gca,'FontSize',12)
set(gca,'FontSize',12)
legend('Bergmann 2016','Bergmann 2017','Bergmann 2018','Bergmann 2019','Ahmed19 fit','Location','EastOutside');
 set(gca,'Xticklabel',[]) ;

ax3=subtightplot(3,1,3,[0.015 0.015],[0.08 0.01],[0.2 0.2]);
plot(Berg16_days_since_ice/7,Berg16_co2_TSG_s,'o','color',colour_cornflowerblue,'MarkerFaceColor',colour_cornflowerblue,'Markersize',4);
hold on
plot(Berg17_days_since_ice/7,Berg17_co2_TSG_s,'o','color',colour_green,'MarkerFaceColor',colour_green,'Markersize',4);
plot(Berg18_days_since_ice/7,Berg18_co2_TSG_s,'o','color',colour_purple,'MarkerFaceColor',colour_purple,'Markersize',4);
plot(Berg19_days_since_ice/7,Berg19_co2_TSG_s,'o','color',colour_navajowhite,'MarkerFaceColor',colour_navajowhite,'Markersize',4);
x=1:0.01:20;
y=(0.28*x)+24.73;
p=plot(x,y,'k');
p(1).LineWidth = 1.5;
xlabel('Weeks since ice breakup (when sea ice <85%)','fontsize',12);
ylabel('Salinity (PSU)','fontsize',12);
xlim([2 16]);
ylim([10 30]);
set(gca,'FontSize',12)
set(gca,'FontSize',12)
legend('Bergmann 2016','Bergmann 2017','Bergmann 2018','Bergmann 2019','Ahmed19 fit','Location','EastOutside');
saveas(h900,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Figure5_Berg_ice_breakup.jpg')
%%     pco2 as a function of icebreakup coloured by region
h901=figure(901)
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'color','w');
ax1=subtightplot(3,1,1,[0.015 0.015],[0.08 0.01],[0.2 0.2]);
plot(Berg17_days_since_ice(Bathurst_17_index)/7,Berg17_co2_pco2_surface(Bathurst_17_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
hold on
plot(Berg17_days_since_ice(Dease_strait_w_17_index)/7,Berg17_co2_pco2_surface(Dease_strait_w_17_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg17_days_since_ice(Wellington_17_index)/7,Berg17_co2_pco2_surface(Wellington_17_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg17_days_since_ice(island17_index)/7,Berg17_co2_pco2_surface(island17_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg17_days_since_ice(cambay17_index)/7,Berg17_co2_pco2_surface(cambay17_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg17_days_since_ice(QMG_17_index)/7,Berg17_co2_pco2_surface(QMG_17_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg17_days_since_ice(Chantry_17_index)/7,Berg17_co2_pco2_surface(Chantry_17_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg16_days_since_ice(Bathurst_16_index)/7,Berg16_co2_pco2_surface(Bathurst_16_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg16_days_since_ice(Dease_strait_w_16_index)/7,Berg16_co2_pco2_surface(Dease_strait_w_16_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg16_days_since_ice(Wellington_16_index)/7,Berg16_co2_pco2_surface(Wellington_16_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg16_days_since_ice(island16_index)/7,Berg16_co2_pco2_surface(island16_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg16_days_since_ice(cambay16_index)/7,Berg16_co2_pco2_surface(cambay16_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg16_days_since_ice(QMG_16_index)/7,Berg16_co2_pco2_surface(QMG_16_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg16_days_since_ice(Chantry_16_index)/7,Berg16_co2_pco2_surface(Chantry_16_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg18_days_since_ice(Bathurst_18_index)/7,Berg18_co2_pco2_surface(Bathurst_18_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg18_days_since_ice(Dease_strait_w_18_index)/7,Berg18_co2_pco2_surface(Dease_strait_w_18_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg18_days_since_ice(Wellington_18_index)/7,Berg18_co2_pco2_surface(Wellington_18_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg18_days_since_ice(island18_index)/7,Berg18_co2_pco2_surface(island18_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg18_days_since_ice(cambay18_index)/7,Berg18_co2_pco2_surface(cambay18_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg18_days_since_ice(QMG_18_index)/7,Berg18_co2_pco2_surface(QMG_18_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg18_days_since_ice(Chantry_18_index)/7,Berg18_co2_pco2_surface(Chantry_18_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg19_days_since_ice(Bathurst_19_index)/7,Berg19_co2_pco2_surface(Bathurst_19_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg19_days_since_ice(Dease_strait_w_19_index)/7,Berg19_co2_pco2_surface(Dease_strait_w_19_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg19_days_since_ice(Wellington_19_index)/7,Berg19_co2_pco2_surface(Wellington_19_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg19_days_since_ice(island19_index)/7,Berg19_co2_pco2_surface(island19_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg19_days_since_ice(cambay19_index)/7,Berg19_co2_pco2_surface(cambay19_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg19_days_since_ice(QMG_19_index)/7,Berg19_co2_pco2_surface(QMG_19_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg19_days_since_ice(Chantry_19_index)/7,Berg19_co2_pco2_surface(Chantry_19_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
x=1:0.01:20;
y=(-0.57*x.^2)+(14.43*x)+286;
p=plot(x,y,'k');
p(1).LineWidth = 1.5;
% xlabel('Weeks since ice breakup (when sea ice <85%)','fontsize',14);
ylabel({['pCO_2 (ppm)']},'fontsize',12); 
xlim([2 16]);
ylim([180 550]);
set(gca,'FontSize',12);
set(gca,'FontSize',12);
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet','Location','EastOutside')
hL1.FontSize = 10;
set(hL1,'Box','on')
set(gca,'Xticklabel',[]) ;

ax2=subtightplot(3,1,2,[0.015 0.015],[0.08 0.01],[0.2 0.2]);
plot(Berg17_days_since_ice(Bathurst_17_index)/7,Berg17_co2_SST_1m(Bathurst_17_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
hold on
plot(Berg17_days_since_ice(Dease_strait_w_17_index)/7,Berg17_co2_SST_1m(Dease_strait_w_17_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg17_days_since_ice(Wellington_17_index)/7,Berg17_co2_SST_1m(Wellington_17_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg17_days_since_ice(island17_index)/7,Berg17_co2_SST_1m(island17_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg17_days_since_ice(cambay17_index)/7,Berg17_co2_SST_1m(cambay17_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg17_days_since_ice(QMG_17_index)/7,Berg17_co2_SST_1m(QMG_17_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg17_days_since_ice(Chantry_17_index)/7,Berg17_co2_SST_1m(Chantry_17_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg16_days_since_ice(Bathurst_16_index)/7,Berg16_co2_SST_1m(Bathurst_16_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg16_days_since_ice(Dease_strait_w_16_index)/7,Berg16_co2_SST_1m(Dease_strait_w_16_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg16_days_since_ice(Wellington_16_index)/7,Berg16_co2_SST_1m(Wellington_16_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg16_days_since_ice(island16_index)/7,Berg16_co2_SST_1m(island16_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg16_days_since_ice(cambay16_index)/7,Berg16_co2_SST_1m(cambay16_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg16_days_since_ice(QMG_16_index)/7,Berg16_co2_SST_1m(QMG_16_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg16_days_since_ice(Chantry_16_index)/7,Berg16_co2_SST_1m(Chantry_16_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg18_days_since_ice(Bathurst_18_index)/7,Berg18_co2_SST_1m(Bathurst_18_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg18_days_since_ice(Dease_strait_w_18_index)/7,Berg18_co2_SST_1m(Dease_strait_w_18_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg18_days_since_ice(Wellington_18_index)/7,Berg18_co2_SST_1m(Wellington_18_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg18_days_since_ice(island18_index)/7,Berg18_co2_SST_1m(island18_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg18_days_since_ice(cambay18_index)/7,Berg18_co2_SST_1m(cambay18_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg18_days_since_ice(QMG_18_index)/7,Berg18_co2_SST_1m(QMG_18_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg18_days_since_ice(Chantry_18_index)/7,Berg18_co2_SST_1m(Chantry_18_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg19_days_since_ice(Bathurst_19_index)/7,Berg19_co2_SST_1m(Bathurst_19_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg19_days_since_ice(Dease_strait_w_19_index)/7,Berg19_co2_SST_1m(Dease_strait_w_19_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg19_days_since_ice(Wellington_19_index)/7,Berg19_co2_SST_1m(Wellington_19_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg19_days_since_ice(island19_index)/7,Berg19_co2_SST_1m(island19_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg19_days_since_ice(cambay19_index)/7,Berg19_co2_SST_1m(cambay19_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg19_days_since_ice(QMG_19_index)/7,Berg19_co2_SST_1m(QMG_19_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg19_days_since_ice(Chantry_19_index)/7,Berg19_co2_SST_1m(Chantry_19_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
x=1:0.01:20;
y=(-0.04*x.^2)+(0.92*x)+1.46;
p=plot(x,y,'k');
p(1).LineWidth = 1.5;
% xlabel('Weeks since ice breakup (when sea ice <85%)','fontsize',14)
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
xlim([2 16])
ylim([-2 22])
set(gca,'FontSize',12)
set(gca,'FontSize',12)
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','EastOutside')
 set(gca,'Xticklabel',[]) ;

ax3=subtightplot(3,1,3,[0.015 0.015],[0.08 0.01],[0.2 0.2]);
plot(Berg17_days_since_ice(Bathurst_17_index)/7,Berg17_co2_TSG_s(Bathurst_17_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
hold on
plot(Berg17_days_since_ice(Dease_strait_w_17_index)/7,Berg17_co2_TSG_s(Dease_strait_w_17_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg17_days_since_ice(Wellington_17_index)/7,Berg17_co2_TSG_s(Wellington_17_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg17_days_since_ice(island17_index)/7,Berg17_co2_TSG_s(island17_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg17_days_since_ice(cambay17_index)/7,Berg17_co2_TSG_s(cambay17_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg17_days_since_ice(QMG_17_index)/7,Berg17_co2_TSG_s(QMG_17_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg17_days_since_ice(Chantry_17_index)/7,Berg17_co2_TSG_s(Chantry_17_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg16_days_since_ice(Bathurst_16_index)/7,Berg16_co2_TSG_s(Bathurst_16_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg16_days_since_ice(Dease_strait_w_16_index)/7,Berg16_co2_TSG_s(Dease_strait_w_16_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg16_days_since_ice(Wellington_16_index)/7,Berg16_co2_TSG_s(Wellington_16_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg16_days_since_ice(island16_index)/7,Berg16_co2_TSG_s(island16_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg16_days_since_ice(cambay16_index)/7,Berg16_co2_TSG_s(cambay16_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg16_days_since_ice(QMG_16_index)/7,Berg16_co2_TSG_s(QMG_16_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg16_days_since_ice(Chantry_16_index)/7,Berg16_co2_TSG_s(Chantry_16_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg18_days_since_ice(Bathurst_18_index)/7,Berg18_co2_TSG_s(Bathurst_18_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg18_days_since_ice(Dease_strait_w_18_index)/7,Berg18_co2_TSG_s(Dease_strait_w_18_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg18_days_since_ice(Wellington_18_index)/7,Berg18_co2_TSG_s(Wellington_18_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg18_days_since_ice(island18_index)/7,Berg18_co2_TSG_s(island18_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg18_days_since_ice(cambay18_index)/7,Berg18_co2_TSG_s(cambay18_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg18_days_since_ice(QMG_18_index)/7,Berg18_co2_TSG_s(QMG_18_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg18_days_since_ice(Chantry_18_index)/7,Berg18_co2_TSG_s(Chantry_18_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
plot(Berg19_days_since_ice(Bathurst_19_index)/7,Berg19_co2_TSG_s(Bathurst_19_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',4);
plot(Berg19_days_since_ice(Dease_strait_w_19_index)/7,Berg19_co2_TSG_s(Dease_strait_w_19_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',4);
plot(Berg19_days_since_ice(Wellington_19_index)/7,Berg19_co2_TSG_s(Wellington_19_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',4);
plot(Berg19_days_since_ice(island19_index)/7,Berg19_co2_TSG_s(island19_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',4);
plot(Berg19_days_since_ice(cambay19_index)/7,Berg19_co2_TSG_s(cambay19_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',4);
plot(Berg19_days_since_ice(QMG_19_index)/7,Berg19_co2_TSG_s(QMG_19_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',4);
plot(Berg19_days_since_ice(Chantry_19_index)/7,Berg19_co2_TSG_s(Chantry_19_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',4);
x=1:0.01:20;
y=(0.28*x)+24.73;
p=plot(x,y,'k');
p(1).LineWidth = 1.5;
xlabel('Weeks since ice breakup (when sea ice <85%)','fontsize',12);
ylabel('Salinity (PSU)','fontsize',12);
xlim([2 16]);
ylim([10 30]);
set(gca,'FontSize',12)
set(gca,'FontSize',12)
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','EastOutside')
% saveas(h901,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_ice_breakup_region.jpg')
%%     pco2 as a function of SST coloured by year
h902=figure(902);
plot(Berg16_co2_pco2_surface,Berg16_co2_SST_1m,'o','color',colour_greyshade,'MarkerFaceColor',colour_greyshade,'Markersize',4);
hold on
plot(Berg17_co2_pco2_surface,Berg17_co2_SST_1m,'o','color',colour_green,'MarkerFaceColor',colour_green,'Markersize',4);
plot(Berg18_co2_pco2_surface,Berg18_co2_SST_1m,'o','color',colour_purple,'MarkerFaceColor',colour_purple,'Markersize',4);
plot(Berg19_co2_pco2_surface,Berg19_co2_SST_1m,'o','color',colour_navajowhite,'MarkerFaceColor',colour_navajowhite,'Markersize',4);
% xlabel('Weeks since ice breakup (when sea ice <85%)','fontsize',14);
xlabel({['pCO_2 (ppm)']},'fontsize',12); 
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
legend('Bergmann 2016','Bergmann 2017','Bergmann 2018','Bergmann 2019','Location','NorthEast');
% saveas(h902,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_co2_vs_SST_year.jpg')
%%     pco2 as a function of SST coloured by region
h1001=figure(1001);
plot(Berg17_co2_pco2_surface(Bathurst_17_index),Berg17_co2_SST_1m(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_pco2_surface(Dease_strait_w_17_index),Berg17_co2_SST_1m(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_pco2_surface(Wellington_17_index),Berg17_co2_SST_1m(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_pco2_surface(island17_index),Berg17_co2_SST_1m(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_pco2_surface(cambay17_index),Berg17_co2_SST_1m(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_pco2_surface(QMG_17_index),Berg17_co2_SST_1m(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_pco2_surface(Chantry_17_index),Berg17_co2_SST_1m(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
plot(Berg16_co2_pco2_surface(Bathurst_16_index),Berg16_co2_SST_1m(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg16_co2_pco2_surface(Dease_strait_w_16_index),Berg16_co2_SST_1m(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_pco2_surface(Wellington_16_index),Berg16_co2_SST_1m(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_pco2_surface(island16_index),Berg16_co2_SST_1m(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_pco2_surface(cambay16_index),Berg16_co2_SST_1m(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_pco2_surface(QMG_16_index),Berg16_co2_SST_1m(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_pco2_surface(Chantry_16_index),Berg16_co2_SST_1m(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);

plot(Berg18_co2_pco2_surface(Bathurst_18_index),Berg18_co2_SST_1m(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg18_co2_pco2_surface(Dease_strait_w_18_index),Berg18_co2_SST_1m(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_pco2_surface(Wellington_18_index),Berg18_co2_SST_1m(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_pco2_surface(island18_index),Berg18_co2_SST_1m(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_pco2_surface(cambay18_index),Berg18_co2_SST_1m(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_pco2_surface(QMG_18_index),Berg18_co2_SST_1m(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_pco2_surface(Chantry_18_index),Berg18_co2_SST_1m(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);

plot(Berg19_co2_pco2_surface(Bathurst_19_index),Berg19_co2_SST_1m(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg19_co2_pco2_surface(Dease_strait_w_19_index),Berg19_co2_SST_1m(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_pco2_surface(Wellington_19_index),Berg19_co2_SST_1m(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_pco2_surface(island19_index),Berg19_co2_SST_1m(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_pco2_surface(cambay19_index),Berg19_co2_SST_1m(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_pco2_surface(QMG_19_index),Berg19_co2_SST_1m(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_pco2_surface(Chantry_19_index),Berg19_co2_SST_1m(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','NorthEast')
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
xlabel({['pCO_2 (ppm)']},'fontsize',12); 
saveas(h1001,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_co2_vs_SST_region.jpg')
%%     pco2 as a function of salinity coloured by year
h903=figure(903);
plot(Berg16_co2_pco2_surface,Berg16_co2_TSG_s,'o','color',colour_greyshade,'MarkerFaceColor',colour_greyshade,'Markersize',4);
hold on
plot(Berg17_co2_pco2_surface,Berg17_co2_TSG_s,'o','color',colour_green,'MarkerFaceColor',colour_green,'Markersize',4);
plot(Berg18_co2_pco2_surface,Berg18_co2_TSG_s,'o','color',colour_purple,'MarkerFaceColor',colour_purple,'Markersize',4);
plot(Berg19_co2_pco2_surface,Berg19_co2_TSG_s,'o','color',colour_navajowhite,'MarkerFaceColor',colour_navajowhite,'Markersize',4);
xlabel({['pCO_2 (ppm)']},'fontsize',12); 
ylabel({['Salinity (PSU)']},'fontsize',12); 
legend('Bergmann 2016','Bergmann 2017','Bergmann 2018','Bergmann 2019','Location','NorthEast');
% saveas(h903,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_co2_vs_sal_year.jpg')
%%     pco2 from all sources in Kitikmeot as a timeseries
h8000=figure(8000)
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'color','w');
plot(Island_tmaster(1:12000),Island_pco2_smoothed(1:12000),'k');
hold on
h8000=plot(Island_tmaster(25480:34000),Island_pco2_smoothed(25480:34000),'k');
h8000.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(ONC_15_dt,ONC_15_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
h8000a=plot(ONC_16_dt,ONC_16_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
h8000b=plot(ONC_17_dt,ONC_17_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_pco2_surface(Bathurst_17_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',2.5);
plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_pco2_surface(Dease_strait_w_17_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',2.5);
plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_pco2_surface(Wellington_17_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',2.5);
plot(Berg17_co2_dt(island17_index),Berg17_co2_pco2_surface(island17_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',2.5);
plot(Berg17_co2_dt(cambay17_index),Berg17_co2_pco2_surface(cambay17_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',2.5);
plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_pco2_surface(QMG_17_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',2.5);
plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_pco2_surface(Chantry_17_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',2.5);
plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_pco2_surface(Bathurst_16_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',2.5);
plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_pco2_surface(Dease_strait_w_16_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',2.5);
plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_pco2_surface(Wellington_16_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',2.5);
plot(Berg16_co2_dt(island16_index),Berg16_co2_pco2_surface(island16_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',2.5);
plot(Berg16_co2_dt(cambay16_index),Berg16_co2_pco2_surface(cambay16_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',2.5);
plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_pco2_surface(QMG_16_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',2.5);
plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_pco2_surface(Chantry_16_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',2.5);
plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_pco2_surface(Bathurst_18_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',2.5);
plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_pco2_surface(Dease_strait_w_18_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',2.5);
plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_pco2_surface(Wellington_18_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',2.5);
plot(Berg18_co2_dt(island18_index),Berg18_co2_pco2_surface(island18_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',2.5);
plot(Berg18_co2_dt(cambay18_index),Berg18_co2_pco2_surface(cambay18_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',2.5);
plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_pco2_surface(QMG_18_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',2.5);
dynamicDateTicks([], [], 'dd/mm');
ylim([200 700])
klp=datenum(2015,09,01,0,0,1);
jkl=datenum(2018,09,01,0,0,1);
xlim([klp jkl])
legend('EC tower derived','ONC mooring','Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet','Location','North')
ylabel('pCO_2 (ppm)')
xlabel('Time');
saveas(h8000,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Timeseries_pco2_kitikmeot.jpg')
%%     Figure 5 pco2 from all sources in Kitikmeot as yearly summer timeseries
h8000=figure(8000)
set(gcf, 'Position', get(0, 'Screensize'));
subtightplot(1,3,1,[0.05 0.05],[0.15 0.05],[0.08 0.02])
set(gcf,'color','w');
plot(Island_tmaster(1:12000),Island_pco2_smoothed(1:12000),'k');
hold on
h8000=plot(Island_tmaster(25480:34000),Island_pco2_smoothed(25480:34000),'k');
h8000.Annotation.LegendInformation.IconDisplayStyle = 'off';
h8000a=plot(ONC_16_dt,ONC_16_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(ONC_15_dt,ONC_15_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000b=plot(ONC_17_dt,ONC_17_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(Berg16_co2_dt,Berg16_co2_pco2_surface,'o','color',colour_lightblue,'MarkerFaceColor',colour_lightblue,'Markersize',1.5);
h8000a=plot(ONC_16_dt,ONC_16_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(ONC_15_dt,ONC_15_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000b=plot(ONC_17_dt,ONC_17_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
dynamicDateTicks([], [], 'dd/mm');
ylim([200 550])
klp=datenum(2016,05,01,0,0,1);
jkl=datenum(2016,11,01,0,0,1);
xlim([klp jkl])
[l1,icons] =legend('EC tower derived','ONC mooring','Bergmann','Location','SouthWest')
set(findobj(icons,'-property','fontSize'),'fontSize',20)
set(l1,'fontSize',20);
icons=findobj(icons,'Type','line');
set(icons,'MarkerSize',20);
icons=findobj(icons,'Marker','none','-xor');
set(icons,'MarkerSize',20);

ylabel('pCO_2 (ppm)')
xlabel('Time');
title('2016','fontsize',28)
set(gca, 'XTick', [datenum(2016,05,01,0,0,1),datenum(2016,06,01,0,0,1),datenum(2016,07,01,0,0,1),datenum(2016,08,01,0,0,1),datenum(2016,09,01,0,0,1),datenum(2016,10,01,0,0,1),datenum(2016,11,01,0,0,1)])
rotateXLabels( gca(), 90 )
datetick('x','mmm', 'keepticks') 
set(gca,'FontSize',20)
set(gca,'FontSize',20)

subtightplot(1,3,2,[0.05 0.05],[0.15 0.05],[0.08 0.02])
plot(Island_tmaster(1:12000),Island_pco2_smoothed(1:12000),'k');
hold on
h8000=plot(Island_tmaster(25480:34000),Island_pco2_smoothed(25480:34000),'k');
h8000.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(ONC_15_dt,ONC_15_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000a=plot(ONC_16_dt,ONC_16_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
h8000b=plot(ONC_17_dt,ONC_17_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(Berg17_co2_dt,Berg17_co2_pco2_surface,'o','color',colour_lightblue,'MarkerFaceColor',colour_lightblue,'Markersize',1.5);
dynamicDateTicks([], [], 'dd/mm');
ylim([200 550])
klp=datenum(2017,05,01,0,0,1);
jkl=datenum(2017,11,01,0,0,1);
xlim([klp jkl])
% [l1,icons]=legend('EC tower derived','ONC mooring','Bergmann','Location','NorthWest')
% set(l1,'fontsize',18)
% icons=findobj(icons,'Type','line');
% icons=findobj(icons,'Marker','none','-xor');
% set(icons,'MarkerSize',8);
xlabel('Time');
title('2017','fontsize',28)
set(gca, 'XTick', [datenum(2017,05,01,0,0,1),datenum(2017,06,01,0,0,1),datenum(2017,07,01,0,0,1),datenum(2017,08,01,0,0,1),datenum(2017,09,01,0,0,1),datenum(2017,10,01,0,0,1),datenum(2017,11,01,0,0,1)])
rotateXLabels( gca(), 90 )
datetick('x','mmm', 'keepticks') 
%set(gca,'YTick',[])
set(gca,'FontSize',20)
set(gca,'FontSize',20)

subtightplot(1,3,3,[0.05 0.05],[0.15 0.05],[0.08 0.02])
plot(Island_tmaster(1:12000),Island_pco2_smoothed(1:12000),'k');
hold on
h8000=plot(Island_tmaster(25480:34000),Island_pco2_smoothed(25480:34000),'k');
h8000.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(ONC_15_dt,ONC_15_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000a=plot(ONC_16_dt,ONC_16_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
h8000b=plot(ONC_17_dt,ONC_17_pCO2,'o','color',colour_lightred,'MarkerFaceColor',colour_lightred);
h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(Berg18_co2_dt,Berg18_co2_pco2_surface,'o','color',colour_lightblue,'MarkerFaceColor',colour_lightblue,'Markersize',1.5);
dynamicDateTicks([], [], 'dd/mm');
ylim([200 550])
title('2018','fontsize',28)
klp=datenum(2018,05,01,0,0,1);
jkl=datenum(2018,11,01,0,0,1);
xlim([klp jkl])
xlabel('Time');
% [l1,icons]=legend('EC tower derived','ONC mooring','Bergmann','Location','NorthEast')
% set(l1,'fontsize',18)
% icons=findobj(icons,'Type','line');
% icons=findobj(icons,'Marker','none','-xor');
% set(icons,'MarkerSize',8);xlabel('Time');
set(gca, 'XTick', [datenum(2018,05,01,0,0,1),datenum(2018,06,01,0,0,1),datenum(2018,07,01,0,0,1),datenum(2018,08,01,0,0,1),datenum(2018,09,01,0,0,1),datenum(2018,10,01,0,0,1),datenum(2018,11,01,0,0,1)])
rotateXLabels( gca(), 90 )
datetick('x','mmm', 'keepticks') 
%set(gca,'YTick',[])
set(gca,'FontSize',20)
set(gca,'FontSize',20)
saveas(h8000,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Figure6_Timeseries_pco2_kitikmeot.jpg')
%%     pco2 from all sources in Kitikmeot as yearly summer timeseries
% h8000=figure(8000)
% set(gcf, 'Position', get(0, 'Screensize'));
% subtightplot(1,3,1,[0.015 0.015],[0.15 0.05],[0.05 0.05])
% set(gcf,'color','w');
% plot(Island_tmaster(1:12000),Island_pco2_smoothed(1:12000),'k');
% hold on
% h8000=plot(Island_tmaster(25480:34000),Island_pco2_smoothed(25480:34000),'k');
% h8000.Annotation.LegendInformation.IconDisplayStyle = 'off';
% h8000a=plot(ONC_16_dt,ONC_16_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot(ONC_15_dt,ONC_15_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000b=plot(ONC_17_dt,ONC_17_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_pco2_surface(Bathurst_17_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_pco2_surface(Dease_strait_w_17_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_pco2_surface(Wellington_17_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg17_co2_dt(island17_index),Berg17_co2_pco2_surface(island17_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg17_co2_dt(cambay17_index),Berg17_co2_pco2_surface(cambay17_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_pco2_surface(QMG_17_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_pco2_surface(Chantry_17_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',1.5);
% plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_pco2_surface(Bathurst_16_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_pco2_surface(Dease_strait_w_16_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_pco2_surface(Wellington_16_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg16_co2_dt(island16_index),Berg16_co2_pco2_surface(island16_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg16_co2_dt(cambay16_index),Berg16_co2_pco2_surface(cambay16_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_pco2_surface(QMG_16_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_pco2_surface(Chantry_16_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',1.5);
% plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_pco2_surface(Bathurst_18_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_pco2_surface(Dease_strait_w_18_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_pco2_surface(Wellington_18_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg18_co2_dt(island18_index),Berg18_co2_pco2_surface(island18_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg18_co2_dt(cambay18_index),Berg18_co2_pco2_surface(cambay18_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_pco2_surface(QMG_18_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% h8000a=plot(ONC_16_dt,ONC_16_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot(ONC_15_dt,ONC_15_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000b=plot(ONC_17_dt,ONC_17_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
% dynamicDateTicks([], [], 'dd/mm');
% ylim([200 550])
% klp=datenum(2016,05,01,0,0,1);
% jkl=datenum(2016,11,01,0,0,1);
% xlim([klp jkl])
% legend('EC tower derived','ONC mooring','Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet','Location','NorthWest')
% ylabel('pCO_2 (ppm)')
% xlabel('Time (mmm)');
% title('2016','fontsize',20)
% set(gca, 'XTick', [datenum(2016,05,01,0,0,1),datenum(2016,06,01,0,0,1),datenum(2016,07,01,0,0,1),datenum(2016,08,01,0,0,1),datenum(2016,09,01,0,0,1),datenum(2016,10,01,0,0,1),datenum(2016,11,01,0,0,1)])
% rotateXLabels( gca(), 90 )
% datetick('x','mmm', 'keepticks') 
% 
% subtightplot(1,3,2,[0.015 0.015],[0.15 0.05],[0.05 0.05])
% plot(Island_tmaster(1:12000),Island_pco2_smoothed(1:12000),'k');
% hold on
% h8000=plot(Island_tmaster(25480:34000),Island_pco2_smoothed(25480:34000),'k');
% h8000.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot(ONC_15_dt,ONC_15_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000a=plot(ONC_16_dt,ONC_16_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% h8000b=plot(ONC_17_dt,ONC_17_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_pco2_surface(Bathurst_17_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_pco2_surface(Dease_strait_w_17_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_pco2_surface(Wellington_17_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg17_co2_dt(island17_index),Berg17_co2_pco2_surface(island17_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg17_co2_dt(cambay17_index),Berg17_co2_pco2_surface(cambay17_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_pco2_surface(QMG_17_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_pco2_surface(Chantry_17_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',1.5);
% plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_pco2_surface(Bathurst_16_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_pco2_surface(Dease_strait_w_16_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_pco2_surface(Wellington_16_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg16_co2_dt(island16_index),Berg16_co2_pco2_surface(island16_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg16_co2_dt(cambay16_index),Berg16_co2_pco2_surface(cambay16_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_pco2_surface(QMG_16_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_pco2_surface(Chantry_16_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',1.5);
% plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_pco2_surface(Bathurst_18_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_pco2_surface(Dease_strait_w_18_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_pco2_surface(Wellington_18_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg18_co2_dt(island18_index),Berg18_co2_pco2_surface(island18_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg18_co2_dt(cambay18_index),Berg18_co2_pco2_surface(cambay18_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_pco2_surface(QMG_18_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% dynamicDateTicks([], [], 'dd/mm');
% ylim([200 550])
% klp=datenum(2017,05,01,0,0,1);
% jkl=datenum(2017,11,01,0,0,1);
% xlim([klp jkl])
% legend('EC tower derived','ONC mooring','Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet','Location','NorthWest')
% xlabel('Time (mmm)');
% title('2017','fontsize',20)
% set(gca, 'XTick', [datenum(2017,05,01,0,0,1),datenum(2017,06,01,0,0,1),datenum(2017,07,01,0,0,1),datenum(2017,08,01,0,0,1),datenum(2017,09,01,0,0,1),datenum(2017,10,01,0,0,1),datenum(2017,11,01,0,0,1)])
% rotateXLabels( gca(), 90 )
% datetick('x','mmm', 'keepticks') 
% set(gca,'YTick',[])
% 
% subtightplot(1,3,3,[0.015 0.015],[0.15 0.05],[0.05 0.05])
% plot(Island_tmaster(1:12000),Island_pco2_smoothed(1:12000),'k');
% hold on
% h8000=plot(Island_tmaster(25480:34000),Island_pco2_smoothed(25480:34000),'k');
% h8000.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot(ONC_15_dt,ONC_15_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000a=plot(ONC_16_dt,ONC_16_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000a.Annotation.LegendInformation.IconDisplayStyle = 'off';
% h8000b=plot(ONC_17_dt,ONC_17_pCO2,'-o','color',colour_saddlebrown,'MarkerFaceColor',colour_saddlebrown);
% h8000b.Annotation.LegendInformation.IconDisplayStyle = 'off';
% plot(Berg17_co2_dt(Bathurst_17_index),Berg17_co2_pco2_surface(Bathurst_17_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg17_co2_dt(Dease_strait_w_17_index),Berg17_co2_pco2_surface(Dease_strait_w_17_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg17_co2_dt(Wellington_17_index),Berg17_co2_pco2_surface(Wellington_17_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg17_co2_dt(island17_index),Berg17_co2_pco2_surface(island17_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg17_co2_dt(cambay17_index),Berg17_co2_pco2_surface(cambay17_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg17_co2_dt(QMG_17_index),Berg17_co2_pco2_surface(QMG_17_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% plot(Berg17_co2_dt(Chantry_17_index),Berg17_co2_pco2_surface(Chantry_17_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',1.5);
% plot(Berg16_co2_dt(Bathurst_16_index),Berg16_co2_pco2_surface(Bathurst_16_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg16_co2_dt(Dease_strait_w_16_index),Berg16_co2_pco2_surface(Dease_strait_w_16_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg16_co2_dt(Wellington_16_index),Berg16_co2_pco2_surface(Wellington_16_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg16_co2_dt(island16_index),Berg16_co2_pco2_surface(island16_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg16_co2_dt(cambay16_index),Berg16_co2_pco2_surface(cambay16_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg16_co2_dt(QMG_16_index),Berg16_co2_pco2_surface(QMG_16_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% plot(Berg16_co2_dt(Chantry_16_index),Berg16_co2_pco2_surface(Chantry_16_index),'o','color',colour_orchid,'MarkerFaceColor',colour_orchid,'Markersize',1.5);
% plot(Berg18_co2_dt(Bathurst_18_index),Berg18_co2_pco2_surface(Bathurst_18_index),'o','color',colour_indianred,'MarkerFaceColor',colour_indianred,'Markersize',1.5);
% plot(Berg18_co2_dt(Dease_strait_w_18_index),Berg18_co2_pco2_surface(Dease_strait_w_18_index),'o','color',colour_mustard,'MarkerFaceColor',colour_mustard,'Markersize',1.5);
% plot(Berg18_co2_dt(Wellington_18_index),Berg18_co2_pco2_surface(Wellington_18_index),'o','color',colour_darkblue,'MarkerFaceColor',colour_darkblue,'Markersize',1.5);
% plot(Berg18_co2_dt(island18_index),Berg18_co2_pco2_surface(island18_index),'o','color',colour_mediumturquoise,'MarkerFaceColor',colour_mediumturquoise,'Markersize',1.5);
% plot(Berg18_co2_dt(cambay18_index),Berg18_co2_pco2_surface(cambay18_index),'o','color',colour_rose,'MarkerFaceColor',colour_rose,'Markersize',1.5);
% plot(Berg18_co2_dt(QMG_18_index),Berg18_co2_pco2_surface(QMG_18_index),'o','color',colour_siennna,'MarkerFaceColor',colour_siennna,'Markersize',1.5);
% dynamicDateTicks([], [], 'dd/mm');
% ylim([200 550])
% title('2018','fontsize',20)
% klp=datenum(2018,05,01,0,0,1);
% jkl=datenum(2018,11,01,0,0,1);
% xlim([klp jkl])
% legend('EC tower derived','ONC mooring','Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet','Location','NorthWest')
% xlabel('Time (mmm)');
% set(gca, 'XTick', [datenum(2018,05,01,0,0,1),datenum(2018,06,01,0,0,1),datenum(2018,07,01,0,0,1),datenum(2018,08,01,0,0,1),datenum(2018,09,01,0,0,1),datenum(2018,10,01,0,0,1),datenum(2018,11,01,0,0,1)])
% rotateXLabels( gca(), 90 )
% datetick('x','mmm', 'keepticks') 
% set(gca,'YTick',[])
% saveas(h8000,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Figure6_Timeseries_pco2_kitikmeot.jpg')
%%     SST as a function of salinity coloured by region
h1002=figure(1002);
plot(Berg17_co2_SST_1m(Bathurst_17_index),Berg17_co2_TSG_s(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_SST_1m(Dease_strait_w_17_index),Berg17_co2_TSG_s(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_SST_1m(Wellington_17_index),Berg17_co2_TSG_s(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_SST_1m(island17_index),Berg17_co2_TSG_s(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_SST_1m(cambay17_index),Berg17_co2_TSG_s(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_SST_1m(QMG_17_index),Berg17_co2_TSG_s(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_SST_1m(Chantry_17_index),Berg17_co2_TSG_s(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
plot(Berg16_co2_SST_1m(Bathurst_16_index),Berg16_co2_TSG_s(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg16_co2_SST_1m(Dease_strait_w_16_index),Berg16_co2_TSG_s(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_SST_1m(Wellington_16_index),Berg16_co2_TSG_s(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_SST_1m(island16_index),Berg16_co2_TSG_s(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_SST_1m(cambay16_index),Berg16_co2_TSG_s(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_SST_1m(QMG_16_index),Berg16_co2_TSG_s(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_SST_1m(Chantry_16_index),Berg16_co2_TSG_s(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);

plot(Berg18_co2_SST_1m(Bathurst_18_index),Berg18_co2_TSG_s(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg18_co2_SST_1m(Dease_strait_w_18_index),Berg18_co2_TSG_s(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_SST_1m(Wellington_18_index),Berg18_co2_TSG_s(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_SST_1m(island18_index),Berg18_co2_TSG_s(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_SST_1m(cambay18_index),Berg18_co2_TSG_s(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_SST_1m(QMG_18_index),Berg18_co2_TSG_s(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_SST_1m(Chantry_18_index),Berg18_co2_TSG_s(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);

plot(Berg19_co2_SST_1m(Bathurst_19_index),Berg19_co2_TSG_s(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
plot(Berg19_co2_SST_1m(Dease_strait_w_19_index),Berg19_co2_TSG_s(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_SST_1m(Wellington_19_index),Berg19_co2_TSG_s(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_SST_1m(island19_index),Berg19_co2_TSG_s(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_SST_1m(cambay19_index),Berg19_co2_TSG_s(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_SST_1m(QMG_19_index),Berg19_co2_TSG_s(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_SST_1m(Chantry_19_index),Berg19_co2_TSG_s(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','NorthEast')
xlabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
ylabel('Salinity (PSU)','fontsize',12);
% saveas(h1002,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_co2_vs_SST_region.jpg')
%%     SST as a function of salinity by year and coloured by region
h1003=figure(1003);
subplot(2,2,1)
plot(Berg16_co2_SST_1m(Bathurst_16_index),Berg16_co2_TSG_s(Bathurst_16_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg16_co2_SST_1m(Dease_strait_w_16_index),Berg16_co2_TSG_s(Dease_strait_w_16_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg16_co2_SST_1m(Wellington_16_index),Berg16_co2_TSG_s(Wellington_16_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg16_co2_SST_1m(island16_index),Berg16_co2_TSG_s(island16_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg16_co2_SST_1m(cambay16_index),Berg16_co2_TSG_s(cambay16_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg16_co2_SST_1m(QMG_16_index),Berg16_co2_TSG_s(QMG_16_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg16_co2_SST_1m(Chantry_16_index),Berg16_co2_TSG_s(Chantry_16_index),'*','MarkerSize',1,'color',colour_orchid);
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','EastOutside')
ylabel({['Salinity (PSU)']},'fontsize',12); 
xlabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
title('2016')

subplot(2,2,2)
plot(Berg17_co2_SST_1m(Bathurst_17_index),Berg17_co2_TSG_s(Bathurst_17_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg17_co2_SST_1m(Dease_strait_w_17_index),Berg17_co2_TSG_s(Dease_strait_w_17_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg17_co2_SST_1m(Wellington_17_index),Berg17_co2_TSG_s(Wellington_17_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg17_co2_SST_1m(island17_index),Berg17_co2_TSG_s(island17_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg17_co2_SST_1m(cambay17_index),Berg17_co2_TSG_s(cambay17_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg17_co2_SST_1m(QMG_17_index),Berg17_co2_TSG_s(QMG_17_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg17_co2_SST_1m(Chantry_17_index),Berg17_co2_TSG_s(Chantry_17_index),'*','MarkerSize',1,'color',colour_orchid);
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','EastOutside')
ylabel({['Salinity (PSU)']},'fontsize',12); 
xlabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
title('2017')

subplot(2,2,3)
plot(Berg18_co2_SST_1m(Bathurst_18_index),Berg18_co2_TSG_s(Bathurst_18_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg18_co2_SST_1m(Dease_strait_w_18_index),Berg18_co2_TSG_s(Dease_strait_w_18_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg18_co2_SST_1m(Wellington_18_index),Berg18_co2_TSG_s(Wellington_18_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg18_co2_SST_1m(island18_index),Berg18_co2_TSG_s(island18_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg18_co2_SST_1m(cambay18_index),Berg18_co2_TSG_s(cambay18_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg18_co2_SST_1m(QMG_18_index),Berg18_co2_TSG_s(QMG_18_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg18_co2_SST_1m(Chantry_18_index),Berg18_co2_TSG_s(Chantry_18_index),'*','MarkerSize',1,'color',colour_orchid);
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','EastOutside')
ylabel({['Salinity (PSU)']},'fontsize',12); 
xlabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
title('2018')

subplot(2,2,4)
plot(Berg19_co2_SST_1m(Bathurst_19_index),Berg19_co2_TSG_s(Bathurst_19_index),'*','MarkerSize',1,'color',colour_indianred);
hold on
plot(Berg19_co2_SST_1m(Dease_strait_w_19_index),Berg19_co2_TSG_s(Dease_strait_w_19_index),'*','MarkerSize',1,'color',colour_mustard);
plot(Berg19_co2_SST_1m(Wellington_19_index),Berg19_co2_TSG_s(Wellington_19_index),'*','MarkerSize',1,'color',colour_darkblue);
plot(Berg19_co2_SST_1m(island19_index),Berg19_co2_TSG_s(island19_index),'*','MarkerSize',1,'color',colour_mediumturquoise);
plot(Berg19_co2_SST_1m(cambay19_index),Berg19_co2_TSG_s(cambay19_index),'*','MarkerSize',1,'color',colour_rose);
plot(Berg19_co2_SST_1m(QMG_19_index),Berg19_co2_TSG_s(QMG_19_index),'*','MarkerSize',1,'color',colour_siennna);
plot(Berg19_co2_SST_1m(Chantry_19_index),Berg19_co2_TSG_s(Chantry_19_index),'*','MarkerSize',1,'color',colour_orchid);
[hL1,icons]=legend('Bathurst Inlet','Dease strait West','Wellington Bay','Finlayson Islands','Cambridge Bay','Queen Maud Gulf','Chantry Inlet')
hL1.FontSize = 10;
set(hL1,'Box','on','Location','EastOutside')
ylabel({['Salinity (PSU)']},'fontsize',12); 
xlabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
title('2019')
saveas(h1003,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_sst_vs_sal_region.jpg')
%%     SST as a function of salinity by year coloured by pCO2
h1004=figure(1004);
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf,'color','w');
subplot(2,2,1)
scatter(Berg16_co2_TSG_s,Berg16_co2_SST_1m,1,Berg16_co2_pco2_surface);
title('2016')
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
h=colorbar
ylabel(h,{['pCO_2 (ppm)']},'fontsize',12); 
xlabel('Salinity (PSU)');

subplot(2,2,2)
scatter(Berg17_co2_TSG_s,Berg17_co2_SST_1m,1, Berg17_co2_pco2_surface);
title('2017')
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
h=colorbar
ylabel(h,{['pCO_2 (ppm)']},'fontsize',12); 
xlabel('Salinity (PSU)');

subplot(2,2,3)
scatter(Berg18_co2_TSG_s,Berg18_co2_SST_1m,1,Berg18_co2_pco2_surface);
title('2018')
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
h=colorbar
ylabel(h,{['pCO_2 (ppm)']},'fontsize',12); 
xlabel('Salinity (PSU)');

subplot(2,2,4)
scatter(Berg19_co2_TSG_s,Berg19_co2_SST_1m,1,Berg19_co2_pco2_surface);
title('2019')
ylabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
h=colorbar
ylabel(h,{['pCO_2 (ppm)']},'fontsize',12); 
xlabel('Salinity (PSU)');

% saveas(h1004,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_salandSST_vsco2byyear.jpg')
%%     SST as a function of salinity coloured by pCO2
h103=figure(103);
scatter(Berg16_co2_SST_1m,Berg16_co2_TSG_s,1,Berg16_co2_pco2_surface)
hold on
scatter(Berg17_co2_SST_1m,Berg17_co2_TSG_s,1, Berg17_co2_pco2_surface)
scatter(Berg18_co2_SST_1m,Berg18_co2_TSG_s,1,Berg18_co2_pco2_surface)
scatter(Berg19_co2_SST_1m,Berg19_co2_TSG_s,1,Berg19_co2_pco2_surface)
xlabel({['Temperature (',num2str(degree_symbol),'C)']},'fontsize',12); 
ylabel({['Salinity (PSU)']},'fontsize',12); 
h=colorbar
ylabel(h,{['pCO_2 (ppm)']},'fontsize',12); 
caxis([190 500])
saveas(h103,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_sal_vs_SST_by_co2.jpg')
%%     SST as a function of pco2 coloured by salinity
h104=figure(104) %#ok<*NOPTS>
scatter(Berg16_co2_SST_1m,Berg16_co2_pco2_surface,1,Berg16_co2_TSG_s);
hold on
scatter(Berg17_co2_SST_1m,Berg17_co2_pco2_surface,1, Berg17_co2_TSG_s);
scatter(Berg18_co2_SST_1m,Berg18_co2_pco2_surface,1,Berg18_co2_TSG_s);
scatter(Berg19_co2_SST_1m,Berg19_co2_pco2_surface,1,Berg19_co2_TSG_s);
xlabel('Temp')
ylabel('co2')
colorbar
caxis([0 29])
% saveas(h104,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_co2_vs_SST_.jpg')
%%     SST as a function of pco2 coloured by chl-A
h105=figure(105)
% scatter(Berg16_co2_SST_1m,Berg16_co2_pco2_surface,1,Berg16_co2_Chl_despike)
hold on
scatter(Berg17_co2_SST_1m,Berg17_co2_pco2_surface,1, Berg17_co2_Chl_despike)
scatter(Berg18_co2_SST_1m,Berg18_co2_pco2_surface,1,Berg18_co2_Chl_despike)
scatter(Berg19_co2_SST_1m,Berg19_co2_pco2_surface,1,Berg19_co2_Chl_despike)
xlabel('Temp')
ylabel('co2')
colorbar
caxis([0 1])
% saveas(h105,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Berg_co2_vs_SST_chl.jpg')
%%     Figure 6 Inside vs outside bay plot
h1337=figure(1337)
m_proj('Sinusoidal','lon',[-105.35 -104.75],'lat',[69 69.12]);  
m_grid('linestyle','none','tickdir','out','fontsize',20)
hold on
%add data
set(gca,'FontSize',20)
set(gca,'FontSize',20)
m_gshhs_f('patch',[.5 .5 .5]);
m_scatter(Berg16_co2_Longitude,Berg16_co2_Latitude,2,Berg16_co2_pco2_surface*0,'filled')
m_scatter(Berg17_co2_Longitude,Berg17_co2_Latitude,2,Berg17_co2_pco2_surface*0,'filled')
m_scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,2,Berg18_co2_pco2_surface*0,'filled')
m_scatter(Berg19_co2_Longitude,Berg19_co2_Latitude,2,Berg19_co2_pco2_surface*0,'filled')

%cambay in box
m_line([-105.08 -105.04],[69.095 69.095],'color','r','linewidth',3);
m_line([-105.08 -105.04],[69.115 69.115],'color','r','linewidth',3);
m_line([-105.08 -105.08],[69.095 69.115],'color','r','linewidth',3);
m_line([-105.04 -105.04],[69.095 69.115],'color','r','linewidth',3);

%cambay out box
m_line([-105.12 -105.08],[69.035 69.035],'color','b','linewidth',3);
m_line([-105.12 -105.08],[69.055 69.055],'color','b','linewidth',3);
m_line([-105.12 -105.12],[69.035 69.055],'color','b','linewidth',3);
m_line([-105.08 -105.08],[69.035 69.055],'color','b','linewidth',3);
m_ruler([.6 .9],.1,3,'fontsize',16,'color','w');

y=ylabel(['Latitude (',num2str(degree_symbol),'N)'],'Fontsize',24);
set(y,'Units','Normalized','Position',[-0.055,0.5,0]);
x=xlabel(['Longitude(',num2str(degree_symbol),'W)'],'Fontsize',24);
set(x,'Units','Normalized','Position',[0.5,-0.07,0]); 
saveas(h1337,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Cambay_invsout.jpg')
%%     Figure S1 Plots of temperature corrections
load ('2018_temp_cal.mat')
load ('2017_temp_cal.mat')
 c = polyfit(save4plot_equ2017,save4plot_ros2017,1);
 c2 = polyfit(save4plot_equ2018,save4plot_ros2018,1);

h56 = figure('Position', get(0, 'Screensize'));
subplot(1,2,1)
plot(save4plot_equ2017,save4plot_ros2017,'k*')
hold on
plot(1:1:10,(1:1:10)*c(1)+c(2),'k-')
xlabel({['Equilibrator temperature (',num2str(degree_symbol),'C)']},'fontsize',14)
ylabel({['Rosette CTD temperature (',num2str(degree_symbol),'C)']},'fontsize',14)
title('2017','fontsize',14)
% plot (3:0.1:10,3:0.1:10,'--b')
xlim([3 10])
ylim([3 10])
set(gca,'fontsize',14)
set(gca,'fontsize',14)
text(4,9,'y= 0.8512x -0.50','fontsize',14);
text(4,8.5,(['RMSD= 0.49' degree_symbol 'C']),'fontsize',14);

subplot(1,2,2)
plot(save4plot_equ2018,save4plot_ros2018,'k*')
hold on
plot(-1:1:10,(-1:1:10)*c2(1)+c2(2),'k-')
xlabel({['Equilibrator temperature (',num2str(degree_symbol),'C)']},'fontsize',14)
ylabel({['Rosette CTD temperature (',num2str(degree_symbol),'C)']},'fontsize',14)
title('2018','fontsize',14)
% plot (1:0.1:12,1:0.1:12,'--b')
xlim([-1 10])
ylim([-1 10])
set(gca,'fontsize',14)
set(gca,'fontsize',14)
text(4,9,'y= 1.1875x -3.30','fontsize',14);
text(4,8,(['RMSD= 0.64' degree_symbol 'C']),'fontsize',14);

saveas(h56,'C:\Users\rps207\Documents\Research Papers, Books, Thesises, Course and Lecture Notes\My Papers\2021 - Calgary postdoc - Bergmann summer pCO2/Temp_regressions.jpg')
%% find pCO2 within 1km of the island

%2017
for subset=1:length(Berg17_co2_Latitude);
    dist(subset) = pos2dist(68.984157,-105.834386,Berg17_co2_Latitude(subset),Berg17_co2_Longitude(subset),2);
end

[~ ,xb]=find(dist<1); %only get ones <1km 

%two time periods 
%1163- 1420 = here for 5 hours!
datevec(Berg17_co2_dt(1163))
datevec(Berg17_co2_dt(1420))

%15961-16064 - here ofr 1.5 hours
datevec(Berg17_co2_dt(15961))
datevec(Berg17_co2_dt(16064))

mean(Berg17_co2_fco2_surface(1163:1420))

[~, oa]=find(Island_tmaster>Berg17_co2_dt(1163) & Island_tmaster<Berg17_co2_dt(1420))
nanmean(Island_pco2(oa))

%difference is 414.67- 344.2138

mean(Berg17_co2_fco2_surface(15961:16064))
[~, ob]=find(Island_tmaster>Berg17_co2_dt(15961) & Island_tmaster<Berg17_co2_dt(16064))
nanmean(Island_pco2(ob))
%no data!

%2018 
for subset=1:length(Berg18_co2_Latitude);
    dist2018(subset) = pos2dist(68.984157,-105.834386,Berg18_co2_Latitude(subset),Berg18_co2_Longitude(subset),2);
end

[~ ,xc]=find(dist2018<1); %only get ones <1km 

%two time periods 

%436-474
datevec(Berg18_co2_dt(436))
datevec(Berg18_co2_dt(474))

mean(Berg18_co2_fco2_surface(436:474))

[~, oa]=find(Island_tmaster>Berg18_co2_dt(436) & Island_tmaster<Berg18_co2_dt(474))
nanmean(Island_pco2(oa))

%408.6925-237.4071

%4501- 4640 = here for 2 hours!
datevec(Berg18_co2_dt(4501))
datevec(Berg18_co2_dt(4640))

mean(Berg18_co2_fco2_surface(4501:4640))

[~, oa]=find(Island_tmaster>Berg18_co2_dt(4501) & Island_tmaster<Berg18_co2_dt(4640))
nanmean(Island_pco2(oa))

% no measurements at tower nan!
%% find pCO2 within 0.5km km of the ONC


for subset=1:length(Berg16_co2_Latitude);
    dist(subset) = pos2dist(69.113548,-105.062700,Berg16_co2_Latitude(subset),Berg16_co2_Longitude(subset),2);
end

[~ ,xb]=find(dist<0.5); %only get ones <1km 

%4 periods of overlap

datevec(Berg16_co2_dt(2192))
datevec(Berg16_co2_dt(2493))
mean(Berg16_co2_fco2_surface(2192:2493))

[~, oa]=find(ONC_16_dt>Berg16_co2_dt(2192) & ONC_16_dt<Berg16_co2_dt(2493))
nanmean(ONC_16_pCO2(oa))

%no measurements



datevec(Berg16_co2_dt(3758))
datevec(Berg16_co2_dt(4292))
mean(Berg16_co2_fco2_surface(3758:4292))

[~, oa]=find(ONC_16_dt>Berg16_co2_dt(3758) & ONC_16_dt<Berg16_co2_dt(4292))
nanmean(ONC_16_pCO2(oa))

%no measurements

datevec(Berg16_co2_dt(4701))
datevec(Berg16_co2_dt(5012))
mean(Berg16_co2_fco2_surface(4701:5012))

[~, oa]=find(ONC_15_dt>Berg16_co2_dt(4701) & ONC_15_dt<Berg16_co2_dt(5012))
nanmean(ONC_15_pCO2(oa))

%no measurements

datevec(Berg16_co2_dt(5132))
datevec(Berg16_co2_dt(5521))
mean(Berg16_co2_fco2_surface(5132:5521))

[~, oa]=find(ONC_15_dt>Berg16_co2_dt(5132) & ONC_15_dt<Berg16_co2_dt(5521))
nanmean(ONC_15_pCO2(oa))

%no measurements

%FIND PCO2 when mooring was in and out of the water 
%ONC ON 253/254
x=datevec(ONC_15_dt);
ONC_15_pCO2(253)
ONC_15_pCO2(254)





