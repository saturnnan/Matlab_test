 % 2018/03/18
% Alpha Version 1.0
% ������������

% ��ȡԤ��Ļ���������
[filename, filedir]=uigetfile;
load(fullfile(filedir, filename));

% �뾶���ַ���
ArrayPar.DivPar.NumR = 20;

% �ǶȻ��ַ���
ArrayPar.DivPar.NumAngle = 20;

% save('ArrayInfo','ArrayPar');
