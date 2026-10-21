function burgers_set_ui_time(fig, timeValue)
%BURGERS_SET_UI_TIME Nastavi prikaz na izbrani cas.
%
%   BURGERS_SET_UI_TIME(FIG,TIMEVALUE) v interaktivnem Burgersovem oknu
%   poisce casovni vzorec, ki je najblizji TIMEVALUE, ter posodobi graf,
%   naslov, oznako casa in polozaj drsnika.
%

uiData = fig.UserData; % shrani vse podatke kot t, U, line, ... za krajsi klic

% poiscemo najblizjo izracunano vrednost, 
[~, idx] = min(abs(uiData.t - timeValue));

% sprememba na grafu
uiData.line.YData = uiData.U(idx, :);   % premaknemo crto
uiData.slider.Value = uiData.t(idx);    % drsnik da na dejanski prikazan cas
uiData.timeLabel.Text = sprintf('t = %.4f', uiData.t(idx)); % oznacimo nov cas

% posodobimo tudi naslov
title(uiData.axes, sprintf('Burgersova enacba: t = %.4f', uiData.t(idx)));

drawnow limitrate;
    % drawnow ... dejansko posodobimo graf
    % limitrate ... omeji pogostost posodabljanja za lazje premikanje sliderja
end
