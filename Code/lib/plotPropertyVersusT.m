function plotPropertyVersusT(T,Control_AvgParamRoundT, Mt1_AvgParamRoundT, Mt2_AvgParamRoundT,...
    Control_SEMParamRoundT, Mt1_SEMParamRoundT, Mt2_SEMParamRoundT,LineStyle,colours,paintError)
    
    % % fill with zeros
    % auxZerosT = zeros(size(T'));
    % Control_AvgParamRoundT = cellfun(@(x) auxZerosT+[zeros(length(auxZerosT)-length(x),1) ; x],Control_AvgParamRoundT,'UniformOutput',false);
    
    avgMeanSpeedT_control_Free = mean(Control_AvgParamRoundT,2);
    avgMeanSpeedT_G2019S_Free = mean(Mt1_AvgParamRoundT,2);
    avgMeanSpeedT_A53T_Free = mean(Mt2_AvgParamRoundT,2);
    
    if strcmp(paintError,'calculateError')
        avgSemSpeedT_control_Free = std(Control_AvgParamRoundT,[],2);
        avgSemSpeedT_G2019S_Free = std(Mt1_AvgParamRoundT,[],2);
        avgSemSpeedT_A53T_Free = std(Mt2_AvgParamRoundT,[],2);
        paintError = 1;
    end
    hold on

    if strcmp(paintError,'pooledStandardError')
        if ~isempty(Control_SEMParamRoundT)
            %if we assume having the same number of larvae per time point.
            %This is the way to calculate the "pooled standard error"
            avgSemSpeedT_control_Free = mean(Control_SEMParamRoundT,2);
            avgSemSpeedT_G2019S_Free = mean(Mt1_SEMParamRoundT,2);
            avgSemSpeedT_A53T_Free = mean(Mt2_SEMParamRoundT,2);
        end        
        
        curve1_control_Free = avgMeanSpeedT_control_Free + avgSemSpeedT_control_Free;
        curve1_control_Free(isnan(curve1_control_Free))=0;
        curve2_control_Free = avgMeanSpeedT_control_Free - avgSemSpeedT_control_Free;
        curve2_control_Free(isnan(curve2_control_Free))=0;

        x2=[T,fliplr(T)];
        inBetween = [curve1_control_Free', fliplr(curve2_control_Free')];
        p=fill(x2, inBetween, [colours(1,:)],'FaceAlpha',0.1,'EdgeColor','none');       

        curve1_G2019S_Free = avgMeanSpeedT_G2019S_Free + avgSemSpeedT_G2019S_Free;
        curve2_G2019S_Free = avgMeanSpeedT_G2019S_Free - avgSemSpeedT_G2019S_Free;
        curve1_G2019S_Free(isnan(curve1_G2019S_Free))=0;
        curve2_G2019S_Free(isnan(curve2_G2019S_Free))=0;
        inBetween = [curve1_G2019S_Free', fliplr(curve2_G2019S_Free')];
        fill(x2, inBetween, [colours(2,:)],'FaceAlpha',0.1,'EdgeColor','none');

        curve1_A53T_Free = avgMeanSpeedT_A53T_Free + avgSemSpeedT_A53T_Free;
        curve2_A53T_Free = avgMeanSpeedT_A53T_Free - avgSemSpeedT_A53T_Free;
        curve1_A53T_Free(isnan(curve1_A53T_Free))=0;
        curve2_A53T_Free(isnan(curve2_A53T_Free))=0;
        inBetween = [curve1_A53T_Free', fliplr(curve2_A53T_Free')];
        fill(x2, inBetween, [colours(3,:)],'FaceAlpha',0.1,'EdgeColor','none');
    end

    plot(T,avgMeanSpeedT_control_Free,'Color',[colours(1,:)], 'LineWidth', 1,'LineStyle',LineStyle);
    plot(T,avgMeanSpeedT_G2019S_Free,'Color',[colours(2,:)], 'LineWidth', 1,'LineStyle',LineStyle);
    plot(T,avgMeanSpeedT_A53T_Free,'Color',[colours(3,:)], 'LineWidth', 1,'LineStyle',LineStyle);
    hold off
    set(gca,'Box', 'on', 'XColor', 'k', 'YColor', 'k');
end