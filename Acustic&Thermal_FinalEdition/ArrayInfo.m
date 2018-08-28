 % 2018/03/18
% Alpha Version 1.0
% 输入相控阵参数

% 读取预设的换能器参数
[filename, filedir]=uigetfile;
load(fullfile(filedir, filename));

% 半径划分份数
ArrayPar.DivPar.NumR = 20;

% 角度划分份数
ArrayPar.DivPar.NumAngle = 20;

% save('ArrayInfo','ArrayPar');
