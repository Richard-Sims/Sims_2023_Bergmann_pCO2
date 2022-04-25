%work up Bergmann underway data 2016
clc;  clear all ; close all; %reset workspace
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
path_pco2 = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2016\Raw\SuperCO2\pCO2';%identify file path
path_eco = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2016\Raw\SuperCO2\ECO';%identify file path
path_cr300 = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2016\Raw\CR300';%identify file path
path_tsg=[];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pco2 files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%loop through underway files 
cd(path_pco2); %change current directory to folder with files want to load
fList = dirPlus(path_pco2);
iRow=[];

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

 Time=[];Date=[];GPS_lon=[];GPS_lat=[];TSG_e=[];Valvepos=[];IO3=[];IO4=[];IO5=[];Pres_v=[];Temp_v=[];Pres_kpa=[];Temp_c=[];
    Cell_p=[];Cell_t=[];H20_ppt=[];CO2_ppm=[];DOY_utc=[];TSG_s=[];TSG_t=[];TSG_e=[];Valvepos=[];
    
    
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
Jan1_serial = datenum([2016, 1, 1, 0, 0, 0]); %define first day of year
Dt_doy= Dt - Jan1_serial + 1;%    %convert date to doy (day of year)
clear h20_abs IO3 IO4 IO5 Time_cell Time_char Time_char2 H20_abs Jan1_serial DOY_utc H20_abs Dt_Cat Date Time ans A iRow nanrows nanrowsunq B C Date_char fList fList_pco2 cv col row Date_cell Date_cell2 Index IndexC K mA i k o p time x doy_utc fname_cellstr fNamex fname_char fname_cellstr Velp fList_entry_num length_ent co2_abs micro_ pwrV820


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%eco not logging to pco2 file-import seperately , loop through underway files and 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path_eco); %change current directory to folder with files want to load
fList = dirPlus(path_eco) ;
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
for i = p;
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
%Import CR3000 to get Lat/Long and insitu sea temp and skin temp
%%%%%%%%%%%%%%%%%%%%%%%

%CR300 was logging as two seperate files at start of the cruise before
%being consolidated into a single file. Load all 3 and combine. 


%loop through underway files - looking explicitly for this
fList_dat = dirPlus(path_cr300);  % whilst in files folder, generates list of dat files
iRow=[];
for i=1:size(fList_dat,1);
    if strfind(char(fList_dat(i,:)),'GPS_20160807') > 0;
        iRow = [iRow ; i];
    else ;
    end;
end;


cd(mfileDir);   %change currect directory original matlab folder
filename = char(fList_dat(iRow,:));
delimiter = ',';
startRow = 5;
formatSpec = '%q%q%q%q%q%q%q%q%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[2,3,4,5,6,7,8]
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
rawNumericColumns = raw(:, [2,3,4,5,6,7,8]);
rawCellColumns = raw(:, 1);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
TIMESTAMP0 = rawCellColumns(:, 1);
% batt_volt_Min0 = cell2mat(rawNumericColumns(:, 2));
PTemp0 = cell2mat(rawNumericColumns(:, 3));
Latitude0 = cell2mat(rawNumericColumns(:, 4));
Longitude0 = cell2mat(rawNumericColumns(:, 5));
% Speed_kmh_Avg0 = cell2mat(rawNumericColumns(:, 6));
% Course_Ovr_gnd0 = cell2mat(rawNumericColumns(:, 7));
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;

%now get the water temnp file
%loop through underway files - looking explicitly for this
fList_dat = dirPlus(path_cr300);  % whilst in files folder, generates list of dat files
iRow=[];
for i=1:size(fList_dat,1);
    if strfind(char(fList_dat(i,:)),'Water_20160807') > 0;
        iRow = [iRow ; i];
    else ;
    end;
end;
cd(mfileDir);   %change currect directory original matlab folder
filename = char(fList_dat(iRow,:));
delimiter = ',';
startRow = 5;
formatSpec = '%q%q%q%q%q%q%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[2,3,4,5,6]
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
rawNumericColumns = raw(:, [2,3,4,5,6]);
rawCellColumns = raw(:, 1);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
TIMESTAMP1 = rawCellColumns(:, 1);
% BattV_Avg1 = cell2mat(rawNumericColumns(:, 2));
PTemp_C_Avg1 = cell2mat(rawNumericColumns(:, 3));
SurfT_C_Avg1 = cell2mat(rawNumericColumns(:, 4));
WaterT_C_Avg1 = cell2mat(rawNumericColumns(:, 5));
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;

CR3000_Dt0=datenum(TIMESTAMP0,'yyyy-mm-dd HH:MM:SS');
CR3000_Dt1=datenum(TIMESTAMP1,'yyyy-mm-dd HH:MM:SS');

%lat long every 15 seconds, temp every minute- interp to same length as other variables
pcr300_temp1= interp1(CR3000_Dt0,PTemp0,CR3000_Dt1); %interpolate onto 1min
Latitude1= interp1(CR3000_Dt0,Latitude0,CR3000_Dt1); %interpolate onto 1min
Longitude1= interp1(CR3000_Dt0,Longitude0,CR3000_Dt1); %interpolate onto 1min
clearvars  Latitude0 Longitude0 CR3000_Dt CR3000_Dt0 PTemp0 TIMESTAMP0


%loop through underway files - looking explicitly for this
fList_dat = dirPlus(path_cr300);  % whilst in files folder, generates list of dat files
iRow=[];
for i=1:size(fList_dat,1);
    if strfind(char(fList_dat(i,:)),'GPSWater_Big') > 0;
        iRow = [iRow ; i];
    else ;
    end;
end;
cd(mfileDir);   %change currect directory original matlab folder
filename = char(fList_dat(iRow,:));

delimiter = ',';
startRow = 5;
formatSpec = '%q%q%q%q%q%q%q%q%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[2,3,4,5,6,7,8]
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
rawNumericColumns = raw(:, [2,3,4,5,6,7,8]);
rawCellColumns = raw(:, 1);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
TIMESTAMP2 = rawCellColumns(:, 1);
% RECORD = cell2mat(rawNumericColumns(:, 1));
Latitude2 = cell2mat(rawNumericColumns(:, 2));
Longitude2 = cell2mat(rawNumericColumns(:, 3));
% Speed_kmh = cell2mat(rawNumericColumns(:, 4));
% Course_Ovr_gnd = cell2mat(rawNumericColumns(:, 5));
SurfT_C_Avg2 = cell2mat(rawNumericColumns(:, 6));
WaterT_C_Avg2 = cell2mat(rawNumericColumns(:, 7));
pcr300_temp2=nan(length(Latitude2),1);
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;
CR3000_Dt2=datenum(TIMESTAMP2,'yyyy-mm-dd HH:MM:SS');


%combine CR300 matrices together


CR3000_Latitude=[Latitude1; Latitude2];
CR3000_Longitude=[Longitude1; Longitude2];
CR3000_Dt=[CR3000_Dt1; CR3000_Dt2];
CR3000_WaterT_C_Avg=[WaterT_C_Avg1; WaterT_C_Avg2];
CR3000_SurfT_C_Avg=[SurfT_C_Avg1; SurfT_C_Avg2];
CR3000_PTemp_Avg=[pcr300_temp1; pcr300_temp2];
clearvars pcr300_temp1 pcr300_temp2 CR3000_Dt1 CR3000_Dt2 Latitude1 Latitude2 Longitude1 Longitude2 SurfT_C_Avg1 SurfT_C_Avg2 TIMESTAMP1 TIMESTAMP2 WaterT_C_Avg1 WaterT_C_Avg2

%for all variables find nan values
[row1, ~] = find(isnan(CR3000_Dt));
[row3, ~] = find(isnan(CR3000_Latitude));
[row4, ~] = find(isnan(CR3000_Longitude));
% [row8, ~] = find(isnan(CR3000_PTemp_Avg));
[row9, ~] = find(isnan(CR3000_SurfT_C_Avg));
[row10, ~] = find(isnan(CR3000_WaterT_C_Avg));

 
%concatenate nan rows for all variables
nanrows=[row1;row3;row4;row9;row10];
nanrowsunq=unique(nanrows); %find only unique rows - note this is only 265 rows of 13831
clearvars nanrows row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12 row13 row14 row15 row16 row17 row18 row19 row20 row21

%remove these rows from data
    CR3000_Dt(nanrowsunq)=[];
    CR3000_Latitude(nanrowsunq)=[];
    CR3000_Longitude(nanrowsunq)=[];
    CR3000_PTemp_Avg(nanrowsunq)=[];
    CR3000_SurfT_C_Avg(nanrowsunq)=[];
    CR3000_WaterT_C_Avg(nanrowsunq)=[];
    
    
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
  
%interp to same length as other variables
Latitude= interp1(CR3000_Dt,CR3000_Latitude_dec,Dt); %interpolate onto pco2 time
Longitude= interp1(CR3000_Dt,CR3000_Longitude_dec,Dt); %interpolate onto pco2 time
pcr300_temp= interp1(CR3000_Dt,CR3000_PTemp_Avg,Dt); %interpolate onto pco2 time
Skin_temp= interp1(CR3000_Dt,CR3000_SurfT_C_Avg,Dt); %interpolate onto pco2 time
Sea_temp= interp1(CR3000_Dt,CR3000_WaterT_C_Avg,Dt); %interpolate onto pco2 time



clearvars GPS_lat GPS_lon  i iRow fList_dat CR3000_Dt CR3000_Latitude CR3000_Longitude CR3000_PTemp_Avg CR3000_SurfT_C_Avg CR3000_WaterT_C_Avg
clearvars col CR3000_Dt CR3000_Dt_Ph CR3000_H2OFlow_LPM_Avg CR3000_Latitude CR3000_Longitude CR3000_pH_Avg CR3000_pH_temp_Avg CR3000_pH_V_Avg CR3000_PTemp_Avg CR3000_SurfT_C_Avg CR3000_WaterT_C_Avg dupRows ia ic length_ent nanrowsunq
clearvars CR3000_Longitude_dec CR3000_Latitude_dec lat_deg lat_min lat_sec lon_deg lon_min lon_sec PTemp_C_Avg1


Flowrate=nan(length(Latitude),1);
ph_avg=nan(length(Latitude),1);
ph_temp=nan(length(Latitude),1);
ph_volt=nan(length(Latitude),1);



cd (mfileDir)
save('2016_und.mat')




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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVE CALIBRATION DATA AT EDGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
plot(Dt(ind_co2_atm),CO2_ppm(ind_co2_atm),'g*');
plot(Dt(ind_co2_samp1),CO2_ppm(ind_co2_samp1),'r*');
% plot(Dt(ind_co2_samp1_end),CO2_ppm(ind_co2_samp1_end),'m*');
plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'rs');
% plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
plot(Dt(ind_co2_samp3),CO2_ppm(ind_co2_samp3),'ro');
dynamicDateTicks([], [], ' mm/dd');
legend('xco2','atm co2','std1','std2','std3');
title('FIG 1 - NO QC Berg pCO2 data');
% this code finds the stanards and can move the first couple of points-
% this has been replaced by better code below
ylim([0 1000])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMOVE DATA WITHOUT STANDARDS or bad standards
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


temp_cutoutsrt= datenum('2016-08-01 00:04:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2016-08-02 14:05:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

temp_cutoutsrt= datenum('2016-08-03 01:47:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2016-08-03 14:02:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

temp_cutoutsrt= datenum('2016-08-04 05:28:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2016-08-04 05:36:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

temp_cutoutsrt= datenum('2016-08-04 06:48:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2016-08-04 07:04:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

temp_cutoutsrt= datenum('2016-08-04 17:00:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2016-08-04 18:26:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

temp_cutoutsrt= datenum('2016-08-10 20:07:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2016-08-10 20:38:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;



%instrument reading negative values - remove these
[negind,~ ]=find(CO2_ppm<-100);
CO2_ppm(negind)=nan;

%Samples after std3 - remove first 7 points
c_meas=find(diff(ind_co2_meas) ~= 1) + 1;
for i=1:length(c_meas)-1;
    CO2_ppm(ind_co2_meas(c_meas(i):c_meas(i)+7))=nan;
end


%manually pick out indexes of  pco2 to remove that are clear outliers
plot(CO2_ppm(ind_co2_meas),'*')
fixplot1('%1.8f')


CO2_ppm(ind_co2_meas([19894 8671 14724 13358]))=nan;

%locate all standards  in a subset of the data
%then get index of the last point when the standard has properly flushed
%through

%std1
ind_co2_samp1_final=[];
ind_co2_samp1_flushing=[];
v=1:100:length(CO2_ppm);
for f=1:length(v)-1;
[p, ~]=find(ind_co2_samp1>v(f) & ind_co2_samp1<v(f+1));
if ~(isnan(p))
ind_co2_samp1_final=[ind_co2_samp1_final;p(end)];
ind_co2_samp1_flushing=[ind_co2_samp1_flushing;p(1:end-1)];
else
end
end
ind_co2_samp1_end=ind_co2_samp1(ind_co2_samp1_final);
ind_co2_samp1_flush=ind_co2_samp1(ind_co2_samp1_flushing);

%std2
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


%std3
ind_co2_samp3_final=[];
ind_co2_samp3_flushing=[];
v=1:100:length(CO2_ppm);
for f=1:length(v)-1;
[p, ~]=find(ind_co2_samp3>v(f) & ind_co2_samp3<v(f+1));
if ~(isnan(p))
ind_co2_samp3_final=[ind_co2_samp3_final;p(end)];
ind_co2_samp3_flushing=[ind_co2_samp3_flushing;p(1:end-1)];
else
end
end
ind_co2_samp3_end=ind_co2_samp3(ind_co2_samp3_final);
ind_co2_samp3_flush=ind_co2_samp3(ind_co2_samp3_flushing);

figure(2)
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
plot(Dt(ind_co2_atm),CO2_ppm(ind_co2_atm),'g*');
plot(Dt(ind_co2_samp1),CO2_ppm(ind_co2_samp1),'r*');
% plot(Dt(ind_co2_samp1_end),CO2_ppm(ind_co2_samp1_end),'m*');
plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'rs');
% plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
plot(Dt(ind_co2_samp3),CO2_ppm(ind_co2_samp3),'rO');
dynamicDateTicks([], [], ' mm/dd');
legend('xco2','atm co2','std1','std2','STD3')
title('FIGURE 2 - OUTLIERS QC Berg pCO2 data')



%ignore the nans otehrwise this ruins the calibration below!
b=~(isnan(CO2_ppm(ind_co2_samp1_end)));
ind_co2_samp1_end=ind_co2_samp1_end(b);

b=~(isnan(CO2_ppm(ind_co2_samp2_end)));
ind_co2_samp2_end=ind_co2_samp2_end(b);

b=~(isnan(CO2_ppm(ind_co2_samp3_end)));
ind_co2_samp3_end=ind_co2_samp3_end(b);



%now remove the standards when the system is being flushed and atmospheric
%CO2
CO2_ppm(ind_co2_atm)=nan;
CO2_ppm(ind_co2_samp1_flush)=nan;
CO2_ppm(ind_co2_samp2_flush)=nan;
CO2_ppm(ind_co2_samp3_flush)=nan;
clearvars ans c f i c_meas p tempbackind tempoutind temp_cutoutend temp_cutoutsrt v



%add to standards
ind_co2_samp1_end=[ind_co2_samp1_end ;316];
ind_co2_samp2_end=[ind_co2_samp2_end;317];
ind_co2_samp3_end=[ind_co2_samp3_end;318];
ind_co2_samp1_end=sort(ind_co2_samp1_end);
ind_co2_samp2_end=sort(ind_co2_samp2_end);
ind_co2_samp3_end=sort(ind_co2_samp3_end);

CO2_ppm(316)=129.5980;
CO2_ppm(317)=235.2540;
CO2_ppm(318)=327.8190;
%remove from flushing index standrads want to save
[ind_removal, ~]=find(ind_co2_samp1_flush==316);
ind_co2_samp1_flush(ind_removal)=[];

[ind_removal, ~]=find(ind_co2_samp2_flush==317);
ind_co2_samp2_flush(ind_removal)=[];

[ind_removal, ~]=find(ind_co2_samp3_flush==318);
ind_co2_samp3_flush(ind_removal)=[];

%remove duplicate cals
[ind_removal, ~]=find(ind_co2_samp1_end==2900);
ind_co2_samp1_end(ind_removal)=[];
[ind_removal, ~]=find(ind_co2_samp1_end==21700);
ind_co2_samp1_end(ind_removal)=[];

[ind_removal, ~]=find(ind_co2_samp2_end==10200);
ind_co2_samp2_end(ind_removal)=[];
[ind_removal, ~]=find(ind_co2_samp2_end==20000);
ind_co2_samp2_end(ind_removal)=[];

[ind_removal, ~]=find(ind_co2_samp3_end==2700);
ind_co2_samp3_end(ind_removal)=[];
[ind_removal, ~]=find(ind_co2_samp3_end==5800);
ind_co2_samp3_end(ind_removal)=[];
[ind_removal, ~]=find(ind_co2_samp3_end==12300);
ind_co2_samp3_end(ind_removal)=[];

figure(3)
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
% plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'b*');
plot(Dt(ind_co2_samp1_end),CO2_ppm(ind_co2_samp1_end),'m*');
plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
plot(Dt(ind_co2_samp3_end),CO2_ppm(ind_co2_samp3_end),'mo');
legend('xco2','std1','std2','std3')
title('FIGURE 3 - OUTLIERS QC + final standard point only Berg pCO2 data')


for labelcat=1:length(ind_co2_samp1_end);
labelpoints(Dt(ind_co2_samp1_end(labelcat)),CO2_ppm(ind_co2_samp1_end(labelcat)),([num2str((labelcat),'%10.1f')]),'color','b','Fontsize',5,'Fontweight','bold','BackgroundColor','none')
end

for labelcat=1:length(ind_co2_samp2_end);
labelpoints(Dt(ind_co2_samp2_end(labelcat)),CO2_ppm(ind_co2_samp2_end(labelcat)),([num2str((labelcat),'%10.1f')]),'color','b','Fontsize',5,'Fontweight','bold','BackgroundColor','none')
end

for labelcat=1:length(ind_co2_samp3_end);
labelpoints(Dt(ind_co2_samp3_end(labelcat)),CO2_ppm(ind_co2_samp3_end(labelcat)),([num2str((labelcat),'%10.1f')]),'color','b','Fontsize',5,'Fontweight','bold','BackgroundColor','none')
end
dynamicDateTicks([], [], ' mm/dd');


%super co2 records as pCO2 but we want xco2 for water vapour correction
Berg16_co2_CO2umm=CO2_ppm./(Cell_p*0.00986923);

Berg16_co2_dt=Dt;

% main loop to do the calibrations here
% for every interval between standards
% loop through and calibrate between this and the next set of standards
    Berg16_co2_CO2umm_cal=[];
    for z=1:(length(ind_co2_samp2_end)-1); %for each set of standards
        calstart_STD1Ind = ind_co2_samp1_end(z);
        calstart_STD2Ind = ind_co2_samp2_end(z);
        calstart_STD3Ind = ind_co2_samp3_end(z);

        calend_STD1Ind = ind_co2_samp1_end(z+1);
        calend_STD2Ind = ind_co2_samp2_end(z+1);
        calend_STD3Ind = ind_co2_samp3_end(z+1);
        
    for y=calstart_STD3Ind+1:calend_STD1Ind-1; % for the number of measurements between standards
    %from dickson 2007 p 100
    interpolatedstd1=Berg16_co2_CO2umm(calstart_STD1Ind)+(((Berg16_co2_CO2umm(calend_STD1Ind)-Berg16_co2_CO2umm(calstart_STD1Ind)).*(( (Berg16_co2_dt(y)) -(Berg16_co2_dt(calstart_STD1Ind)))./(Berg16_co2_dt(calend_STD3Ind)-Berg16_co2_dt(calstart_STD1Ind)))));
    interpolatedstd2=Berg16_co2_CO2umm(calstart_STD2Ind)+(((Berg16_co2_CO2umm(calend_STD2Ind)-Berg16_co2_CO2umm(calstart_STD2Ind)).*(( (Berg16_co2_dt(y)) -(Berg16_co2_dt(calstart_STD1Ind)))./(Berg16_co2_dt(calend_STD3Ind)-Berg16_co2_dt(calstart_STD1Ind)))));
    interpolatedstd3=Berg16_co2_CO2umm(calstart_STD3Ind)+(((Berg16_co2_CO2umm(calend_STD3Ind)-Berg16_co2_CO2umm(calstart_STD3Ind)).*(( (Berg16_co2_dt(y)) -(Berg16_co2_dt(calstart_STD1Ind)))./(Berg16_co2_dt(calend_STD3Ind)-Berg16_co2_dt(calstart_STD1Ind)))));
    interpolatedvec=[interpolatedstd1,interpolatedstd2,interpolatedstd3];

    %check with Brent
    truestd=[255.1 409.9 566.4];
 
    %calculate the linear fit for each data point
    c = polyfit(interpolatedvec,truestd,1);
    slopes=c(1);
    intercept=c(2);
    Berg16_co2_CO2umm_cal(y)=(Berg16_co2_CO2umm(y).*slopes)+intercept; 
    end
    end
    

    Berg16_co2_CO2umm_cal=Berg16_co2_CO2umm_cal';
    %pad out the end of the matrix with NaN where there wasn't a standard at the end
    Berg16_co2_CO2umm_cal(23795:24126)=NaN;
    
%remove calibrations from the co2 matrix
Berg16_co2_CO2umm_cal(ind_co2_atm)=NaN;
Berg16_co2_CO2umm_cal(ind_co2_samp1)=NaN;
Berg16_co2_CO2umm_cal(ind_co2_samp1_end)=NaN;
Berg16_co2_CO2umm_cal(ind_co2_samp2)=NaN;
Berg16_co2_CO2umm_cal(ind_co2_samp2_end)=NaN;
Berg16_co2_CO2umm_cal(ind_co2_samp3)=NaN;
Berg16_co2_CO2umm_cal(ind_co2_samp3_end)=NaN;

    
%outliers at beggining where pressure is 0!!
Berg16_co2_CO2umm_cal([1:315])=nan;  

%outliers 

%salinity is bad
Berg16_co2_CO2umm_cal(([11826 963 824 656 498 3602 4121 4122 5311 5314 5310 5312 5491 5313 5493 5492 8927:8948 10535 11820 22769 15067 21175:21197 23756:23785]))=nan;



figure(4)
plot(Berg16_co2_dt(ind_co2_meas),Berg16_co2_CO2umm(ind_co2_meas),'bo');
hold on
plot(Berg16_co2_dt(ind_co2_samp1_end),Berg16_co2_CO2umm(ind_co2_samp1_end),'m*');
plot(Berg16_co2_dt(ind_co2_samp2_end),Berg16_co2_CO2umm(ind_co2_samp2_end),'ms');
plot(Berg16_co2_dt(ind_co2_samp3_end),Berg16_co2_CO2umm(ind_co2_samp3_end),'mo');
plot(Berg16_co2_dt(ind_co2_meas),Berg16_co2_CO2umm_cal(ind_co2_meas),'ko');
legend('xco2' ,'std1', 'std2','std3', 'xco2cal')
title('FIGURE 4 - QC plus standard calibration - Berg pCO2 data')
dynamicDateTicks([], [], ' mm/dd');

 
%final xCO2 data
figure(41)
plot(Berg16_co2_dt,Berg16_co2_CO2umm_cal,'ko');
clearvars ind_co2_meas ind_co2_samp negind y z Valvepos truestd slopes calend_STD2Ind calstart_STD2Ind ind_co2_atm ind_co2_samp1 ind_co2_samp2 ind_co2_samp2_end ind_co2_samp2_final ind_co2_samp2_flush ind_co2_samp2_flushing ind_co2_samp3 intercept interpolatedstd2 interpolatedvec l std_make_nan stdfiltind t
clearvars ans c f i c_meas p tempbackind tempoutind temp_cutoutend temp_cutoutsrt v
clearvars tempbackind tmp2 tmp tempoutind temp_cutoutend temp_cutoutsrt b calend_STD1Ind calend_STD3Ind calstart_STD1Ind calstart_STD3Ind ind_co2_samp1_end ind_co2_samp1_final ind_co2_samp1_flush ind_co2_samp1_flushing ind_co2_samp3_end ind_co2_samp3_final ind_co2_samp3_flush ind_co2_samp3_flushing interpolatedstd1 interpolatedstd3 mfileDir path_cr300 path_eco path_pco2 path_tsg

%cross correlate temp from CTD 
%load in Bergmann matlab CTD structure 
    
load('C:\Users\rps207\Documents\MATLAB\2019 - Bergmann carbonate transects 2016-2019/Bergmann.mat','Berg')

CTD_casts_2016=fieldnames(Berg.year_2016); %names of the stations

CTD_TEMP_0_5m=[];CTD_TEMP_1m=[];CTD_TEMP_1_5m=[];CTD_TEMP_2m=[];CTD_SAL_1m=[];CTD_DEPTH_1m=[];CTD_DT_1m=[];
CTD_SAL_0_5m=[];CTD_SAL_1_5m=[];CTD_SAL_2m=[];

for w=1:numel(CTD_casts_2016); 
        ghj = Berg.year_2016.([CTD_casts_2016{w}']); 
        [~, f]=size(ghj);
        for h=1:f
        %these are binned
        CTDdepth_1m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Depth_dwncst_intp(15);
        %this time is not super accurate (+/- a couple mins max) but is fine for this
        CTDdt_1m=datenum(Berg.year_2016.([CTD_casts_2016{w}'])(h).DT_str(end),'dd-mmm-yyyy HH:MM:SS');
        
        
        CTDsal_0_5m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Sal_dwncst_intp(5);
        CTDsal_1m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Sal_dwncst_intp(10);
        CTDsal_1_5m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Sal_dwncst_intp(15);
        CTDsal_2m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Sal_dwncst_intp(20);

        CTDtemp_0_5m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Temp_dwncst_intp(5);
        CTDtemp_1m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Temp_dwncst_intp(10);
        CTDtemp_1_5m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Temp_dwncst_intp(15);
        CTDtemp_2m=Berg.year_2016.([CTD_casts_2016{w}'])(h).Temp_dwncst_intp(20);

%         % store 
%         if CTDdt_1m>datenum([2019 08 09 17 32 00])
        CTD_DEPTH_1m=[CTD_DEPTH_1m,CTDdepth_1m];
        CTD_DT_1m=[CTD_DT_1m,CTDdt_1m];
        
        CTD_TEMP_0_5m=[CTD_TEMP_0_5m,CTDtemp_0_5m];
        CTD_TEMP_1m=[CTD_TEMP_1m,CTDtemp_1m];
        CTD_TEMP_1_5m=[CTD_TEMP_1_5m,CTDtemp_1_5m];
        CTD_TEMP_2m=[CTD_TEMP_2m,CTDtemp_2m];

        CTD_SAL_0_5m=[CTD_SAL_0_5m,CTDsal_0_5m];
        CTD_SAL_1m=[CTD_SAL_1m,CTDsal_1m];
        CTD_SAL_1_5m=[CTD_SAL_1_5m,CTDsal_1_5m];
        CTD_SAL_2m=[CTD_SAL_2m,CTDsal_2m];
%         else
%         %dont store the Quest was in port! we were on the Jenny!
%         end
         end
end
clearvars w ghj f h

temp_matchup_tsg=[]; temp_matchup=[];temp_matchup_sea_temp=[];sal_matchup=[];
for b=1:length(CTD_DT_1m);
[n m]=min(abs(CTD_DT_1m(b)-Berg16_co2_dt));
%if there is no temp data within that 10mins ignore! 
if n>1/24*6;
    n=nan;
else    
end
temp_matchup_tsg=[temp_matchup_tsg,TSG_t(m)];
temp_matchup=[temp_matchup,Temp_c(m)];
temp_matchup_sea_temp=[temp_matchup_sea_temp,Sea_temp(m)];

sal_matchup=[sal_matchup,TSG_s(m)];
% temp_matchup=[temp_matchup,tmp(m)];

end
clearvars n m b

  l=~(isnan(CTD_TEMP_1m)) & ~(isnan(temp_matchup));
 c = polyfit(temp_matchup(l),CTD_TEMP_1m(l),1);
 
 l=~(isnan(CTD_TEMP_1m));
 d = polyfit(temp_matchup_tsg(l),CTD_TEMP_1m(l),1);
 
  l=~(isnan(CTD_TEMP_1m)) & ~(isnan(temp_matchup_sea_temp));
 j = polyfit(temp_matchup_sea_temp(l),CTD_TEMP_1m(l),1);
 
figure(5)
plot(CTD_TEMP_1m,temp_matchup,'k*')
hold on
plot(CTD_TEMP_1m,temp_matchup_tsg,'r*')
plot(CTD_TEMP_1m,temp_matchup_sea_temp,'m*')
% plot(CTD_TEMP_1m,(temp_matchup*c(1))+c(2),'b*')
plot (1:0.1:12,1:0.1:12,'k')
xlabel('rosette')
ylabel('underway')
xlim([4 12])
ylim([4 12])
legend('Location','SouthEast','temp equ','temp tsg','temp sea probe','1:1 line')
title('1m CTD vs temp sensors')

figure(51)
plot(CTD_TEMP_0_5m,temp_matchup_sea_temp,'m*')
hold on
plot(CTD_TEMP_1m,temp_matchup_sea_temp,'k*')
plot(CTD_TEMP_1_5m,temp_matchup_sea_temp,'b*')
plot(CTD_TEMP_2m,temp_matchup_sea_temp,'g*')
% plot(CTD_TEMP_1m,(temp_matchup*c(1))+c(2),'b*')
plot (1:0.1:12,1:0.1:12,'k')
xlabel('rosette')
ylabel('underway')
xlim([4 12])
ylim([4 12])
legend('Location','SouthEast','temp 0.5m','temp 1m','temp 1.5m','temp 2m','1:1 line');
title('ctd depths vs sea temp probe')

 l=~(isnan(CTD_SAL_1m));
 e = polyfit(sal_matchup(l),CTD_SAL_1m(l),1);
 
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
plot(CTD_SAL_1m(l),(sal_matchup(l)*e(1))+e(2),'b*')
plot (18:0.1:30,18:0.1:30,'k');
xlabel('rosette sal');
ylabel('underway sal');
xlim([18 30]);
ylim([18 30]);
legend('Location','SouthEast','sal 0.5m','sal 1m','sal 1.5m','sal 2m','1:1 line');

figure(7)
plot(TSG_t,'k*')
hold on
plot(Temp_c,'r*')
plot(Sea_temp,'m*')
legend('TSG t','Temp equ','sea probe');
ylabel('Temp')
xlabel('Measurement number')
% plot(Sea_temp,'g*')
% plot(Skin_temp,'y*')


figure(71)
plot(TSG_s,'k*')
legend('TSG s','Temp equ','sea probe');
ylabel('Sal')
xlabel('Measurement number')
fixplot1('%1.8f')


% This is corrected SST from equilibrator temp.
Berg16_co2_equtemp=Temp_c;
%not correcting this to CTD as it is the actual temperature
Berg16_co2_SST_1m=Sea_temp;
% Berg16_co2_SST_1m=(Sea_temp*j(1))+j(2);



%other variables
Berg16_co2_Longitude=Longitude;
Berg16_co2_Latitude=Latitude;
Berg16_co2_Flowrate=Flowrate;
Berg16_co2_H20_ppt=H20_ppt;
Berg16_co2_Chl=Chl;
Berg16_co2_Flour=Flour;
Berg16_co2_Cell_p=Cell_p;
Berg16_co2_Cell_t=Cell_t;
Berg16_co2_TSG_t=TSG_t;
Berg16_co2_TSG_s=TSG_s;
Berg16_co2_Scatter=Scatter;
Berg16_co2_Pres_kpa=Pres_kpa;




%these all seem to have bad data so will make them all nans here
Berg16_co2_ph_temp=nan(length(Berg16_co2_TSG_t),1);%bad
Berg16_co2_ph_avg=nan(length(Berg16_co2_TSG_t),1);%bad
Berg16_co2_pcr300_temp=nan(length(Berg16_co2_TSG_t),1);%bad
Berg16_co2_Skin_temp=nan(length(Berg16_co2_TSG_t),1); %bad
Berg16_co2_Sea_temp=nan(length(Berg16_co2_TSG_t),1);%bad


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%     CO2 calculations  Part 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %use Wagner and garb 2002 to get water vapour
    Berg16_co2_equtemp_kelvin=Berg16_co2_equtemp +273.15; %convert temperature into kelvin
    temp_mod = 1-Berg16_co2_equtemp_kelvin./647.096;
    vapor_0sal_kPa=(22.064e3)*(exp((647.076./(Berg16_co2_equtemp_kelvin)).*((-7.85951783*temp_mod)+((1.84408259)*(temp_mod.^(3/2)))+(-11.7866497*(temp_mod.^3))+(22.6807411*(temp_mod.^3.5))+(-15.9618719*(temp_mod.^4))+(1.80122502*(temp_mod.^7.5)))));
    %Correct vapor pressure for salinity
    molality = 31.998 * Berg16_co2_TSG_s ./(1e3-1.005*Berg16_co2_TSG_s);
    osmotic_coef = 0.90799 -0.08992*(0.5*molality) +0.18458*(0.5*molality).^2 -0.07395*(0.5*molality).^3 -0.00221*(0.5*molality).^4;
    vapor_press_kPa = vapor_0sal_kPa .* exp(-0.018 * osmotic_coef .* molality);
    Vapour_pressure_mbar = 10*(vapor_press_kPa);%Convert to mbar
    Vapour_pressure_atm=0.0098692327 .*Vapour_pressure_mbar;%convert to atm 1 millibar = 0.000986923267 atmosphere


    %add woolf 16/2019 corrections for skin to salinity and temp
   Berg16_co2_SST_1m=Berg16_co2_SST_1m-0.17;
   Berg16_co2_TSG_s=Berg16_co2_TSG_s+0.1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%     CO2 calculations  Part 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %use pressure from pco2 system
    Berg16_co2_Pres_mbar = 10*(Berg16_co2_Pres_kpa);%Convert to mbar
    Berg16_co2_Pres_atm= Berg16_co2_Pres_mbar *0.000986923; %convert from mb to atm
    Berg16_co2_Pres_pa= Berg16_co2_Pres_mbar *100; %convert from mb to pa

    Berg16_co2_LicorpCO2= Berg16_co2_CO2umm_cal.*(Berg16_co2_Pres_atm - Vapour_pressure_atm);%Correction for water vapour pressure as described in (dickson(2007)-section 8.5.3 TO GET PCO2
    BCO2te= -1636.75 + (12.0408*(Berg16_co2_equtemp_kelvin)) - (3.27957*0.01*(Berg16_co2_equtemp_kelvin).^2) + (3.16528*0.00001*(Berg16_co2_equtemp_kelvin).^3);%units of cm^3 mol^-1 ,determine the two viral coefficents of co2, (Dickson 2007) SOP 24 and p98 section 8.3 use equilibrator_pressure and equilibrator_temperature
    deltaCO2te= 57.7 - 0.118*( Berg16_co2_equtemp_kelvin); %units of cm^3 mol^-1
    R=8.31447; %specific gas constant J/Mol*K
    Berg16_co2_fco2= Berg16_co2_LicorpCO2.*exp(((BCO2te+(2*deltaCO2te))*0.000001.*(Berg16_co2_Pres_pa))./(R *Berg16_co2_equtemp_kelvin));%use viral coefficents to determine fco2
    Berg16_co2_fco2_surface=Berg16_co2_fco2.*exp(0.0423*(Berg16_co2_SST_1m - Berg16_co2_equtemp));%correction of co2 to sea surface temperature , (Dickson 2007) p98 8.4
    
    Berg16_co2_pco2_surface=Berg16_co2_LicorpCO2.*exp(0.0423*(Berg16_co2_SST_1m - Berg16_co2_equtemp));%correction of co2 to sea surface temperature , (Dickson 2007) p98 8.4



    figure(8)
    plot(Berg16_co2_dt,Berg16_co2_pco2_surface,'r*')
    hold on
    plot(Berg16_co2_dt,Berg16_co2_fco2_surface,'g*')
    plot(Berg16_co2_dt,Berg16_co2_LicorpCO2,'y*')
    plot(Berg16_co2_dt,Berg16_co2_CO2umm_cal,'m*')
     plot(Berg16_co2_dt,Berg16_co2_CO2umm,'k*')
    legend('pco2 surf','fco2 surf','pco2','xco2 cal','xco2 raw')
dynamicDateTicks([], [], 'mm/dd');
    
figure(9)
plot(Berg16_co2_dt,Berg16_co2_pco2_surface,'-*')
dynamicDateTicks([], [], 'mm/dd');




%QC this dataset!

%these are outliers in the processed data!
f=[3752 3693 5042 5117 5275:5276 6907 16761 20567 21691 2876 3751 3904:3907 3986 4267 10175 9015 10517 10513 10569 10662 10568 10657 10745 11020 10045 11063 11044 11812 12100 14222 22822 22866 22896 22915 22917 22935 22784 23203 23371 23389 23519 22645 22607 22594 22512 22435 22436 6017 6121 6061 5908 5907 5905 5906 5909 5904 5714 5780:5782 7052 8398 10877 11045 9527 9648 9616 9621 9587 9553 9525 9524 9531 9442 9255 9263 9265 9276 9325 9349 9373 9442 9527 9648 10041 10351 10434:10435 11045 11702 11673 11672 11898 11897 11896 12117 12128 12139 12247 12369:12370 12330:12332 12313 12314 12317 12318 12435 12436 12532 13240 13327:13329 13429 13483 13545 13757 13761 13897 13899 13974 14094 14106 14594:14598 14834 15075 15302 15796 23297 1636 16669 19984 19724 19655 9529 9519 9694:9700 11805 11811 11748:11750 11740 11735 11804 11882 11947 11949 4258 11804 12050 12049 12065 12387 14599 13790 13792 13796 13791 13898 13959 14591 14592 14733 15136 16248 16249 16267 16259 16307 16308 16334 16335 16424 16434 16438 16533 16535 16534 16503 16505 16496 16495 16505 16506 16636 16667 16668 16797 16828:16830 20465 20668 20762 20560 21131 21154 20997 20979 20980 20951 20889 20893 20916:20921 20831:20833 20804:20806 20813:20817 20809 20804:20806 21131 21154 21081 21777 21776 21778 21773 21802 21810 21816 21847 21865 21866 21932 21912 21984 21982 21997 22078 22079 22098 22123 22156 22153 22141 22211 22250 22357 22351 22371 22438 22439 22558 22586 22606 22590 22615 22624 22592 23151 23387 23370 23390 23674 23707 23698 23699 23698 23687 23672 23664 23665 21928 22097 23697 19961 19629 19630 19622 19682 19683 19700 19756 19824 19504 15787 15794 15818 15942 15502 14804 14803 14702 14581 13674 13675 13665:13667 13647:13649 13574:13576 13504 13512 13456:13458 13449:13450 1363 13365 13358 13359 13312   ];

%these look way too high. Happens in short periods potentially when the
%ship was doing operations? no UPS?
v=[ 8388:8392 8835:8949    18942:19621 20250:20446 22804:22814 21692:21734  20249:2042 22709:22803  19318:19495  22804:22814 ]; 
% k=[3491:3549 3980:3983      5849:5870  5903:5941 5957:6093 6866:6869 7051:7056 7303:73144008:4027 4040:4060 4094:4124 4142:4260 4326:4335 9214:9741 9955:9971 11191:11274 11570:11704  13233:13268 13288:13298 13948:14107 14425:14478 14588:14681  14728:14866    14594:14599 15354:15396 15118:15235 15408:15489 15738:15795 15622:15652 15971:16278 16798:16817 23664:23710 20249:20425 19951:20018 19713:19798 20495:20546 20643:20671 ];


figure(44)
plot(Berg16_co2_pco2_surface,'*')
hold on
fixplot1('%1.8f')
plot(([v]),Berg16_co2_pco2_surface([v]),'r*');
plot(([f]),Berg16_co2_pco2_surface([f]),'m*');


%remove outliers 
Berg16_co2_pco2_surface([v])=nan;  
Berg16_co2_pco2_surface([f])=nan;  

%unknown noise on second and third cruise legs
%decided to remove
Berg16_co2_pco2_surface([8000:end])=nan;  

%shorten where NaN
b=(isnan(Berg16_co2_pco2_surface));

%where co2 is nan make the other variables nan
Temp_c(b)=[];
Longitude(b)=[];
Latitude(b)=[];
Flowrate(b)=[];
H20_ppt(b)=[];
Chl(b)=[];
Flour(b)=[];
Cell_p(b)=[];
Cell_t(b)=[];
TSG_t(b)=[];
TSG_s(b)=[];
Scatter(b)=[];
Pres_kpa(b)=[];
ph_temp(b)=[];
ph_avg(b)=[];
pcr300_temp(b)=[];
Skin_temp(b)=[];
Sea_temp(b)=[];

 CO2_ppm(b)=[];
 Dt(b)=[];
 Dt_doy(b)=[]; 
 n_records(b)=[];
 ph_volt(b)=[];
 Pres_v(b)=[];
 Temp_v(b)=[];
 Berg16_co2_CO2umm(b)=[];
 Berg16_co2_dt(b)=[];
Berg16_co2_Longitude(b)=[];
Berg16_co2_Latitude(b)=[];
Berg16_co2_Flowrate(b)=[];
Berg16_co2_H20_ppt(b)=[];
Berg16_co2_Chl(b)=[];
Berg16_co2_Flour(b)=[];
Berg16_co2_Cell_p(b)=[];
Berg16_co2_Cell_t(b)=[];
Berg16_co2_TSG_t(b)=[];
Berg16_co2_TSG_s(b)=[];
Berg16_co2_Scatter(b)=[];
Berg16_co2_Pres_kpa(b)=[];
Berg16_co2_CO2umm_cal(b)=[]; 
Berg16_co2_equtemp(b)=[]; 
Berg16_co2_equtemp_kelvin(b)=[];
Berg16_co2_fco2(b)=[];
Berg16_co2_fco2_surface(b)=[];
Berg16_co2_LicorpCO2(b)=[]; 
Berg16_co2_pco2_surface(b)=[]; 
Berg16_co2_pcr300_temp(b)=[]; 
Berg16_co2_ph_avg(b)=[]; 
Berg16_co2_ph_temp(b)=[]; 
Berg16_co2_Pres_atm(b)=[]; 
Berg16_co2_Pres_mbar(b)=[]; 
Berg16_co2_Pres_pa(b)=[]; 
Berg16_co2_Sea_temp(b)=[]; 
Berg16_co2_Skin_temp(b)=[]; 
Berg16_co2_SST_1m(b)=[]; 
 
% plot(Berg2016_co2_CO2umm_cal,'ko');
% fixplot1('%1.8f')

%calculate smoothed matrix
f = fit((1:numel(Berg16_co2_pco2_surface))',Berg16_co2_pco2_surface,'smoothingspline','SmoothingParam',0.004);
coeffvals= coeffvalues(f);
x=coeffvals.coefs(:,4);

%smooth further to dampen noise from the outliers
u=smooth(x,200);


figure(45)
plot(Berg16_co2_pco2_surface,'*')
hold on
plot(x,'r-')
fixplot1('%1.8f')
plot(u,'y-');

%this is no longer necessary
%replace with smoothed value that captures the trend well
% Berg16_co2_pco2_surface=[u;nan];


%%%%%%%%%%%%%%%%
% FLUX 2016
%%%%%%%%%%%%%%%%

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
Berg16_co2_atmCO2=interp1(Barrow_DT,Barrow_pco2,Berg16_co2_dt);
clearvars a b c d e f z ans day month hour minute year second ar ai as ah ag af Barrow_DT Barrow_pco2


%import NETCDF NCEP data for wind!

%2016
ncdisp('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2016.nc')
ncdisp('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/vwnd.10m.gauss.2016.nc')

NCEP_lat=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2016.nc','lat');
NCEP_long=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2016.nc','lon');
NCEP_time=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2016.nc','time');
NCEP_uwnd=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2016.nc','uwnd');
NCEP_vwnd=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/vwnd.10m.gauss.2016.nc','vwnd');

%convert NCEP time to useful MATLAB datenum
% NCEP_datevec=datevec(datenum(1800,1,1) + (NCEP_time/24));
%for 2016 Berg dataset find the timepoint closest
NCEP_DT=(datenum(1800,1,1) + (NCEP_time/24));
time_ind=[];
for k=1:length(Berg16_co2_dt);
    [~, i]=min(abs(NCEP_DT-Berg16_co2_dt(k)));
    time_ind(k)=i;
end

%for 2016 Berg dataset find the latitude and longitude closest
%note this is slow because of pos2dist calcs!
lat_ind=[];long_ind=[];
for m=1:length(Berg16_co2_dt);
    for n=1:length(NCEP_lat)
        for p=1:length(NCEP_long)
            distx(n,p)= pos2dist(Berg16_co2_Latitude(m),Berg16_co2_Longitude(m),NCEP_lat(n),NCEP_long(p),1);

        end
    end
            [min_val,idx]=min(distx(:));
            [row,col]=ind2sub(size(distx),idx);
            lat_ind(m)=row;
            long_ind(m)=col;
            m;
end

Berg16_co2_u=[];
Berg16_co2_v=[];

for v=1:length(long_ind);
Berg16_co2_u(v)=NCEP_uwnd(long_ind(v),lat_ind(v),1,time_ind(v));
Berg16_co2_v(v)=NCEP_vwnd(long_ind(v),lat_ind(v),1,time_ind(v));

end



 %inputs
 Berg16_co2_u10=((Berg16_co2_u.^2)+(Berg16_co2_v.^2)).^0.5;
 % wind speed m/s
 T=Berg16_co2_SST_1m;%temperature in degrees celsius (-0.17 degrees for the skin inclusive above)
 deltaCO2=Berg16_co2_pco2_surface-Berg16_co2_atmCO2; % in micro atm, this is (sea-air) where negative flux is into ocean
 Tk=T+273.15-0.17; %temperature in kelvin (-0.17 degrees for the skin)
 S=Berg16_co2_TSG_s;%salinity (plus 0.1 psu for the skin inclusive above)
 

 %equations
 k660=((0.222*(Berg16_co2_u10.^2)) +(0.333*Berg16_co2_u10))';%from nightingale 2000
 
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
 Berg16_co2_FCO2_mmol_per_m2_per_d=Kw.*k0.*deltaCO2.*scal1; %Units of mmol m-2 d-1
 
 figure(89)
 plot(Berg16_co2_FCO2_mmol_per_m2_per_d)
 
 
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
 days_since_ice=nan(1,length(Berg16_co2_dt));
 Berg_year=char('2016');
 
 for ice_loop=1:length(Berg16_co2_dt)
 
 %first open the first file and find the closest point    

 %get the date info and open appropriate satellite data
 [year_ice,month_ice,day_ice,~,~,~]=datevec(Berg16_co2_dt(ice_loop));
 %loop through folders to find files
 months_names= char({'jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec'});
 %locate the appropriate daily file based on month and day
 grid_ice_conc = hdfread(char({['C:\Users\rps207\Documents\Data\Sea ice\ASMR2 - 3.125km\' Berg_year '\' months_names(month_ice,:) '\Arctic3125\asi-AMSR2-n3125-' Berg_year sprintf('%02d',month_ice) sprintf('%02d',day_ice) '-v5.4.hdf']}),'ASI Ice Concentration'); %read file
 %for each loop get lat and long to match
 ice_find_lat=Berg16_co2_Latitude(ice_loop);
 ice_find_long=Berg16_co2_Longitude(ice_loop);
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
%  u=smooth(x,140);

% figure(45)
% plot(site_ice_conc_each_day,'*');
% hold on
% plot(x,'r-')
% fixplot1('%1.8f')
% plot(u,'y-');
% 
close all
[y, l]=findpeaks(x,'MINPEAKHEIGHT',80);
[~, d]=minpositive(220-l);
l(d);%this is day of year from which sea ice starts to decline 

[fff, ~]=find(x<85);%find values below 85% sea ice

[gg, ggg]=minpositive(fff-l(d));
doy_ice_sub85=fff(ggg);%this is the day when it drops below 85%
doy_sample = Berg16_co2_dt(ice_loop) - datenum(str2num(Berg_year),1,1) + 1;%sample collected on

days_since_ice(ice_loop)=doy_sample-doy_ice_sub85;
ice_loop
 end
Berg16_days_since_ice=days_since_ice';

clearvars  l molality osmotic_coef temp_mod vapor_0sal_kPa
clearvars c d e temp_matchup_tsg temp_matchup sal_matchup CTDtemp_1m CTDsal_1m CTDdt_1m CTDdepth_1m CTD_TEMP_1m CTD_SAL_1m CTD_DT_1m CTD_DEPTH_1m CTD_casts_2018 Berg
clearvars Latitude Longitude n_records Flowrate H20_ppt Chl CO2_ppm Dt Dt_doy Flour Cell_p Cell_t TSG_t TSG_s Temp_v Temp_c Skin_temp Sea_temp Scatter Pres_v Pres_kpa ph_volt ph_temp ph_avg pcr300_temp
clearvars CTD_casts_2016 temp_matchup_sea_temp CTD_casts_16 CTDtemp_2m CTDtemp_1_5m CTDtemp_0_5m CTD_TEMP_2m CTD_TEMP_1_5m CTD_TEMP_0_5m CTD_casts_16temp_matchup_sea_temp n m labelcat k j ind_removal CTDsal_2m CTDsal_1_5m CTDsal_0_5m CTD_casts_2016b  BCO2te deltaCO2te mfileDir path_cr300 path_eco path_pco2 path_tsg R TSG_e vapor_press_kPa Vapour_pressure_atm Vapour_pressure_mbar CTD_casts_2019 CTD_SAL_0_5m CTD_SAL_1_5m CTD_SAL_2m ans
clearvars NCEP_vwnd A A1 A2 A3 B B1 B2 B3 x NCEP_lat NCEP_long NCEP_time NCEP_uwnd p row S Sc scal1 Schdep T time_ind Tk u u10 v C coeffvals col D deltaCO2 distx E i idx k0 k660 Kw lat_ind long_ind min_val NCEP_DT
    
save('2016_undpCO2_proc.mat')
    
    

 
