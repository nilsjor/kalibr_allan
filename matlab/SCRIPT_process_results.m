%% Initalization
close all
clear all

% Read in our toolboxes
addpath('functions')
addpath('functions/allan_v3')

% Our bag information
titlestr = 'BNO055';
mat_path = '../data/results_20180817T141614.mat';

%titlestr = 'Tango Yellowstone #1';
%mat_path = '../data/results_20171031T115123.mat';


% Load the mat file (should load "data_imu" matrix)
fprintf('opening the mat file.\n')
load(mat_path);


%% Get the calculated sigmas

fprintf('plotting accelerometer.\n')
[fh1,sigma_a,sigma_ba] = gen_chart(results_ax.tau1,results_ax.sig2,...
                                    results_ay.sig2,results_az.sig2,...
                                    titlestr,'acceleration','m/s^2',...
                                    'm/s^2sqrt(Hz)','m/s^3sqrt(Hz)');


fprintf('plotting gyroscope.\n')
[fh2,sigma_g,sigma_ga] = gen_chart(results_wx.tau1,results_wx.sig2,...
                                    results_wy.sig2,results_wz.sig2,...
                                    titlestr,'gyroscope','rad/s',...
                                    'rad/s^1sqrt(Hz)','rad/s^2sqrt(Hz)');



%% Print to yaml-file
fid = fopen('../data/bno055.yaml','w');
% Accelerometer
fprintf(fid,'accelerometer_noise_density: %e\n',max(sigma_a));
fprintf(fid,'accelerometer_random_walk:   %e\n',max(sigma_ba));
% Gyroscope
fprintf(fid,'gyroscope_noise_density:     %e\n',max(sigma_g));
fprintf(fid,'gyroscope_random_walk:       %e\n',max(sigma_ga));
% Other info
fprintf(fid,'rostopic:                    /imu0\n');
fprintf(fid,'update_rate:                 %e\n',update_rate);

fclose(fid);


%% Save to file
[pathstr, name, ext] = fileparts(mat_path);
print(fh1,'-dpng','-r500',[pathstr,'/',name,'_accel.png'])
print(fh2,'-dpng','-r500',[pathstr,'/',name,'_gyro.png'])
