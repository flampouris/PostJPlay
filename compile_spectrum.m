function [E] = compile_spectrum(ALPHA1, ALPHA2, R1, R2, C, fr, dtheta, bool_vis)
% ====== Short Description ======
% The subroutine compile_spectrum creates frequency-direction wave spectra
% from alpha1, alpha2, r1, r2 and the spectral density, given the
% frequency. 
% ====== Input =======
% ALPHA1    : mean_wave_dir
% ALPHA1    : principal_wave_dir
% R1        : wave_spectrum_r1
% R2        : wave_spectrum_r2
% C         : spectral_wave_density
% fr        : frequency
% bool_vis  : bool variable for data visualization in polar coordinates
%
% ====== Output =======
% E         : Direction Frequency direction with dtheta=dtheta
%
% ====== Called functions ======
% PolarContour 
% 
%% Source Code  
%
if ~exist('bool_vis','var')
    bool_vis = 0;
    bool_vis = logical(bool_vis);
 end

for f=1:length(C)
    for A=1:36
        D(f,A) = (1/pi)*(0.5+R1(f)*(5/7)*cos(deg2rad(A*dtheta-ALPHA1(f)))+(2/7)*R2(f)*cos(deg2rad(2*(A*dtheta-ALPHA2(f)))));
    end
end

for i=1:length(C)
    for j=1:36
        E(i,j)=C(i)*D(i,j);
    end
end

if (bool_vis)
    [px, py] = PolarContour(E', fr');
end