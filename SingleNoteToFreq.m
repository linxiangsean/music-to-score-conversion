

% Function: Processing single note from wave to an actual note.
%           From the audio piece into the frequency number it represented.


function [freq] = SingleNoteToFreq(n,x,fs)


  % n ----- signal length
  % x ----- soundbite
  


% In this case we assume that the file contains one single pitch
% Go through FFT and get the frequency of this pitch

X = fft(x);                         % go through the fft
X_mag = abs(X);                     % get the absolute value(Mag)   
%plot(X_mag)                        % plot the graph
%f = (0:n-1)*(fs/n);                 % get the effective frequency length
%plot(f,X_mag);

v = X_mag(1:floor(length(X_mag)/2));       % get half of the absolute value(mirrored)
V = v/max(v);                       % round the value   
[pks,locs] = findpeaks(V,'MinPeakHeight',0.3);  % get rid of noisy peaks
freq = locs(1)*(fs/n);              % get the exact value

end

