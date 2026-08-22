function [wordlist] = Study(window, rect, wordlist) % Allows the script to be called as a function
% clear all;
% KbName('UnifyKeyNames')
% Screen('Preference','SkipSyncTests', 1); %don't worry about refresh timing for now
% rect = [0 0 1024 768];
% window=Screen('OpenWindow', 0, 255, [rect(1) rect(2) rect(3) rect(4)]);
% Screen('TextFont',window, 'Helvetica');
% load testingwordlist.mat;

%% Define Subject Number Variable Constants
listlength = size(wordlist);
listlength = listlength(1);
presentationlength = listlength/2;

% keyboard responses
escapeKey = KbName('ESCAPE');

% colours
in_white = [255, 255, 255];
in_black = [0, 0, 0];
in_red = [255, 0, 0];
in_green = [0, 255, 0];
in_blue = [0, 255, 255];

%% INITIALISE PRESENTATION OF STUDY LIST

Screen('TextFont',window, 'Arial');
Screen('TextSize',window, 48);

%initialize functions and values
GetSecs;
KbCheck;
fixOA = 0.5; % fixation timing in seconds
presOA = 2.5;

% The following initialise variable for the first trial
made_a_response = false;

%% FIXATION + SLOP

BeginStudy_time = GetSecs;
for study_trials = 1:presentationlength
    start_time = GetSecs; %onset of study trial
    
    % Fixation
    Screen('TextSize',window, 48);
    DrawFormattedText(window, '+', 'center', 'center', in_black);
    Screen('Flip',window);
    while GetSecs - start_time < fixOA;
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        % If the user is pressing a key
        if keyIsDown
            find(keyCode);
            if keyCode(escapeKey)
                break;
            end
            while KbCheck;
                if GetSecs - start_time > fixOA break; end;
            end
        end
    end
    
    %% PRESENTATION OF STIMULUS
    Screen('TextSize',window, 48);
    DrawFormattedText(window, wordlist{study_trials,1}, 'center', 'center', in_black);
    
    Screen('Flip',window);
    trial_time = GetSecs;
    
    while GetSecs - start_time < presOA;
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        % If the user is pressing a key
        if keyIsDown
            find(keyCode);
            if keyCode(escapeKey)
                break;
            end
            while KbCheck;
                if GetSecs - start_time > presOA break; end;
            end
        end
    end
    
    wordlist{study_trials,2}=1;
    wordlist{study_trials,4}=GetSecs-trial_time;
    wordlist{study_trials,5}=GetSecs-BeginStudy_time;
    
    %% RESET BEFORE LOOP
    
    made_a_response = false; %reset for new trial
end %end of for study_trial loop

random_indices = randperm(listlength/2)';
immediatedelay = [ones(listlength/4,1)+1;ones(listlength/4,1)];
immediatedelay = immediatedelay(random_indices);
immediatedelay = [immediatedelay;immediatedelay];
wordlist(:,3) = num2cell(immediatedelay);

while KbCheck; end % Wait until all keys are released.
ListenChar(0);

% Screen('CloseAll');
end