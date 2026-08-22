function DisplayPicKey(window,rect,pic,timelimit)

KbName('UnifyKeyNames');
a = imread(pic);
escapeKey = KbName('ESCAPE');
in_white = [255, 255, 255];

w = Screen('MakeTexture', window, a);
Screen('DrawTexture', window, w);
Screen('TextSize',window, 16);
DrawFormattedText(window, 'time', 0, 0, in_white);
Screen('Flip', window);

start_time = GetSecs;
while GetSecs - start_time < timelimit;
    [keyIsDown,seconds,keyCode] = KbCheck;
    % If the user is pressing a key
    if keyIsDown
        find(keyCode);
        if keyCode(escapeKey)
            break;
        end
        while KbCheck;
            if GetSecs - start_time > timelimit
                break;
            end;
        end
    end
end
while KbCheck;
end % Wait until all keys are released.
end