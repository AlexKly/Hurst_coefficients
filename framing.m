% ������� ��� ��������� ������� �� ��������������� ����:
% === ������� ��������� ===> : 
% signal - ������ ��������� ��������;
% frame_length - ����� ���� � ��������;
% frame_step - ����� ���� ��� ���� � ��������;
% <=== �������� �������� === :
% frames - ������ �������� ������������ �����_���� x ����������_��������_��_����;
function [ frames ] = framing(signal, frame_length, frame_step)

    signal_length = length(signal);
    num_frames = floor((signal_length - frame_length) / frame_step) + 1;    % ���������� ���� �� �������� �������
    
    frames = zeros(num_frames, frame_length);   % �������� ������ ��� ��������, �������� � ���������� ����
    begin_ind = 1;
    end_ind = frame_length;
    shift = 0;
    for i = 1:num_frames
        for j = begin_ind:end_ind
            % ����������� ������� � ������ ���������� �����:
            frames(i, j) = signal(j + frame_step * shift);
        end;
        % ����� ����:
        shift = shift + 1;
    end;

end

