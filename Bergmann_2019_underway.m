%work up Bergmann underway data 2019
%% Reset workspace
clc;  clear all ; close all; %reset workspace
%% Designate - Function paths and directories
%add directories of functions that maybe needed - probably not required.
addpath('c:\Users\rps207\Documents\Matlab\Functions');
addpath('c:\Users\rps207\Documents\Matlab\Functions\Add_Axis');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cbdate');
addpath('c:\Users\rps207\Documents\Matlab\Functions\mixing_library');
addpath('c:\Users\rps207\Documents\Matlab\Functions\despiking_tooblox');
addpath('c:\Users\rps207\Documents\Matlab\Functions\cm_and_cb_utilities');
addpath('c:\Users\rps207\Documents\Matlab\Functions\tsplot');
%% Designate - File directories
%directories of files
mfileDir = 'C:\Users\rps207\Documents\MATLAB\2019 - Bergmann pCO2 2016 -2019\'; %path for main matlab analysis
path_pco2 = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2019\Raw\SuperCO2\pCO2';%identify file path
path_eco = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2019\Raw\SuperCO2\ECO';%identify file path
path_tsg = 'C:\Users\rps207\University of Calgary\Brent Else - OneDrive_ElseLab\Data_new_2019\Underway\Bergmann\2019\Raw\SuperCO2\TSG';%identify file path
path_cr300=[];
%% Load - CO2 files
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

[ o p ]=sort(Velp);

 Time=[];Date=[];GPS_lon=[];GPS_lat=[];TSG_e=[];Valvepos=[];IO3=[];IO4=[];IO5=[];Pres_v=[];Temp_v=[];Pres_kpa=[];Temp_c=[];
    Cell_p=[];Cell_t=[];H20_ppt=[];CO2_ppm=[];DOY_utc=[];TSG_s=[];TSG_t=[];TSG_e=[];Valvepos=[];
    
    
for i = p
    fNamex = char(fList_pco2(i,:));
    delimiter = '\t';
    startRow = 5;
    formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
    fName = [fNamex];
    fileID = fopen(fName,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
    for col=1:length(dataArray)-1;
        raw(1:length(dataArray{col}),col) = dataArray{col};
    end
    numericData = NaN(size(dataArray{1},1),size(dataArray,2));
    for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];
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
    R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
    raw(R) = {NaN}; % Replace non-numeric cells
    doy_utc = cell2mat(raw(:, 1));
    co2_ppm = cell2mat(raw(:, 2));
    co2_abs = cell2mat(raw(:, 3));
    h20_ppt = cell2mat(raw(:, 4));
    H20_abs = cell2mat(raw(:, 5));
    cell_t = cell2mat(raw(:, 6));
    cell_p = cell2mat(raw(:, 7));
    pwrV820 = cell2mat(raw(:, 8));
    temp_c = cell2mat(raw(:, 9));
    pres_kpa = cell2mat(raw(:, 10));
    temp_v = cell2mat(raw(:, 11));
    pres_v = cell2mat(raw(:, 12));
    io3 = cell2mat(raw(:, 13));
    io4 = cell2mat(raw(:, 14));
    io5 = cell2mat(raw(:, 15));
    valvepos = cell2mat(raw(:, 16));
    tsg_t = cell2mat(raw(:, 17));
    tsg_s = cell2mat(raw(:, 18));
    tsg_e = cell2mat(raw(:, 19));
    gps_lat = cell2mat(raw(:, 20));
    gps_lon = cell2mat(raw(:, 21));
    date = cell2mat(raw(:, 22));
    time = cell2mat(raw(:, 23));
    clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
    
    Time=[Time ; time];
    Date=[Date ; date];
    GPS_lon=[GPS_lon ; gps_lon];
    GPS_lat=[GPS_lat ; gps_lat];
    TSG_e=[TSG_e ; tsg_e];
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
    %DOY_utc=[DOY_utc ; doy_utc];
    
    clearvars date gps_lon gps_lat tsg_e tsg_s  tsg_t valvepos io3 io5 io4 pres_v temp_v pres_kpa temp_c cell_p cell_t h20_ppt co2_ppm doy_utc];
    
end

%DATA CONVERSIONS and QC

%convert GPS LAT and LONG to usable decimal degrees
lat_deg=floor(GPS_lat/100);
lat_min=(floor(((GPS_lat/100)-lat_deg)*100))./60;
lat_sec=(1/60)*((((GPS_lat/100)-lat_deg)*100)-(floor(((GPS_lat/100)-lat_deg)*100)));
Latitude=lat_deg+lat_min+lat_sec;

GPS_lon=-1*GPS_lon;
lon_deg=floor(GPS_lon/100);
lon_min=(floor(((GPS_lon/100)-lon_deg)*100))./60;
lon_sec=(1/60)*((((GPS_lon/100)-lon_deg)*100)-(floor(((GPS_lon/100)-lon_deg)*100)));
Longitude=-1*(lon_deg+lon_min+lon_sec);

clearvars lon_deg lon_deg lon_min lon_sec lat_sec lat_min lat_deg GPS_lat GPS_lon D



%for all variables find nan values
[row1, ~] = find(isnan(Time));
[row2, ~] = find(isnan(Date));
[row3, ~] = find(isnan(TSG_s));
[row4, ~] = find(isnan(Longitude));
[row5, ~] = find(isnan(Latitude));
[row6, ~] = find(isnan(TSG_s));
[row7, ~] = find(isnan(TSG_e));
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

%also look for the 5 or so rows where GPS screwed up!
[row22, ~] =find(Latitude<10);
[row23, ~] =find(Latitude>90);
[row24, ~] =find(Longitude>-50);

%concatenate nan rows for all variables
nanrows=[row1;row2;row3;row4;row5;row6;row7;row8;row9;row10;row11;row12;row13;row14;row15;row16;row17;row18;row19;row20;row21;row22;row23;row24];
nanrowsunq=unique(nanrows); %find only unique rows - note this is only 265 rows of 13831
clearvars nanrows row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12 row13 row14 row15 row16 row17 row18 row19 row20 row21

%remove these rows from data
    Time(nanrowsunq)=[];
    Date(nanrowsunq)=[];
    Longitude(nanrowsunq)=[];
    Latitude(nanrowsunq)=[];
    TSG_e(nanrowsunq)=[];
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
    %DOY_utc(nanrowsunq)=[];

%there are no dashes for time add these for clarity!
Date_char=num2str(Date); %convert to char for concatination
Date_cell={};
%add first bracket
for K=1:length(Date_char);
        A= strtrim(regexprep(Date_char(K,:), '.{4}', '$0/','once'));
        Date_cell(K,:)=cellstr(A);
end
%Add second bracket
Date_cell2={}
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
Jan1_serial = datenum([2019, 1, 1, 0, 0, 0]); %define first day of year
Dt_doy= Dt - Jan1_serial + 1;%    %convert date to doy (day of year)
clear Time_cell Time_char Time_char2 H20_abs Jan1_serial DOY_utc H20_abs Dt_Cat Date Time ans A iRow nanrows nanrowsunq B C Date_char fList fList_pco2 cv col row Date_cell Date_cell2 Index IndexC K mA i k o p time x doy_utc fname_cellstr fNamex fname_char fname_cellstr Velp fList_entry_num length_ent co2_abs micro_ pwrV820
%% Load - ECO files
%eco not logging to pco2 file-import seperately , loop through underway files and 
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
[~,ia]=unique(Dt_ECO);

Flour_ECO=Flour_ECO(ia);
Dt_ECO = Dt_ECO(ia);
Chl_ECO = Chl_ECO(ia);
Scatter_ECO = Scatter_ECO(ia);


%interp to same length as other variables
Chl= interp1(Dt_ECO,Chl_ECO,Dt); %interpolate onto pco2 time
Flour= interp1(Dt_ECO,Flour_ECO,Dt); %interpolate onto pco2 time
Scatter= interp1(Dt_ECO,Scatter_ECO,Dt); %interpolate onto pco2 time

clearvars Scatter_ECO ia Flour_ECO Eco_time Eco_date Dt_ECO Chl_ECO C fname_char path fName fList_entry_num flour fNamex u v Velp w x y z scatter o p  aa ab eco_time eco_doyutc eco_date fList fList_ECO fList_pco2 chl H20_abs i Index IndexC iRow k length_ent
%% Load - TSG files
%NOTE INLINE TEMPERATURE SENSOR NOT LOGGING TO PCO2- IN TSG FILE
cd(path_tsg); %change current directory to folder with files want to load
fList = dirPlus(path_tsg) ;
iRow=[];

%select only co2 files
IndexC = strfind(fList,'desktop.ini'); %necessary to first remove ini file
Index = find(not(cellfun('isempty',IndexC)));
fList(Index)=[]; %remove that file
IndexC = strfind(fList,'TSG');%find only TSG files
Index = find(not(cellfun('isempty',IndexC)));
fList_TSG=fList(Index); 

%loop through files and extract identifier from end of files
Velp=[];
fList_entry_num=size(fList_TSG);
for k=1:fList_entry_num(1,1);
    fname_char=char(fList_TSG(k,:));
    length_ent=length(fname_char);
    x=str2double(fname_char(:,length_ent-11:length_ent-4));
    Velp(k)=x;
end

[ ~, p ]=sort(Velp);
TSG_sea_temp=[]; TSG_date=[];TSG_time=[];TSG_doy=[];

for i = p;
fNamex = char(fList_TSG(i,:));
fName = [fNamex];
fileID = fopen(fName,'r');
delimiter = ' ';
startRow = 5;
formatSpec = '%s%s%s%s%s%s%s%s%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1;
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4,5,6,7];
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
rawNumericColumns = raw(:, [1,2,3,4,5,6,7]);
rawCellColumns = raw(:, 8);
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
% Allocate imported array to column variable names
tsg_doy = cell2mat(rawNumericColumns(:, 1)); % dont need already have date an time
% tsg_temp = cell2mat(rawNumericColumns(:, 2));already have these
% tsg_cond = cell2mat(rawNumericColumns(:, 3)); already have these
% tsg_sal = cell2mat(rawNumericColumns(:, 4));already have these
tsg_sea_temp = cell2mat(rawNumericColumns(:, 5));
tsg_date = cell2mat(rawNumericColumns(:, 6));
tsg_time = cell2mat(rawNumericColumns(:, 7));
% VarName8 = rawCellColumns(:, 1); empty

%Eco_doyutc=[Eco_doyutc ; eco_doyutc];
TSG_sea_temp=[TSG_sea_temp ; tsg_sea_temp];
TSG_date=[TSG_date ; tsg_date];
TSG_time=[TSG_time ; tsg_time];
TSG_doy=[TSG_doy ; tsg_doy];

end

clearvars tsg_date tsg_sea_temp tsg_time filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;

%for all variables find nan values
[row1, ~] = find(isnan(TSG_sea_temp));
[row2, ~] = find(isnan(TSG_date));
[row3, ~] = find(isnan(TSG_time));
[row4, ~] = find(isnan(TSG_doy));

%these need to be removed
[row5, ~] = find(TSG_sea_temp<2);

%concatenate nan rows for all variables
nanrows=[row1;row2;row3;row4;row5];
nanrowsunq=unique(nanrows); %find only unique rows - note this is only 265 rows of 13831
clearvars nanrows row1 row2 row3 row4 row5 row6 row7 row8 row9 row10 row11 row12 row13 row14 row15 row16 row17 row18 row19 row20 row21

%remove these rows from TSG data
    TSG_sea_temp(nanrowsunq)=[];
    TSG_date(nanrowsunq)=[];
    TSG_time(nanrowsunq)=[];
    TSG_doy(nanrowsunq)=[];


Dt_temp=datetime('1-Jan-2019')+TSG_doy-1; % This code will give the date of the 'N'th day.
Dt_TSG=datenum(Dt_temp);

%note that there are several duplicate entries 
[~,ia]=unique(Dt_TSG);
Dt_TSG=Dt_TSG(ia);
TSG_sea_temp = TSG_sea_temp(ia);

%interp to same length as other variables
Sea_temp= interp1(Dt_TSG,TSG_sea_temp,Dt); %interpolate onto pco2 time
clear ia fList_TSG Dt_TSG IO3 IO4 IO5 TSG_date TSG_time TSG_sea_temp startRow flour fList_ECO eco_time eco_doyutc Eco_doyutc eco_date chl fName row22 row23 row24 scatter Time_cell Time_char Time_char2 H20_abs Jan1_serial DOY_utc H20_abs Dt_Cat Date Time ans A iRow nanrows nanrowsunq B C Date_char fList fList_pco2 cv col row Date_cell Date_cell2 Index IndexC K mA i k o p time x doy_utc fname_cellstr fNamex fname_char fname_cellstr Velp fList_entry_num length_ent co2_abs micro_ pwrV820

%these may become filled once i have the CR300 files
Skin_temp=nan(length(Latitude),1);
ph_volt=nan(length(Latitude),1);
ph_temp=nan(length(Latitude),1);
ph_avg=nan(length(Latitude),1);
pcr300_temp=nan(length(Latitude),1);
Flowrate=nan(length(Latitude),1);
%% Save - raw data
cd(mfileDir)
save('2019_und.mat')


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
datevec(Dt(ind_co2_samp(c)));
%% Plot - raw xCO2 data
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
%% Plot - Salinity
%also plot temp and salinity for bad data
figure(11)
plot(Dt(ind_co2_meas),TSG_s(ind_co2_meas),'*');
dynamicDateTicks([], [], ' mm/dd');
%% Plot - Temperature
figure(12)
plot(Dt(ind_co2_meas),Temp_c(ind_co2_meas),'*');
dynamicDateTicks([], [], ' mm/dd');

%Samples after std3 - remove first 7 points
c_meas=find(diff(ind_co2_meas) ~= 1) + 1;
for i=1:length(c_meas);
    CO2_ppm(ind_co2_meas(c_meas(i)-1:c_meas(i)+7))=nan;
end
%% QC - remove data that can't be calibrated with standards
%remove times where the co2 edges where there are no standards bounding the
%data
temp_cutoutsrt= datenum('2019-08-09 17:04:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2019-08-09 17:40:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove times where the co2 jumps for some reason
temp_cutoutsrt= datenum('2019-08-11 01:53:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2019-08-11 02:31:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove times where the co2 jumps for some reason
temp_cutoutsrt= datenum('2019-08-13 02:27:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2019-08-13 16:58:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove times where the co2 jumps for some reason
temp_cutoutsrt= datenum('2019-08-21 03:46:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2019-09-16 15:42:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obvious data spikes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%remove times where the co2 jumps for some reason
temp_cutoutsrt= datenum('2019-08-15 00:05:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2019-08-15 00:12:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;

%remove times where the co2 jumps for some reason
temp_cutoutsrt= datenum('2019-08-14 14:19:00','yyyy-mm-dd HH:MM:SS');
temp_cutoutend= datenum('2019-08-14 14:22:00','yyyy-mm-dd HH:MM:SS');
tmp = abs(Dt-temp_cutoutsrt);
[~, tempoutind] = min(tmp); %index of closest value
tmp2 = abs(Dt-temp_cutoutend);
[~, tempbackind] = min(tmp2); %index of closest value
CO2_ppm(tempoutind:tempbackind)=nan;


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

%remove double standard here rgese are not removed in the step to find the
%flush/end point of the standard runs
[t , ~]=find(ind_co2_samp1_end==1200);
ind_co2_samp1_end(t)=[];

[t , ~]=find(ind_co2_samp2_end==13300);
ind_co2_samp2_end(t)=[];


[t , ~]=find(ind_co2_samp3_end==9700);
ind_co2_samp3_end(t)=[];
[t , ~]=find(ind_co2_samp3_end==10100);
ind_co2_samp3_end(t)=[];
[t , ~]=find(ind_co2_samp3_end==10500);
ind_co2_samp3_end(t)=[];
[t , ~]=find(ind_co2_samp3_end==10900);
ind_co2_samp3_end(t)=[];
[t , ~]=find(ind_co2_samp3_end==11300);
ind_co2_samp3_end(t)=[];
[t , ~]=find(ind_co2_samp3_end==11700);
ind_co2_samp3_end(t)=[];
[t , ~]=find(ind_co2_samp3_end==12100);
ind_co2_samp3_end(t)=[];
[t , ~]=find(ind_co2_samp3_end==12500);
ind_co2_samp3_end(t)=[];




figure(2)
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
plot(Dt(ind_co2_atm),CO2_ppm(ind_co2_atm),'g*');
plot(Dt(ind_co2_samp1),CO2_ppm(ind_co2_samp1),'r*');
% plot(Dt(ind_co2_samp1_end),CO2_ppm(ind_co2_samp1_end),'m*');
plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'rs');
% plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
plot(Dt(ind_co2_samp3),CO2_ppm(ind_co2_samp3),'rs');
dynamicDateTicks([], [], ' mm/dd');
legend('xco2','atm co2','std1','std2')
title('FIGURE 2 - OUTLIERS QC Berg pCO2 data')
%% QC - remove bad standards
%now remove the standards when the system is being flushed and atmospheric
%CO2
CO2_ppm(ind_co2_atm)=nan;
CO2_ppm(ind_co2_samp1_flush)=nan;
CO2_ppm(ind_co2_samp2_flush)=nan;
CO2_ppm(ind_co2_samp3_flush)=nan;
clearvars ans c f i c_meas p tempbackind tempoutind temp_cutoutend temp_cutoutsrt v

%ignore the nans otehrwise this ruins the calibration!
b=~(isnan(CO2_ppm(ind_co2_samp1_end)));
ind_co2_samp1_end=ind_co2_samp1_end(b);

b=~(isnan(CO2_ppm(ind_co2_samp2_end)));
ind_co2_samp2_end=ind_co2_samp2_end(b);

b=~(isnan(CO2_ppm(ind_co2_samp3_end)));
ind_co2_samp3_end=ind_co2_samp3_end(b);

%to avoid no calibration at the end make the last point a standard with the
%same value
CO2_ppm(13553)=CO2_ppm(ind_co2_samp1_end(end));
ind_co2_samp1_end=[ind_co2_samp1_end;13553];
CO2_ppm(13554)=CO2_ppm(ind_co2_samp2_end(end));
ind_co2_samp2_end=[ind_co2_samp2_end;13554];
CO2_ppm(13555)=CO2_ppm(ind_co2_samp3_end(end));
ind_co2_samp3_end=[ind_co2_samp3_end;13555];

ind_co2_meas(12174:12178)=[];
%% Plot - raw xCO2 data with standards labelled
figure(3)
plot(Dt(ind_co2_meas),CO2_ppm(ind_co2_meas),'*');
hold on
% plot(Dt(ind_co2_samp2),CO2_ppm(ind_co2_samp2),'b*');
plot(Dt(ind_co2_samp1_end),CO2_ppm(ind_co2_samp1_end),'m*');
plot(Dt(ind_co2_samp2_end),CO2_ppm(ind_co2_samp2_end),'ms');
plot(Dt(ind_co2_samp3_end),CO2_ppm(ind_co2_samp3_end),'mo');
dynamicDateTicks([], [], ' mm/dd');
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
%% main loop to do the calibrations here
%super co2 records as pCO2 but we want xco2 for water vapour correction
Berg19_co2_CO2umm=CO2_ppm;
Berg19_co2_dt=Dt;

% main loop to do the calibrations here
% for every interval between standards
% loop through and calibrate between this and the next set of standards
    Berg19_co2_CO2umm_cal=[];
    for z=1:(length(ind_co2_samp2_end)-1); %for each set of standards
        calstart_STD1Ind = ind_co2_samp1_end(z);
        calstart_STD2Ind = ind_co2_samp2_end(z);
        calstart_STD3Ind = ind_co2_samp3_end(z);

        calend_STD1Ind = ind_co2_samp1_end(z+1);
        calend_STD2Ind = ind_co2_samp2_end(z+1);
        calend_STD3Ind = ind_co2_samp3_end(z+1);
        
    for y=calstart_STD3Ind+1:calend_STD1Ind-1; % for the number of measurements between standards
    %from dickson 2007 p 100
    interpolatedstd1=Berg19_co2_CO2umm(calstart_STD1Ind)+(((Berg19_co2_CO2umm(calend_STD1Ind)-Berg19_co2_CO2umm(calstart_STD1Ind)).*(( (Berg19_co2_dt(y)) -(Berg19_co2_dt(calstart_STD1Ind)))./(Berg19_co2_dt(calend_STD3Ind)-Berg19_co2_dt(calstart_STD1Ind)))));
    interpolatedstd2=Berg19_co2_CO2umm(calstart_STD2Ind)+(((Berg19_co2_CO2umm(calend_STD2Ind)-Berg19_co2_CO2umm(calstart_STD2Ind)).*(( (Berg19_co2_dt(y)) -(Berg19_co2_dt(calstart_STD1Ind)))./(Berg19_co2_dt(calend_STD3Ind)-Berg19_co2_dt(calstart_STD1Ind)))));
    interpolatedstd3=Berg19_co2_CO2umm(calstart_STD3Ind)+(((Berg19_co2_CO2umm(calend_STD3Ind)-Berg19_co2_CO2umm(calstart_STD3Ind)).*(( (Berg19_co2_dt(y)) -(Berg19_co2_dt(calstart_STD1Ind)))./(Berg19_co2_dt(calend_STD3Ind)-Berg19_co2_dt(calstart_STD1Ind)))));
    interpolatedvec=[interpolatedstd1,interpolatedstd2,interpolatedstd3];

    %THESE ARE NOT FINAL! 
    
    truestd=[0 250 450];
    %calculate the linear fit for each data point
    c = polyfit(interpolatedvec,truestd,1);
    slopes=c(1);
    intercept=c(2);
    Berg19_co2_CO2umm_cal(y)=(Berg19_co2_CO2umm(y).*slopes)+intercept; 
    end
    end
    
    Berg19_co2_CO2umm_cal=Berg19_co2_CO2umm_cal';
    %pad out the end of the matrix with NaN where there wasn't a standard at the end
    Berg19_co2_CO2umm_cal(13556:46795)=NaN;
    
%outliers at beggining where pressure is 0!!
Berg19_co2_CO2umm_cal(1:9)=nan;  

%remove calibrations from the co2 matrix
Berg19_co2_CO2umm_cal(ind_co2_atm)=NaN;
Berg19_co2_CO2umm_cal(ind_co2_samp1)=NaN;
Berg19_co2_CO2umm_cal(ind_co2_samp1_end)=NaN;
Berg19_co2_CO2umm_cal(ind_co2_samp2)=NaN;
Berg19_co2_CO2umm_cal(ind_co2_samp2_end)=NaN;
Berg19_co2_CO2umm_cal(ind_co2_samp3)=NaN;
Berg19_co2_CO2umm_cal(ind_co2_samp3_end)=NaN;
 %% Plot - calibrated xCO2 and standards   
figure(4)
plot(Berg19_co2_dt(ind_co2_meas),Berg19_co2_CO2umm(ind_co2_meas),'bo');
hold on
plot(Berg19_co2_dt(ind_co2_samp1_end),Berg19_co2_CO2umm(ind_co2_samp1_end),'m*');
plot(Berg19_co2_dt(ind_co2_samp2_end),Berg19_co2_CO2umm(ind_co2_samp2_end),'ms');
plot(Berg19_co2_dt(ind_co2_samp3_end),Berg19_co2_CO2umm(ind_co2_samp3_end),'mo');
plot(Berg19_co2_dt(ind_co2_meas),Berg19_co2_CO2umm_cal(ind_co2_meas),'ko');
legend('xco2' ,'std1', 'std2','std3', 'xco2cal')
title('FIGURE 4 - QC plus standard calibration - Berg pCO2 data')
dynamicDateTicks([], [], ' mm/dd');
%% Plot - calibrated xCO2 
%final xCO2 data
figure(41)
plot(Berg19_co2_dt,Berg19_co2_CO2umm_cal,'ko');
clearvars ind_co2_meas ind_co2_samp negind y z Valvepos truestd slopes calend_STD2Ind calstart_STD2Ind ind_co2_atm ind_co2_samp1 ind_co2_samp2 ind_co2_samp2_end ind_co2_samp2_final ind_co2_samp2_flush ind_co2_samp2_flushing ind_co2_samp3 intercept interpolatedstd2 interpolatedvec l std_make_nan stdfiltind t
clearvars ans c f i c_meas p tempbackind tempoutind temp_cutoutend temp_cutoutsrt v
clearvars tempbackind tmp2 tmp tempoutind temp_cutoutend temp_cutoutsrt b calend_STD1Ind calend_STD3Ind calstart_STD1Ind calstart_STD3Ind ind_co2_samp1_end ind_co2_samp1_final ind_co2_samp1_flush ind_co2_samp1_flushing ind_co2_samp3_end ind_co2_samp3_final ind_co2_samp3_flush ind_co2_samp3_flushing interpolatedstd1 interpolatedstd3 mfileDir path_cr300 path_eco path_pco2 path_tsg
%% QC - remove calibrations from the co2 matrix
%bad point not caught by previous QC 
Berg19_co2_CO2umm_cal(3206)=nan;
%where co2 is nan make the other variables nan
b=(isnan(Berg19_co2_CO2umm_cal));
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
%% Load - Bergmann  CTD data to cross correlate temp from CTD 

%cross correlate temp from CTD 
%load in Bergmann matlab CTD structure 

load('C:\Users\rps207\Documents\MATLAB\2019 - Bergmann carbonate transects 2016-2019\Processed data/Bergmann.mat','Berg')

CTD_casts_2019=fieldnames(Berg.year_2019); %names of the stations
CTD_casts_2019=CTD_casts_2019(1:end-2); %y4 and y5 not completed casts!

CTD_TEMP_0_5m=[];CTD_TEMP_1m=[];CTD_TEMP_1_5m=[];CTD_TEMP_2m=[];CTD_DEPTH_1m=[];CTD_DT_1m=[];
CTD_SAL_0_5m=[];CTD_SAL_1m=[];CTD_SAL_1_5m=[];CTD_SAL_2m=[];

for w=1:numel(CTD_casts_2019); 
        ghj = Berg.year_2019.([CTD_casts_2019{w}']); 
        [~, f]=size(ghj);
        for h=1:f
        %these are binned
        CTDtemp_0_5m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Temp_dwncst_intp(5);
        CTDtemp_1m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Temp_dwncst_intp(10);
        CTDtemp_1_5m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Temp_dwncst_intp(15);
        CTDtemp_2m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Temp_dwncst_intp(20);

       
        CTDdepth_1m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Depth_dwncst_intp(10);
        %this time is not super accurate (+/- a couple mins max) but is fine for this 
        CTDdt_1m=datenum(Berg.year_2019.([CTD_casts_2019{w}'])(h).DT_str(end),'dd-mmm-yyyy HH:MM:SS');
        
        CTDsal_0_5m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Sal_dwncst_intp(5);
        CTDsal_1m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Sal_dwncst_intp(10);
        CTDsal_1_5m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Sal_dwncst_intp(15);
        CTDsal_2m=Berg.year_2019.([CTD_casts_2019{w}'])(h).Sal_dwncst_intp(20);

        
        % store 
        if CTDdt_1m>datenum([2019 08 09 17 32 00])
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
        else
        %dont store the Quest was in port! we were on the Jenny!
        end
        end
end
clearvars w ghj f h

temp_matchup_tsg=[]; temp_matchup=[];temp_matchup_sea_temp=[];sal_matchup=[];
for b=1:length(CTD_DT_1m);
[n m]=min(abs(CTD_DT_1m(b)-Berg19_co2_dt));
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

l=~(isnan(CTD_TEMP_1m));
 c = polyfit(temp_matchup(l),CTD_TEMP_1m(l),1);
 
 l=~(isnan(CTD_TEMP_1m));
 d = polyfit(temp_matchup_tsg(l),CTD_TEMP_1m(l),1);
 
  l=~(isnan(CTD_TEMP_1m)) & ~(isnan(temp_matchup_sea_temp));
 j = polyfit(temp_matchup_sea_temp(l),CTD_TEMP_1m(l),1);
 %% Plot - equilibrator temp and CTD temp 
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
%% Correlate - underway salinity vs CTD salinity 
 l=~(isnan(CTD_SAL_1m));
 e = polyfit(sal_matchup(l),CTD_SAL_1m(l),1);
 %% Plot - underway salinity vs CTD salinity 
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
plot (15:0.1:30,15:0.1:30,'k');
xlabel('rosette sal');
ylabel('underway sal');
xlim([15 30]);
ylim([15 30]);
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
%% Plot - temperature
figure(71)
plot(TSG_s,'k*')
legend('TSG s','Temp equ','sea probe');
ylabel('Sal')
xlabel('Measurement number')
%% Designate - output variables to save
% This is corrected SST from equilibrator temp.
Berg19_co2_equtemp=Temp_c;

%this is actual measured temp in situ water
Berg19_co2_SST_1m=Sea_temp;

% Berg19_co2_SST_1m=(Sea_temp*j(1))+j(2);
%other variables
Berg19_co2_Longitude=Longitude;
Berg19_co2_Latitude=Latitude;
Berg19_co2_Flowrate=Flowrate;
Berg19_co2_H20_ppt=H20_ppt;
Berg19_co2_Chl=Chl;
Berg19_co2_Flour=Flour;
Berg19_co2_Cell_p=Cell_p;
Berg19_co2_Cell_t=Cell_t;
Berg19_co2_TSG_t=TSG_t;
Berg19_co2_TSG_s=TSG_s;
Berg19_co2_Scatter=Scatter;
Berg19_co2_Pres_kpa=Pres_kpa;
%% QC - these instruments were not working
%these all seem to have bad data so will make them all nans here
Berg19_co2_ph_temp=nan(length(Berg19_co2_TSG_t),1);%bad
Berg19_co2_ph_avg=nan(length(Berg19_co2_TSG_t),1);%bad
Berg19_co2_pcr300_temp=nan(length(Berg19_co2_TSG_t),1);%bad
Berg19_co2_Skin_temp=nan(length(Berg19_co2_TSG_t),1); %bad
Berg19_co2_Sea_temp=nan(length(Berg19_co2_TSG_t),1);%bad
%% CO2 calculations  Part 1      %use Wagner and garb 2002 to get water vapour
    Berg19_co2_equtemp_kelvin=Berg19_co2_equtemp +273.15; %convert temperature into kelvin
    temp_mod = 1-Berg19_co2_equtemp_kelvin./647.096;
    vapor_0sal_kPa=(22.064e3)*(exp((647.076./(Berg19_co2_equtemp_kelvin)).*((-7.85951783*temp_mod)+((1.84408259)*(temp_mod.^(3/2)))+(-11.7866497*(temp_mod.^3))+(22.6807411*(temp_mod.^3.5))+(-15.9618719*(temp_mod.^4))+(1.80122502*(temp_mod.^7.5)))));
    %Correct vapor pressure for salinity
    molality = 31.998 * Berg19_co2_TSG_s ./(1e3-1.005*Berg19_co2_TSG_s);
    osmotic_coef = 0.90799 -0.08992*(0.5*molality) +0.18458*(0.5*molality).^2 -0.07395*(0.5*molality).^3 -0.00221*(0.5*molality).^4;
    vapor_press_kPa = vapor_0sal_kPa .* exp(-0.018 * osmotic_coef .* molality);
    Vapour_pressure_mbar = 10*(vapor_press_kPa);%Convert to mbar
    Vapour_pressure_atm=0.00098692327 .*Vapour_pressure_mbar;%convert to atm 1 millibar = 0.000986923267 atmosphere
 %% Add constants temperature and salinity constants to account for skin
    %add woolf 2016/2019 corrections for skin to salinity and temp
   Berg19_co2_SST_1m=Berg19_co2_SST_1m-0.17;
   Berg19_co2_TSG_s=Berg19_co2_TSG_s+0.1;
 %% CO2 calculations  Part 2  
    %use pressure from pco2 system
    Berg19_co2_Pres_mbar = 10*(Berg19_co2_Pres_kpa);%Convert to mbar
    Berg19_co2_Pres_atm= Berg19_co2_Pres_mbar *0.000986923; %convert from mb to atm
    Berg19_co2_Pres_pa= Berg19_co2_Pres_mbar *100; %convert from mb to pa
    %now simply multiple calibrated xco2 and pressure
    Berg19_co2_LicorpCO2= Berg19_co2_CO2umm_cal.*(Berg19_co2_Pres_atm);%
    %note we are not longer making a water vapour correction here. We had no dryer so assuming 100% humidity.
    BCO2te= -1636.75 + (12.0408*(Berg19_co2_equtemp_kelvin)) - (3.27957*0.01*(Berg19_co2_equtemp_kelvin).^2) + (3.16528*0.00001*(Berg19_co2_equtemp_kelvin).^3);%units of cm^3 mol^-1 ,determine the two viral coefficents of co2, (Dickson 2007) SOP 24 and p98 section 8.3 use equilibrator_pressure and equilibrator_temperature
    deltaCO2te= 57.7 - 0.118*( Berg19_co2_equtemp_kelvin); %units of cm^3 mol^-1
    R=8.31447; %specific gas constant J/Mol*K
    Berg19_co2_fco2= Berg19_co2_LicorpCO2.*exp(((BCO2te+(2*deltaCO2te))*0.000001.*(Berg19_co2_Pres_pa))./(R *Berg19_co2_equtemp_kelvin));%use viral coefficents to determine fco2
    Berg19_co2_fco2_surface=Berg19_co2_fco2.*exp(0.0423*(Berg19_co2_SST_1m - Berg19_co2_equtemp));%correction of co2 to sea surface temperature , (Dickson 2007) p98 8.4
    Berg19_co2_pco2_surface=Berg19_co2_LicorpCO2.*exp(0.0423*(Berg19_co2_SST_1m - Berg19_co2_equtemp));%correction of co2 to sea surface temperature , (Dickson 2007) p98 8.4
%% Plot - raw xCO2, calibrated xCO2, pCO2 equ, pCO2 sw, fCO2 sw
 figure(8)
 plot(Berg19_co2_dt,Berg19_co2_CO2umm,'k*')
 hold on
 plot(Berg19_co2_dt,Berg19_co2_CO2umm_cal,'m*')
 plot(Berg19_co2_dt,Berg19_co2_LicorpCO2,'y*')
 plot(Berg19_co2_dt,Berg19_co2_pco2_surface,'r*')
   
    plot(Berg19_co2_dt,Berg19_co2_fco2_surface,'g*')
    legend('pco2 surf','fco2 surf','pco2','xco2 cal','xco2 raw')
dynamicDateTicks([], [], 'mm/dd');
    
figure(9)
plot(Berg19_co2_dt,Berg19_co2_pco2_surface,'*')
dynamicDateTicks([], [], 'mm/dd');


%shorten where NaN
b=(isnan(Berg19_co2_pco2_surface));

 Berg19_co2_CO2umm(b)=[];
 Berg19_co2_dt(b)=[];
Berg19_co2_Longitude(b)=[];
Berg19_co2_Latitude(b)=[];
Berg19_co2_Flowrate(b)=[];
Berg19_co2_H20_ppt(b)=[];
Berg19_co2_Chl(b)=[];
Berg19_co2_Flour(b)=[];
Berg19_co2_Cell_p(b)=[];
Berg19_co2_Cell_t(b)=[];
Berg19_co2_TSG_t(b)=[];
Berg19_co2_TSG_s(b)=[];
Berg19_co2_Scatter(b)=[];
Berg19_co2_Pres_kpa(b)=[];
Berg19_co2_CO2umm_cal(b)=[]; 
Berg19_co2_equtemp(b)=[]; 
Berg19_co2_equtemp_kelvin(b)=[];
Berg19_co2_fco2(b)=[];
Berg19_co2_fco2_surface(b)=[];
Berg19_co2_LicorpCO2(b)=[]; 
Berg19_co2_pco2_surface(b)=[]; 
Berg19_co2_pcr300_temp(b)=[]; 
Berg19_co2_ph_avg(b)=[]; 
Berg19_co2_ph_temp(b)=[]; 
Berg19_co2_Pres_atm(b)=[]; 
Berg19_co2_Pres_mbar(b)=[]; 
Berg19_co2_Pres_pa(b)=[]; 
Berg19_co2_Sea_temp(b)=[]; 
Berg19_co2_Skin_temp(b)=[]; 
Berg19_co2_SST_1m(b)=[]; 



%%%%%%%%%%%%%%%%
% FLUX 2019
%%%%%%%%%%%%%%%%
%% Load - NETCDF NCEP data for wind
%import 

%2019
ncdisp('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2019.nc')
ncdisp('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/vwnd.10m.gauss.2019.nc')

NCEP_lat=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2019.nc','lat');
NCEP_long=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2019.nc','lon');
NCEP_time=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2019.nc','time');
NCEP_uwnd=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/uwnd.10m.gauss.2019.nc','uwnd');
NCEP_vwnd=ncread('C:\Users\rps207\Documents\Data\Field data\2021 - 01 - Bergmann pCO2/vwnd.10m.gauss.2019.nc','vwnd');

%convert NCEP time to useful MATLAB datenum
% NCEP_datevec=datevec(datenum(1800,1,1) + (NCEP_time/24));
%for 2016 Berg dataset find the timepoint closest
NCEP_DT=(datenum(1800,1,1) + (NCEP_time/24));
time_ind=[];
for k=1:length(Berg19_co2_dt);
    [~, i]=min(abs(NCEP_DT-Berg19_co2_dt(k)));
    time_ind(k)=i;
end

Berg19_co2_Longitude_0_360=Berg19_co2_Longitude;
%code to convert longitude from -180 to 180 , to, 0 360
for k=1:length(Berg19_co2_Longitude_0_360)
if Berg19_co2_Longitude_0_360(k)<0; Berg19_co2_Longitude_0_360(k)=Berg19_co2_Longitude_0_360(k)+360;
end
if Berg19_co2_Longitude_0_360(k)>360; Berg19_co2_Longitude_0_360(k)=Berg19_co2_Longitude_0_360(k)-360;
end
end

%for 2016 Berg dataset find the latitude and longitude closest
%note this is slow and a bit of a bottleneck but not the end of the world!
lat_ind=[];long_ind=[];distx=[];
for m=1:length(Berg19_co2_dt);
    for n=1:length(NCEP_lat)
        for p=1:length(NCEP_long)
            distx(n,p)= pos2dist(Berg19_co2_Latitude(m),Berg19_co2_Longitude_0_360(m),NCEP_lat(n),NCEP_long(p),2);
        end
    end
    [min_val,idx]=min(distx(:));
    [row,col]=ind2sub(size(distx),idx);
    lat_ind(m)=row;
    long_ind(m)=col;
    distx=[];
    m
end

%check the lat /long/time matchup
%matchup is not perfect

xu=NCEP_long(long_ind);
figure(1001)
plot(xu,'*')

xy=NCEP_lat(lat_ind);
figure(1002)
plot(xy,'*')

%extract wind
Berg19_co2_u=[];
Berg19_co2_v=[];

for v=1:length(long_ind);
Berg19_co2_u(v)=NCEP_uwnd(long_ind(v),lat_ind(v),1,time_ind(v));
Berg19_co2_v(v)=NCEP_uwnd(long_ind(v),lat_ind(v),1,time_ind(v));

end

%matchup is not perfect remove where it is using nans for pos2dist calc!
[a ~]=find(xy>80);
Berg19_co2_u10(a)=NaN;

[b ~]=find(xu<50);
Berg19_co2_u10(b)=NaN;

% %this works!
% xu=NCEP_DT(time_ind);
% figure(1003)
% plot(xu,'*')

Berg19_co2_u10=((Berg19_co2_u.^2)+(Berg19_co2_v.^2)).^0.5;

figure(10)
plot(Berg19_co2_u10);
%% Load - pCO2 air from Barrow Alaska
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
Berg19_co2_atmCO2=interp1(Barrow_DT,Barrow_pco2,Berg19_co2_dt);
clearvars a b c d e f z ans day month hour minute year second ar ai as ah ag af Barrow_DT Barrow_pco2
 %% Calculate - Air sea flux of CO2
 %inputs
 u10=Berg19_co2_u10;% wind speed m/s
 T=Berg19_co2_SST_1m;%temperature in degrees celsius (-0.17 degrees for the skin inclusive above)
 deltaCO2=Berg19_co2_pco2_surface-Berg19_co2_atmCO2; % in micro atm, this is (sea-air) where negative flux is into ocean
 Tk=T+273.15; %temperature in kelvin (-0.17 degrees for the skin)
 S=Berg19_co2_TSG_s;%salinity (plus 0.1 psu for the skin inclusive above)
 
 %equations
 k660=((0.222*(u10.^2)) +(0.333*u10))';%from nightingale 2000
 
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
 Berg19_co2_FCO2_mmol_per_m2_per_d=Kw.*k0.*deltaCO2.*scal1; %Units of mmol m-2 d-1

  figure(49)
subplot(2,1,1)
plot(Berg19_co2_dt,Berg19_co2_CO2umm_cal,'ko');
dynamicDateTicks([], [], 'mm/dd');
subplot(2,1,2)
plot(Berg19_co2_dt,Berg19_co2_Latitude,'ko');
 dynamicDateTicks([], [], 'mm/dd');
%% Get AMSR Sea ice concentration - very slow
%load AMSR grid
grid_fname=('C:\Users\rps207\Documents\Data\Sea ice\ASMR2 - 3.125km\LongitudeLatitudeGrid-n3125-Arctic3125.hdf');
grid_fileinfo = hdfinfo(grid_fname);
grid_lat = hdfread(grid_fname,'Latitudes');
grid_long_0_360 = hdfread(grid_fname,'Longitudes');
grid_long=wrapTo180(grid_long_0_360);
clear grid_long_0_360

days_since_ice=[]; 
 %sea ice
 days_since_ice=nan(1,length(Berg19_co2_dt));
 Berg_year=char('2019');
 
 for ice_loop=1:length(Berg19_co2_dt)
 
 %first open the first file and find the closest point    

 %get the date info and open appropriate satellite data
 [year_ice,month_ice,day_ice,~,~,~]=datevec(Berg19_co2_dt(ice_loop));
 %loop through folders to find files
 months_names= char({'jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec'});
 %locate the appropriate daily file based on month and day
 grid_ice_conc = hdfread(char({['C:\Users\rps207\Documents\Data\Sea ice\ASMR2 - 3.125km\' Berg_year '\' months_names(month_ice,:) '\Arctic3125\asi-AMSR2-n3125-' Berg_year sprintf('%02d',month_ice) sprintf('%02d',day_ice) '-v5.4.hdf']}),'ASI Ice Concentration'); %read file
 %for each loop get lat and long to match
 ice_find_lat=Berg19_co2_Latitude(ice_loop);
 ice_find_long=Berg19_co2_Longitude(ice_loop);
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
doy_sample = Berg19_co2_dt(ice_loop) - datenum(str2num(Berg_year),1,1) + 1;%sample collected on

days_since_ice(ice_loop)=doy_sample-doy_ice_sub85;
ice_loop
 end
  
Berg19_days_since_ice=days_since_ice';
Berg19_co2_u10=Berg19_co2_u10';
Berg19_co2_u=Berg19_co2_u';
Berg19_co2_v=Berg19_co2_v';

%% filter chlorophyll for bubbles and spikes
Berg19_co2_Chl_despike=medfilt1(Berg19_co2_Chl,20);
%% Delete temporary variable
clearvars amsr_day l molality osmotic_coef temp_mod vapor_0sal_kPa Dt_temp tsg_doy TSG_doy
clearvars c d e temp_matchup_tsg temp_matchup sal_matchup CTDtemp_1m CTDsal_1m CTDdt_1m CTDdepth_1m CTD_TEMP_1m CTD_SAL_1m CTD_DT_1m CTD_DEPTH_1m CTD_casts_2018 Berg
clearvars Latitude Longitude n_records Flowrate H20_ppt Chl CO2_ppm Dt Dt_doy Flour Cell_p Cell_t TSG_t TSG_s Temp_v Temp_c Skin_temp Sea_temp Scatter Pres_v Pres_kpa ph_volt ph_temp ph_avg pcr300_temp
clearvars k labelcat m n temp_matchup_sea_temp CTDsal_2m CTDtemp_0_5m CTDtemp_1_5m CTDtemp_2m j CTD_TEMP_0_5m CTD_TEMP_1_5m CTD_TEMP_2m CTDsal_0_5m CTDsal_1_5m b  BCO2te deltaCO2te mfileDir path_cr300 path_eco path_pco2 path_tsg R TSG_e vapor_press_kPa Vapour_pressure_atm Vapour_pressure_mbar CTD_casts_2019 CTD_SAL_0_5m CTD_SAL_1_5m CTD_SAL_2m ans
clearvars A A1 A2 A3 AA aaa B B1 B2 B3 bbb deltaCO2 C D E k0 k660 Kw NM numind p S Sc scal1 Schdep T Tk Tower_ts Tower_u10 Tower_u10n Tower_ws Tower_ws_avg u10 vb
clearvars abc col distx i idx lat_ind long_ind min_val NCEP_DT NCEP_lat NCEP_long NCEP_time NCEP_uwnd row time_ind v xu xy yu
clearvars NCEP_vwnd year_ice Berg_year coeffvals d day_ice days_since_ice dist doy_ice_sub85 doy_sample f fff filelist filelist_all_char filelist_all_str fListStruct full_index_col full_index_row gg ggg grid_fileinfo grid_fname grid_ice_conc grid_ice_conc_subset grid_lat grid_lat_subset grid_long grid_long_subset ice_column ice_find_lat ice_find_long ice_loop ice_row iceindex idxEmpty index_valid IndexC indexs_nonan l m month_ice month_ice_loop months_names n nanx posNonEmpty rootdir site_ice_conc_each_day subset subset1 t validIndices value_valid x y
%% Save - processed data
save('2019_undpCO2_proc.mat')

