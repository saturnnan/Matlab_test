function [PseudoInv] = ExciteEfficiency(PseudoInv)
%EXCITEEFFICIENCY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% *************************************************************************
% *************************************************************************
% *  ʱ�䣺2018��3��21��                                                  *
% *  ����Ŀ�ģ�ͨ������Ч���㷨�������ļ�������U                        *
% *  �������룺α���㷨����ļ�������U                                    * 
% *  ���ϣ�H���󣬿��Ƶ���ѹ����PControl                                  *
% *  �����������Ԫ��������U                                              *
% *************************************************************************
% *************************************************************************
% ��Ҫ��ΪЧ�ʲ��ܴﵽ0.99�������󾡿�������Ч��
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

