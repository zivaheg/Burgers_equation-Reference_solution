function data = run_burgers_project()
%RUN_BURGERS_PROJECT izracuna priblizek + rezultate.
%
% (Glavna funkcija projekta Burgersove enacbe.)
% izracuna zelo natancen numerični priblizek resitve viskozne Burgersove 
% enacbe, shrani rezultate in izdela osnovne graficne prikaze ter animacijo.
%
% Privzeto:
%   - 9-tockovna prostorska shema koncnih diferenc,
%   - metoda premic (method of lines),
%   - MATLAB solver ODE15S,
%   - strogi toleranci RelTol = 1e-10 in AbsTol = 1e-12,
%   - gosta mreza Nx = 2001 in Nt = 1001.
%

config = burgers_default_config();

fprintf(' REFERENCNA RESITEV VISKOZNE BURGERSOVE ENACBE\n');
fprintf('nu               = %.12g\n', config.nu);
fprintf('Nx               = %d\n', config.Nx);
fprintf('Nt               = %d\n', config.Nt);
fprintf('prostorska shema = %d-tockovna\n', config.stencilPoints);
fprintf('casovni solver   = %s\n', config.timeSolver);
fprintf('RelTol           = %.1e\n', config.relTol);
fprintf('AbsTol           = %.1e\n\n', config.absTol);

tic;
data = burgers_reference(config);
data.elapsedTime = toc;

fprintf('Izracun koncan v %.3f s.\n', data.elapsedTime);

% mat datoteka shrani tocne vrednosti.
matFile = fullfile(config.outputDir, 'burgers_reference.mat');
save(matFile, '-struct', 'data', '-v7.3');
fprintf('Shranjeno: %s\n', matFile);

% shranimo tudi CSV datoteko za kasnejse delo v Pythonu.
if config.exportCSV
   export_reference_csv(data, config.outputDir);
end

% glavne vizualizacije
plot_burgers_results(data, config.outputDir);

% animacija razvoja profila skozi cas
animate_burgers(data, config.frameStep, config.saveVideo, config.outputDir);

end
