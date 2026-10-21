
%% main function
data = run_burgers_project();

% export_reference_csv(data); 
    % -> rezultat funkcije je bil zbrisan saj je
    % csv datoteka z izracunano referencno resitvijo prevelika in tudi zip
    % datoteka postane prevelika za spletno ucilnico.
data;
%% konvergenca

convSpace9 = spatial_convergence_study(9);
convSpace5 = spatial_convergence_study(5);

convTime = temporal_convergence_study(9);

comparison = compare_time_integrators();

%% interaktivna animacija

data = run_burgers_project();
interactive_burgers(data);


