function stats_tab=plotBoxChart(Chemotaxis_data,FreeNav_data, colors, category,fontSizeFigure,fontNameFigure,yLabel,minMax_Y_val,tickInterval,xTickLabels)

%remove nans
Chemotaxis_data=cellfun(@(x) x(~isnan(x)), Chemotaxis_data,'UniformOutput',false);
if ~isempty(FreeNav_data)
    FreeNav_data=cellfun(@(x) x(~isnan(x)), FreeNav_data,'UniformOutput',false);
end
% Create the boxplot
grouped_data = [Chemotaxis_data,FreeNav_data];
colors = [colors;colors];
%indexes
idx = 1:numel(grouped_data);% [1,2,3,4,5,6]; 
hold on;

for i = 1:numel(grouped_data)
    % Plot boxplot
    i2=i;
    if i>3, i2=i+1; end
    boxplot(grouped_data{i}, 'Positions', i2, 'Widths', 0.4, 'Colors', [0 0 0]);
end
% Set boxchart colors
h = findobj(gca, 'Tag', 'Box');
for i = 1:numel(h)
    box_color = colors(end-i+1,:);
    patch(get(h(i), 'XData'), get(h(i), 'YData'), box_color, 'FaceAlpha', 0.25, 'EdgeColor', 'k');
end

for i = 1:numel(grouped_data)
    % Plot individual data points as small circles
    i2=i;
    if i>3, i2=i+1; end
    s=swarmchart(i2*ones(size(grouped_data{i})), grouped_data{i}, 10, [colors(idx(i),:)], 'filled', 'MarkerEdgeColor', 'k');
    s.XJitterWidth = 0.25;
end


% Set labels and title
set(gca, 'XTick', [2,6], 'XTickLabel', xTickLabels);
ylabel(yLabel);

% Adjust figure properties

grid on;
set(gca,'XGrid','off')
set(gca,'Box','off')
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [2, 2, 10, 6]); % Adjust width and height as needed
set(gca, 'FontName', fontNameFigure, 'FontSize', fontSizeFigure);
% set(findall(gcf,'-property','FontName'),'FontName',fontNameFigure);
% set(findall(gcf,'-property','FontSize'),'FontSize',fontSizeFigure);

title(category)

ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))

[stats_WT_G2019S_Chemo]=compareMeansOfMatrices(Chemotaxis_data{1},Chemotaxis_data{2});
[stats_WT_A53T_Chemo]=compareMeansOfMatrices(Chemotaxis_data{1},Chemotaxis_data{3});

maxVal = max([max(Chemotaxis_data{1}),max(Chemotaxis_data{2}),max(Chemotaxis_data{3})]);
paintSignificance(maxVal,tickInterval,stats_WT_G2019S_Chemo.p,[1,2])
paintSignificance(maxVal+tickInterval,tickInterval,stats_WT_A53T_Chemo.p,[1,3])
stats_tab = [stats_WT_G2019S_Chemo;stats_WT_A53T_Chemo];


if iscell(yLabel)
    yLabel=yLabel{1};
end

if ~isempty(FreeNav_data)

    [stats_WT_G2019S_FreeNav]=compareMeansOfMatrices(FreeNav_data{1},FreeNav_data{2});
    [stats_WT_A53T_FreeNav]=compareMeansOfMatrices(FreeNav_data{1},FreeNav_data{3});
    stats_tab=[stats_tab;stats_WT_G2019S_FreeNav;stats_WT_A53T_FreeNav];
    maxValFreeNav = max([max(FreeNav_data{1}),max(FreeNav_data{2}),max(FreeNav_data{3})]);
    paintSignificance(maxValFreeNav,tickInterval,stats_WT_G2019S_FreeNav.p,[5,6])
    paintSignificance(maxValFreeNav+tickInterval,tickInterval,stats_WT_A53T_FreeNav.p,[5,7])
    stats_tab.Properties.RowNames = {[yLabel '_' xTickLabels{1} '_WTvsG2019S'],[yLabel '_' xTickLabels{1} '_WTvsA53T'],[yLabel '_' xTickLabels{2} '_WTvsG2019S'],[yLabel '_' xTickLabels{2} '_WTvsA53T']};
else
    stats_tab.Properties.RowNames = {[yLabel '_' xTickLabels{1} '_WTvsG2019S'],[yLabel '_' xTickLabels{1} '_WTvsA53T']};
end



