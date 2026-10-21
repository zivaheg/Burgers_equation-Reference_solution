function figs = plot_burgers_results(data, outputDir)
%PLOT_BURGERS_RESULTS Ustvari glavne graficne prikaze Burgersove resitve.
%
%   FIGS = PLOT_BURGERS_RESULTS(DATA,OUTPUTDIR) ustvari in shrani:
%   1. barvni zemljevid u(t,x),
%   2. tridimenzionalno povrsino u(t,x),
%   3. vec casovnih prerezov,
%   4. razvoj najvecjega absolutnega prostorskega gradienta.
%

% privzeta nastavitev da lahko pozenemo samo z data
if nargin < 2 || isempty(outputDir)
outputDir = '.';
end

x = data.x;
t = data.t;
U = data.U;

figs = gobjects(4, 1);
    % gobjects ... zacetni array za graphics objects

    % HEATMAP
figs(1) = figure('Name', 'Burgers: heatmap', 'Color', 'w');

imagesc(t, x, U.');
axis xy;    % nastavimo koord.
xlabel('t');
ylabel('x');
% naslov dopolnimo z nu vrednostjo
title(sprintf('Referencna resitev u(t,x), \\nu = %.6g', data.nu));

cb = colorbar;
cb.Label.String = 'u(t,x)';
colormap(turbo);
% sliko shranimo 
exportgraphics(figs(1),fullfile(outputDir, 'burgers_heatmap.png'),'Resolution', 200);

    % 3D POVRSINA (SURF)
figs(2) = figure('Name', 'Burgers: surface', 'Color', 'w');

surf(t, x, U.', 'EdgeColor', 'none');
xlabel('t');
ylabel('x');
zlabel('u(t,x)');
title('3D prikaz referencne resitve');
view(45, 30);
grid on;
colorbar;
colormap(turbo);

exportgraphics(figs(2), fullfile(outputDir, 'burgers_surface.png'), 'Resolution', 200);

    % CASOVNI PREREZI
timesToPlot = [0, 0.25, 0.50, 0.75, 1.00];

% poiscemo index najblizjega t za vsakega iz izbranih
indices = arrayfun( @(tau) find(abs(t - tau) == min(abs(t - tau)), 1), timesToPlot);

figs(3) = figure('Name', 'Burgers: time slices', 'Color', 'w');
% razdeli prereze po povrsini slike
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

for k = 1:numel(indices)
    nexttile;   % nasledji graf v svojem okvircku
    plot(x, U(indices(k), :), 'LineWidth', 2);
    yline(0, ':');
    grid on;
    xlim([x(1), x(end)]);
    ylim([-1.1, 1.1]);
    xlabel('x');
    ylabel('u(t,x)');
    title(sprintf('t = %.2f', t(indices(k))));
end

nexttile; % zadnji okvircek ima lastnosti / podatke 
axis off;
text(0.05, 0.78, sprintf('\\nu = %.8f', data.nu), 'FontSize', 11);
text(0.05, 0.60, sprintf('N_x = %d', data.Nx), 'FontSize', 11);
text(0.05, 0.42, sprintf('N_t = %d', data.Nt), 'FontSize', 11);
text(0.05, 0.24, sprintf('Stencil = %d tock', data.stencilPoints), 'FontSize', 11);
text(0.05, 0.06, sprintf('Solver = %s', data.timeSolver), 'FontSize', 11);

% skupni naslov vseh okvirckov
sgtitle('Razvoj profila Burgersove enacbe skozi cas');

exportgraphics(figs(3), ...
fullfile(outputDir, 'burgers_time_slices.png'), 'Resolution', 200);

    % NAJVECJI GRADIENT - najvecja razlika pri x za vsak t
h = x(2) - x(1);

% poracunamo s pomocjo koncne dif.
maxAbsSlope = max(abs(diff(U, 1, 2)), [], 2) / h;
    % diff ... razlike med sosednjimi elementi u(k, i+1) - U(k, i)

figs(4) = figure('Name', 'Burgers: max gradient', 'Color', 'w');

plot(t, maxAbsSlope, 'LineWidth', 2);
xlabel('t');
ylabel('max |u_x|');
title('Razvoj najvecjega prostorskega gradienta');
grid on;

exportgraphics(figs(4), fullfile(outputDir, 'burgers_max_gradient.png'), 'Resolution', 200);
end
