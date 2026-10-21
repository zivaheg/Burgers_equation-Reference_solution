function result = temporal_convergence_study(stencilPoints)
%TEMPORAL_CONVERGENCE_STUDY Preveri konvergenco RK4 v casu.
%
%   RESULT = TEMPORAL_CONVERGENCE_STUDY(STENCILPOINTS) na isti prostorski
%   mrezi primerja RK4 pri vec zaporedno razpolovljenih casovnih korakih
%   z zelo natancno resitvijo ODE15S istega pol-diskretnega sistema.
%
% S tem je vpliv prostorske diskretizacije pri primerjavi skupen vsem
% resitvam, zato opazujemo predvsem casovno napako RK4.
%
% Privzeti koraki:
%   dt = 2e-3, 1e-3, 5e-4, 2.5e-4.
%
% Pricakovani asimptoticni red klasicne RK4 metode je 4.
%

if nargin < 1   % nargin...stevilo podanih argumentov
    stencilPoints = 9;
end

% prilagodimo mrezo
config = burgers_default_config();
config.Nx = 257;
config.Nt = 2;
config.stencilPoints = stencilPoints;

% prilagodimo tolerance
config.relTol = 1e-12;
config.absTol = 1e-14;
config.maxStep = 1e-3;
config.saveVideo = false;

%if ~exist(config.outputDir, 'dir')
%    mkdir(config.outputDir);
%end

fprintf('\nCasovna konvergenca RK4, Nx = %d, stencil = %d\n', config.Nx, stencilPoints);

config.timeSolver = 'ode15s';
ref = burgers_reference(config);    % referencna resitev
uRef = ref.U(end, :);               % mreza

dtValues = [2e-3, 1e-3, 5e-4, 2.5e-4]; % seznam casov, ki poskusimo
errors = zeros(numel(dtValues), 1);
actualDt = zeros(numel(dtValues), 1);

% izpisemo za vsak cas
for k = 1:numel(dtValues)
    sol = burgers_rk4(config, dtValues(k));
    actualDt(k) = sol.dt;
    errors(k) = max(abs(sol.U(end, :) - uRef));
end

observedOrder = NaN(size(errors));  % zadnji bo vedno ostal NaN
% izracun reda konvergence
observedOrder(1:end-1) = log(errors(1:end-1) ./ errors(2:end)) ./ ...
                         log(actualDt(1:end-1) ./ actualDt(2:end));

T = table(actualDt(:), errors, observedOrder,'VariableNames', {'dt', 'MaxErrorAtT1', 'ObservedOrder'});
disp(T);

% shranimo tabelo v csv
writetable(T, fullfile(config.outputDir,sprintf('temporal_convergence_RK4_%dpoint.csv', stencilPoints)));
    % fullfile... sestavi pot do datoteke
    % sprintf ... v tem primeru vstavi pravilno vrednost v file name

fig = figure('Name', 'Casovna konvergenca RK4','Color', 'w');

loglog(actualDt, errors, 'o-', 'LineWidth', 1.8, 'MarkerSize', 7);
    % graf kjer sta x in y osi logaritemski
set(gca, 'XDir', 'reverse');
    % gca...get current axes -> "delaj na trenutno aktivnih koord. oseh"
    % XDir reverse ... smer podatkov na x osi obrni
grid on;
xlabel('\Deltat');
ylabel('||u_{RK4} - u_{ode15s}||_\infty pri t=1');
title(sprintf('Casovna konvergenca RK4, %d-tockovna prostorska shema', stencilPoints));

exportgraphics(fig, fullfile(config.outputDir, sprintf('temporal_convergence_RK4_%dpoint.png', stencilPoints)), 'Resolution', 200);

result = struct();
result.table = T;
result.Nx = config.Nx;
result.stencilPoints = stencilPoints;
end
