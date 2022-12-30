function cellOutlinesLarvae=parseOutlinesFile(folderName,fileName)
    
    fileOutline = readlines(fullfile(folderName,fileName));

    sizeFile = size(fileOutline,1);
    tempCellOutlinesLarvae = cell(sizeFile-1,4);
    parfor nLine=1:(sizeFile-1)
        lineN = str2double(strsplit(fileOutline(nLine)));
        tempRow=cell(1,4);
        tempRow{1,1}=lineN(2);
        tempRow{1,2}=lineN(3);
        tempRow{1,3}=lineN(4:2:end);
        tempRow{1,4}=lineN(5:2:end);
        tempCellOutlinesLarvae(nLine,:)=tempRow;
    end
    cellOutlinesLarvae=tempCellOutlinesLarvae;
    
    save(fullfile(folderName,'rawlarvaeOutlines.mat'),'cellOutlinesLarvae');
end