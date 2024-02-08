function allVars = initializeVars(sizeAllDir)

allVars.averageLarvaeLength = zeros(sizeAllDir,1);
allVars.navigationIndex_Xaxis = zeros(sizeAllDir,1);
allVars.navigationIndex_Yaxis = zeros(sizeAllDir,1);
allVars.propLarvInAnglGroup = cell(sizeAllDir,1);
allVars.matrixProbOrientation = cell(sizeAllDir,1);
allVars.transitionMatrixOrientation = cell(sizeAllDir,1);
allVars.binsXdistributionInitEnd= cell(sizeAllDir,1);
allVars.avgSpeedRoundT= cell(sizeAllDir,1);
allVars.stdSpeedRoundT= cell(sizeAllDir,1);
allVars.semSpeedRoundT= cell(sizeAllDir,1);
allVars.avgMeanSpeed= zeros(sizeAllDir,1);
allVars.avgStdSpeed= zeros(sizeAllDir,1);
allVars.avgSemSpeed= zeros(sizeAllDir,1);
allVars.avgSpeed085RoundT= cell(sizeAllDir,1);
allVars.stdSpeed085RoundT= cell(sizeAllDir,1);
allVars.semSpeed085RoundT= cell(sizeAllDir,1);
allVars.avgMeanSpeed085= zeros(sizeAllDir,1);
allVars.avgStdSpeed085= zeros(sizeAllDir,1);
allVars.avgSemSpeed085= zeros(sizeAllDir,1);

allVars.avgCrabSpeedRoundT= cell(sizeAllDir,1);
allVars.stdCrabSpeedRoundT= cell(sizeAllDir,1); 
allVars.semCrabSpeedRoundT= cell(sizeAllDir,1);
allVars.avgMeanCrabSpeed= zeros(sizeAllDir,1);
allVars.avgStdCrabSpeed= zeros(sizeAllDir,1);
allVars.avgSemCrabSpeed= zeros(sizeAllDir,1);

allVars.avgAreaRoundT= cell(sizeAllDir,1);
allVars.stdAreaRoundT= cell(sizeAllDir,1);
allVars.semAreaRoundT= cell(sizeAllDir,1);
allVars.avgMeanArea=zeros(sizeAllDir,1);
allVars.avgStdArea=zeros(sizeAllDir,1);
allVars.avgSemArea=zeros(sizeAllDir,1);

allVars.avgCurveRoundT= cell(sizeAllDir,1);
allVars.stdCurveRoundT= cell(sizeAllDir,1);
allVars.semCurveRoundT= cell(sizeAllDir,1);
allVars.avgMeanCurve=zeros(sizeAllDir,1);
allVars.avgStdCurve=zeros(sizeAllDir,1);
allVars.avgSemCurve=zeros(sizeAllDir,1);

allVars.avgSpeedPerOrientation= cell(sizeAllDir,1);
allVars.stdSpeedPerOrientation= cell(sizeAllDir,1);
allVars.avgSpeed085PerOrientation= cell(sizeAllDir,1);
allVars.stdSpeed085PerOrientation= cell(sizeAllDir,1);

allVars.avgCrabSpeedPerOrientation= cell(sizeAllDir,1);
allVars.stdCrabSpeedPerOrientation= cell(sizeAllDir,1);
allVars.avgCurvePerOrientation= cell(sizeAllDir,1);
allVars.stdCurvePerOrientation= cell(sizeAllDir,1);

allVars.meanAngularSpeedPerT= cell(sizeAllDir,1);
allVars.stdAngularSpeedPerT= cell(sizeAllDir,1);
allVars.semAngularSpeedPerT= cell(sizeAllDir,1);
allVars.avgMeanAngularSpeed= zeros(sizeAllDir,1);
allVars.avgStdAngularSpeed= zeros(sizeAllDir,1);
allVars.avgSemAngularSpeed= zeros(sizeAllDir,1);
allVars.angularSpeed= cell(sizeAllDir,1);
allVars.avgAngularSpeedPerOrientation= cell(sizeAllDir,1);
allVars.stdAngularSpeedPerOrientation= cell(sizeAllDir,1);

allVars.matrixProbMotionStates= cell(sizeAllDir,1);
allVars.transitionMatrixMotionStates= cell(sizeAllDir,1);

allVars.propOrientationPriorCasting= cell(sizeAllDir,1);
allVars.propOrientationAfterCasting= cell(sizeAllDir,1);
allVars.propOrientationPriorCastingOrTurning= cell(sizeAllDir,1);
allVars.propOrientationAfterCastingOrTurning= cell(sizeAllDir,1);

allVars.proportionLarvaeRunPerT= cell(sizeAllDir,1);
allVars.proportionLarvaeStopPerT= cell(sizeAllDir,1);
allVars.proportionLarvaeTurnPerT= cell(sizeAllDir,1);
allVars.proportionLarvaeCastingPerT= cell(sizeAllDir,1);

allVars.tableSummaryFeatures = cell(sizeAllDir,1);


end