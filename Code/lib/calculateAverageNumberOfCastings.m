function [averageNumberOfCastings]=calculateAverageNumberOfCastings(castFile,xFile,yFile)

%%%% accurate detection of the head casts and hunches requires simultaneous use of several variables: head angle, spine length, width, x, and y
%%%% The following head angle thresholds are used: upper amplitude threshold 27°, lower amplitude threshold 20°, width threshold 0.15 s and gap threshold 0.67 s

%weigth the number of castings depending on the total time the animal is
%detected


%threshold that a casting has to pass.
upperAngleBound = 27;
lowerAngleBound = -20;

%The casting has to occur in this time interval. 
minTimeBound = 0.15;
maxTimeBound = 0.67;

%During the time of casting the XY distance cannot exceed a distance
%threshold
xyThreshold = 0.1; %%%I HAVE TO EXPLORE THIS THRESHOLD



end