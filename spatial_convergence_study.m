function result = spatial_convergence_study(stencilPoints)
%SPATIAL_CONVERGENCE_STUDY Preveri konvergenco glede na prostorsko mrezo.
%
%   RESULT = SPATIAL_CONVERGENCE_STUDY(STENCILPOINTS) primerja resitve na
%   zaporedno gostejsih mrezah. Casovna napaka je zmanjsana z
%   uporabo ODE15S in strogih toleranc.
%
% Privzeto:
%   - coarse Nx = 129, 257, 513, 1025
%   - reference Nx = 2049
%
%   Za vsako mrezo izracunamo E_h = max_x |u_h(T,x) - u_ref(T,x)|
%   in opazovani red p = log(E_h/E_{h/2}) / log(2).
%

if nargin < 1 % st. argumentov
    stencilPoints = 9;
end

config = burgers_default_config();
config.stencilPoints = stencilPoints;
config.Nt = 2;
config.relTol = 1e-11;
config.absTol = 1e-13;
config.maxStep = 5e-3;
config.saveVideo = false;

Nxs = [129, 257, 513, 1025];
referenceNx = 2049;

fprintf('\nProstorska konvergenca, %d-tockovna shema\n', stencilPoints);

config.Nx = referenceNx;
ref = burgers_reference(config);
uRef = ref.U(end, :);

errors = zeros(numel(Nxs), 1);
hValues = zeros(numel(Nxs), 1);

for k = 1:numel(Nxs)
    config.Nx = Nxs(k); % dolocimo st. vozlisc

    sol = burgers_reference(config);

    stride = (referenceNx - 1) / (config.Nx - 1); % koliko do sovpadanja mreze
    uRefOnGrid = uRef(1:stride:end);    % mreza ki se sovpada referencni

    errors(k) = max(abs(sol.U(end, :) - uRefOnGrid));
    hValues(k) = (config.xMax - config.xMin) / (config.Nx - 1);  % prostorski korak
end

observedOrder = NaN(size(errors));
observedOrder(1:end-1) = log(errors(1:end-1) ./ errors(2:end)) / log(2);

% od tu naprej enako kot temporal
T = table( Nxs(:), hValues, errors, observedOrder,'VariableNames', {'Nx', 'h', 'MaxErrorAtT1', 'ObservedOrder'});
disp(T);

csvName = sprintf('spatial_convergence_%dpoint.csv', stencilPoints);
writetable(T, fullfile(config.outputDir, csvName));

fig = figure('Name', 'Prostorska konvergenca', 'Color', 'w');

loglog(hValues, errors, 'o-', 'LineWidth', 1.8,'MarkerSize', 7);
set(gca, 'XDir', 'reverse');
grid on;
xlabel('h');
ylabel('||u_h - u_{ref}||_\infty pri t=1');
title(sprintf('Prostorska konvergenca: %d-tockovna shema', stencilPoints));

pngName = sprintf('spatial_convergence_%dpoint.png', stencilPoints);
exportgraphics(fig, fullfile(config.outputDir, pngName), 'Resolution', 200);

result = struct();
result.table = T;
result.referenceNx = referenceNx;
result.stencilPoints = stencilPoints;
end
