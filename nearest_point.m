function [ d2km_out,index_out ] = nearest_point(LON, LAT, POILON, POILAT, nop, dist_km)
% ====== Short Description ======
% The subroutine nearest_point finds the nearest points between a
% list of points with coordinates LON and LAT and a list of points of
% interest with coordinates with POILON and POILAT.
%
% ====== Input =======
% LON       : Longitude of known points, e.g buoys
% LAT       : Latitude of known points
% POILON    : Longitude of poi
% POILAT    : Latitude of poi
% nop       : number ofc_wv] = spec_import(fl_nm, keep)
% points to be found between the poi and the known
%           points
% dist_km   : maximum distance between the poi and known points
%
% ====== Output =======
% d2km_out  : distance of each poi from the known points
% index_out : index of known points at LON and LAT
% 
% ====== Called functions ======
% kd_buildtree
% kd_knn
% lldistkm
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
tree = kd_buildtree([LON,LAT],0);
index_out = [];
d2km_out = [];
for i1 = 1:1:length(POILON)
    [index,~,~] = kd_knn(tree,[POILON(i1),POILAT(i1)],nop,0);
    index_out = [index_out,index];
    for i2 = 1:1:nop
        [d1km(i2) d2km(i2)]=lldistkm([LAT(index(i2)),LON(index(i2))],[POILAT(i1), POILON(i1)]);
    end
    d2km_out = [d2km_out,d2km'];
   
end

index_out = sort(index_out,1);
d2km_out = sort(d2km_out,1);

for i1 = 1:length(POILON)
    ind = find(d2km_out(:,i1)>dist_km);
    if ~isempty (ind)
        d2km_out(ind,i1) = NaN;
        index_out(ind,i1) = NaN;
    end
end
