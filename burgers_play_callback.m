function burgers_play_callback(~, ~, fig)
%BURGERS_PLAY_CALLBACK Predvaja resitev v interaktivnem UI oknu.
%
%   BURGERS_PLAY_CALLBACK(~,~,FIG) zaporedno prikazuje casovne vzorce
%   Burgersove resitve, shranjene v FIG.UserData.
%

uiData = fig.UserData;  %skrajsamo zapis

% razdelimo na ~200 frames
frameStep = max(1, round(numel(uiData.t) / 200));
% dolocimo indexe frames
frameIndices = 1:frameStep:numel(uiData.t);

% doda zadnji frame id v indekse, da se zagotovo prikaze
if frameIndices(end) ~= numel(uiData.t)
    frameIndices = [frameIndices, numel(uiData.t)];
end

% zanka po frames
for idx = frameIndices
    % klicemo funkcijo ki posodobi graf
    burgers_set_ui_time(fig, uiData.t(idx));
end

end
