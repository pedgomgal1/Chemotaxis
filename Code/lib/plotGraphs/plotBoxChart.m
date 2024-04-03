function plotBoxChart(Chemotaxis_data,FreeNav_data, colors, category,fontSizeFigure,fontNameFigure,yLabel)


% Create the boxplot
grouped_data = [Chemotaxis_data,FreeNav_data];
colors = [colors;colors];
%indexes
idx = [1,4,2,5,3,6]; 
hold on;

for i = 1:numel(grouped_data)
    % Plot boxplot
    boxplot(grouped_data{idx(i)}, 'Positions', i, 'Widths', 0.4, 'Colors', [0 0 0]);
end
% Set boxchart colors
h = findobj(gca, 'Tag', 'Box');
for i = 1:numel(h)
    box_color = colors(idx(end-i+1),:);
    patch(get(h(i), 'XData'), get(h(i), 'YData'), box_color, 'FaceAlpha', 0.25, 'EdgeColor', 'k');
end


for i = 1:numel(grouped_data)
    % Plot individual data points as small circles
    s=swarmchart(i*ones(size(grouped_data{idx(i)})), grouped_data{idx(i)}, 10, [colors(idx(i),:)], 'filled', 'MarkerEdgeColor', 'k');
    s.XJitterWidth = 0.25;
end


% Set labels and title
set(gca, 'XTick', 1:numel(grouped_data), 'XTickLabel', {'Chemotaxis','Free Nav.', 'Chemotaxis','Free Nav.', 'Chemotaxis','Free Nav.'});
ylabel(yLabel);

% Adjust figure properties
grid on;
set(gcf, 'Units', 'inches');
set(gcf, 'Position', [2, 2, 10, 6]); % Adjust width and height as needed
set(gca, 'FontName', fontNameFigure, 'FontSize', fontSizeFigure);
set(findall(gcf,'-property','FontName'),'FontName',fontNameFigure);
set(findall(gcf,'-property','FontSize'),'FontSize',fontSizeFigure);

title(category)


