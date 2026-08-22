function [testoutput] = Test1(window, rect, wordlist) % Allows the script to be called as a function
% clear all;
% KbName('UnifyKeyNames')
% Screen('Preference','SkipSyncTests', 1); %don't worry about refresh timing for now
% rect = [0 0 1024 768];
% window=Screen('OpenWindow', 0, 255, [rect(1) rect(2) rect(3) rect(4)]);
% Screen('TextFont',window, 'Arial');
% load testingwordlist.mat;
% wordlist = StudyWord1_immediate;

%% Define Subject Number Variable Constants
listlength = size(wordlist);
listlength = listlength(1);
presentationlength = listlength/2;
ITI_text = '+';
stimfontsize = 48;

% Colours
in_white = [255, 255, 255];
in_black = [0, 0, 0];
in_grey = [150,150,150];
in_red = [255, 0, 0];
in_green = [0, 255, 0];
in_blue = [100, 100, 255];

% Expected keypresses
KbName('UnifyKeyNames');%sets up a common set of key names and values
key1=[KbName('1!'), KbName('1')];
key2=[KbName('2@'), KbName('2')];
key3=[KbName('3#'), KbName('3')];

keyb=KbName('b');
keyn=KbName('n');
escapeKey = KbName('ESCAPE');

%% Randomise list for test
order = randperm(length(wordlist));
words = wordlist(order,:);

%% INITIALISE PRESENTATION OF TEST LIST

question1_text = 'OLD (b) or NEW (n)?';
question2_text = 'Confidence: 1 - 3?';

Screen('TextFont',window, 'Arial');

% Initialise functions and clues
GetSecs;
KbCheck;
test_length = listlength;
ITI = .5;

% The following initialise variable for the first trial
made_a_response = false;

% Fixation presented, which last .5 seconds
Screen('TextSize',window, 48);
DrawFormattedText(window, ITI_text, 'center', 'center', in_black);

Screen('Flip',window);
start_time = GetSecs;
while GetSecs - start_time < .5;
    [ keyIsDown, seconds, keyCode ] = KbCheck;
    % If the user is pressing a key
    if keyIsDown
        find(keyCode);
        if keyCode(escapeKey)
            break;
        end
        while KbCheck;
            if GetSecs - start_time > .5
                break;
            end;
        end
    end
end

%% STIMULUS

BeginTest_time = GetSecs;

for test_trials = 1:test_length
    % OLDNEW
    trial_time = GetSecs; %onset of test trial
    
    Screen('TextSize',window, 50);
    DrawFormattedText(window, question1_text, 'center', rect(4)*1/6, in_black);
       
    %Words
    Screen('TextSize',window, stimfontsize);
    DrawFormattedText_mod(window, words{test_trials,1}, 'center', 'center', in_black);
    
    Screen('Flip',window);
    
    while made_a_response == false
        [secs, keyCode, deltaSecs] = KbWait;
        keypress = find(keyCode,1);
        if any(keypress == keyb) == 1
            made_a_response = true;
            respcode = 'resp_old';
        elseif any(keypress == keyn) == 1
            made_a_response = true;
            respcode = 'resp_new';
        elseif keypress == escapeKey
            made_a_response = true;
            respcode = 'Escape';
        end
    end
    
    words{test_trials,6}=respcode;
    words{test_trials,8}=GetSecs-trial_time;
    words{test_trials,9} = GetSecs-BeginTest_time;
    
    if keypress == escapeKey
        words{test_trials,7} = 'NA';
    elseif strcmp(respcode,'resp_old')&&(isempty(words{test_trials,2})==0)
        words{test_trials,7} = true;
        while KbCheck; end % Wait until all keys are released.
    elseif strcmp(respcode,'resp_new')&&isempty(words{test_trials,2})
        words{test_trials,7} = true;
        while KbCheck; end % Wait until all keys are released.
    else
        words{test_trials,7} = false;
        while KbCheck; end % Wait until all keys are released.
    end
    
    % JUSTIFICATION
    made_a_response = false; %reset for new trial
    trial_time = GetSecs; %onset of test trial
    
    Screen('TextSize',window, 50);
    DrawFormattedText(window, question2_text, 'center', rect(4)*3/4, in_black);
       
    %Words
    Screen('TextSize',window, stimfontsize);
    DrawFormattedText_mod(window, words{test_trials,1}, 'center', 'center', in_black);
    
    Screen('Flip',window);
    
    while made_a_response == false
        [secs, keyCode, deltaSecs] = KbWait;
        keypress = find(keyCode,1);
        if any(keypress == key1) == 1
            made_a_response = true;
            respcode = 1;
        elseif any(keypress == key2) == 1
            made_a_response = true;
            respcode = 2;
        elseif any(keypress == key3) == 1
            made_a_response = true;
            respcode = 3;
        elseif keypress == escapeKey
            made_a_response = true;
            respcode = 'Escape';
        end
    end
    
    words{test_trials,10}=respcode;
    words{test_trials,11}=GetSecs-trial_time;
    words{test_trials,12} = GetSecs-BeginTest_time;
        
    % 0.5s ITI
    
%     Screen('TextSize',window, 50);
%     DrawFormattedText(window, question1_text, 'center', rect(4)*1/6, in_black);
    
    Screen('TextSize',window, 48);
    DrawFormattedText(window, ITI_text, 'center', 'center', in_black);
    Screen('Flip',window);
    ITI_start = GetSecs;
    while GetSecs - ITI_start < .5;
        [ keyIsDown, seconds, keyCode ] = KbCheck;
        % If the user is pressing a key
        if keyIsDown
            find(keyCode);
            if keyCode(escapeKey)
                break;
            end
            while KbCheck;
                if GetSecs - ITI_start > .5
                    break;
                end;
            end
        end
    end
    
    made_a_response = false; %reset for new trial
    
end
while KbCheck; end % Wait until all keys are released.

%% Finish Study and write to a file
testoutput = words;

% ListenChar(0);
% Screen('CloseAll');
end