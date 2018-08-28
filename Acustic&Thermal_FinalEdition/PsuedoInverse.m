function [PseudoInv] = PsuedoInverse(FocusPar,PseudoInv,TissueType)
%PSUEDOINVERSE ͨ������������������Ƶ���ѹ����
%
% *************************************************************************
% *************************************************************************
% *  ʱ�䣺2018��3��21��                                                  *
% *  �汾��Beta Version 2.0                                               *
% *  ����Ŀ�ģ�ͨ������������������Ƶ���ѹ����PControl                   *
% *            ���ϣ����H�����α��HPlus��ͨ��α���㷨�����������U      *
% *  �������룺H���󣬿��Ƶ�δ������ѹ����                                *
% *  �����������Ԫ��������U�����Ƶ���ѹ����PControl                      *
% *            �Լ���������G                                              *
% *************************************************************************
% *************************************************************************

%HTran��ʾH�����ת�ù���
HTran = PseudoInv.H';
%HPlus��ʾH����Ĺ�����
HPlus = HTran * inv(PseudoInv.H * HTran);
%ͨ����������������Ƶ���ѹ����λ
PhaseP = EigenVector(PseudoInv.H);
%��������������������õ����õĽ��
PseudoInv.PControl = FocusPar.FocusP .* exp(1i * PhaseP');
% PControl = P .* [1 j -1 -j];
%α���㷨���U
PseudoInv.U = HPlus * PseudoInv.PControl.';
%���������GC
PNow = PseudoInv.PControl.';
[~,N] = size(PseudoInv.H);
ConMulti = N / ((TissueType.Dens^2) * (TissueType.SoundSpeed^2));
VarMulti = PNow' * PNow / (PNow' * inv(PseudoInv.H * HTran) * PNow);
PseudoInv.G = ConMulti * VarMulti;

end

