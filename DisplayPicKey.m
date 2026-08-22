function keypress = DisplayPicKey(window,rect,pic,keys)
KbName('UnifyKeyNames');%sets up a common set of key names and values
a = imread(pic);
escapeKey = KbName('ESCAPE');
in_white = [255, 255, 255];
in_black = [0, 0, 0];

w = Screen('MakeTexture', window, a);
Screen('DrawTexture', window, w);
Screen('TextSize',window, 16);
DrawFormattedText(window, 'key', 0, 0, in_white);
Screen('Flip', window);

made_a_response = false;
while made_a_response == false
    [secs, keyCode, deltaSecs] = KbWait;
    keypress = find(keyCode,1);
    if any(keypress == keys) == 1
        made_a_response = true;
    elseif keypress == escapeKey
        made_a_response = true;
        break
    end
end
while KbCheck; end % Wait until all keys are released.
end