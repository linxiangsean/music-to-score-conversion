%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create an MusicXML file for Multiple notes on set     %
%                                                       %
%   Author: Xiang Lin  10/09/17                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc, close all
    
% get the sound file
[x, fs] = audioread('MIDIDoToDo.wav');       % load an audio file
x = x(:, 1);                                      % get the first channel

% Divide up different notes onset

movm = movmean(x.^2,0.05*fs);   
% get the movmean 
% indicates the amplitude of pitches
                                                                                     
% Get a clear graph of spaces by using negalog
negalog = -log(movm);      
M = negalog/max(negalog);

% Use average as the line to recogonize peaks
aveM = mean(M);
% Get the silent section using peak detection
[points,locas] = findpeaks(M,'MinPeakHeight',aveM+0.1);

% Use local difference get more accurate turning point.
locaDiff = diff(locas);
LocaDiff = locaDiff/max(locaDiff);

% Return values into a list
[n,TurningPoints] = findpeaks(LocaDiff,'MinpeakHeight',0.2);

% Get list of changing moments. 
ChangeNoteTime = locas(TurningPoints+1);
NewChangeNote = [1;ChangeNoteTime(1:end)];


% Divide the file into Different pieces that represent each note.
% And Run the function SingleNoteToFreq to get frequencies of each note.
% Store frequencies into FreqList.
numOfNotes = length(ChangeNoteTime);
FreqList = zeros(30,1); % Assuming No more than 30 notes.
indexing = 1;
indexingTemp = 0;

while indexing <= numOfNotes
    piece = x(NewChangeNote(indexing):NewChangeNote(indexing+1));
    n = length(piece);
    indexingTemp = n;
    
        freq = SingleNoteToFreq(n,piece,fs);
        FreqList(indexing) = freq;
    
    indexing = indexing+1;
end

% Cut off all the zeros
FreqList(FreqList==0) = []; 


% Convert the freq into 1-Step, 2-alter, 3-octave
% Use Function FreqToNote to get crucial attributes of each note.
% And store these values into stepValuelist, alterValuelist and
% octaveValuelist.
stepValuelist = strings(30,1);
alterValuelist = strings(30,1);
octaveValuelist = strings(30,1);

lenOfF = length(FreqList);
tempV = 1;

while tempV <= lenOfF
        [stepValue,alterValue,octaveValue] = FreqToNote(FreqList(tempV));
        stepValuelist(tempV) = stepValue;
        alterValuelist(tempV) = alterValue;
        octaveValuelist(tempV) = octaveValue;
        tempV = tempV+1;
end



%-------------------------------------------------------------------------------
% Use three values for exporting a MusicXML file

% Create the XML file.
docNode = com.mathworks.xml.XMLUtils.createDocument('score-partwise');

% Write in nodes in MUSICXML format
score_partwise = docNode.getDocumentElement;
score_partwise.setAttribute('version','3.0');
% list of parts
part_list = docNode.createElement('part-list');
score_partwise.appendChild(part_list);
% part 1
score_part = docNode.createElement('score-part');
score_part.setAttribute('id','P1');
part_list.appendChild(score_part);
% Name of the part 1
part_name = docNode.createElement('part-name');
part_name.appendChild(docNode.createTextNode('Music'));
score_part.appendChild(part_name);
% Information of part 1
part = docNode.createElement('part');
part.setAttribute('id','P1');
score_partwise.appendChild(part);
% Information of measure 1
measure = docNode.createElement('measure');
measure.setAttribute('number','1');
part.appendChild(measure);

%Elements in attributes
attributes = docNode.createElement('attributes');
measure.appendChild(attributes);
%Divisions
divisions = docNode.createElement('divisions');
divisions.appendChild(docNode.createTextNode('1'));
attributes.appendChild(divisions);
% the key signature
key = docNode.createElement('key');
attributes.appendChild(key);
%circle of fifth determines the key signature
fifths = docNode.createElement('fifths');
fifths.appendChild(docNode.createTextNode('0'));
key.appendChild(fifths);
% time value
time = docNode.createElement('time');
attributes.appendChild(time);
% beats and beat types
beats = docNode.createElement('beats');
beats.appendChild(docNode.createTextNode('4'));
beat_type = docNode.createElement('beat-type');
beat_type.appendChild(docNode.createTextNode('4'));
time.appendChild(beats);
time.appendChild(beat_type);
% what clef do we use
clef = docNode.createElement('clef');
attributes.appendChild(clef);
% second line from bottom is G
if(freq<261)
sign = docNode.createElement('sign');
sign.appendChild(docNode.createTextNode('F'));
line = docNode.createElement('line');
line.appendChild(docNode.createTextNode('4'));
clef.appendChild(sign);
clef.appendChild(line);
else
sign = docNode.createElement('sign');
sign.appendChild(docNode.createTextNode('G'));
line = docNode.createElement('line');
line.appendChild(docNode.createTextNode('2'));
clef.appendChild(sign);
clef.appendChild(line);
end

% Use loop to print each note element in a dumb way.
tempV = 1;
while tempV <= lenOfF
    
    
    % Elements in note
    note = docNode.createElement('note');
    measure.appendChild(note);
    % Pitch element!!!!!
    pitch = docNode.createElement('pitch');
    note.appendChild(pitch);
    % Step, alter, and octave
    step = docNode.createElement('step');
    step.appendChild(docNode.createTextNode(stepValuelist(tempV)));
    alter = docNode.createElement('alter');
    alter.appendChild(docNode.createTextNode(alterValuelist(tempV)));
    octave = docNode.createElement('octave');
    octave.appendChild(docNode.createTextNode(octaveValuelist(tempV)));
    pitch.appendChild(step);
    pitch.appendChild(alter);
    pitch.appendChild(octave);
    % the duration of the note
    duration = docNode.createElement('duration');
    duration.appendChild(docNode.createTextNode('4'));
    note.appendChild(duration);
    % the type of the note, its whole note or half or...
    type = docNode.createElement('type');
    type.appendChild(docNode.createTextNode('quarter'));
    note.appendChild(type);
    
    
    tempV = tempV+1;
end




% Write to XML file and view the file.
xmlwrite('NoteFile.xml',docNode);
open NoteFile.xml

%open the file with MuseScore application in MacOS
!/Applications/MuseScore\ 2.app/Contents/MacOS/mscore NoteFile.xml &

%Open File in Windows
%command = '"C:\Program Files (x86)\MuseScore 2\bin\MuseScore.exe" "C:\Users\Xiang\Documents\MATLAB\Examples\Sound_Analysis\NoteFile.xml"';
%status = dos(command)


