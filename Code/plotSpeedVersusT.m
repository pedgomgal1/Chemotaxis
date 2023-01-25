function plotSpeedVersusT(avgSpeedRoundT,semSpeedRoundT,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyle,colours,paintError)
    
    x=0:600;
    
    
    avgMeanSpeedT_control_Free = mean(cat(3,avgSpeedRoundT{intersect(idsFreeNav,idsTH)}),3);
    avgMeanSpeedT_G2019S_Free = mean(cat(3,avgSpeedRoundT{intersect(idsFreeNav,idsG2019S)}),3);
    avgMeanSpeedT_A53T_Free = mean(cat(3,avgSpeedRoundT{intersect(idsFreeNav,idsA53T)}),3);
    


    if paintError
        avgSemSpeedT_control_Free = mean(cat(3,semSpeedRoundT{intersect(idsFreeNav,idsTH)}),3);
        avgSemSpeedT_G2019S_Free = mean(cat(3,semSpeedRoundT{intersect(idsFreeNav,idsG2019S)}),3);
        avgSemSpeedT_A53T_Free = mean(cat(3,semSpeedRoundT{intersect(idsFreeNav,idsA53T)}),3);
        
        curve1_control_Free = avgMeanSpeedT_control_Free + avgSemSpeedT_control_Free;
        curve2_control_Free = avgMeanSpeedT_control_Free - avgSemSpeedT_control_Free;
        x2=[x,fliplr(x)];
        inBetween = [curve1_control_Free', fliplr(curve2_control_Free')];
        fill(x2, inBetween, [colours(1,:)],'FaceAlpha',0.3,'EdgeColor','none');
        hold on;

        curve1_G2019S_Free = avgMeanSpeedT_G2019S_Free + avgSemSpeedT_G2019S_Free;
        curve2_G2019S_Free = avgMeanSpeedT_G2019S_Free - avgSemSpeedT_G2019S_Free;
        inBetween = [curve1_G2019S_Free', fliplr(curve2_G2019S_Free')];
        fill(x2, inBetween, [colours(2,:)],'FaceAlpha',0.3,'EdgeColor','none');

        curve1_A53T_Free = avgMeanSpeedT_A53T_Free + avgSemSpeedT_A53T_Free;
        curve2_A53T_Free = avgMeanSpeedT_A53T_Free - avgSemSpeedT_A53T_Free;
        inBetween = [curve1_A53T_Free', fliplr(curve2_A53T_Free')];
        fill(x2, inBetween, [colours(3,:)],'FaceAlpha',0.3,'EdgeColor','none');
    end

    plot(x,avgMeanSpeedT_control_Free,'Color',[colours(1,:)], 'LineWidth', 1,'LineStyle',LineStyle);
    hold on
    
    plot(x,avgMeanSpeedT_G2019S_Free,'Color',[colours(2,:)], 'LineWidth', 1,'LineStyle',LineStyle);
    
    
    plot(x,avgMeanSpeedT_A53T_Free,'Color',[colours(3,:)], 'LineWidth', 1,'LineStyle',LineStyle);
    
  

end