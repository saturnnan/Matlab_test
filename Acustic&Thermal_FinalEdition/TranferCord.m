function [NewPointsA] = TranferCord(PointsA,OriginP,VectorN)
%TRANFERCORD 此处显示有关此函数的摘要
% 
% *************************************************************************
% *************************************************************************
% *  时间：2018年3月20日                                                  *
% *  版本：Alpha Version 1.0                                              *
% *  函数目的：将任意多个点在A坐标系下的坐标，转变为在B坐标系下的坐标。   *
% *  函数输入：PointsA为任意多个点在A坐标系下的坐标，n行3列               *
% *            OriginP为A坐标系的原点在B坐标系下的坐标                    *
% *            VectorN为A坐标系下的Z轴，在B坐标系下的单位向量表示         *
% *  函数输出：NewPointsA为任意多个点，在B坐标系下的坐标，n行3列          *
% *************************************************************************
% *************************************************************************
MatrixNull = null(VectorN);
VectorA = -MatrixNull(:,2).';
VectorB = MatrixNull(:,1).';
VectorN = VectorN/norm(VectorN);     % 向量单位化


MatrixT = [VectorA(1),VectorA(2),VectorA(3),0
           VectorB(1),VectorB(2),VectorB(3),0
           VectorN(1),VectorN(2),VectorN(3),0
           OriginP(1),OriginP(2),OriginP(3),1];

NewPointsA = [PointsA,ones(size(PointsA,1),1)] * MatrixT;
NewPointsA = NewPointsA(:,1:3);

end

