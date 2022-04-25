%work up Bergmann underway data 2018
clc;  clear all ; close all; %reset workspace

%add directories of functions that maybe needed - probably not required.

addpath('c:\Users\rps207\Documents\Matlab\Functions');
addpath('c:\Users\rps207\Documents\Matlab\Functions\Add_Axis');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cbdate');
addpath('c:\Users\rps207\Documents\Matlab\Functions\mixing_library');
addpath('c:\Users\rps207\Documents\Matlab\Functions\despiking_tooblox');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cm_and_cb_utilities');
addpath('c:\Users\rps207\Documents\Matlab\Functions\tsplot');
set(groot,'DefaultFigureColormap',jet)

%directories of files
mfileDir = 'C:\Users\rps207\Documents\MATLAB\2019 - Bergmann pCO2 2016 -2019\'; %path for main matlab analysis
path_pco2 = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2018\Raw\SuperCO2\pCO2';%identify file path
path_eco = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2018\Raw\SuperCO2\ECO';%identify file path
path_cr300 = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2018\Raw\CR300\BergmannUnderway_all.txt';

path_tsg=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pco2 files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loop through underway files 
cd(path_pco2); %change current directory to folder with files want to load
fList = dirPlus(path_pco2);

%select only co2 files
IndexC = strfind(fList,'desktop.ini'); %necessary to first remove ini file
Index = find(not(cellfun('isempty',IndexC)));
fList(Index)=[]; %remove that file
IndexC = strfind(fList,'pCO2');%find only co2 files
Index = find(not(cellfun('isempty',IndexC)));
fList_pco2=fList(Index); 


%loop through files and extract identifier from end of files
Velp=[];
fList_entry_num=size(fList_pco2);
for k=1:fList_entry_num(1,1);
    fname_char=char(fList_pco2(k,:));
    length_ent=length(fname_char);
    x=str2double(fname_char(:,length_ent-11:length_ent-4));
    Velp(k)=x;
end

%sort files by date
[ ~, p ]=sort(Velp);

 Time=[];Date=[];TSG_e=[];Valvepos=[];IO3=[];IO4=[];IO5=[];Pres_v=[];Temp_v=[];Pres_kpa=[];Temp_c=[];
    Cell_p=[];Cell_t=[];H20_ppt=[];CO2_ppm=[];DOY_utc=[];TSG_s=[];TSG_t=[];Valvepos=[];
    
    

for i = p;
fNamex = char(fList_pco2(i,:));
delimiter = '\t';
startRow = 6;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fName = [fNamex];
fileID = fopen(fName,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

doy_utc = dataArray{:, 1};
co2_ppm = dataArray{:, 2};
co2_abs = dataArray{:, 3};
h20_ppt = dataArray{:, 4};
h20_abs = dataArray{:, 5};
cell_t = dataArray{:, 6};
cell_p = dataArray{:, 7};
pwrV820 = dataArray{:, 8};
temp_c = dataArray{:, 9};
pres_kpa = dataArray{:, 10};
temp_v = dataArray{:, 11};
pres_v = dataArray{:, 12};
io3 = dataArray{:, 13};
io4 = dataArray{:, 14};
io5 = dataArray{:, 15};
valvepos = dataArray{:, 16};
tsg_t = dataArray{:, 17};
tsg_s = dataArray{:, 18};
%note difference from 2019 is that there is no GPS or emissivity in this
%file
date = dataArray{:, 19};
time = dataArray{:, 20};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

    Time=[Time ; time];
    Date=[Date ; date];
    TSG_s=[TSG_s ; tsg_s];
    TSG_t=[TSG_t ; tsg_t];
    Valvepos=[Valvepos ; valvepos];
    IO3=[IO3 ; io3];
    IO5=[IO5 ; io5];
    IO4=[IO4 ; io4];
    Pres_v=[Pres_v ; pres_v];
    Temp_v=[Temp_v ; temp_v];
    Pres_kpa=[Pres_kpa ; pres_kpa];
    Temp_c=[Temp_c ; temp_c];
    Cell_p=[Cell_p ; cell_p];
    Cell_t=[Cell_t ; cell_t];
    H20_ppt=[H20_ppt ; h20_ppt];
    CO2_ppm=[CO2_ppm ; co2_ppm];
    DOY_utc=[DOY_utc ; doy_utc];
    
    clearvars date gps_lon gps_lat tsg_e tsg_s  tsg_t valvepos io3 io5 io4 pres_v temp_v pres_kpa temp_c cell_p cell_t h20_ppt co2_ppm doy_utc];
    
end


%DATA CONVERSIONS and QC

%for all variables find nan values
[row1, ~] = find(isnan(Time));
[row2, ~] = find(isnan(Date));
[row3, ~] = find(isnan(TSG_s));
% % % [row4, col] = find(isnan(Longitude));%in seperate file
% % % [row5, col] = find(isnan(Latitude)); %in seperate file
[row6, ~] = find(isnan(TSG_s));
% % % [row7, col] = find(isnan(TSG_e)); not present
[row8, ~] = find(isnan(TSG_t));
[row9, ~] = find(isnan(Valvepos));
[row10, ~] = find(isnan(IO3));
[row11, ~] = find(isnan(IO5));
[row12, ~] = find(isnan(IO4));
[row13, ~] = find(isnan(Pres_v));
[row14, ~] = find(isnan(Temp_v));
[row15, ~] = find(isnan(Pres_kpa));
[row16, ~] = find(isnan(Temp_c));
[row17, ~] = find(isnan(Cell_p));
[row18, ~] = find(isnan(Cell_t));
[row19, ~] = find(isnan(H20_ppt));
[row20, ~] = find(isnan(CO2_ppm));
[row21, ~] = find(isnan(DOY_utc));


%concatenate nan rows for all variables
nanrows=[row1;row2;row3;row6;row8;row9;row10;row11;row12;row13;row14;row15;row16;row17;row18;row19;row20;row21];
nanrowsunq=unique(nanrows); %find only unique rows - note this is only 265 rows of 13831
clearvars nanrows row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12 row13 row14 row15 row16 row17 row18 row19 row20 row21


%remove these rows from data
    Time(nanrowsunq)=[];
    Date(nanrowsunq)=[];
    TSG_s(nanrowsunq)=[];
    TSG_t(nanrowsunq)=[];
    Valvepos(nanrowsunq)=[];
    IO3(nanrowsunq)=[];
    IO5(nanrowsunq)=[];
    IO4(nanrowsunq)=[];
    Pres_v(nanrowsunq)=[];
    Temp_v(nanrowsunq)=[];
    Pres_kpa(nanrowsunq)=[];
    Temp_c(nanrowsunq)=[];
    Cell_p(nanrowsunq)=[];
    Cell_t(nanrowsunq)=[];
    H20_ppt(nanrowsunq)=[];
    CO2_ppm(nanrowsunq)=[];
    DOY_utc(nanrowsunq)=[];

%there are no dashes for time add these for clarity!
Date_char=num2str(Date); %convert to char for concatination
Date_cell={};
%add first bracket
for K=1:length(Date_char);
        A= strtrim(regexprep(Date_char(K,:), '.{4}', '$0/','once'));
        Date_cell(K,:)=cellstr(A);
end
%Add second bracket
Date_cell2={};
for K=1:length(Date_cell);
        A= strtrim(regexprep(Date_cell(K,:), '.{7}', '$0/','once'));
        Date_cell2(K,:)=cellstr(A);
end

%no colons for time again add for clarity
Time_char=num2str(Time,'%06.f'); %convert the time into a format with leading 0's
Time_cell={};
%add first bracket
for K=1:length(Time);
        A= strtrim(regexprep(Time_char(K,:), '.{2}', '$0:','once'));
        Time_cell(K,:)=cellstr(A);
end
%Add second bracket
Time_char2={};
for K=1:length(Time_cell);
        A= strtrim(regexprep(Time_cell(K,:), '.{5}', '$0:','once'));
        Time_char2(K,:)=cellstr(A);
end

Dt_Cat=strcat(Date_cell2,{' '}, Time_char2);
Dt=datenum(Dt_Cat,'yyyy/mm/dd HH:MM:SS');
Jan1_serial = datenum([2018, 1, 1, 0, 0, 0]); %define first day of year
Dt_doy= Dt - Jan1_serial + 1;%    %convert date to doy (day of year)
clear IO3 IO4 IO5 Time_cell Time_char Time_char2 H20_abs Jan1_serial DOY_utc H20_abs Dt_Cat Date Time ans A iRow nanrows nanrowsunq B C Date_char fList fList_pco2 cv col row Date_cell Date_cell2 Index IndexC K mA i k o p time x doy_utc fname_cellstr fNamex fname_char fname_cellstr Velp fList_entry_num length_ent co2_abs micro_ pwrV820


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%eco not logging to pco2 file-import seperately , loop through underway files and 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path_eco); %change current directory to folder with files want to load
fList = dirPlus(path_eco); 
iRow=[];

%select only co2 files
IndexC = strfind(fList,'desktop.ini'); %necessary to first remove ini file
Index = find(not(cellfun('isempty',IndexC)));
fList(Index)=[]; %remove that file
IndexC = strfind(fList,'ECO');%find only co2 files
Index = find(not(cellfun('isempty',IndexC)));
fList_ECO=fList(Index); 

%loop through files and extract identifier from end of files

%loop through files and extract identifier from end of files
Velp=[];
fList_entry_num=size(fList_ECO);
for k=1:fList_entry_num(1,1);
    fname_char=char(fList_ECO(k,:));
    length_ent=length(fname_char);
    x=str2double(fname_char(:,length_ent-11:length_ent-4));
    Velp(k)=x;
end

[ ~, p ]=sort(Velp);
Eco_doyutc=[]; Scatter_ECO=[];Chl_ECO=[]; Flour_ECO=[]; Eco_date=[]; Eco_time=[];
for i = p
fNamex = char(fList_ECO(i,:));
fName = [fNamex];
delimiter = ' ';
startRow = 5;
formatSpec = '%f%f%f%f%f%f%s%*s%*s%[^\n\r]';
fileID = fopen(fName,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
%eco_doyutc = dataArray{:, 1};
scatter = dataArray{:, 2};
chl = dataArray{:, 3};
flour = dataArray{:, 4};
eco_date = dataArray{:, 5};
eco_time = dataArray{:, 6};

    %Eco_doyutc=[Eco_doyutc ; eco_doyutc];
    Scatter_ECO=[Scatter_ECO ; scatter];
    Chl_ECO=[Chl_ECO ; chl];
    Flour_ECO=[Flour_ECO ; flour];
    Eco_date=[Eco_date ; eco_date];
    Eco_time=[Eco_time ; eco_time];

clearvars filename delimiter startRow formatSpec fileID dataArray ans;
end

%for all variables find nan values
[row1, ~] = find(isnan(Flour_ECO));
[row2, ~] = find(isnan(Eco_time));
[row3, ~] = find(isnan(Eco_date));
[row4, ~] = find(isnan(Chl_ECO));
[row5, ~] = find(isnan(Scatter_ECO));

%concatenate nan rows for all variables
nanrows=[row1;row2;row3;row4;row5];
nanrowsunq=unique(nanrows); %find only unique rows - note this is only 265 rows of 13831
clearvars nanrows row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12 row13 row14 row15 row16 row17 row18 row19 row20 row21

%remove these rows from ECO data
    Flour_ECO(nanrowsunq)=[];
    Eco_time(nanrowsunq)=[];
    Eco_date(nanrowsunq)=[];
    Chl_ECO(nanrowsunq)=[];
    Scatter_ECO(nanrowsunq)=[];

%there are no dashes for time add these for clarity!
Date_char=num2str(Eco_date); %convert to char for concatination
Date_cell={};
%add first bracket
for K=1:length(Date_char);
        A= strtrim(regexprep(Date_char(K,:), '.{4}', '$0/','once'));
        Date_cell(K,:)=cellstr(A);
end
%Add second bracket
Date_cell2={};
for K=1:length(Date_cell);
        A= strtrim(regexprep(Date_cell(K,:), '.{7}', '$0/','once'));
        Date_cell2(K,:)=cellstr(A);
end

%no colons for time again add for clarity
Time_char=num2str(Eco_time,'%06.f'); %convert the time into a format with leading 0's
Time_cell={};
%add first bracket
for K=1:length(Eco_time);
        A= strtrim(regexprep(Time_char(K,:), '.{2}', '$0:','once'));
        Time_cell(K,:)=cellstr(A);
end
%Add second bracket
Time_char2={};
for K=1:length(Time_cell);
        A= strtrim(regexprep(Time_cell(K,:), '.{5}', '$0:','once'));
        Time_char2(K,:)=cellstr(A);
end
Dt_Cat=strcat(Date_cell2,{' '}, Time_char2);
Dt_ECO=datenum(Dt_Cat,'yyyy/mm/dd HH:MM:SS');
clear flour fList_ECO eco_time eco_doyutc Eco_doyutc eco_date chl fName row22 row23 row24 scatter Time_cell Time_char Time_char2 H20_abs Jan1_serial DOY_utc H20_abs Dt_Cat Date Time ans A iRow nanrows nanrowsunq B C Date_char fList fList_pco2 cv col row Date_cell Date_cell2 Index IndexC K mA i k o p time x doy_utc fname_cellstr fNamex fname_char fname_cellstr Velp fList_entry_num length_ent co2_abs micro_ pwrV820

%note that there are several duplicate entries in the ECO data
[C,ia]=unique(Dt_ECO);
Flour_ECO=Flour_ECO(ia);
Dt_ECO = Dt_ECO(ia);
Chl_ECO = Chl_ECO(ia);
Scatter_ECO = Scatter_ECO(ia);
%interp to same length as other variables
Chl= interp1(Dt_ECO,Chl_ECO,Dt); %interpolate onto pco2 time
Flour= interp1(Dt_ECO,Flour_ECO,Dt); %interpolate onto pco2 time
Scatter= interp1(Dt_ECO,Scatter_ECO,Dt); %interpolate onto pco2 time
clearvars Scatter_ECO ia Flour_ECO Eco_time Eco_date Dt_ECO Chl_ECO C fname_char path fName fList_entry_num flour fNamex u v Velp w x y z scatter o p  aa ab eco_time eco_doyutc eco_date fList fList_ECO fList_pco2 chl H20_abs i Index IndexC iRow k length_ent


%%%%%%%%%%%%%%%%%%%%%%%
%Import CR3000 to get GPS
%%%%%%%%%%%%%%%%%%%%%%%

delimiter = ',';
startRow = 5;
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
fileID = fopen(path_cr300,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[2,3,4,5,6,9,11,12,13,14,15,16]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
rawNumericColumns = raw(:, [2,3,4,5,6,9,11,12,13,14,15,16]);
rawCellColumns = raw(:, [1,7,8,10]);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
CR3000_TIMESTAMP = rawCellColumns(:, 1);
% CR3000_RECORD = cell2mat(rawNumericColumns(:, 1)); %DONT NEED
CR3000_Latitude = cell2mat(rawNumericColumns(:, 2));
CR3000_Longitude = cell2mat(rawNumericColumns(:, 3));
% CR3000_Speed_kmh = cell2mat(rawNumericColumns(:, 4)); %DONT NEED
% CR3000_Course_Ovr_gnd = cell2mat(rawNumericColumns(:, 5)); DONT NEED
% CR3000_GPSData_1 = rawCellColumns(:, 2); %same as lat and long above
% CR3000_GPSData_2 = rawCellColumns(:, 3); %same as lat and long above
CR3000_SurfT_C_Avg = cell2mat(rawNumericColumns(:, 6));
CR3000_WaterT_C_Avg = rawCellColumns(:, 4);
CR3000_H2OFlow_LPM_Avg = cell2mat(rawNumericColumns(:, 7));
CR3000_pH_V_Avg = cell2mat(rawNumericColumns(:, 8));
CR3000_pH_temp_Avg = cell2mat(rawNumericColumns(:, 9));
CR3000_pH_Avg = cell2mat(rawNumericColumns(:, 10));
CR3000_PTemp_Avg = cell2mat(rawNumericColumns(:, 11));

CR3000_Dt=datenum(CR3000_TIMESTAMP,'yyyy-mm-dd HH:MM:SS');


%CR3000_WaterT_C_Avg for some reason this is coming up as a cell?
% think it is because nans are NAN rather than NaN
IndexC = strfind(CR3000_WaterT_C_Avg,'NAN');
Index = find(not(cellfun('isempty',IndexC))); %bad indexes
Index2 = find((cellfun('isempty',IndexC))); %bad indexes
%make new matrix
CR3000_WaterT_C_Avg_new=zeros(length(CR3000_WaterT_C_Avg),1);
%insert temp and NaN back into this new matrix
CR3000_WaterT_C_Avg_new(Index)=NaN;
x=(CR3000_WaterT_C_Avg(Index2));
y=str2double(x);
CR3000_WaterT_C_Avg_new(Index2)=y;
CR3000_WaterT_C_Avg=CR3000_WaterT_C_Avg_new;

%for all variables find nan values
[row1, ~] = find(isnan(CR3000_Dt));
[row2, ~] = find(isnan(CR3000_Latitude));
[row3, ~] = find(isnan(CR3000_Longitude));
[row6, ~] = find(isnan(CR3000_H2OFlow_LPM_Avg));
[row7, ~] = find(isnan(CR3000_pH_V_Avg));
[row8, ~] = find(isnan(CR3000_pH_temp_Avg));
[row9, ~] = find(isnan(CR3000_pH_Avg));
[row10, ~] = find(isnan(CR3000_PTemp_Avg));

%concatenate nan rows for all variables
nanrows=[row1;row2;row3;row6,row7;row8;row9;row10];
nanrowsunq=unique(nanrows); %find only unique rows - note this is only 265 rows of 13831
clearvars ans nanrows row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12 row13 row14 row15 row16 row17 row18 row19 row20 row21

%remove these rows from CR300 data
CR3000_Dt(nanrowsunq)=[];
CR3000_Latitude(nanrowsunq)=[];
CR3000_Longitude(nanrowsunq)=[];
CR3000_SurfT_C_Avg(nanrowsunq)=[];
CR3000_WaterT_C_Avg(nanrowsunq)=[];
CR3000_H2OFlow_LPM_Avg(nanrowsunq)=[];
CR3000_pH_V_Avg(nanrowsunq)=[];
CR3000_pH_temp_Avg(nanrowsunq)=[];
CR3000_pH_Avg(nanrowsunq)=[];
CR3000_PTemp_Avg(nanrowsunq)=[];
    
CR3000_Dt_tempa=CR3000_Dt;
CR3000_Dt_tempb=CR3000_Dt;

%convert GPS LAT and LONG to usable decimal degrees
lat_deg=floor(CR3000_Latitude/100);
lat_min=(floor(((CR3000_Latitude/100)-lat_deg)*100))./60;
lat_sec=(1/60)*((((CR3000_Latitude/100)-lat_deg)*100)-(floor(((CR3000_Latitude/100)-lat_deg)*100)));
CR3000_Latitude_dec=lat_deg+lat_min+lat_sec;

CR3000_Longitude=CR3000_Longitude;
lon_deg=floor(CR3000_Longitude/100);
lon_min=(floor(((CR3000_Longitude/100)-lon_deg)*100))./60;
lon_sec=(1/60)*((((CR3000_Longitude/100)-lon_deg)*100)-(floor(((CR3000_Longitude/100)-lon_deg)*100)));
CR3000_Longitude_dec=-1*(lon_deg+lon_min+lon_sec);

[~, unique_index]=unique(CR3000_Dt);


CR3000_Dt=CR3000_Dt(unique_index);
CR3000_H2OFlow_LPM_Avg=CR3000_H2OFlow_LPM_Avg(unique_index);
CR3000_Latitude_dec=CR3000_Latitude_dec(unique_index);
CR3000_Longitude_dec=CR3000_Longitude_dec(unique_index);
CR3000_pH_temp_Avg=CR3000_pH_temp_Avg(unique_index);
CR3000_pH_Avg=CR3000_pH_Avg(unique_index);
CR3000_pH_V_Avg=CR3000_pH_V_Avg(unique_index);
CR3000_PTemp_Avg=CR3000_PTemp_Avg(unique_index);

[~, unique_index2]=unique(CR3000_Dt_tempa);
CR3000_Dt_tempa=CR3000_Dt_tempa(unique_index2);
CR3000_SurfT_C_Avg=CR3000_SurfT_C_Avg(unique_index2);

[~, unique_index3]=unique(CR3000_Dt_tempb);
CR3000_Dt_tempb=CR3000_Dt_tempb(unique_index3);
CR3000_WaterT_C_Avg=CR3000_WaterT_C_Avg(unique_index3);


%interp to same length as other variables
Flowrate= interp1(CR3000_Dt,CR3000_H2OFlow_LPM_Avg,Dt); %interpolate onto pco2 time
Latitude= interp1(CR3000_Dt,CR3000_Latitude_dec,Dt); %interpolate onto pco2 time
Longitude= interp1(CR3000_Dt,CR3000_Longitude_dec,Dt); %interpolate onto pco2 time
ph_temp= interp1(CR3000_Dt,CR3000_pH_temp_Avg,Dt); %interpolate onto pco2 time
ph_avg= interp1(CR3000_Dt,CR3000_pH_Avg,Dt); %interpolate onto pco2 time
ph_volt= interp1(CR3000_Dt,CR3000_pH_V_Avg,Dt); %interpolate onto pco2 time
pcr300_temp= interp1(CR3000_Dt,CR3000_PTemp_Avg,Dt); %interpolate onto pco2 time

%temperatures cut out more didn't want to remove more temp data then necessary
[row4, ~] = find(isnan(CR3000_SurfT_C_Avg));
CR3000_Dt_tempa(row4)=[];
CR3000_SurfT_C_Avg(row4)=[];
Skin_temp= interp1(CR3000_Dt_tempa,CR3000_SurfT_C_Avg,Dt); %interpolate onto pco2 time

[row5, ~] = find(isnan(CR3000_WaterT_C_Avg));
CR3000_Dt_tempb(row5)=[];
CR3000_WaterT_C_Avg(row5)=[];
Sea_temp= interp1(CR3000_Dt_tempb,CR3000_WaterT_C_Avg,Dt); %interpolate onto pco2 time



clearvars CR3000_TIMESTAMP filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;
clearvars calarray h20_abs Index Index2 IndexC Std1 Std2 Std3 x y col CR3000_Dt CR3000_Dt_Ph CR3000_H2OFlow_LPM_Avg CR3000_Latitude CR3000_Longitude CR3000_pH_Avg CR3000_pH_temp_Avg CR3000_pH_V_Avg CR3000_WaterT_C_Avg_new dupRows ia ic length_ent nanrowsunq


clearvars unique_index unique_index2 unique_index3 CR3000_Latitude_dec CR3000_Longitude_dec lat_deg lat_min lat_sec lon_deg lon_min lon_sec CR3000_Dt_tempa CR3000_Dt_tempb CR3000_PTemp_Avg CR3000_SurfT_C_Avg CR3000_WaterT_C_Avg col nanrows row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12 row13 row14 row15 row16 row17 row18 row19 row20 row21

cd (mfileDir)
save('2018_und.mat')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FURTHER QC, CALIBRATIONS AND CORRECTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Code to do corrections and calculate fluxes
n_records=(1:length(Dt))';
[ind_co2_meas, ~]=find(Valvepos==1);
[ind_co2_atm, ~]=find(Valvepos==2);
[ind_co2_samp1, ~]=find(Valvepos==3);
[ind_co2_samp2, ~]=find(Valvepos==4);
[ind_co2_samp3, ~]=find(Valvepos==5);
[ind_co2_samp, ~]=find((Valvepos==3)| (Valvepos==4) | (Valvepos==5));

%break the calibration runs into chunks- important to code this as the
%calibration run times vary between years
%this gives the indexes of where a new calibration run starts! as in it has
%cycled through 3,4,5 then the the next calibration run 3,4,5 starts at index c 
c=find(diff(ind_co2_samp) ~= 1) + 1;

%diagnostic 
datevec(Dt(ind_co2_samp(c)))

figure(1)
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
plot(Dt(ind_co2_atm),CO2_ppm(ind_co2_atm),'g*');
plot(Dt(ind_co2_samp1),CO2_ppm(ind_co2_samp1),'r*');
% plot(Dt(ind_co2_samp1_end),CO2_ppm(ind_co2_samp1_end),'m*');
plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'rs');
% plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
dynamicDateTicks([], [], ' mm/dd');
legend('xco2','atm co2','std1','std2')
title('FIG 1 - NO QC Berg pCO2 data')
% this code finds the stanards and can move the first couple of points-
% this has been replaced by better code below

%also plot temp and salinity for bad data
figure(11)
plot(Dt(ind_co2_meas),TSG_s(ind_co2_meas),'*');
dynamicDateTicks([], [], ' mm/dd');

figure(12)
plot(Dt(ind_co2_meas),Temp_c(ind_co2_meas),'*');
dynamicDateTicks([], [], ' mm/dd');


%Samples after standards - remove first 7 points
c_meas=find(diff(ind_co2_meas) ~= 1) + 1;
for i=1:length(c_meas)-1;
    CO2_ppm(ind_co2_meas(c_meas(i)-1:c_meas(i)+7))=nan;
end


%find where standard 2 has now flushed and has the old standard/atmosphere
[stdfiltind,~ ]=find(CO2_ppm(ind_co2_samp2)<500);
std_make_nan=ind_co2_samp2(stdfiltind);
CO2_ppm(std_make_nan)=nan;




%locate all standards of std2 in a subset of the data
%then get index of the last point when the standard has properly flushed
%through
ind_co2_samp2_final=[];
ind_co2_samp2_flushing=[];
v=1:100:length(CO2_ppm);
for f=1:length(v)-1;
[p, ~]=find(ind_co2_samp2>v(f) & ind_co2_samp2<v(f+1));
if ~(isnan(p))
ind_co2_samp2_final=[ind_co2_samp2_final;p(end)];
ind_co2_samp2_flushing=[ind_co2_samp2_flushing;p(1:end-1)];
else
end
end
ind_co2_samp2_end=ind_co2_samp2(ind_co2_samp2_final);
ind_co2_samp2_flush=ind_co2_samp2(ind_co2_samp2_flushing);

%remove double standard here
[t , ~]=find(ind_co2_samp2==12999);
ind_co2_samp2(t)=[];

%instrument reading negative values - remove these
[negind,~ ]=find(CO2_ppm<-100);
CO2_ppm(negind)=nan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVE DATA WITHOUT STANDARDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%remove junk where there are no calibrations or between system off
temp_cutoutsrt= datenum('2018-07-31 00:09:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2018-07-31 22:10:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove junk where there are no calibrations or between system off
temp_cutoutsrt= datenum('2018-08-01 13:11:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2018-08-01 23:11:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove junk where there are no calibrations or between system off
temp_cutoutsrt= datenum('2018-08-02 10:00:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2018-08-02 10:29:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove junk where there are no calibrations or between system off
temp_cutoutsrt= datenum('2018-08-03 17:09:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2018-08-03 17:14:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove junk where there are no calibrations or between system off
temp_cutoutsrt= datenum('2018-08-06 09:19:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2018-08-07 01:24:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;


%remove junk where there are no calibrations or between system off
temp_cutoutsrt= datenum('2018-08-08 07:17:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2018-08-17 11:41:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove junk where there are no calibrations or between system off
temp_cutoutsrt= datenum('2018-08-06 00:49:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2018-08-06 01:05:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

clearvars tempbackind tmp2 tmp tempoutind temp_cutoutend temp_cutoutsrt

%manually pick out indexes of  pco2 to remove that are clear outliers
CO2_ppm(ind_co2_meas([2845:2849 4789:4795 4987:4999 5948:5952 6630 7604 8567 8643 8709 8719 8760 9341:9345 10987:11000 12418:12423 13711:13716 14126:14127]))=nan;

figure(2)
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
plot(Dt(ind_co2_atm),CO2_ppm(ind_co2_atm),'g*');
plot(Dt(ind_co2_samp1),CO2_ppm(ind_co2_samp1),'r*');
% plot(Dt(ind_co2_samp1_end),CO2_ppm(ind_co2_samp1_end),'m*');
plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'rs');
% plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
dynamicDateTicks([], [], ' mm/dd');
legend('xco2','atm co2','std1','std2')
title('FIGURE 2 - OUTLIERS QC Berg pCO2 data')

%now remove the standards when the system is being flushed and atmospheric
%CO2
CO2_ppm(ind_co2_atm)=nan;
CO2_ppm(ind_co2_samp1)=nan;
CO2_ppm(ind_co2_samp2_flush)=nan;
clearvars ans c f i c_meas p tempbackind tempoutind temp_cutoutend temp_cutoutsrt v

%to avoid no calibration at the end make the last point a standard with the
%same value
ind_co2_samp2_end=[ind_co2_samp2_end;14946];
CO2_ppm(14946)=579.15;

%ignore the nans otehrwise this ruins the calibration!
b=~(isnan(CO2_ppm(ind_co2_samp2_end)));
ind_co2_samp2_end=ind_co2_samp2_end(b);

figure(3)
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
% plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'b*');
plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
dynamicDateTicks([], [], ' mm/dd');
legend('xco2','std2')
title('FIGURE 3 - OUTLIERS QC + final standard point only Berg pCO2 data')

for labelcat=1:length(ind_co2_samp2_end);
labelpoints(Dt(ind_co2_samp2_end(labelcat)),CO2_ppm(ind_co2_samp2_end(labelcat)),([num2str((labelcat),'%10.1f')]),'color','b','Fontsize',5,'Fontweight','bold','BackgroundColor','none')
end

dynamicDateTicks([], [], ' mm/dd');


%super co2 records as pCO2 but we want xco2 for water vapour correction
Berg18_co2_CO2umm=CO2_ppm./(Cell_p*0.00986923);
Berg18_co2_dt=Dt;

% main loop to do the calibrations here
% for every interval between standards
% loop through and calibrate between this and the next set of standards
    Berg18_co2_CO2umm_cal=[];
    for z=1:(length(ind_co2_samp2_end)-1); %for each set of standards
        calstart_STD2Ind = ind_co2_samp2_end(z);
        calend_STD2Ind = ind_co2_samp2_end(z+1);
    for y=calstart_STD2Ind+1:calend_STD2Ind-1; % for the number of measurements between standards
    %from dickson 2007 p 100
    interpolatedstd2=Berg18_co2_CO2umm(calstart_STD2Ind)+(((Berg18_co2_CO2umm(calend_STD2Ind)-Berg18_co2_CO2umm(calstart_STD2Ind)).*(( (Berg18_co2_dt(y)) -(Berg18_co2_dt(calstart_STD2Ind)))./(Berg18_co2_dt(calend_STD2Ind)-Berg18_co2_dt(calstart_STD2Ind)))));
    interpolatedvec=[interpolatedstd2];
    truestd=[566.4];
    %calculate the linear fit for each data point
    c = polyfit(interpolatedvec,truestd,1);
    slopes=c(1);
    intercept=c(2);
    Berg18_co2_CO2umm_cal(y)=(Berg18_co2_CO2umm(y).*slopes)+intercept; 
    end
    end
    
    Berg18_co2_CO2umm_cal=Berg18_co2_CO2umm_cal';
    %pad out the end of the matrix with NaN where there wasn't a standard at the end
    Berg18_co2_CO2umm_cal(14936:14947)=NaN;

    
figure(4)
plot(Berg18_co2_dt(ind_co2_meas),Berg18_co2_CO2umm(ind_co2_meas),'bo');
hold on
plot(Berg18_co2_dt(ind_co2_samp2_end),Berg18_co2_CO2umm(ind_co2_samp2_end),'ms');
plot(Berg18_co2_dt(ind_co2_meas),Berg18_co2_CO2umm_cal(ind_co2_meas),'ko');
legend('xco2' ,'std1', 'std2', 'xco2cal')
title('FIGURE 4 - QC plus standard calibration - Berg pCO2 data')
dynamicDateTicks([], [], ' mm/dd');

%remove calibrations from the co2 matrix
Berg18_co2_CO2umm_cal(ind_co2_atm)=NaN;
Berg18_co2_CO2umm_cal(ind_co2_samp1)=NaN;
Berg18_co2_CO2umm_cal(ind_co2_samp2)=NaN;
Berg18_co2_CO2umm_cal(ind_co2_samp2_end)=NaN;

%outliers at beggining where pressure is 0!!
Berg18_co2_CO2umm_cal(1:4)=nan;

%final xCO2 data
figure(41)
plot(Berg18_co2_dt,Berg18_co2_CO2umm_cal,'ko');




%cross correlate temp from CTD 
%load in Bergmann matlab CTD structure 

load('C:\Users\rps207\Documents\MATLAB\2019 - Bergmann carbonate transects 2016-2019/Bergmann.mat','Berg')

CTD_casts_2018=fieldnames(Berg.year_2018); %names of the stations
CTD_casts_2018=CTD_casts_2018(1:end-3); %R1,G2,G4 bad or not completed casts!

CTD_TEMP_0_5m=[];CTD_TEMP_1m=[];CTD_TEMP_1_5m=[];CTD_TEMP_2m=[];CTD_DEPTH_1m=[];CTD_DT_1m=[];
CTD_SAL_0_5m=[];CTD_SAL_1m=[];CTD_SAL_1_5m=[];CTD_SAL_2m=[];

for w=1:numel(CTD_casts_2018); 
        ghj = Berg.year_2018.([CTD_casts_2018{w}']); 
        [~, f]=size(ghj);
        for h=1:f
        %these are binned
        CTDtemp_0_5m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Temp_dwncst_intp(5);
        CTDtemp_1m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Temp_dwncst_intp(10);
        CTDtemp_1_5m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Temp_dwncst_intp(15);
        CTDtemp_2m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Temp_dwncst_intp(20);

        
        CTDsal_0_5m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Sal_dwncst_intp(5);
        CTDsal_1m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Sal_dwncst_intp(10);
        CTDsal_1_5m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Sal_dwncst_intp(15);
        CTDsal_2m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Sal_dwncst_intp(20);

        CTDdepth_1m=Berg.year_2018.([CTD_casts_2018{w}'])(h).Depth_dwncst_intp(10);
        %this time is not super accurate (+/- a couple mins max) but is fine for this 
        CTDdt_1m=datenum(Berg.year_2018.([CTD_casts_2018{w}'])(h).DT_str(end),'dd-mmm-yyyy HH:MM:SS');
        
        CTD_TEMP_0_5m=[CTD_TEMP_0_5m,CTDtemp_0_5m];
        CTD_TEMP_1m=[CTD_TEMP_1m,CTDtemp_1m];
        CTD_TEMP_1_5m=[CTD_TEMP_1_5m,CTDtemp_1_5m];
        CTD_TEMP_2m=[CTD_TEMP_2m,CTDtemp_2m];
        
        CTD_SAL_0_5m=[CTD_SAL_0_5m,CTDsal_0_5m];
        CTD_SAL_1m=[CTD_SAL_1m,CTDsal_1m];
        CTD_SAL_1_5m=[CTD_SAL_1_5m,CTDsal_1_5m];
        CTD_SAL_2m=[CTD_SAL_2m,CTDsal_2m];
        
        CTD_DEPTH_1m=[CTD_DEPTH_1m,CTDdepth_1m];
        CTD_DT_1m=[CTD_DT_1m,CTDdt_1m];
        end
end

temp_matchup_tsg=[]; temp_matchup=[];sal_matchup=[];
for b=1:length(CTD_DT_1m);
[n m]=min(abs(CTD_DT_1m(b)-Berg18_co2_dt));
%if there is no temp data within that 10mins ignore! 
if n>1/24*6;
    n=nan;
else    
end
temp_matchup_tsg=[temp_matchup_tsg,TSG_t(m)];
temp_matchup=[temp_matchup,Temp_c(m)];

sal_matchup=[sal_matchup,TSG_s(m)];
% temp_matchup=[temp_matchup,tmp(m)];

end

l=~(isnan(CTD_TEMP_1m));
c = polyfit(temp_matchup(l),CTD_TEMP_1m(l),1)

temp_corrected=(temp_matchup(l)*c(1))+c(2);

C1 = sqrt(mean(((temp_corrected- CTD_TEMP_1m(l)).^2))) %RMSE =     0.64
%exp(0.0423*0.64)=1.0209 - 2.09% difference



save4plot_equ2018=temp_matchup(l);
save4plot_ros2018=CTD_TEMP_1m(l);
save('2018_temp_cal.mat','save4plot_equ2018','save4plot_ros2018');
 
figure(5)
plot(CTD_TEMP_0_5m,temp_matchup,'k*')
hold on
plot(CTD_TEMP_0_5m,temp_matchup_tsg,'r*')
plot(CTD_TEMP_0_5m,(temp_matchup*c(1))+c(2),'b*')
plot (1:0.1:8,1:0.1:8,'k')
xlabel('rosette')
ylabel('underway')
xlim([0 8])
ylim([0 8])
legend('temp c','tsg','temp c corrected','1:1 line')

figure(51)
plot(CTD_TEMP_0_5m,temp_matchup,'m*')
hold on
plot(CTD_TEMP_1m,temp_matchup,'k*')
plot(CTD_TEMP_1_5m,temp_matchup,'b*')
plot(CTD_TEMP_2m,temp_matchup,'g*')
% plot(CTD_TEMP_1m,(temp_matchup*c(1))+c(2),'b*')
plot (1:0.1:12,1:0.1:12,'k')
xlabel('rosette')
ylabel('underway')
xlim([0 12])
ylim([0 12])
legend('Location','SouthEast','temp 0.5m','temp 1m','temp 1.5m','temp 2m','1:1 line');
title('ctd depths vs equ temp')


 l=~(isnan(CTD_SAL_0_5m));
 l(19)=l(20);% this is an outlier
 e = polyfit(sal_matchup(l),CTD_SAL_0_5m(l),1);
 
%no salinity corrected required
figure(6)
k=~(isnan(CTD_SAL_0_5m));
plot(CTD_SAL_0_5m(k),sal_matchup(k),'m*');
hold on
plot(CTD_SAL_1m(l),sal_matchup(l),'k*');
n=~(isnan(CTD_SAL_1_5m));
plot(CTD_SAL_1_5m(n),sal_matchup(n),'b*');
m=~(isnan(CTD_SAL_2m));
plot(CTD_SAL_2m(m),sal_matchup(m),'g*');
% plot(CTD_SAL_1m(l),(sal_matchup(l)*e(1))+e(2),'b*')
plot (25:0.1:30,25:0.1:30,'k');
xlabel('rosette sal');
ylabel('underway sal');
xlim([25 30]);
ylim([25 30]);
legend('Location','SouthEast','sal 0.5m','sal 1m','sal 1.5m','sal 2m','1:1 line');

figure(7)
plot(TSG_t,'k*')
hold on
plot(Temp_c,'r*')
plot(Temp_v,'b*')
legend('TSG t','Temp c','Temp v');
ylabel('Temp')
xlabel('Measurement number')
% plot(Sea_temp,'g*')
% plot(Skin_temp,'y*')


%where co2 is nan make the other variables nan
b=(isnan(Berg18_co2_CO2umm_cal));

Temp_c(b)=nan;
Longitude(b)=nan;
Latitude(b)=nan;
Flowrate(b)=nan;
H20_ppt(b)=nan;
Chl(b)=nan;
Flour(b)=nan;
Cell_p(b)=nan;
Cell_t(b)=nan;
TSG_t(b)=nan;
TSG_s(b)=nan;
Scatter(b)=nan;
Pres_kpa(b)=nan;
ph_temp(b)=nan;
ph_avg(b)=nan;
pcr300_temp(b)=nan;
Skin_temp(b)=nan;
Sea_temp(b)=nan;


% This is corrected SST from equilibrator temp.
Berg18_co2_equtemp=Temp_c;
Berg18_co2_SST_1m=(Temp_c*c(1))+c(2);
%other variables
Berg18_co2_Longitude=Longitude;
Berg18_co2_Latitude=Latitude;
Berg18_co2_Flowrate=Flowrate;
Berg18_co2_H20_ppt=H20_ppt;
Berg18_co2_Chl=Chl;
Berg18_co2_Flour=Flour;
Berg18_co2_Cell_p=Cell_p;
Berg18_co2_Cell_t=Cell_t;
Berg18_co2_TSG_t=TSG_t;
Berg18_co2_TSG_s=TSG_s;
Berg18_co2_Scatter=Scatter;
Berg18_co2_Pres_kpa=Pres_kpa;

%these all seem to have bad data so will make them all nans here
Berg18_co2_ph_temp=nan(length(Berg18_co2_TSG_t),1);%bad
Berg18_co2_ph_avg=nan(length(Berg18_co2_TSG_t),1);%bad
Berg18_co2_pcr300_temp=nan(length(Berg18_co2_TSG_t),1);%bad
Berg18_co2_Skin_temp=nan(length(Berg18_co2_TSG_t),1); %bad
Berg18_co2_Sea_temp=nan(length(Berg18_co2_TSG_t),1);%bad

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%     CO2 calculations  Part 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %use Wagner and garb 2002 to get water vapour
    Berg18_co2_equtemp_kelvin=Berg18_co2_equtemp +273.15; %convert temperature into kelvin
    temp_mod = 1-Berg18_co2_equtemp_kelvin./647.096;
    vapor_0sal_kPa=(22.064e3)*(exp((647.076./(Berg18_co2_equtemp_kelvin)).*((-7.85951783*temp_mod)+((1.84408259)*(temp_mod.^(3/2)))+(-11.7866497*(temp_mod.^3))+(22.6807411*(temp_mod.^3.5))+(-15.9618719*(temp_mod.^4))+(1.80122502*(temp_mod.^7.5)))));
    %Correct vapor pressure for salinity
    molality = 31.998 * Berg18_co2_TSG_s ./(1e3-1.005*Berg18_co2_TSG_s);
    osmotic_coef = 0.90799 -0.08992*(0.5*molality) +0.18458*(0.5*molality).^2 -0.07395*(0.5*molality).^3 -0.00221*(0.5*molality).^4;
    vapor_press_kPa = vapor_0sal_kPa .* exp(-0.018 * osmotic_coef .* molality);
    Vapour_pressure_mbar = 10*(vapor_press_kPa);%Convert to mbar
    Vapour_pressure_atm=0.0098692327 .*Vapour_pressure_mbar;%convert to atm 1 millibar = 0.000986923267 atmosphere


    %add woolf 2016/2019 corrections for skin to salinity and temp
   Berg18_co2_SST_1m=Berg18_co2_SST_1m-0.17;
   Berg18_co2_TSG_s=Berg18_co2_TSG_s+0.1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%     CO2 calculations  Part 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %use pressure from pco2 system
    Berg18_co2_Pres_mbar = 10*(Berg18_co2_Pres_kpa);%Convert to mbar
    Berg18_co2_Pres_atm= Berg18_co2_Pres_mbar *0.000986923; %convert from mb to atm
    Berg18_co2_Pres_pa= Berg18_co2_Pres_mbar *100; %convert from mb to pa

    Berg18_co2_LicorpCO2= Berg18_co2_CO2umm_cal.*(Berg18_co2_Pres_atm - Vapour_pressure_atm);%Correction for water vapour pressure as described in (dickson(2007)-section 8.5.3 TO GET PCO2
    BCO2te= -1636.75 + (12.0408*(Berg18_co2_equtemp_kelvin)) - (3.27957*0.01*(Berg18_co2_equtemp_kelvin).^2) + (3.16528*0.00001*(Berg18_co2_equtemp_kelvin).^3);%units of cm^3 mol^-1 ,determine the two viral coefficents of co2, (Dickson 2007) SOP 24 and p98 section 8.3 use equilibrator_pressure and equilibrator_temperature
    deltaCO2te= 57.7 - 0.118*( Berg18_co2_equtemp_kelvin); %units of cm^3 mol^-1
    R=8.31447; %specific gas constant J/Mol*K
    Berg18_co2_fco2= Berg18_co2_LicorpCO2.*exp(((BCO2te+(2*deltaCO2te))*0.000001.*(Berg18_co2_Pres_pa))./(R *Berg18_co2_equtemp_kelvin));%use viral coefficents to determine fco2
    Berg18_co2_fco2_surface=Berg18_co2_fco2.*exp(0.0423*(Berg18_co2_SST_1m - Berg18_co2_equtemp));%correction of co2 to sea surface temperature , (Dickson 2007) p98 8.4
    
    Berg18_co2_pco2_surface=Berg18_co2_LicorpCO2.*exp(0.0423*(Berg18_co2_SST_1m - Berg18_co2_equtemp));%correction of co2 to sea surface temperature , (Dickson 2007) p98 8.4


%%%%%%%%%%%%%%%%
% FLUX 2018
%%%%%%%%%%%%%%%%

%load in U10 island data from Brian
load('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/wind_data_rich.mat');
Tower_ts=timestamp;
Tower_u10=U10; 
Tower_u10n=U10n;
Tower_ws_avg=ws_avg; 
Tower_ws=ws;
clearvars timestamp U10 U10n ws_avg ws

%plot to check the data
plot(Tower_ts,Tower_u10)
dynamicDateTicks([], [], 'mm/dd');

%interp wind onto Bergmann timestamp data
Berg18_co2_u10=interp1(Tower_ts,Tower_u10,Berg18_co2_dt);

%import ATMOSPHERIC CO2 from Barrow Alaska
filename = 'C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2\co2_brw_surface-insitu_1_ccgg_HourlyData.txt';
delimiter = ' ';
startRow = 158;
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
% site_code = dataArray{:, 1};
year = dataArray{:, 2};
month = dataArray{:, 3};
day = dataArray{:, 4};
hour = dataArray{:, 5};
minute = dataArray{:, 6};
second = dataArray{:, 7};
% time_decimal = dataArray{:, 8};
Barrow_pco2 = dataArray{:, 9};
% pco2_std_dev = dataArray{:, 10};
% value_unc = dataArray{:, 11};
% nvalue = dataArray{:, 12};
% latitude = dataArray{:, 13};
% longitude = dataArray{:, 14};
% altitude = dataArray{:, 15};
% elevation = dataArray{:, 16};
% intake_height = dataArray{:, 17};
% instrument = dataArray{:, 18};
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
a=char(year);ar=str2num(a);a=num2str(ar,'%04.f');
b=char(month);as=str2num(b);b=num2str(as,'%02.f');
c=char(day);af=str2num(c);c=num2str(af,'%02.f'); 
d=char(hour);ag=str2num(d);d=num2str(ag,'%02.f'); 
e=char(minute);ah=str2num(e);e=num2str(ah,'%02.f'); 
f=char(second);ai=str2num(f);f=num2str(ai,'%02.f'); 
z=[a,b,c,d,e,f];
Barrow_DT=datenum(z,'yyyymmddHHMMSS');

Barrow_pco2 = str2double(Barrow_pco2);
[p , ~]=find (Barrow_pco2==-999.9900);
Barrow_pco2(p)=NaN;
%interp atmco2 onto Bergmann timestamp data
Berg18_co2_atmCO2=interp1(Barrow_DT,Barrow_pco2,Berg18_co2_dt);
clearvars a b c d e f z ans day month hour minute year second ar ai as ah ag af Barrow_DT Barrow_pco2


 %inputs
 u10=Berg18_co2_u10;% wind speed m/s
 T=Berg18_co2_SST_1m;%temperature in degrees celsius (-0.17 degrees for the skin inclusive above)
 deltaCO2=Berg18_co2_pco2_surface-Berg18_co2_atmCO2; % in micro atm, this is (sea-air) where negative flux is into ocean
 Tk=T+273.15; %temperature in kelvin (-0.17 degrees for the skin)
 S=Berg18_co2_TSG_s;%salinity (plus 0.1 psu for the skin inclusive above)
 
 %equations
 k660=((0.222*(u10.^2)) +(0.333*u10));%from nightingale 2000
 
 %Sc dimensionless schmidt number - Wannikhof 2014
 A=2116.8;
 B=-136.25;
 C=4.7353;
 D=-0.092307;
 E=0.0007555;
 Sc = A + (B*T) + (C*T.^2) + (D*T.^3) + (E*T.^4); %(T in °C).
%  Sc=(2073.1 -(125.62*T) + (3.6276*(T^2)) - (0.04321*(T^3)));%from wannikhoif 1992 - for seawater
 Schdep=(Sc/660).^-0.5; % wannikhof 2014 
 Kw=Schdep.*k660;%k with units of cm hr-1
 
 %K0 with units(mol l-1 atm-1) weiss 1974
 %ln ? = ?1 + ?2 (100/?) + A3 ln (T/100) + S [(B1 + B2(T/100) + B3 (T/100)2]
 A1=-58.0931;
 A2=90.5069;
 A3=22.2940;
 B1=0.027766;
 B2=-0.025888; 
 B3=0.0050578; 
 k0=exp(A1+ (A2.*(100./Tk)) + (A3.*log(Tk./100)) +(S.*(B1 + (B2.*(Tk/100)) + (B3.*((Tk/100).^2)))));%PER LITRE

 scal1=(1/100)*24; %scaling Kw from cm hr-1 to m d-1
 %FLUX
 % Kw - units of cm hr-1 -> with scaling becomes m d-1
 %delta pco2 - u atm (micro atmospheres)
 %k0 - units of mol l-1 atm-1
 % units are then [ m d-1 u atm mol l-1 atm-1] ->  [   mmol m-2 d-1]
 Berg18_co2_FCO2_mmol_per_m2_per_d=Kw.*k0.*deltaCO2.*scal1; %Units of mmol m-2 d-1

 figure(891)
 scatter(Berg18_co2_Longitude,Berg18_co2_Latitude,10,Berg18_co2_dt)
 colorbar
 cbdate
 
figure(41)
subplot(2,1,1)
plot(Berg18_co2_dt,Berg18_co2_CO2umm_cal,'ko');
subplot(2,1,2)
plot(Berg18_co2_dt,Berg18_co2_Latitude,'ko');
 

 % ==================================================================== %
 % Get AMSR Sea ice concentration
 % ==================================================================== %
    
 %load AMSR grid
grid_fname=('C:\Users\rps207\Documents\Data\Sea ice\ASMR2 - 3.125km\LongitudeLatitudeGrid-n3125-Arctic3125.hdf');
grid_fileinfo = hdfinfo(grid_fname);
grid_lat = hdfread(grid_fname,'Latitudes');
grid_long_0_360 = hdfread(grid_fname,'Longitudes');
grid_long=wrapTo180(grid_long_0_360);
clear grid_long_0_360

days_since_ice=[]; 
 %sea ice
 days_since_ice=nan(1,length(Berg18_co2_dt));
 Berg_year=char('2018');
 
 for ice_loop=1:length(Berg18_co2_dt)
 
 %first open the first file and find the closest point    

 %get the date info and open appropriate satellite data
 [year_ice,month_ice,day_ice,~,~,~]=datevec(Berg18_co2_dt(ice_loop));
 %loop through folders to find files
 months_names= char({'jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec'});
 %locate the appropriate daily file based on month and day
 grid_ice_conc = hdfread(char({['C:\Users\rps207\Documents\Data\Sea ice\ASMR2 - 3.125km\' Berg_year '\' months_names(month_ice,:) '\Arctic3125\asi-AMSR2-n3125-' Berg_year sprintf('%02d',month_ice) sprintf('%02d',day_ice) '-v5.4.hdf']}),'ASI Ice Concentration'); %read file
 %for each loop get lat and long to match
 ice_find_lat=Berg18_co2_Latitude(ice_loop);
 ice_find_long=Berg18_co2_Longitude(ice_loop);
 %find nearest location and the sea ice for that
 [ice_column,ice_row] =find(grid_long>-112 & grid_long<-95  & grid_lat>65 & grid_lat<70); %subset for Kitikmeot sea
 
 %this is not the whole lot just the subset with range above
 grid_lat_subset=[];grid_long_subset=[]; grid_ice_conc_subset=[];
 for subset1=1:length(ice_row);
     grid_lat_subset(subset1)=grid_lat(ice_column(subset1),ice_row(subset1));
     grid_long_subset(subset1)=grid_long(ice_column(subset1),ice_row(subset1));
     grid_ice_conc_subset(subset1)=grid_ice_conc(ice_column(subset1),ice_row(subset1));
 end
 
 %find distance from every point in the grid
 for subset=1:length(grid_ice_conc_subset);
     dist(subset) = pos2dist(ice_find_lat,ice_find_long,grid_lat_subset(subset),grid_long_subset(subset),2);
 end
 
 validIndices = ~isnan(grid_ice_conc_subset);
 [value_valid,index_valid]=min(dist(validIndices));
 indexs_nonan=find(validIndices==1);
 iceindex=indexs_nonan(index_valid);
 %iceindex is the closest point on the subgrid
 
 
 %need to load in the from May 1st to now
 
 %find the indexes in the full grid 3584 x2432
 full_index_col=ice_column(iceindex);
 full_index_row=ice_row(iceindex);
 
 %these are the closest points on the grid
  grid_long(full_index_col,full_index_row);
  grid_lat(full_index_col,full_index_row);

 site_ice_conc_each_day=[];
 %find distance from every point in the grid
 for month_ice_loop=1:length(months_names); %every month
     rootdir=(['C:\Users\rps207\Documents\Data\Sea ice\ASMR2 - 3.125km\' Berg_year '\' months_names(month_ice_loop,:) '\Arctic3125\']);
     %this is a change from Brian as Listfiles does not work for me!
     fListStruct=rdir([rootdir, '\**\*.hdf'], '');
     filelist_all_char = char({fListStruct.name}); %convert to character
     filelist_all_str=cellstr(filelist_all_char); %convert to string
     [IndexC]=strfind(filelist_all_str,'v5.4'); %search for text segment
     idxEmpty = cellfun('isempty',IndexC);
     posNonEmpty = find(~idxEmpty); %indexes of non empty
     filelist=filelist_all_char(posNonEmpty,:);
     [m , n]=size(filelist);
     for amsr_day=1:m
         grid_ice_conc = hdfread(filelist(amsr_day,:),'ASI Ice Concentration','Index',{[full_index_col full_index_row],[],[1 1]}); %read file
         site_ice_conc_each_day=[site_ice_conc_each_day;grid_ice_conc];
     end
 end
 
site_ice_conc_each_day(1)=100;
site_ice_conc_each_day(end)=100;

nanx = isnan(site_ice_conc_each_day);
t    = 1:numel(site_ice_conc_each_day);
site_ice_conc_each_day(nanx) = interp1(t(~nanx), site_ice_conc_each_day(~nanx), t(nanx));


%calculate smoothed matrix
f = fit((1:numel(site_ice_conc_each_day))',site_ice_conc_each_day,'smoothingspline','SmoothingParam',0.004);
coeffvals= coeffvalues(f);
x=coeffvals.coefs(:,4);

% %smooth further to dampen noise from the outliers
% u=smooth(x,140);

% figure(45)
% plot(site_ice_conc_each_day,'*');
% hold on
% plot(x,'r-')
% fixplot1('%1.8f')
% plot(u,'y-');

close all
[y, l]=findpeaks(x,'MINPEAKHEIGHT',80);
[~, d]=minpositive(220-l);
l(d);%this is day of year from which sea ice starts to decline 

[fff, ~]=find(x<85);%find values below 85% sea ice

[gg, ggg]=minpositive(fff-l(d));
doy_ice_sub85=fff(ggg);%this is the day when it drops below 85%
doy_sample = Berg18_co2_dt(ice_loop) - datenum(str2num(Berg_year),1,1) + 1;%sample collected on

days_since_ice(ice_loop)=doy_sample-doy_ice_sub85;
ice_loop
 end
Berg18_days_since_ice=days_since_ice';



 clearvars  l molality osmotic_coef temp_mod vapor_0sal_kPa
clearvars c d e temp_matchup_tsg temp_matchup sal_matchup CTDtemp_1m CTDsal_1m CTDdt_1m CTDdepth_1m CTD_TEMP_1m CTD_SAL_1m CTD_DT_1m CTD_DEPTH_1m CTD_casts_2018 Berg
clearvars Latitude Longitude n_records Flowrate H20_ppt Chl CO2_ppm Dt Dt_doy Flour Cell_p Cell_t TSG_t TSG_s Temp_v Temp_c Skin_temp Sea_temp Scatter Pres_v Pres_kpa ph_volt ph_temp ph_avg pcr300_temp
clearvars ind_co2_meas ind_co2_samp negind y z Valvepos truestd slopes calend_STD2Ind calstart_STD2Ind ind_co2_atm ind_co2_samp1 ind_co2_samp2 ind_co2_samp2_end ind_co2_samp2_final ind_co2_samp2_flush ind_co2_samp2_flushing ind_co2_samp3 intercept interpolatedstd2 interpolatedvec l std_make_nan stdfiltind t
clearvars w ghj f h n m b
clearvars ans labelcat CTD_SAL_0_5m CTD_SAL_1_5m CTD_SAL_2m CTD_TEMP_0_5m CTD_TEMP_1_5m CTD_TEMP_2m CTDsal_0_5m CTDsal_1_5m CTDsal_2m CTDtemp_0_5m CTDtemp_1_5m CTDtemp_2m k labelcatans b  BCO2te deltaCO2te mfileDir path_cr300 path_eco path_pco2 path_tsg R TSG_e vapor_press_kPa Vapour_pressure_atm Vapour_pressure_mbar
clearvars A A1 A2 A3 AA aaa B B1 B2 B3 bbb deltaCO2 C D E k0 k660 Kw NM numind p S Sc scal1 Schdep T Tk Tower_ts Tower_u10 Tower_u10n Tower_ws Tower_ws_avg u10 vb

%GPS signal goes weird on way back from Bathurst- remove these
Berg18_co2_atmCO2(3700:6500)=nan;
Berg18_co2_Cell_p(3700:6500)=nan;
Berg18_co2_Cell_t(3700:6500)=nan;
Berg18_co2_Chl(3700:6500)=nan;
Berg18_co2_CO2umm(3700:6500)=nan;
Berg18_co2_CO2umm_cal(3700:6500)=nan;
Berg18_co2_dt(3700:6500)=nan;
Berg18_co2_equtemp(3700:6500)=nan;
Berg18_co2_equtemp_kelvin(3700:6500)=nan;
Berg18_co2_fco2(3700:6500)=nan;
Berg18_co2_FCO2_mmol_per_m2_per_d(3700:6500)=nan;
Berg18_co2_fco2_surface(3700:6500)=nan;
Berg18_co2_Flour(3700:6500)=nan;
Berg18_co2_Flowrate(3700:6500)=nan;
Berg18_co2_H20_ppt(3700:6500)=nan;
Berg18_co2_Latitude(3700:6500)=nan;
Berg18_co2_LicorpCO2(3700:6500)=nan;
Berg18_co2_Longitude(3700:6500)=nan;
Berg18_co2_pco2_surface(3700:6500)=nan;
Berg18_co2_pcr300_temp(3700:6500)=nan;
Berg18_co2_ph_avg(3700:6500)=nan;
Berg18_co2_ph_temp(3700:6500)=nan;
Berg18_co2_Pres_atm(3700:6500)=nan;
Berg18_co2_Pres_kpa(3700:6500)=nan;
Berg18_co2_Pres_mbar(3700:6500)=nan;
Berg18_co2_Pres_pa(3700:6500)=nan;
Berg18_co2_Scatter(3700:6500)=nan;
Berg18_co2_Sea_temp(3700:6500)=nan;
Berg18_co2_Skin_temp(3700:6500)=nan;
Berg18_co2_SST_1m(3700:6500)=nan;
Berg18_co2_TSG_s(3700:6500)=nan;
Berg18_co2_TSG_t(3700:6500)=nan;
Berg18_co2_u10(3700:6500)=nan;
Berg18_days_since_ice(3700:6500)=nan;

[c]=~isnan(Berg18_co2_fco2_surface);
%trim the matrix by removing values that are nan
Berg18_co2_atmCO2=Berg18_co2_atmCO2(c);
Berg18_co2_Cell_p=Berg18_co2_Cell_p(c);
Berg18_co2_Cell_t=Berg18_co2_Cell_t(c);
Berg18_co2_Chl=Berg18_co2_Chl(c);
Berg18_co2_CO2umm=Berg18_co2_CO2umm(c);
Berg18_co2_CO2umm_cal=Berg18_co2_CO2umm_cal(c);
Berg18_co2_dt=Berg18_co2_dt(c);
Berg18_co2_equtemp=Berg18_co2_equtemp(c);
Berg18_co2_equtemp_kelvin=Berg18_co2_equtemp_kelvin(c);
Berg18_co2_fco2=Berg18_co2_fco2(c);
Berg18_co2_FCO2_mmol_per_m2_per_d=Berg18_co2_FCO2_mmol_per_m2_per_d(c);
Berg18_co2_fco2_surface=Berg18_co2_fco2_surface(c);
Berg18_co2_Flour=Berg18_co2_Flour(c);
Berg18_co2_Flowrate=Berg18_co2_Flowrate(c);
Berg18_co2_H20_ppt=Berg18_co2_H20_ppt(c);
Berg18_co2_Latitude=Berg18_co2_Latitude(c);
Berg18_co2_LicorpCO2=Berg18_co2_LicorpCO2(c);
Berg18_co2_Longitude=Berg18_co2_Longitude(c);
Berg18_co2_pco2_surface=Berg18_co2_pco2_surface(c);
Berg18_co2_pcr300_temp=Berg18_co2_pcr300_temp(c);
Berg18_co2_ph_avg=Berg18_co2_ph_avg(c);
Berg18_co2_ph_temp=Berg18_co2_ph_temp(c);
Berg18_co2_Pres_atm=Berg18_co2_Pres_atm(c);
Berg18_co2_Pres_kpa=Berg18_co2_Pres_kpa(c);
Berg18_co2_Pres_mbar=Berg18_co2_Pres_mbar(c);
Berg18_co2_Pres_pa=Berg18_co2_Pres_pa(c);
Berg18_co2_Scatter=Berg18_co2_Scatter(c);
Berg18_co2_Sea_temp=Berg18_co2_Sea_temp(c);
Berg18_co2_Skin_temp=Berg18_co2_Skin_temp(c);
Berg18_co2_SST_1m=Berg18_co2_SST_1m(c);
Berg18_co2_TSG_s=Berg18_co2_TSG_s(c);
Berg18_co2_TSG_t=Berg18_co2_TSG_t(c);
Berg18_co2_u10=Berg18_co2_u10(c);
Berg18_days_since_ice=Berg18_days_since_ice(c);
clearvars c d

%filter chlorophyll for bubbles and particles
Berg18_co2_Chl_despike=medfilt1(Berg18_co2_Chl,20);


save('2018_undpCO2_proc.mat')


