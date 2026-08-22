% Immediate and Delayed recognition task with distractor between tests.
% Making this within subjects, 1 lists per condition.
% If Rem 6 = 1, TikTok > Youtube > Reading
% If Rem 6 = 2, TikTok > Reading > Youtube
% If Rem 6 = 3, Youtube > TikTok > Reading
% If Rem 6 = 4, Youtube > Reading > TikTok
% If Rem 6 = 5, Reading > TikTok > Youtube
% If Rem 6 = 0, Reading > Youtube > TikTok

%% CHANGE FOR EACH PARTICIPANT
subNo = 5;
buildmachine = 0; % Change to 1 if running on uni machine, 0 if personal machine

%% ADD PSYCHTOOLBOX TO PATH (FOR UNI MACHINES)
if buildmachine == 1
    if not(exist('PsychStartup', 'file'))
        matlab.addons.toolbox.installToolbox('\\cfs\shared\class\MATLAB\psychtoolbox-3.0.19.13.mltbx')
    end
    psychbasicpath=fullfile(PsychtoolboxRoot,'PsychBasic')
    rmpath(psychbasicpath)
    addpath(psychbasicpath,'-end')
    PsychStartup
end

%% user-defined variables
wordlistlength = 120; % number of items presented at test
num_lists = 6; % number of lists required
random_order_file = strcat('pp',num2str(subNo),'_randomstimuli.mat');
data_file = strcat('pp',num2str(subNo),'_data.mat');
fullscreen = 1; % switch to 1 for real experiment
pausetime = 5;

% load and randomise word stimuli
load words.mat;
rand('state',sum(100*clock));% initialize rand - Use a modified version a Subtract-with-Borrow algorithm
random_indices = randperm(length(words))';
words = words(random_indices); %jumbles cell array

%keyboard variables
KbName('UnifyKeyNames');%sets up a common set of key names and values
pkey=KbName('p');
spacebar=KbName('space');
allkeys=[pkey spacebar];
key0=[KbName('0)'), KbName('0')]; 
key1=[KbName('1!'), KbName('1')];
key2=[KbName('2@'), KbName('2')];
key3=[KbName('3#'), KbName('3')];
key4=[KbName('4$'), KbName('4')]; 
key5=[KbName('5%'), KbName('5')];
numberkeys=[key0 key1 key2 key3 key4 key5];

%% WRITE NEW LISTs
% Defines the stimuli to be used in all blocks.  If an error were to occur
% during one block, the other blocks could be resumed.

% Create experimental lists for both 'words'
words = words(1:wordlistlength*num_lists); % creates 1 column
% This now needs to be written out in an intelligible way
wordlist = words;
wordlist = reshape(wordlist, wordlistlength, num_lists);
save(random_order_file, 'wordlist*', 'prac*');

%% OPEN WINDOW
ListenChar(2); %turns off matlab command window keyboard output
Screen('Preference','SkipSyncTests', 2); %don't worry about refresh timing for now
if fullscreen == 0
    rect = [0 0 1024 768];
    window=Screen('OpenWindow', 0, 255, [rect(1) rect(2) rect(3) rect(4)]);
else
    rect=Screen('Rect',0);%gets dimensions of screen
    window=Screen('OpenWindow', 0, 255);
end

%% MEMORY PHASE Instructions and Practice phase
DisplayPicKey(window,rect,'Slide1.JPG',allkeys)
DisplayPicKey(window,rect,'Slide2.JPG',allkeys)
DisplayPicKey(window,rect,'Slide3.JPG',allkeys)
StudyWord(window,rect,practestlist);
DisplayPicKey(window,rect,'Slide4.JPG',allkeys)
TestWord_SIR(window,rect,practestlist);
DisplayPicKey(window,rect,'Slide5.JPG',allkeys)

%% Administer study/test runs with counterbalanced run order

% Blocks 1 & 2
switch rem(subNo,6)
    case {1,2} % TikTok Blocks 1 & 2
        % Block 1 Study
        StudyWord1 = StudyWord(window,rect,wordlist(:,1));
        t = cell2mat(StudyWord1(:,3));
        StudyWord1_immediate=StudyWord1(t == 1,:);
        StudyWord1_delayed=StudyWord1(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        % Block 1 Tests
        TestWordTikTok1_imm_1= TestWord_SIR(window,rect,StudyWord1_immediate);
        DisplayPicKey(window,rect,'Slide7_TikTok.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordTikTok1_del_1= TestWord_SIR(window,rect,StudyWord1_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 2 Study
%         StudyWord2 = StudyWord(window,rect,wordlist(:,2));
%         t = cell2mat(StudyWord2(:,3));
%         StudyWord2_immediate=StudyWord2(t == 1,:);
%         StudyWord2_delayed=StudyWord2(t == 2,:);
% 
%         % Block 2 tests
%         TestWordTikTok2_imm_2= TestWord_SIR(window,rect,StudyWord2_immediate);
%         DisplayPicKey(window,rect,'Slide7_TikTok.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordTikTok2_del_2= TestWord_SIR(window,rect,StudyWord2_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

    case {3,4} % YouTube Blocks 1 & 2
        % Block 1 Study
        StudyWord1 = StudyWord(window,rect,wordlist(:,1));
        t = cell2mat(StudyWord1(:,3));
        StudyWord1_immediate=StudyWord1(t == 1,:);
        StudyWord1_delayed=StudyWord1(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        %Block 1 Tests
        TestWordYouTube1_imm_1= TestWord_SIR(window,rect,StudyWord1_immediate);
        DisplayPicKey(window,rect,'Slide7_YouTube.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordYouTube1_del_1= TestWord_SIR(window,rect,StudyWord1_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 2 Study
%         StudyWord2 = StudyWord(window,rect,wordlist(:,2));
%         t = cell2mat(StudyWord2(:,3));
%         StudyWord2_immediate=StudyWord2(t == 1,:);
%         StudyWord2_delayed=StudyWord2(t == 2,:);
%         DisplayPicKey(window,rect,'Slide6.JPG',allkeys)
% 
%         % Block 2 Tests
%         TestWordYouTube2_imm_2= TestWord_SIR(window,rect,StudyWord2_immediate);
%         DisplayPicKey(window,rect,'Slide7_YouTube.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordYouTube2_del_2= TestWord_SIR(window,rect,StudyWord2_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

    case {5,0} % Reading Blocks 1 & 2
        % Block 1 Study
        StudyWord1 = StudyWord(window,rect,wordlist(:,1));
        t = cell2mat(StudyWord1(:,3));
        StudyWord1_immediate=StudyWord1(t == 1,:);
        StudyWord1_delayed=StudyWord1(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        TestWordRead1_imm_1= TestWord_SIR(window,rect,StudyWord1_immediate);
        DisplayPicKey(window,rect,'Slide7_Read.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordRead1_del_1= TestWord_SIR(window,rect,StudyWord1_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 2 Study
%         StudyWord2 = StudyWord(window,rect,wordlist(:,2));
%         t = cell2mat(StudyWord2(:,3));
%         StudyWord2_immediate=StudyWord2(t == 1,:);
%         StudyWord2_delayed=StudyWord2(t == 2,:);
%         DisplayPicKey(window,rect,'Slide6.JPG',allkeys)
% 
%         TestWordRead2_imm_2= TestWord_SIR(window,rect,StudyWord2_immediate);
%         DisplayPicKey(window,rect,'Slide7_Read.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordRead2_del_2= TestWord_SIR(window,rect,StudyWord2_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)
end

% Blocks 3 & 4
switch rem(subNo,6)
    case {3,5} % TikTok Blocks 3 & 4
        % Block 3 Study
        StudyWord3 = StudyWord(window,rect,wordlist(:,3));
        t = cell2mat(StudyWord3(:,3));
        StudyWord3_immediate=StudyWord3(t == 1,:);
        StudyWord3_delayed=StudyWord3(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        % Block 3 Tests
        TestWordTikTok1_imm_3= TestWord_SIR(window,rect,StudyWord3_immediate);
        DisplayPicKey(window,rect,'Slide7_TikTok.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordTikTok1_del_3= TestWord_SIR(window,rect,StudyWord3_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 4 Study
%         StudyWord4 = StudyWord(window,rect,wordlist(:,4));
%         t = cell2mat(StudyWord4(:,3));
%         StudyWord4_immediate=StudyWord4(t == 1,:);
%         StudyWord4_delayed=StudyWord4(t == 2,:);
% 
%         % Block 4 tests
%         TestWordTikTok2_imm_4= TestWord_SIR(window,rect,StudyWord4_immediate);
%         DisplayPicKey(window,rect,'Slide7_TikTok.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordTikTok2_del_4= TestWord_SIR(window,rect,StudyWord4_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

    case {1,0} % YouTube Blocks 3 & 4
        % Block 3 Study
        StudyWord3 = StudyWord(window,rect,wordlist(:,3));
        t = cell2mat(StudyWord3(:,3));
        StudyWord3_immediate=StudyWord3(t == 1,:);
        StudyWord3_delayed=StudyWord3(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        %Block 3 Tests
        TestWordYouTube1_imm_3= TestWord_SIR(window,rect,StudyWord3_immediate);
        DisplayPicKey(window,rect,'Slide7_YouTube.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordYouTube1_del_3= TestWord_SIR(window,rect,StudyWord3_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 4 Study
%         StudyWord4 = StudyWord(window,rect,wordlist(:,4));
%         t = cell2mat(StudyWord4(:,3));
%         StudyWord4_immediate=StudyWord4(t == 1,:);
%         StudyWord4_delayed=StudyWord4(t == 2,:);
%         DisplayPicKey(window,rect,'Slide6.JPG',allkeys)
% 
%         % Block 4 Tests
%         TestWordYouTube2_imm_4= TestWord_SIR(window,rect,StudyWord4_immediate);
%         DisplayPicKey(window,rect,'Slide7_YouTube.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordYouTube2_del_4= TestWord_SIR(window,rect,StudyWord4_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

    case {2,4} % Reading Blocks 3 & 4
        % Block 3 Study
        StudyWord3 = StudyWord(window,rect,wordlist(:,3));
        t = cell2mat(StudyWord3(:,3));
        StudyWord3_immediate=StudyWord3(t == 1,:);
        StudyWord3_delayed=StudyWord3(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        % Block 3 Tests
        TestWordRead1_imm_3= TestWord_SIR(window,rect,StudyWord3_immediate);
        DisplayPicKey(window,rect,'Slide7_Read.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordRead1_del_3= TestWord_SIR(window,rect,StudyWord3_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 4 Study
%         StudyWord4 = StudyWord(window,rect,wordlist(:,4));
%         t = cell2mat(StudyWord4(:,3));
%         StudyWord4_immediate=StudyWord4(t == 1,:);
%         StudyWord4_delayed=StudyWord4(t == 2,:);
%         DisplayPicKey(window,rect,'Slide6.JPG',allkeys)
% 
%         % Block 4 Tests
%         TestWordRead2_imm_4= TestWord_SIR(window,rect,StudyWord4_immediate);
%         DisplayPicKey(window,rect,'Slide7_Read.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordRead2_del_4= TestWord_SIR(window,rect,StudyWord4_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)
end

% Blocks 5 & 6
switch rem(subNo,6)
    case {4,0} % TikTok Blocks 5 & 6
        % Block 5 Study
        StudyWord5 = StudyWord(window,rect,wordlist(:,5));
        t = cell2mat(StudyWord5(:,3));
        StudyWord5_immediate=StudyWord5(t == 1,:);
        StudyWord5_delayed=StudyWord5(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        % Block 5 Tests
        TestWordTikTok1_imm_5= TestWord_SIR(window,rect,StudyWord5_immediate);
        DisplayPicKey(window,rect,'Slide7_TikTok.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordTikTok1_del_5= TestWord_SIR(window,rect,StudyWord5_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 6 Study
%         StudyWord6 = StudyWord(window,rect,wordlist(:,6));
%         t = cell2mat(StudyWord6(:,3));
%         StudyWord6_immediate=StudyWord6(t == 1,:);
%         StudyWord6_delayed=StudyWord6(t == 2,:);
% 
%         % Block 6 tests
%         TestWordTikTok2_imm_6= TestWord_SIR(window,rect,StudyWord6_immediate);
%         DisplayPicKey(window,rect,'Slide7_TikTok.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordTikTok2_del_6= TestWord_SIR(window,rect,StudyWord6_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

    case {2,5} % YouTube Blocks 5 & 6
        % Block 5 Study
        StudyWord5 = StudyWord(window,rect,wordlist(:,5));
        t = cell2mat(StudyWord5(:,3));
        StudyWord5_immediate=StudyWord5(t == 1,:);
        StudyWord5_delayed=StudyWord5(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        %Block 5 Tests
        TestWordYouTube1_imm_5= TestWord_SIR(window,rect,StudyWord5_immediate);
        DisplayPicKey(window,rect,'Slide7_YouTube.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordYouTube1_del_5= TestWord_SIR(window,rect,StudyWord5_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 6 Study
%         StudyWord6 = StudyWord(window,rect,wordlist(:,6));
%         t = cell2mat(StudyWord6(:,3));
%         StudyWord6_immediate=StudyWord6(t == 1,:);
%         StudyWord6_delayed=StudyWord6(t == 2,:);
%         DisplayPicKey(window,rect,'Slide6.JPG',allkeys)
% 
%         % Block 6 Tests
%         TestWordYouTube2_imm_6= TestWord_SIR(window,rect,StudyWord6_immediate);
%         DisplayPicKey(window,rect,'Slide7_YouTube.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordYouTube2_del_6= TestWord_SIR(window,rect,StudyWord6_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

    case {1,3} % Reading Blocks 5 & 6
        % Block 5 Study
        StudyWord5 = StudyWord(window,rect,wordlist(:,5));
        t = cell2mat(StudyWord5(:,3));
        StudyWord5_immediate=StudyWord5(t == 1,:);
        StudyWord5_delayed=StudyWord5(t == 2,:);
        DisplayPicKey(window,rect,'Slide6.JPG',allkeys)

        % Block 5 Tests
        TestWordRead1_imm_5= TestWord_SIR(window,rect,StudyWord5_immediate);
        DisplayPicKey(window,rect,'Slide7_Read.JPG',allkeys)
        DisplayPicTime(window,rect,'Slide8_5.JPG',60)
        DisplayPicTime(window,rect,'Slide8_4.JPG',60)
        DisplayPicTime(window,rect,'Slide8_3.JPG',60)
        DisplayPicTime(window,rect,'Slide8_2.JPG',60)
        DisplayPicTime(window,rect,'Slide8_1.JPG',60)
        DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
        TestWordRead1_del_5= TestWord_SIR(window,rect,StudyWord5_delayed);
        DisplayPicKey(window,rect,'Slide10.JPG',allkeys)

%         % Block 6 Study
%         StudyWord6 = StudyWord(window,rect,wordlist(:,6));
%         t = cell2mat(StudyWord6(:,3));
%         StudyWord6_immediate=StudyWord6(t == 1,:);
%         StudyWord6_delayed=StudyWord6(t == 2,:);
%         DisplayPicKey(window,rect,'Slide6.JPG',allkeys)
% 
%         % Block 6 Tests
%         TestWordRead2_imm_6= TestWord_SIR(window,rect,StudyWord6_immediate);
%         DisplayPicKey(window,rect,'Slide7_Read.JPG',allkeys)
%         DisplayPicTime(window,rect,'Slide8_5.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_4.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_3.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_2.JPG',60)
%         DisplayPicTime(window,rect,'Slide8_1.JPG',60)
%         DisplayPicKey(window,rect,'Slide9.JPG',allkeys)
%         TestWordRead2_del_6= TestWord_SIR(window,rect,StudyWord6_delayed);
%         DisplayPicKey(window,rect,'Slide10.JPG',allkeys)
end

%% Questionnaire
DisplayPicKey(window,rect,'TikTokQIntro.JPG',allkeys)

questionnaire = {};
qs = dir('Questionnaire');
qs = {qs(~[qs.isdir]).name};
for q = 1:length(qs)
    image = strcat('Questionnaire\', qs{q});
    response = DisplayPicKey(window,rect,image,numberkeys);
    questionnaire{q,1} = q;
    if response > 60
        response = response - 96;
    else
        response = response - 48;
    end
    questionnaire{q,2} = response;
end

DisplayPicKey(window,rect,'Slide11.JPG',allkeys)

%% MOVE FILES TO NEWLY CREATED PP DIRECTORY

%Makes new directory
mkdir(strcat('pp',num2str(subNo)));
save(data_file, 'Study*', 'Test*', questionnaire);
movefile(random_order_file, strcat('pp',num2str(subNo),'/',random_order_file));
movefile(data_file, strcat('pp',num2str(subNo),'/',data_file));

Screen('CloseAll');
ListenChar(0); %turns on matlab command window keyboard output

