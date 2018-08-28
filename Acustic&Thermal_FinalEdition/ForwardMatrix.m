function [PseudoInv,ArrayPar] = ForwardMatrix(AcousticPar,ArrayPar,FocusPar,TissueType)
%FORWARDMATRIX 求解前向传递矩阵H，及每个阵元的离散点在笛卡尔坐标系的三维坐标
% 
% *************************************************************************
% *************************************************************************
% *  时间：2018年3月20日                                                  *
% *  版本：Beta Version 2.0                                               *
% *  函数目的：求解前向传递矩阵H，以及相控阵内每个阵元中点声源在笛卡尔坐  *
% *            标系的三维坐标XArray、YArray、ZArray，及前向传递矩阵H。    *
% *  函数输入：AcousticPar为预设声参数                                    *
% *            ArrayPar为预设的换能器结构参数，含有所有换能片信息         *
% *            FocusPar为仿真焦点、步长参数                               *
% *            TissueType为仿真的介质参数                                 *
% *************************************************************************
% *************************************************************************

ArrayPar.DivPar.XArray = zeros(size(ArrayPar.DivPar.XYZVectorArrayCor,1),ArrayPar.EleNum);
ArrayPar.DivPar.YArray = zeros(size(ArrayPar.DivPar.XYZVectorArrayCor,1),ArrayPar.EleNum);
ArrayPar.DivPar.ZArray = zeros(size(ArrayPar.DivPar.XYZVectorArrayCor,1),ArrayPar.EleNum);
r_total = zeros(400,64);
for iElement = 1:ArrayPar.EleNum
    % 求每片换能片上离散微元的全局坐标
    XYZVectorGlobal = TranferCord(ArrayPar.DivPar.XYZVectorArrayCor, ...
                                  ArrayPar.ElePos.CartCoor(iElement,:), ...
                                  ArrayPar.ElePos.NormVector(iElement,:));
    
    ArrayPar.DivPar.XArray(:,iElement) = XYZVectorGlobal(:,1);
    ArrayPar.DivPar.YArray(:,iElement) = XYZVectorGlobal(:,2);
    ArrayPar.DivPar.ZArray(:,iElement) = XYZVectorGlobal(:,3);

    r = sqrt((ArrayPar.DivPar.XArray(:,iElement) - FocusPar.FocusCoord(1)).^2 ...
           + (ArrayPar.DivPar.YArray(:,iElement) - FocusPar.FocusCoord(2)).^2 ...
           + (ArrayPar.DivPar.ZArray(:,iElement) - FocusPar.FocusCoord(3)).^2);
	Heds = exp(-(1j * AcousticPar.WaveNum + AcousticPar.Alpha) .* r) ...
        .* reshape(ArrayPar.DivPar.DeltaS,size(ArrayPar.DivPar.XArray,1),1) ./ r;
	Hes(iElement) = sum(Heds,1);
    r_total(:,iElement) = r;
end
% The pseudo inverse matrix method related Matrix:
PseudoInv.H = 1i * TissueType.Dens * AcousticPar.Freq * Hes;

end
