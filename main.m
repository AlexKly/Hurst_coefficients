clc, clearvars, close all

% ������������� ���������:
FILENAME = 'Analyzer_Ch_11052018_���.wav';
FRAME_LENGTH = 0.025;   % ����� ����������� ���� (��)
FRAME_STEP = 0.015;      % ��� ����������� ���� (��)
CEIL_LENGTH = 0.01;     % ����� ������ (��)
THRESHOLD = 0.3;        % �����

flag_debug = false;     % ���� ������ ������� ����������. ���� ����������� ���������� - ������������� ����������� ��������

% ��������� ������:
% ============================================================== %
if(FRAME_LENGTH == 0 && FRAME_STEP == 0 && CEIL_LENGTH == 0)
    flag_debug = true;
    warning('FRAME_LENGTH or FRAME STEP or CEIL_LENGTH is equal 0');
end;
if (FRAME_LENGTH <= FRAME_STEP)
    flag_debug = true;
    warning('FRAME_LENGTH is less then or equal FRAME_STEP');
end;
if (FRAME_LENGTH <= CEIL_LENGTH)
    flag_debug = true;
    warning('FRAME_LENGTH is less then or equal CEIL_LENGTH');
end;
if (THRESHOLD < 0 && THRESHOLD > 1)
    flag_debug = true;
    warning('THRESHOLD is more then 1 and less then 0');
end;
% ============================================================== %

if (flag_debug == true)
    FRAME_LENGTH = 0.025;
    FRAME_STEP = 0.015;
    CEIL_LENGTH = 0.01;
    THRESHOLD = 0.3;
end;
    
% ������� ���������:
[data, SampleRate] = audioread(FILENAME);
% data - �������� �������
% SampleRate - ������� �������������

FrameLength = floor(FRAME_LENGTH * SampleRate); % ���������� �������� � ���������� ����
FrameStep = floor(FRAME_STEP * SampleRate);     % ���������� �������� � ���� ����
CeilLength = floor(CEIL_LENGTH * SampleRate);   % ���������� �������� � ������

% ���������� ���������� ����� �� ������ � �������� ������ ��������:
frames = framing(data, FrameLength, FrameStep);

% ��������� ������ �������������:
ind_frac = get_indexFract(frames, CeilLength);

mark = zeros(1, length(ind_frac));  % �������� ������ ��� ������� ��������
mark_mask = zeros(1, length(data)); % �������� ������ ��� ����� �������� ��� ��������� �� ������
begin_mark = 1;
end_mark = FrameLength;
% ���� ��� ���������� ������� �������� � �����:
for i = 1:length(ind_frac)
    % ���������� ������ ������������� � �������:
    if (ind_frac(i) <= THRESHOLD)
        mark(i) = true;
    else
        mark(i) = false;
    end;
   
    % ��������� ����� ��������:
    for j = begin_mark:end_mark
        mark_mask(j) = mark(i);
    end;
    begin_mark = end_mark + 1;        % ������� ������ ���� (����� �������)
    end_mark = end_mark + FrameStep;  % ������� ����� ���� (������ �������)
end;

figure(1);
hold on;
% ��� ����������� ����������� �������� �� �������:
for i = 1:length(FILENAME)
    if (FILENAME(i) == '_')
        FILENAME(i) = ' ';
    end;
end;
% ��������� �����:
t = linspace(0, length(data) / SampleRate, length(data));
plot(data);
plot(mark_mask * max(data));
xlabel('t, �');
legend(FILENAME, 'Mark');

