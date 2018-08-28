function [ArrayPar] = ArrayDiv(ArrayPar)
%ARRAYDIV 将相控阵内每个阵元离散化为点声源
% 2018/03/20
% Beta Version 2.0
% 本函数的目的：将相控阵内每个阵元离散化为点声源，其中NumRadius为沿半径方向划分
% 的份数，NumAngle为沿圆周划分的角度，DeltaS为每个点声源的面积。
% 新版本做出了一些改动，对于离散点坐标矩阵，改为n行3列形式，每列为别为x、y、z坐标。

% XDiv,YDiv,ZDiv为NumRadius*NumAngle维
RadiusDiv = ArrayPar.EleR/ArrayPar.DivPar.NumR - ArrayPar.EleR/ArrayPar.DivPar.NumR/2 ...
            :ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR - ArrayPar.EleR/ArrayPar.DivPar.NumR/2;
AngleDiv = 2*pi/ArrayPar.DivPar.NumAngle : 2*pi/ArrayPar.DivPar.NumAngle : 2*pi;
ArrayPar.DivPar.XDiv = RadiusDiv.'*cos(AngleDiv);
ArrayPar.DivPar.YDiv = RadiusDiv.'*sin(AngleDiv);
ArrayPar.DivPar.ZDiv = zeros(ArrayPar.DivPar.NumR,ArrayPar.DivPar.NumAngle);

% 计算点声源的面积
RadiusDiv_plus = ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR;
RadiusDiv_minus = 0 : ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR-ArrayPar.EleR/ArrayPar.DivPar.NumR;
ArrayPar.DivPar.DeltaS = 1/ArrayPar.DivPar.NumAngle*pi*(RadiusDiv_plus.^2 - RadiusDiv_minus.^2);
ArrayPar.DivPar.DeltaS = repmat(ArrayPar.DivPar.DeltaS',1,ArrayPar.DivPar.NumAngle);

% 将XDiv,YDiv,ZDiv变成行向量,有利于后续的坐标变换的批量处理
XShape = reshape(ArrayPar.DivPar.XDiv,ArrayPar.DivPar.NumR*ArrayPar.DivPar.NumAngle,1);
YShape = reshape(ArrayPar.DivPar.YDiv,ArrayPar.DivPar.NumR*ArrayPar.DivPar.NumAngle,1);
ZShape = reshape(ArrayPar.DivPar.ZDiv,ArrayPar.DivPar.NumR*ArrayPar.DivPar.NumAngle,1);
ArrayPar.DivPar.XYZVectorArrayCor = [XShape,YShape,ZShape];

end
