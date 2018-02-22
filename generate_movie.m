clc; close all; clear all;

%%% Data info
data_files = dir(['MovieData/*.txt']);
n_files = numel(data_files);

%%% Initialize array to hold all data
first_data = csvread("MovieData/sol_000.txt");
len_data = numel(first_data);
all_data = zeros(len_data, n_files);

%%% Read in all data
for i = 0:n_files-1
    fname = strcat('MovieData/sol_', sprintf('%03d',i), '.txt');
    all_data(:,i+1) = csvread(fname);
end

%%% Animate data
h = figure;
axis([1, len_data, -1, 1])    % ensure constant axis bounds
outgif = 'MovieData/plotgif.gif';
for k = 1:len_data
    xvec = [1:len_data];
    yvec = all_data(:,k);
    plot(xvec, yvec);
    
    drawnow
    pause(1/30);
    
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    % Write to the GIF file
    if k == 1
        imwrite(imind,cm,outgif,'gif','Loopcount',inf,'DelayTime',1/30);
    else
        imwrite(imind,cm,outgif,'gif','WriteMode','append','DelayTime',1/30);
    end
end