function setup()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% set up environment variable for the system
addpath(pwd,'-frozen');
addpath(genpath([pwd '/src']),'-frozen');
addpath(genpath([pwd '/db']),'-frozen');
addpath(genpath([pwd '/lib']),'-frozen');
addpath(genpath([pwd '/script']),'-frozen');
addpath(genpath([pwd '/test']),'-frozen');
savepath;

a=opengl('data');

if a.Software
    opengl software;
    opengl('save','software');
else
    opengl hardware;
    opengl('save','hardware');
end
end

