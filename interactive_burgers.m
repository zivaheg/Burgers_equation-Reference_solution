function fig = interactive_burgers(data)
%INTERACTIVE_BURGERS Odpre interaktivni MATLAB prikaz resitve.
%
%   FIG = INTERACTIVE_BURGERS(DATA) odpre UI okno z grafom u(t,x),
%   drsnikom za izbiro casa in gumbom za samodejno predvajanje.
%
% Vhod:
%   data - rezultat BURGERS_REFERENCE ali RUN_BURGERS_PROJECT
%
% Izhod:
%   fig - rocaj na ustvarjeno UI okno
%

% graf nadomestimo z interaktivno verzijo, sintaksa ostane ista
fig = uifigure('Name', 'Interaktivna Burgersova enacba', 'Position', [100, 100, 860, 570]);

ax = uiaxes(fig, 'Position', [70, 160, 720, 350]);

hLine = plot(ax, data.x, data.U(1, :), 'LineWidth', 2.5);
grid(ax, 'on');
xlim(ax, [data.x(1), data.x(end)]);
ylim(ax, [-1.1, 1.1]);
xlabel(ax, 'x');
ylabel(ax, 'u(t,x)');
title(ax, sprintf('t = %.4f', data.t(1)));

uilabel(fig, 'Position', [70, 100, 60, 22], 'Text', 'Cas t:');

slider = uislider(fig,'Position', [135, 110, 530, 3], ...
'Limits', [data.t(1), data.t(end)],'Value', data.t(1));

timeLabel = uilabel(fig, 'Position', [690, 98, 100, 25], 'Text', sprintf('t = %.4f', data.t(1)));

playButton = uibutton(fig,'push', 'Text', 'Predvajaj', 'Position', [365, 40, 120, 35]);


uiData = struct();
uiData.x = data.x;
uiData.t = data.t;
uiData.U = data.U;
uiData.line = hLine;
uiData.axes = ax;
uiData.slider = slider;
uiData.timeLabel = timeLabel;

fig.UserData = uiData;

%dolocimo funkcije sliders
slider.ValueChangingFcn = @(src, event) burgers_set_ui_time(fig, event.Value);

slider.ValueChangedFcn = @(src, event) burgers_set_ui_time(fig, event.Value);

playButton.ButtonPushedFcn = @(src, event) burgers_play_callback(src, event, fig);

end
