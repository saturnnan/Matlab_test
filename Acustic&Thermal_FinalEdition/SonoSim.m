% 2018/03/14
% Beta Version 2.5
% ����Բ����Ԫ�ʻ��ηֲ��ĸ�����������������������ά��ѹ�ֲ�������۽��������
% ����λʱʹ����ģʽɨ�跽������˶��������Ԫ�ļ��ηֲ��;۽�ģʽ�������ƣ�����
% ������ģʽ�����зֲ������������ã�����ż������ģʽ���ԣ�������Ԫ�ԳƷֲ�����
% ����
% 
% Beta 2.1�汾���µ�Ŀ���ǣ��Բο�����ϵ��ʹ�ý��й淶����������������任���̡�
% 
% ע�⣺1. ������°汾�У�����ƬΪ�����Ų�ģʽ����ֱ�Ӷ���ÿһƬ����Ƭ��
%          �ռ����ꡣ
%       2. ����Ƭ���꺬��������x,y,z����ά����������һ�������û���Ƭ�ļ���
%          ���ĵ���ά���꣬�ڶ���Ϊ����Ƭ������+���ķ����������������򣩡�
% 
% 
% ԭʼ�汾��ʹ���������ַ��������������ð汾�����˽��׷����ٶȽϿ죬�����ܵõ���
% ѹ�ֲ����ð汾����������Ĳ�����������˽ṹ����ʽ����Ϊ�������ˡ�
% 
% 1.0������Ϊ���裬2.0�������۷��޸Ĳ��������У����׷�����ASA.m����Ϊ��껡�
% 2.5�汾����������д���ر�������任���֡�
% ���У����׷��������⣬��ʱ����ʹ�á�

% ��ʼ������״̬
clear;          % �����ڴ�
warning off;    % �رվ���
format long;    % ���徫�ȣ�12λС��

% ��ʼ������    % �ֱ����������ű����޸�
TissueInfo;
ArrayInfo;
FocusInfo;
tic             % ��ʼ��ʱ

% ѡ���������㷽��   RSIMΪ�������ַ�����ASMΪ���׷���
SoundFieldMethod = 'RSIM';

% ��ÿ����Ԫ����Ϊ����Դ�����ÿ������Դ����������
ArrayPar = ArrayDiv(ArrayPar);
% ���ǰ�򴫵ݾ���H
[PseudoInv,ArrayPar] = ForwardMatrix(AcousticPar,ArrayPar,FocusPar,TissueType);
% ͨ��α����������λ�ֲ�U
PseudoInv = PsuedoInverse(FocusPar,PseudoInv,TissueType);
% �����������U
PseudoInv = ExciteEfficiency(PseudoInv);
% �����������ά��ѹ�ֲ�
if strcmp(SoundFieldMethod,'RSIM') == 1
    Intensity3D_RSIM;        % Rayleigh-Sommerfeld integral method
elseif strcmp(SoundFieldMethod,'ASM') == 1
    Intensity3D_Wu;     % Angular spectrum method
    
    pDim = size(midVel,1);
    planesize = 512;    % ����X/Yƽ�棬�����Ĵ�С����ƽ������ڱ������X/Yƽ�档
    plane1 = zeros(planesize,planesize);
    plane1((planesize-pDim)/2+1:(planesize-pDim)/2+pDim,(planesize-pDim)/2+1 ...
        :(planesize-pDim)/2+pDim)=midVel;
    thisPlane = plane1;
    % ע�⣺���׷��е�P3DimAbs��������ѹ�ľ���ֵ��������ǿ�й�...
    P3DimAbs = [];
    for dz = SimPar.ZStep:SimPar.ZStep:2*SimPar.ZRange(2)+SimPar.ZStep
    	D = 2*SimPar.XRange(2)/(pDim-1)*(planesize-1);
    	anotherPlane = ASA(thisPlane,dz,TissueType,AcousticPar,D);
    	anotherPlanet = anotherPlane((planesize-pDim)/2+1 ...
            :(planesize-pDim)/2+pDim,(planesize-pDim)/2+1:(planesize-pDim)/2+pDim);
        P3DimAbs = [P3DimAbs,abs(anotherPlanet)];
    end
    P3DimAbs = reshape(P3DimAbs,pDim,pDim,length(0:SimPar.ZStep:2*SimPar.ZRange(2)));
    I3Dim = abs(P3DimAbs);
    clear P3DimAbs pDim thisPlane anotherPlane anotherPlanet ...
        dz D plane1 planesize midVel;
    MatrixType = 'Sound Intensity';
    FocusHeatingPower = 2*AcousticPar.Alpha*sum(sum(sum(I3Dim)))*SimPar.XStep*SimPar.YStep*SimPar.ZStep;
    save('I3DimASM','I3Dim','SimPar','FocusPar','TissuePar','TissueType', ...
        'AcousticPar','MatrixType','SoundFieldMethod','ArrayPar', 'FocusHeatingPower');
else
    error('�޷�ʶ��������������㷽��������������');
end

toc
