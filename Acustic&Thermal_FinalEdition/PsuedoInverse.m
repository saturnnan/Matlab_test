function [PseudoInv] = PsuedoInverse(FocusPar,PseudoInv,TissueType)
%PSUEDOINVERSE 通过特征向量法求出控制点声压向量
%
% *************************************************************************
% *************************************************************************
% *  时间：2018年3月21日                                                  *
% *  版本：Beta Version 2.0                                               *
% *  函数目的：通过特征向量法求出控制点声压向量PControl                   *
% *            续上，算出H矩阵的伪逆HPlus，通过伪逆算法求出激励向量U      *
% *  函数输入：H矩阵，控制点未处理声压向量                                *
% *  函数输出：阵元激励向量U，控制点声压向量PControl                      *
% *            以及近场增益G                                              *
% *************************************************************************
% *************************************************************************

%HTran表示H矩阵的转置共轭
HTran = PseudoInv.H';
%HPlus表示H矩阵的广义逆
HPlus = HTran * inv(PseudoInv.H * HTran);
%通过特征向量法求控制点声压的相位
PhaseP = EigenVector(PseudoInv.H);
%采用特征向量法反而会得到不好的结果
PseudoInv.PControl = FocusPar.FocusP .* exp(1i * PhaseP');
% PControl = P .* [1 j -1 -j];
%伪逆算法求出U
PseudoInv.U = HPlus * PseudoInv.PControl.';
%求近场增益GC
PNow = PseudoInv.PControl.';
[~,N] = size(PseudoInv.H);
ConMulti = N / ((TissueType.Dens^2) * (TissueType.SoundSpeed^2));
VarMulti = PNow' * PNow / (PNow' * inv(PseudoInv.H * HTran) * PNow);
PseudoInv.G = ConMulti * VarMulti;

end

