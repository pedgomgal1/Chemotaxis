function cellOutlinesLarvae=parseOutlinesFile(folderName,fileName)
    
    fileOutline = readlines(fullfile(folderName,fileName));
    
    cellOutlinesLarvae = cell(size(fileOutline,1)-1,3);
    for nLine=1:size(fileOutline,1)-1
        lineN = str2double(strsplit(fileOutline(nLine)));
        cellOutlinesLarvae{nLine,1}=lineN(2);
        cellOutlinesLarvae{nLine,2}=lineN(3);
        cellOutlinesLarvae{nLine,3}=lineN(4:2:end);
        cellOutlinesLarvae{nLine,4}=lineN(5:2:end);
    end
    
    save(fullfile(folderName,'rawlarvaeOutlines.mat'),'cellOutlinesLarvae');
end