% 2018/03/14
% Beta Version 2.5
% 用于圆形阵元呈环形分布的各类球面相控阵计算声场的三维声压分布。计算聚焦所需的理
% 论相位时使用了模式扫描方法，因此对相控阵阵元的几何分布和聚焦模式有所限制，对于
% 单焦点模式，所有分布的相控阵均适用；对于偶数焦点模式而言，仅限阵元对称分布的相
% 控阵。
% 
% Beta 2.1版本更新的目的是，对参考坐标系的使用进行规范，并重新整理坐标变换过程。
% 
% 注意：1. 在这个新版本中，换能片为任意排布模式，即直接定义每一片换能片的
%          空间坐标。
%       2. 换能片坐标含有两个（x,y,z）三维特征量，第一个标明该换能片的几何
%          中心的三维坐标，第二个为换能片正方向（+）的法向量（声传播方向）。
% 
% 
% 原始版本，使用瑞利积分方法计算声场，该版本加入了角谱法，速度较快，但不能得到声
% 压分布。该版本将绝大多数的参数，整理成了结构体形式，较为清晰明了。
% 
% 1.0版作者为吉翔，2.0版由屈雄飞修改并整理，其中，角谱法函数ASA.m作者为吴昊。
% 2.5版本大量代码重写，特别是坐标变换部分。
% 其中，角谱法存在问题，暂时请勿使用。

% 初始化运行状态
clear;          % 清理内存
warning off;    % 关闭警告
format long;    % 定义精度，12位小数

% 初始化参数    % 分别在这三个脚本中修改
TissueInfo;
ArrayInfo;
FocusInfo;
tic             % 开始计时

% 选择声场计算方法   RSIM为瑞利积分方法，ASM为角谱法。
SoundFieldMethod = 'RSIM';

% 将每个阵元划分为点声源，求出每个点声源的坐标和面积
ArrayPar = ArrayDiv(ArrayPar);
% 求出前向传递矩阵H
[PseudoInv,ArrayPar] = ForwardMatrix(AcousticPar,ArrayPar,FocusPar,TissueType);
% 通过伪逆矩阵计算相位分布U
PseudoInv = PsuedoInverse(FocusPar,PseudoInv,TissueType);
% 求出激励向量U
PseudoInv = ExciteEfficiency(PseudoInv);
% 求出声场的三维声压分布
if strcmp(SoundFieldMethod,'RSIM') == 1
    Intensity3D_RSIM;        % Rayleigh-Sommerfeld integral method
elseif strcmp(SoundFieldMethod,'ASM') == 1
    Intensity3D_Wu;     % Angular spectrum method
    
    pDim = size(midVel,1);
    planesize = 512;    % 计算X/Y平面，补齐后的大小。次平面需大于被计算的X/Y平面。
    plane1 = zeros(planesize,planesize);
    plane1((planesize-pDim)/2+1:(planesize-pDim)/2+pDim,(planesize-pDim)/2+1 ...
        :(planesize-pDim)/2+pDim)=midVel;
    thisPlane = plane1;
    % 注意：角谱法中的P3DimAbs并不是声压的绝对值，而和声强有关...
    P3DimAbs = [];
    for dz = SimPar.ZStep:SimPar.ZStep:2*SimPar.ZRange(2)+SimPar.ZStep
    	D = 2*SimPar.XRange(2)/(pDim-1)*(planesize-1);
    	anotherPlane = ASA(thisPlane,dz,TissueType,AcousticPar,D);
    	anotherPlanet = anotherPlane((planesize-pDim)/2+1 ...
            :(planesize-pDim)/2+pDim,(planesize-pDim)/2+1:(planesize-pDim)/2+pDim);
        P3DimAbs = [P3DimAbs,abs(anotherPlanet)];
    end
    P3DimAbs = reshape(P3DimAbs,pDim,pDim,length(0:SimPar.ZStep:2*SimPar.ZRange(2)));
    I3Dim = abs(P3DimAbs);
    clear P3DimAbs pDim thisPlane anotherPlane anotherPlanet ...
        dz D plane1 planesize midVel;
    MatrixType = 'Sound Intensity';
    FocusHeatingPower = 2*AcousticPar.Alpha*sum(sum(sum(I3Dim)))*SimPar.XStep*SimPar.YStep*SimPar.ZStep;
    save('I3DimASM','I3Dim','SimPar','FocusPar','TissuePar','TissueType', ...
        'AcousticPar','MatrixType','SoundFieldMethod','ArrayPar', 'FocusHeatingPower');
else
    error('无法识别给定的声场计算方法，请重新设置');
end

toc
