% 2018/03/19
% Alpha Version 1.0
% �ýű��������ǣ����ɻ��ڷ��������Ų�����ؾ۽�����̽ͷ��ʹ��Բ�λ�����Ԫ��
% Դ�����£�Evaluation of a novel therapeutic focused ultrasound 
%           transducer based on Fermat��s spiral.
clear
tic
% ��ʼ������
ArrayPar.TransducerType = 'FermatSpiral';
ArrayPar.EleNum = 32;                  % ����Ƭ����
ArrayPar.EleR = 4.5e-3;                 % ����Ƭ�뾶
ArrayPar.FocalLength = 105e-3;          % ̽ͷ���ʰ뾶
ArrayPar.Diameter = 0e0;                % δ����
ArrayPar.EleInterval = 1e-3;            % ����Ƭ��϶����

ArrayPar.FermatSpiralPar.c = 4.5e-3;    % ������ͨ���Ȼ���Ƭ�뾶��Сһ���
ArrayPar.FermatSpiralPar.Phi = 137.51 * pi/180; % �ƽ��;

% ԭ��Ϊ��Ȼ���㣻
ArrayPar.ElePos.CartCoor = [];          % ����Ƭ�������ĵѿ�������
ArrayPar.ElePos.NormVector = [];        % ����Ƭ�ѿ�������ϵ�ĵ�λ������
ArrayPar.ElePos.PolA = [];              % ����Ƭ�����꼫�ǣ�����X��������ļн�
ArrayPar.ElePos.AziA = [];              % ����Ƭ�����귽λ�ǣ�����Z��������ļн�
ArrayPar.ElePos.R = [];                 % ����Ƭ�����꾶�����
ArrayPar.EleDisMin = [];                % �����������Ļ���Ƭ��ľ��룻

% ��������ɢ����
ArrayPar.DivPar.NumR = 20;                  % �뾶���ַ���
ArrayPar.DivPar.NumAngle = 20;          	% �ǶȻ��ַ���
ArrayPar.DivPar.SIR_Div = 1e-4;             % ����Ƭϸ�ֳߴ磨�ò���������SIR������

% ���㻻��Ƭ�����꣨������&�ѿ������꣩
for i_Index = 1:ArrayPar.EleNum
    ArrayPar.ElePos.R = [ArrayPar.ElePos.R;ArrayPar.FocalLength];
    tmp_n_PloA = i_Index*ArrayPar.FermatSpiralPar.Phi;
    % �����Ŀ���ǣ�����һƬ��Ԫת��X���ϣ����������㡣����Ӱ���Ķ�����
    tmp_n_PloA_new = (i_Index-1)*ArrayPar.FermatSpiralPar.Phi;
    ArrayPar.ElePos.PolA = [ArrayPar.ElePos.PolA;tmp_n_PloA_new];
    tmp_n_AziA = pi - ArrayPar.FermatSpiralPar.c*sqrt(tmp_n_PloA)/ArrayPar.FocalLength;
    ArrayPar.ElePos.AziA = [ArrayPar.ElePos.AziA;tmp_n_AziA];
    
    tmp_n_XPos = ArrayPar.FocalLength * sin(tmp_n_AziA) * cos(tmp_n_PloA_new);
    tmp_n_YPos = ArrayPar.FocalLength * sin(tmp_n_AziA) * sin(tmp_n_PloA_new);
    tmp_n_ZPos = ArrayPar.FocalLength * cos(tmp_n_AziA);
    ArrayPar.ElePos.CartCoor = [ArrayPar.ElePos.CartCoor;tmp_n_XPos,tmp_n_YPos,tmp_n_ZPos];
    % ���ÿƬ����Ƭ�ĵ�λ������
    tmp_NormVector = [-tmp_n_XPos,-tmp_n_YPos,-tmp_n_ZPos];
    ArrayPar.ElePos.NormVector = [ArrayPar.ElePos.NormVector;tmp_NormVector./norm(tmp_NormVector)];
end
clear tmp_n_PloA tmp_n_PloA_new tmp_n_AziA tmp_n_XPos tmp_n_YPos tmp_n_ZPos i_Index tmp_NormVector

% ���㻻��Ƭ��������룻
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

toc

ArrayPar.OutFileNumber = randi([1,9999]);
ArrayPar.OutFileName = sprintf('ArrayPar_%s%d_%d',ArrayPar.TransducerType,ArrayPar.EleNum,ArrayPar.OutFileNumber);

fprintf('����Ƭ�������Ϊ��%f\n',min(ArrayPar.EleDisMin));
if min(ArrayPar.EleDisMin) < 2*ArrayPar.EleR + ArrayPar.EleInterval
    error('����Ƭ������ľ಻��������������޸ĳ�������ArrayPar.FermatSpiralPar.c��');
else
    fprintf('����Ƭ������ľ಻С��%f����������������ڻ�ͼ��\n',2*ArrayPar.EleR + ArrayPar.EleInterval);
end

save(ArrayPar.OutFileName,'ArrayPar');
ArrayDrawing3D(ArrayPar)
