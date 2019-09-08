%% Main_jPlay_Spectra_Evaluation.m
%
% ====== Short Description ======
% The Main_jPlay_Spectra_Evaluation.m is the driver of the evaluation of the 
% output wave spectra from jPlay, in comparison with in-situ spectra provided 
% by NDBC.
%
% ====== Input =======
% The following variables have to be set
% jPlayFilename     : Filename of the file with the jPlay spectrum
% nop               : No of nearest buoy requested 
% dist_km           : Maximum distance between the poi and known points.
% bool_flag         : Flag of plotting the spectrum.
% wdir.dwnld        : Directory to where to download the NDBC file
%
% ====== Output =======
% d1km      :
% ind       : 
% spec_insitu : 
% spec      :
% 
% ====== Input Files =======
%  - buoy_spec.mat : fix file with names and locations of the NDBC buoys
%  - netCDF file with most recent wave spectra from the nearest buoy. It is
%  downloaded during the runtime 
%
% ====== Output Files =======
% - N/A
% - Everything is in memory
%
% ====== Called functions ======
% list_of_fl
% nearest_point
% spec_import
% compile_spectrum
% 
% ============ TODO =============
%
%% License and more typicallities etc 
%   Copyright (C) 2018 Stylianos Flampouris
%   GNU Lesser General Public License
%       
%   Washington, DC, USA, Earth
%
%   For a copy of the GNU Lesser General Public License, 
%   see <http://www.gnu.org/licenses/>.
%
% =========================================================================
%

clear;clc;close all;
%% User defined input parameters
wdir.main = 'D:\jPlay\';
jPlayFilename = 'dwCal*';
% Hardcoded Lon/Lat and timestamp
[POILAT, POILON] = utm2deg_Palacios(401500, 3579500,  '11 R');
POITIME=datenum([2017,6, 18, 18, 43, 21]);
% 
nop = 1;
dist_km = 50;
% 
bool_flag=1;
dtheta=10;
%% Import jPlaySpectra
wdir.jPlay = [wdir.main,'jPlayOutput'];
jPlayFiles = list_of_fl (wdir.jPlay, jPlayFilename);

for i1=1:1:length(jPlayFiles)
    jPlaySpec(i1) = load([jPlayFiles(i1).folder,'\',jPlayFiles(i1).name], '-mat');
end

% notes
% jPlaySpec.Packet.Waves48.kx
%  jPlaySpec.Packet.Waves48.kx 
% jPlaySpec.Waves.Windwaves.SpectrumdB

%% import the list of buoys with spectra
load buoy_spec.mat

for i1=1:length(buoy)
    coor_buoy(i1,:) = buoy(i1).coor;
end

%% Find the buoys closest to the POI
[d1km,ind]=nearest_point(coor_buoy(:,2),coor_buoy(:,1),POILON,POILAT,nop,dist_km);

%% Download the ndbc spectra
wdir.dwnld=[wdir.main,'Download\'];

if exist(wdir.dwnld) ~= 7
    mkdir (wdir.dwnld)
end

for i1 = 1:length(ind)
    if ~isnan(ind(i1))
        url = ['https://dods.ndbc.noaa.gov/thredds/fileServer/data/swden/',buoy(ind(i1)).name,'/',buoy(ind(i1)).name,'w9999.nc'];
        local_name = [wdir.dwnld,buoy(ind(i1)).name,'w9999.nc'];
        outfile(i1).name = websave(local_name,url);
    end
end

%% Import the spectra
[spec_insitu] = spec_import(outfile);

% Closest in time

[min,idd] = min(abs(spec_insitu.time-POITIME));

spec = compile_spectrum ( spec_insitu(1).mean_wave_dir(:,idd)           ...
                        , spec_insitu(1).principal_wave_dir(:,idd)      ...
                        , spec_insitu(1).wave_spectrum_r1(:,idd)        ...
                        , spec_insitu(1).wave_spectrum_r2(:,idd)        ...
                        , spec_insitu(1).spectral_wave_density(:,idd)   ...
                        , spec_insitu(1).frequency                      ...
                        , dtheta                                        ...
                        , 0);
%% Plot insitu spec
figure, pcolor(spec_insitu(1).frequency,0:dtheta:359,spec')
%
%% jPlay Transformations

[KX,KY] = meshgrid(jPlaySpec.Packet.WavesA8.kx,jPlaySpec.Packet.WavesA8.ky);
[jPlaytheta,jPlayrho] = cart2pol(KX(:),KY(:));
jPlaytheta=rad2deg(reshape(jPlaytheta,size(KX)));
jPlayrho=reshape(jPlayrho,size(KY));

jPlaySpec.Packet.WavesA8.Windwaves.SpectrumdB(jPlaySpec.Packet.WavesA8.Windwaves.SpectrumdB==0)=NaN;
figure, pcolor(jPlaytheta,jPlayrho, jPlaySpec.Packet.WavesA8.Windwaves.SpectrumdB'); shading flat;


%% ================= EoF Main_jPlay_Spectra_Evaluation.m ==================