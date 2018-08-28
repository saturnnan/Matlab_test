% 2018/03/06
% Beta Version 2.0
% 将换能器构成参数，整理成最终形式。

% 凹球面曲率半径，单位：m
clear
format long;

ArrayPar.TransducerType = 'Shit';    % 'OldRegular' or 'NewRegular' or 'Shit'
ArrayPar.EleR = 5e-3;                       % 换能片半径
ArrayPar.Diameter = 0e0;                    % 未定义
ArrayPar.EleInterval = 5e-4;                % 换能片间隙距离

NumRingEle = [1 6 13 19 25];                % 每环阵元数量
NumRing = size(NumRingEle,2);               % 阵元环数
ArrayPar.EleNum = sum(NumRingEle);          % 相控阵阵元数量

ArrayPar.DivPar.NumR = 20;                  % 半径划分份数
ArrayPar.DivPar.NumAngle = 20;          	% 角度划分份数
ArrayPar.DivPar.SIR_Div = 1e-4;             % 换能片细分尺寸（该参数仅用于SIR方法）

if strcmpi(ArrayPar.TransducerType,'OldRegular') == 1
    ArrayPar.FocalLength = 120e-3;          % 探头曲率半径
    AngleZ = [0 5.521 11.041 16.295 21.548]/180*pi; % 每环与Z轴夹角，单位：rad
elseif strcmpi(ArrayPar.TransducerType,'NewRegular') == 1
    ArrayPar.FocalLength = 115e-3;          % 探头曲率半径
    AngleZ = [0 5.552 11.104 16.387 21.670]/180*pi; % 每环与Z轴夹角，单位：rad
elseif strcmpi(ArrayPar.TransducerType,'Shit') == 1
    ArrayPar.FocalLength = 120e-3;          % 探头曲率半径
    AngleZ = [0 5.34 10.00 14.89 19.92]/180*pi;
end
AngleZ = pi - AngleZ;

% 每环首阵元与X轴夹角，单位：rad
AngleFirstX = [0 8.9153 22.0359 15.2772 42.8234]/180*pi;
if strcmpi(ArrayPar.TransducerType,'Shit') == 1
    ArrayPar.AngleFirstX = pi ./ NumRingEle;
end

% 原点为自然焦点；
ArrayPar.ElePos.CartCoor = [];              % 换能片几何中心笛卡尔坐标
ArrayPar.ElePos.NormVector = [];            % 换能片笛卡尔坐标系的单位法向量
ArrayPar.ElePos.PolA = [];                  % 换能片球坐标极角，即和X轴正方向的夹角
ArrayPar.ElePos.AziA = [];                  % 换能片球坐标方位角，即和Z轴正方向的夹角
ArrayPar.ElePos.R = ArrayPar.FocalLength*ones(ArrayPar.EleNum,1);	% 换能片球坐标径向距离
ArrayPar.EleDisMin = [];                    % 相对于其最近的换能片间的距离；

% 求每片换能片的极角和方位角
for i = 1:NumRing
    ArrayPar.ElePos.PolA = [ArrayPar.ElePos.PolA AngleFirstX(i):...
    	2*pi/NumRingEle(i):...
    	2*pi/NumRingEle(i)*(NumRingEle(i)-1)+AngleFirstX(i)];
    ArrayPar.ElePos.AziA = [ArrayPar.ElePos.AziA AngleZ(i)*ones(1,NumRingEle(i))];
end
clear i;
clear AngleFirstX AngleZ NumRing NumRingEle;
ArrayPar.ElePos.PolA = ArrayPar.ElePos.PolA';
ArrayPar.ElePos.AziA = ArrayPar.ElePos.AziA';

% 根据极坐标，求解每片换能片的笛卡尔坐标
XPos = ArrayPar.FocalLength*sin(ArrayPar.ElePos.AziA).*cos(ArrayPar.ElePos.PolA);
YPos = ArrayPar.FocalLength*sin(ArrayPar.ElePos.AziA).*sin(ArrayPar.ElePos.PolA);
ZPos = ArrayPar.FocalLength*cos(ArrayPar.ElePos.AziA);
ArrayPar.ElePos.CartCoor = [XPos,YPos,ZPos];
ArrayPar.ElePos.CartCoor(abs(ArrayPar.ElePos.CartCoor)<1e-10) = 0;  % 将极为接近0的坐标，置为零。
% 根据笛卡尔坐标，求换能片中心单位法向量，换能片指向球心（原点O），故取负
ArrayPar.ElePos.NormVector = -ArrayPar.ElePos.CartCoor./repmat(sqrt(XPos.^2+YPos.^2+ZPos.^2),1,3);
clear XPos YPos ZPos;

for i_Index = 1:ArrayPar.EleNum
    i_repmat_CartCoor = repmat(ArrayPar.ElePos.CartCoor(i_Index,:),1,ArrayPar.EleNum);
    i_ele_dis = sqrt((i_repmat_CartCoor(:,1)-ArrayPar.ElePos.CartCoor(:,1)).^2 ...
                    +(i_repmat_CartCoor(:,2)-ArrayPar.ElePos.CartCoor(:,2)).^2 ...
                    +(i_repmat_CartCoor(:,3)-ArrayPar.ElePos.CartCoor(:,3)).^2);
    i_ele_dis_sort = sort(i_ele_dis);
    % 为了代码写起来方便，里边未排除计算换能片和自己的距离（0），因而取第二小距离。
    ArrayPar.EleDisMin = [ArrayPar.EleDisMin;i_ele_dis_sort(2)];    
end
clear i_repmat_CartCoor i_ele_dis i_ele_dis_sort i_Index

ArrayPar.OutFileNumber = randi([1,9999]);
ArrayPar.OutFileName = sprintf('ArrayPar_%s%d_%d',ArrayPar.TransducerType,ArrayPar.EleNum,ArrayPar.OutFileNumber);

fprintf('换能片最近距离为：%f\n',min(ArrayPar.EleDisMin));
if min(ArrayPar.EleDisMin) < 2*ArrayPar.EleR + ArrayPar.EleInterval
    error('换能片最近中心距小于%f，请重新检查。\n',2*ArrayPar.EleR + ArrayPar.EleInterval);
else
    fprintf('换能片最近中心距不小于%f，满足设计需求，正在画图。\n',2*ArrayPar.EleR + ArrayPar.EleInterval);
end

save(ArrayPar.OutFileName,'ArrayPar');
ArrayDrawing3D(ArrayPar)