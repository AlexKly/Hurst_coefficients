% Функция для расчета индекса фрактальности:
% === Входные параметры ===> : 
% frames - массив отсчетов размерностью число_окон x количество_отсчетов_на_окно;
% ceil_length - количество отсчетов в ячейке;
% <=== Выходные парметры === :
% indexFract - индекс фрактальности;
function [ indexFract ] = get_indexFract(frames, ceil_length)

    [num_frames, frame_length] = size(frames);
    num_ceils = floor(frame_length / ceil_length);  % Число ячейке в окне
    
    indexFract = zeros(1, num_frames);  % Выделяем память для индексов фрактольности 
    V = zeros(1, num_frames);           % Выделяем память для суммы амплитудных вариаций
    for i = 1:num_frames
        frame = frames(i, :);
        begin_ceil = 1;
        end_ceil = ceil_length;
        A = zeros(1, num_ceils);    % Выделяем память амплитудных вариаций в ячейках
        for j = 1:num_ceils
            ceil = zeros(1, ceil_length);
            % Накапливаем в отсчеты в ячейку:
            for k = begin_ceil:end_ceil
                ceil(k) = frame(k);
            end;
            begin_ceil = end_ceil + 1;              % Двигаем начало ячейки
            end_ceil = end_ceil + ceil_length + 1;  % Двигаем конец ячейки
            A(j) = max(ceil) - min(ceil);           % Считаем амплитудную вариацию
        end;
        V(i) = sum(A);  % Сумма амплитудных вариаций
        
        indexFract(i) = -(log(V(i)) / log(ceil_length));    % Индекс фрактальности временного ряда на i окне
    end;
    
end

