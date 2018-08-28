function [PseudoInv,ArrayPar] = ForwardMatrix(AcousticPar,ArrayPar,FocusPar,TissueType)
%FORWARDMATRIX ���ǰ�򴫵ݾ���H����ÿ����Ԫ����ɢ���ڵѿ�������ϵ����ά����
% 
% *************************************************************************
% *************************************************************************
% *  ʱ�䣺2018��3��20��                                                  *
% *  �汾��Beta Version 2.0                                               *
% *  ����Ŀ�ģ����ǰ�򴫵ݾ���H���Լ��������ÿ����Ԫ�е���Դ�ڵѿ�����  *
% *            ��ϵ����ά����XArray��YArray��ZArray����ǰ�򴫵ݾ���H��    *
% *  �������룺AcousticParΪԤ��������                                    *
% *            ArrayParΪԤ��Ļ������ṹ�������������л���Ƭ��Ϣ         *
% *            FocusParΪ���潹�㡢��������                               *
% *            TissueTypeΪ����Ľ��ʲ���                                 *
% *************************************************************************
% *************************************************************************

ArrayPar.DivPar.XArray = zeros(size(ArrayPar.DivPar.XYZVectorArrayCor,1),ArrayPar.EleNum);
ArrayPar.DivPar.YArray = zeros(size(ArrayPar.DivPar.XYZVectorArrayCor,1),ArrayPar.EleNum);
ArrayPar.DivPar.ZArray = zeros(size(ArrayPar.DivPar.XYZVectorArrayCor,1),ArrayPar.EleNum);
r_total = zeros(400,64);
for iElement = 1:ArrayPar.EleNum
    % ��ÿƬ����Ƭ����ɢ΢Ԫ��ȫ������
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
