clc, clearvars, close all

% Настраиваемые параметры:
FILENAME = 'Analyzer_Ch_11052018_ред.wav';
FRAME_LENGTH = 0.025;   % Длина скользящего окна (мс)
FRAME_STEP = 0.015;      % Шаг скользящего окна (мс)
CEIL_LENGTH = 0.01;     % Длина клетки (мс)
THRESHOLD = 0.3;        % Порог

flag_debug = false;     % Флаг ошибки входных параметров. Если срабатывает исключения - присваиваются стандартные значения

% Обработка ошибок:
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
    
% Открыть аудиофайл:
[data, SampleRate] = audioread(FILENAME);
% data - звуковые отсчеты
% SampleRate - частота дискретизации

FrameLength = floor(FRAME_LENGTH * SampleRate); % Количетсво отсчетов в скользящем окне
FrameStep = floor(FRAME_STEP * SampleRate);     % Количетсво отсчетов в шаге окна
CeilLength = floor(CEIL_LENGTH * SampleRate);   % Количетсов отсчетов в ячейке

% Проходимся скользящим окном по сигнал и получаем массив отсчетов:
frames = framing(data, FrameLength, FrameStep);

% Вычисляем индекс фрактальности:
ind_frac = get_indexFract(frames, CeilLength);

mark = zeros(1, length(ind_frac));  % Выделяем память для массива маркеров
mark_mask = zeros(1, length(data)); % Выделяем память для маски маркеров для наложения на сигнал
begin_mark = 1;
end_mark = FrameLength;
% Цикл для заполнения массива маркеров и маски:
for i = 1:length(ind_frac)
    % Сравниваем индекс фрактальности с порогом:
    if (ind_frac(i) <= THRESHOLD)
        mark(i) = true;
    else
        mark(i) = false;
    end;
   
    % Заполняем маску маркеров:
    for j = begin_mark:end_mark
        mark_mask(j) = mark(i);
    end;
    begin_mark = end_mark + 1;        % Двигаем начало окна (левая граница)
    end_mark = end_mark + FrameStep;  % Двигаем конец окна (правая граница)
end;

figure(1);
hold on;
% Для корректного отображения названия на графике:
for i = 1:length(FILENAME)
    if (FILENAME(i) == '_')
        FILENAME(i) = ' ';
    end;
end;
% Временная сетка:
t = linspace(0, length(data) / SampleRate, length(data));
plot(data);
plot(mark_mask * max(data));
xlabel('t, с');
legend(FILENAME, 'Mark');

