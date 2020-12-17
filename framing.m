% ‘ункци€ дл€ дроблени€ сигнала на перекрывающиес€ окна:
% === ¬ходные параметры ===> : 
% signal - массив временных отсчетов;
% frame_length - длина окна в отсчетах;
% frame_step - длина шага дл€ окна в отсчетах;
% <=== ¬ыходные парметры === :
% frames - массив отсчетов размерностью число_окон x количество_отсчетов_на_окно;
function [ frames ] = framing(signal, frame_length, frame_step)

    signal_length = length(signal);
    num_frames = floor((signal_length - frame_length) / frame_step) + 1;    %  оличество окон на заданном сигнале
    
    frames = zeros(num_frames, frame_length);   % ¬ыдел€ем пам€ть дл€ отсчетов, вход€щие в скольз€щие окна
    begin_ind = 1;
    end_ind = frame_length;
    shift = 0;
    for i = 1:num_frames
        for j = begin_ind:end_ind
            % Ќакапливаем отсчеты в массив скольз€щим окном:
            frames(i, j) = signal(j + frame_step * shift);
        end;
        % —двиг окна:
        shift = shift + 1;
    end;

end

