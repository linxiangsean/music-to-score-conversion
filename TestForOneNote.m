
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create an MusicXML file for A Single Note             %
%                                                       %
%   Author: Xiang Lin  10/09/17                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc, close all

% This function analyze a single note(pitch) and return the Name of this
% pitch.
%
% It returns three values: 1.step -- Is the note C or D or E...
%                          2. alter -- does note contain '#' or not '+1'
%                               means it has '#'
%                          3. octave -- the octave this note falls in.


% fetch in the sound file that contains a single note
[x, fs] = audioread('VocalC4#F.wav');   % load an audio file
x = x(:, 1);                            % get the first channel
n = length(x);                          % signal length


% In this case we assume that the file contains one single pitch
% Go through FFT and get the frequency of this pitch

X = fft(x);                         % go through the fft
X_mag = abs(X);                     % get the absolute value(Mag)
v = X_mag(1:length(X_mag)/2);       % get half of the absolute value(mirrored)
V = v/max(v);                       % round the value


[pks,locs] = findpeaks(V,'MinPeakHeight',0.3);  % get rid of noisy peaks
freq = locs(1)*(fs/n);                          % get the exact value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Convert the freq into 1-Step, 2-alter, 3-octave

A4 = 440.0;
A4_Index = 57;

notes = [
    "C 0","C # 0","D 0","D # 0","E 0","F 0","F # 0","G 0","G # 0","A 0","A # 0","B 0", "C 1","C # 1","D 1","D # 1","E 1","F 1","F # 1","G 1","G # 1","A 1","A # 1","B 1","C 2","C # 2","D 2","D # 2","E 2","F 2","F # 2","G 2","G # 2","A 2","A # 2","B 2","C 3","C # 3","D 3","D # 3","E 3","F 3","F # 3","G 3","G # 3","A 3","A # 3","B 3","C 4","C # 4","D 4","D # 4","E 4","F 4","F # 4","G 4","G # 4","A 4","A # 4","B 4","C 5","C # 5","D 5","D # 5","E 5","F 5","F # 5","G 5","G # 5","A 5","A # 5","B 5","C 6","C # 6","D 6","D # 6","E 6","F 6","F # 6","G 6","G # 6","A 6","A # 6","B 6","C 7","C # 7","D 7","D # 7","E 7","F 7","F # 7","G 7","G # 7","A 7","A # 7","B 7","C 8","C # 8","D 8","D # 8","E 8","F 8","F # 8","G 8","G # 8","A 8","A # 8","B 8","C 9","C # 9","D 9","D # 9","E 9","F 9","F # 9","G 9","G # 9","A 9","A # 9","B 9" ];

numOfSimiT = 12*log2(freq/A4);
NumOfSimiT = round(numOfSimiT)+1;
targetIndex = A4_Index + NumOfSimiT;

targetStirng = notes(targetIndex);
target = strsplit(targetStirng);

if(length(target) == 2)
    step = target(1);
    alter = "0";
    octave = target(2);
end
if(length(target) == 3)
    step = target(1);
    alter = "+1";
    octave = target(3);
end

sharp = "+1";
if(alter == sharp)
        sharp = "#";
else
    sharp = " ";
end

fprintf('%s%s%s',step,octave,sharp)
