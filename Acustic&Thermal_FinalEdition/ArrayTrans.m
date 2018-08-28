% 2018/03/06
% Beta Version 2.0
% �����������ɲ����������������ʽ��

% ���������ʰ뾶����λ��m
clear
format long;

ArrayPar.TransducerType = 'Shit';    % 'OldRegular' or 'NewRegular' or 'Shit'
ArrayPar.EleR = 5e-3;                       % ����Ƭ�뾶
ArrayPar.Diameter = 0e0;                    % δ����
ArrayPar.EleInterval = 5e-4;                % ����Ƭ��϶����

NumRingEle = [1 6 13 19 25];                % ÿ����Ԫ����
NumRing = size(NumRingEle,2);               % ��Ԫ����
ArrayPar.EleNum = sum(NumRingEle);          % �������Ԫ����

ArrayPar.DivPar.NumR = 20;                  % �뾶���ַ���
ArrayPar.DivPar.NumAngle = 20;          	% �ǶȻ��ַ���
ArrayPar.DivPar.SIR_Div = 1e-4;             % ����Ƭϸ�ֳߴ磨�ò���������SIR������

if strcmpi(ArrayPar.TransducerType,'OldRegular') == 1
    ArrayPar.FocalLength = 120e-3;          % ̽ͷ���ʰ뾶
    AngleZ = [0 5.521 11.041 16.295 21.548]/180*pi; % ÿ����Z��нǣ���λ��rad
elseif strcmpi(ArrayPar.TransducerType,'NewRegular') == 1
    ArrayPar.FocalLength = 115e-3;          % ̽ͷ���ʰ뾶
    AngleZ = [0 5.552 11.104 16.387 21.670]/180*pi; % ÿ����Z��нǣ���λ��rad
elseif strcmpi(ArrayPar.TransducerType,'Shit') == 1
    ArrayPar.FocalLength = 120e-3;          % ̽ͷ���ʰ뾶
    AngleZ = [0 5.34 10.00 14.89 19.92]/180*pi;
end
AngleZ = pi - AngleZ;

% ÿ������Ԫ��X��нǣ���λ��rad
AngleFirstX = [0 8.9153 22.0359 15.2772 42.8234]/180*pi;
if strcmpi(ArrayPar.TransducerType,'Shit') == 1
    ArrayPar.AngleFirstX = pi ./ NumRingEle;
end

% ԭ��Ϊ��Ȼ���㣻
ArrayPar.ElePos.CartCoor = [];              % ����Ƭ�������ĵѿ�������
ArrayPar.ElePos.NormVector = [];            % ����Ƭ�ѿ�������ϵ�ĵ�λ������
ArrayPar.ElePos.PolA = [];                  % ����Ƭ�����꼫�ǣ�����X��������ļн�
ArrayPar.ElePos.AziA = [];                  % ����Ƭ�����귽λ�ǣ�����Z��������ļн�
ArrayPar.ElePos.R = ArrayPar.FocalLength*ones(ArrayPar.EleNum,1);	% ����Ƭ�����꾶�����
ArrayPar.EleDisMin = [];                    % �����������Ļ���Ƭ��ľ��룻

% ��ÿƬ����Ƭ�ļ��Ǻͷ�λ��
for i = 1:NumRing
    ArrayPar.ElePos.PolA = [ArrayPar.ElePos.PolA AngleFirstX(i):...
    	2*pi/NumRingEle(i):...
    	2*pi/NumRingEle(i)*(NumRingEle(i)-1)+AngleFirstX(i)];
    ArrayPar.ElePos.AziA = [ArrayPar.ElePos.AziA AngleZ(i)*ones(1,NumRingEle(i))];
end
clear i;
clear AngleFirstX AngleZ NumRing NumRingEle;
ArrayPar.ElePos.PolA = ArrayPar.ElePos.PolA';
ArrayPar.ElePos.AziA = ArrayPar.ElePos.AziA';

% ���ݼ����꣬���ÿƬ����Ƭ�ĵѿ�������
XPos = ArrayPar.FocalLength*sin(ArrayPar.ElePos.AziA).*cos(ArrayPar.ElePos.PolA);
YPos = ArrayPar.FocalLength*sin(ArrayPar.ElePos.AziA).*sin(ArrayPar.ElePos.PolA);
ZPos = ArrayPar.FocalLength*cos(ArrayPar.ElePos.AziA);
ArrayPar.ElePos.CartCoor = [XPos,YPos,ZPos];
ArrayPar.ElePos.CartCoor(abs(ArrayPar.ElePos.CartCoor)<1e-10) = 0;  % ����Ϊ�ӽ�0�����꣬��Ϊ�㡣
% ���ݵѿ������꣬����Ƭ���ĵ�λ������������Ƭָ�����ģ�ԭ��O������ȡ��
ArrayPar.ElePos.NormVector = -ArrayPar.ElePos.CartCoor./repmat(sqrt(XPos.^2+YPos.^2+ZPos.^2),1,3);
clear XPos YPos ZPos;

for i_Index = 1:ArrayPar.EleNum
    i_repmat_CartCoor = repmat(ArrayPar.ElePos.CartCoor(i_Index,:),1,ArrayPar.EleNum);
    i_ele_dis = sqrt((i_repmat_CartCoor(:,1)-ArrayPar.ElePos.CartCoor(:,1)).^2 ...
                    +(i_repmat_CartCoor(:,2)-ArrayPar.ElePos.CartCoor(:,2)).^2 ...
                    +(i_repmat_CartCoor(:,3)-ArrayPar.ElePos.CartCoor(:,3)).^2);
    i_ele_dis_sort = sort(i_ele_dis);
    % Ϊ�˴���д�������㣬���δ�ų����㻻��Ƭ���Լ��ľ��루0�������ȡ�ڶ�С���롣
    ArrayPar.EleDisMin = [ArrayPar.EleDisMin;i_ele_dis_sort(2)];    
end
clear i_repmat_CartCoor i_ele_dis i_ele_dis_sort i_Index

ArrayPar.OutFileNumber = randi([1,9999]);
ArrayPar.OutFileName = sprintf('ArrayPar_%s%d_%d',ArrayPar.TransducerType,ArrayPar.EleNum,ArrayPar.OutFileNumber);

fprintf('����Ƭ�������Ϊ��%f\n',min(ArrayPar.EleDisMin));
if min(ArrayPar.EleDisMin) < 2*ArrayPar.EleR + ArrayPar.EleInterval
    error('����Ƭ������ľ�С��%f�������¼�顣\n',2*ArrayPar.EleR + ArrayPar.EleInterval);
else
    fprintf('����Ƭ������ľ಻С��%f����������������ڻ�ͼ��\n',2*ArrayPar.EleR + ArrayPar.EleInterval);
end

save(ArrayPar.OutFileName,'ArrayPar');
ArrayDrawing3D(ArrayPar)