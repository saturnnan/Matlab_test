% 2018/03/19
% Alpha Version 1.0
% 该脚本的作用是，生成基于费马螺线排布的相控聚焦治疗探头，使用圆形活塞振元。
% 源于文章：Evaluation of a novel therapeutic focused ultrasound 
%           transducer based on Fermat’s spiral.
clear
tic
% 初始化变量
ArrayPar.TransducerType = 'FermatSpiral';
ArrayPar.EleNum = 32;                  % 换能片数量
ArrayPar.EleR = 4.5e-3;                 % 换能片半径
ArrayPar.FocalLength = 105e-3;          % 探头曲率半径
ArrayPar.Diameter = 0e0;                % 未定义
ArrayPar.EleInterval = 1e-3;            % 换能片间隙距离

ArrayPar.FermatSpiralPar.c = 4.5e-3;    % 常数，通常比换能片半径稍小一点点
ArrayPar.FermatSpiralPar.Phi = 137.51 * pi/180; % 黄金角;

% 原点为自然焦点；
ArrayPar.ElePos.CartCoor = [];          % 换能片几何中心笛卡尔坐标
ArrayPar.ElePos.NormVector = [];        % 换能片笛卡尔坐标系的单位法向量
ArrayPar.ElePos.PolA = [];              % 换能片球坐标极角，即和X轴正方向的夹角
ArrayPar.ElePos.AziA = [];              % 换能片球坐标方位角，即和Z轴正方向的夹角
ArrayPar.ElePos.R = [];                 % 换能片球坐标径向距离
ArrayPar.EleDisMin = [];                % 相对于其最近的换能片间的距离；

% 换能器离散参数
ArrayPar.DivPar.NumR = 20;                  % 半径划分份数
ArrayPar.DivPar.NumAngle = 20;          	% 角度划分份数
ArrayPar.DivPar.SIR_Div = 1e-4;             % 换能片细分尺寸（该参数仅用于SIR方法）

% 计算换能片的坐标（球坐标&笛卡尔坐标）
for i_Index = 1:ArrayPar.EleNum
    ArrayPar.ElePos.R = [ArrayPar.ElePos.R;ArrayPar.FocalLength];
    tmp_n_PloA = i_Index*ArrayPar.FermatSpiralPar.Phi;
    % 这里的目的是，将第一片振元转到X轴上，看起来方便。不会影响别的东西。
    tmp_n_PloA_new = (i_Index-1)*ArrayPar.FermatSpiralPar.Phi;
    ArrayPar.ElePos.PolA = [ArrayPar.ElePos.PolA;tmp_n_PloA_new];
    tmp_n_AziA = pi - ArrayPar.FermatSpiralPar.c*sqrt(tmp_n_PloA)/ArrayPar.FocalLength;
    ArrayPar.ElePos.AziA = [ArrayPar.ElePos.AziA;tmp_n_AziA];
    
    tmp_n_XPos = ArrayPar.FocalLength * sin(tmp_n_AziA) * cos(tmp_n_PloA_new);
    tmp_n_YPos = ArrayPar.FocalLength * sin(tmp_n_AziA) * sin(tmp_n_PloA_new);
    tmp_n_ZPos = ArrayPar.FocalLength * cos(tmp_n_AziA);
    ArrayPar.ElePos.CartCoor = [ArrayPar.ElePos.CartCoor;tmp_n_XPos,tmp_n_YPos,tmp_n_ZPos];
    % 求出每片换能片的单位法向量
    tmp_NormVector = [-tmp_n_XPos,-tmp_n_YPos,-tmp_n_ZPos];
    ArrayPar.ElePos.NormVector = [ArrayPar.ElePos.NormVector;tmp_NormVector./norm(tmp_NormVector)];
end
clear tmp_n_PloA tmp_n_PloA_new tmp_n_AziA tmp_n_XPos tmp_n_YPos tmp_n_ZPos i_Index tmp_NormVector

% 计算换能片间最近距离；
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

toc

ArrayPar.OutFileNumber = randi([1,9999]);
ArrayPar.OutFileName = sprintf('ArrayPar_%s%d_%d',ArrayPar.TransducerType,ArrayPar.EleNum,ArrayPar.OutFileNumber);

fprintf('换能片最近距离为：%f\n',min(ArrayPar.EleDisMin));
if min(ArrayPar.EleDisMin) < 2*ArrayPar.EleR + ArrayPar.EleInterval
    error('换能片最近中心距不满足设计需求，请修改常量参数ArrayPar.FermatSpiralPar.c！');
else
    fprintf('换能片最近中心距不小于%f，满足设计需求，正在画图。\n',2*ArrayPar.EleR + ArrayPar.EleInterval);
end

save(ArrayPar.OutFileName,'ArrayPar');
ArrayDrawing3D(ArrayPar)
