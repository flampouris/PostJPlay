function [spec_wv] = spec_import(fl_nm)
% Description
% The subroutine imports the insitu spectra data from: 
% 
% [spec_wv] = spec_import(fl_nm, keep)
%
% spec_wv    : structure with the in-situ spectra at the fl_nm
%
% fl_nm     : structure with field .Name, it's the names of the nc files
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
%% The Code

% Basic Check of the input
if ~nargin == 1 || isempty(fl_nm)
    error('Declare at least one NC file')
end
%
% The main
for i = 1:1:length(fl_nm)
    if ~isempty(fl_nm(i).name)
        infowv = ncinfo(fl_nm(i).name);
        for i1 = 1:1:length(infowv.Variables)
    %         spec_wv(i).([infowv.Variables(i1).Name]).Attributes = infowv.Variables(i1).Attributes;
    %         spec_wv(i).([infowv.Variables(i1).Name]).Dimensions = infowv.Variables(i1).Dimensions;
    %         spec_wv(i).([infowv.Variables(i1).Name]).Size = infowv.Variables(i1).Size;
    %         spec_wv(i).([infowv.Variables(i1).Name]).Datatype = infowv.Variables(i1).Datatype;
    %         spec_wv(i).([infowv.Variables(i1).Name]).Data = ncread(fl_nm(i).name,infowv.Variables(i1).Name);
            spec_wv(i).([infowv.Variables(i1).Name]) = squeeze(double(ncread(fl_nm(i).name,infowv.Variables(i1).Name)));
        end
        spec_wv(i).time = datenum(1970,1,1,0,0,0)+spec_wv(i).time./86400;
        spec_wv(i).ind_LL = i;
    end
end
%%
% toc;