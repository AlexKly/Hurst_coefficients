% ������� ��� ������� ������� �������������:
% === ������� ��������� ===> : 
% frames - ������ �������� ������������ �����_���� x ����������_��������_��_����;
% ceil_length - ���������� �������� � ������;
% <=== �������� �������� === :
% indexFract - ������ �������������;
function [ indexFract ] = get_indexFract(frames, ceil_length)

    [num_frames, frame_length] = size(frames);
    num_ceils = floor(frame_length / ceil_length);  % ����� ������ � ����
    
    indexFract = zeros(1, num_frames);  % �������� ������ ��� �������� ������������� 
    V = zeros(1, num_frames);           % �������� ������ ��� ����� ����������� ��������
    for i = 1:num_frames
        frame = frames(i, :);
        begin_ceil = 1;
        end_ceil = ceil_length;
        A = zeros(1, num_ceils);    % �������� ������ ����������� �������� � �������
        for j = 1:num_ceils
            ceil = zeros(1, ceil_length);
            % ����������� � ������� � ������:
            for k = begin_ceil:end_ceil
                ceil(k) = frame(k);
            end;
            begin_ceil = end_ceil + 1;              % ������� ������ ������
            end_ceil = end_ceil + ceil_length + 1;  % ������� ����� ������
            A(j) = max(ceil) - min(ceil);           % ������� ����������� ��������
        end;
        V(i) = sum(A);  % ����� ����������� ��������
        
        indexFract(i) = -(log(V(i)) / log(ceil_length));    % ������ ������������� ���������� ���� �� i ����
    end;
    
end

