function config = burgers_default_config()
%BURGERS_DEFAULT_CONFIG Vrne privzete nastavitve projekta Burgersove enacbe 
% (podobno kot definiranje razredov v pythonu).
%
%   CONFIG = BURGERS_DEFAULT_CONFIG() vrne strukturo z vsemi pomembnimi
%   parametri za izracun referencne resitve enodimenzionalne viskozne
%   Burgersove enacbe
%
% homogena enacba:
%   u_t + u*u_x - nu*u_xx = 0,
% omejitve parametrov:
%   x v [-1,1], t v [0,1],
%
% doloceni koeficienti:
%   nu = 0.01/pi,
%
% zacetni in robni pogoji:
%   u(0,x) = -sin(pi*x),
%   u(t,-1) = u(t,1) = 0.
%
% Privzeta prostorska diskretizacija uporablja 9-tockovno shemo koncnih diferenc. 
% Casovna integracija uporablja ODE15S s strogima tolerancama.
%

config = struct();

% dolocimo vrednosti
config.nu = 0.01 / pi;

config.xMin = -1;
config.xMax = 1;
config.tEnd = 1;

config.Nx = 2001;
config.Nt = 1001;

% st. tock v prostorski shemi
config.stencilPoints = 9;

% metoda
config.timeSolver = 'ode15s';

config.relTol = 1e-10;
config.absTol = 1e-12;
config.maxStep = 1e-2;

% shranimo rezultate v mapo results
config.outputDir = 'results';   
config.saveVideo = true;
config.frameStep = 5;

config.exportCSV = false;
end
