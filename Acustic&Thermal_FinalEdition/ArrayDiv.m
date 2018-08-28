function [ArrayPar] = ArrayDiv(ArrayPar)
%ARRAYDIV ���������ÿ����Ԫ��ɢ��Ϊ����Դ
% 2018/03/20
% Beta Version 2.0
% ��������Ŀ�ģ����������ÿ����Ԫ��ɢ��Ϊ����Դ������NumRadiusΪ�ذ뾶���򻮷�
% �ķ�����NumAngleΪ��Բ�ܻ��ֵĽǶȣ�DeltaSΪÿ������Դ�������
% �°汾������һЩ�Ķ���������ɢ��������󣬸�Ϊn��3����ʽ��ÿ��Ϊ��Ϊx��y��z���ꡣ

% XDiv,YDiv,ZDivΪNumRadius*NumAngleά
RadiusDiv = ArrayPar.EleR/ArrayPar.DivPar.NumR - ArrayPar.EleR/ArrayPar.DivPar.NumR/2 ...
            :ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR - ArrayPar.EleR/ArrayPar.DivPar.NumR/2;
AngleDiv = 2*pi/ArrayPar.DivPar.NumAngle : 2*pi/ArrayPar.DivPar.NumAngle : 2*pi;
ArrayPar.DivPar.XDiv = RadiusDiv.'*cos(AngleDiv);
ArrayPar.DivPar.YDiv = RadiusDiv.'*sin(AngleDiv);
ArrayPar.DivPar.ZDiv = zeros(ArrayPar.DivPar.NumR,ArrayPar.DivPar.NumAngle);

% �������Դ�����
RadiusDiv_plus = ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR;
RadiusDiv_minus = 0 : ArrayPar.EleR/ArrayPar.DivPar.NumR : ArrayPar.EleR-ArrayPar.EleR/ArrayPar.DivPar.NumR;
ArrayPar.DivPar.DeltaS = 1/ArrayPar.DivPar.NumAngle*pi*(RadiusDiv_plus.^2 - RadiusDiv_minus.^2);
ArrayPar.DivPar.DeltaS = repmat(ArrayPar.DivPar.DeltaS',1,ArrayPar.DivPar.NumAngle);

% ��XDiv,YDiv,ZDiv���������,�����ں���������任����������
XShape = reshape(ArrayPar.DivPar.XDiv,ArrayPar.DivPar.NumR*ArrayPar.DivPar.NumAngle,1);
YShape = reshape(ArrayPar.DivPar.YDiv,ArrayPar.DivPar.NumR*ArrayPar.DivPar.NumAngle,1);
ZShape = reshape(ArrayPar.DivPar.ZDiv,ArrayPar.DivPar.NumR*ArrayPar.DivPar.NumAngle,1);
ArrayPar.DivPar.XYZVectorArrayCor = [XShape,YShape,ZShape];

end
