function [NewPointsA] = TranferCord(PointsA,OriginP,VectorN)
%TRANFERCORD �˴���ʾ�йش˺�����ժҪ
% 
% *************************************************************************
% *************************************************************************
% *  ʱ�䣺2018��3��20��                                                  *
% *  �汾��Alpha Version 1.0                                              *
% *  ����Ŀ�ģ�������������A����ϵ�µ����꣬ת��Ϊ��B����ϵ�µ����ꡣ   *
% *  �������룺PointsAΪ����������A����ϵ�µ����꣬n��3��               *
% *            OriginPΪA����ϵ��ԭ����B����ϵ�µ�����                    *
% *            VectorNΪA����ϵ�µ�Z�ᣬ��B����ϵ�µĵ�λ������ʾ         *
% *  ���������NewPointsAΪ�������㣬��B����ϵ�µ����꣬n��3��          *
% *************************************************************************
% *************************************************************************
MatrixNull = null(VectorN);
VectorA = -MatrixNull(:,2).';
VectorB = MatrixNull(:,1).';
VectorN = VectorN/norm(VectorN);     % ������λ��


MatrixT = [VectorA(1),VectorA(2),VectorA(3),0
           VectorB(1),VectorB(2),VectorB(3),0
           VectorN(1),VectorN(2),VectorN(3),0
           OriginP(1),OriginP(2),OriginP(3),1];

NewPointsA = [PointsA,ones(size(PointsA,1),1)] * MatrixT;
NewPointsA = NewPointsA(:,1:3);

end

