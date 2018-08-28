function [PseudoInv] = ExciteEfficiency(PseudoInv)
%EXCITEEFFICIENCY 此处显示有关此函数的摘要
%   此处显示详细说明
% *************************************************************************
% *************************************************************************
% *  时间：2018年3月21日                                                  *
% *  函数目的：通过激励效率算法求出所需的激励向量U                        *
% *  函数输入：伪逆算法求出的激励向量U                                    * 
% *  续上，H矩阵，控制点声压向量PControl                                  *
% *  函数输出：阵元激励向量U                                              *
% *************************************************************************
% *************************************************************************
% 主要因为效率不能达到0.99，所以求尽可能最大的效率
TempEfficiency = 0;
N = length(PseudoInv.U);
HTran = PseudoInv.H';
TempNum = 1;
Efficiency = (sum((abs(PseudoInv.U)).^2)) / (N *(max(abs(PseudoInv.U)))^2);
TempEfficiency(TempNum) = Efficiency;
while Efficiency <= 0.99
    TempNum = TempNum + 1;
	Uw = 1 ./ abs(PseudoInv.U);
	W = sparse(1:N,1:N,Uw);
	HTran = W * HTran;
	HPlus = HTran * inv(PseudoInv.H * HTran);
	PseudoInv.U = HPlus * PseudoInv.PControl.';
	Efficiency = (sum((abs(PseudoInv.U)).^2)) / (N *(max(abs(PseudoInv.U)))^2);
    TempEfficiency(TempNum) = Efficiency;
end
%  AmpU = abs(PseudoInv.U);
%  AngU = angle(PseudoInv.U);
end

