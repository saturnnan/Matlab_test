% 2018/03/22
% Beta Version 2.0
% 计算三维声压和声强分布

% 每次计算的声场点数，可任意设置
SectorPoint = 101;

[XSound,YSound,ZSound] = ndgrid(SimPar.XRange(1):SimPar.XStep:SimPar.XRange(2), ...
                                SimPar.YRange(1):SimPar.YStep:SimPar.YRange(2), ...
                                SimPar.ZRange(1):SimPar.ZStep:SimPar.ZRange(2));
[d1,d2,d3] = size(XSound);

SoundPoint = d1*d2*d3;
NumSector = ceil(SoundPoint/SectorPoint);
ResPoint = mod(NumSector*SectorPoint,SoundPoint);

XSound = reshape(XSound,1,SoundPoint);
XSound = [XSound,zeros(1,ResPoint)];
YSound = reshape(YSound,1,SoundPoint);
YSound = [YSound,zeros(1,ResPoint)];
ZSound = reshape(ZSound,1,SoundPoint);
ZSound = [ZSound,zeros(1,ResPoint)];
clear ResPoint 
ArrayPar.DivPar.DeltaS_Array = repmat(reshape(ArrayPar.DivPar.DeltaS, ...
                                    numel(ArrayPar.DivPar.DeltaS),1), ...
                                    1,ArrayPar.EleNum*SectorPoint);
PResult = zeros(SectorPoint,NumSector);

% hwait=waitbar(0.05,'Please wait>>>>>>>>');
parfor i = 1:NumSector
    % 用于测试计算速度
%     if NumSector-i<=NumSector*0.05
%         waitbar(i/NumSector,hwait,'Nearing completion');
%     else
%         str=['Please wait...',num2str(100*i/NumSector),'%'];
%         waitbar(i/NumSector,hwait,str);
%     end
    
    XSound_i = XSound((i-1)*SectorPoint+1:i*SectorPoint);
    YSound_i = YSound((i-1)*SectorPoint+1:i*SectorPoint);
    ZSound_i = ZSound((i-1)*SectorPoint+1:i*SectorPoint);    
    
    XArray_Field = repmat(ArrayPar.DivPar.XArray,1,SectorPoint);
    YArray_Field = repmat(ArrayPar.DivPar.YArray,1,SectorPoint);
    ZArray_Field = repmat(ArrayPar.DivPar.ZArray,1,SectorPoint);

    % 尽量使用“.'”而不是的“'”进行转置。前者纯转置，后者共轭转置，一旦碰到复数矩阵直接完蛋。
    XSound_Field = repmat(XSound_i,numel(ArrayPar.DivPar.XArray),1);
    XSound_Field = reshape(XSound_Field,size(ArrayPar.DivPar.XArray,1),size(ArrayPar.DivPar.XArray,2)*SectorPoint);

    YSound_Field = repmat(YSound_i,numel(ArrayPar.DivPar.YArray),1);
    YSound_Field = reshape(YSound_Field,size(ArrayPar.DivPar.YArray,1),size(ArrayPar.DivPar.YArray,2)*SectorPoint);

    ZSound_Field = repmat(ZSound_i,numel(ArrayPar.DivPar.ZArray),1);
    ZSound_Field = reshape(ZSound_Field,size(ArrayPar.DivPar.ZArray,1),size(ArrayPar.DivPar.ZArray,2)*SectorPoint);

% 求出计算声场声压分布的前向传递矩阵H，表示为HResult
    r = sqrt((XArray_Field-XSound_Field).^2+(YArray_Field-YSound_Field).^2+(ZArray_Field-ZSound_Field).^2);
%     clear XSound_i YSound_i ZSound_i XArray_Field YArray_Field ZArray_Field;
%     clear XSound_Field YSound_Field ZSound_Field;
    Heds = exp(-(1j*AcousticPar.WaveNum + AcousticPar.Alpha).* r).* ArrayPar.DivPar.DeltaS_Array ./ r;
%     clear r;
    HResult = (1j * TissueType.Dens * AcousticPar.Freq) .* reshape(sum(Heds,1).',size(ArrayPar.DivPar.XArray,2),SectorPoint).';
%     clear Heds;
    
% 求出声场中三维声压分布PResult
    P_Temp = HResult * PseudoInv.U;
%     clear HResult;
    PResult(:,i) = P_Temp.';
%     clear P_Temp;
end
% close(hwait);
clear i NumSector ResPoint SectorPoint XSound YSound ZSound str hwait;

% 将声压分布从向量形式转换为矩阵形式
P3Dim = PResult(1:SoundPoint);
P3Dim = reshape(P3Dim,d1,d2,d3);
clear d1 d2 d3 SoundPoint PResult;

% 将声压化成声强和热量，写入文件
I3Dim = abs(P3Dim).^2 / (2 * TissueType.Dens * TissueType.SoundSpeed);
Q3Dim = 2*AcousticPar.Alpha*I3Dim;
MatrixType = 'Sound Intensity';
FocusHeatingPower = 2*AcousticPar.Alpha*sum(sum(sum(I3Dim)))*SimPar.XStep*SimPar.YStep*SimPar.ZStep;
save('I3DimRSIM','P3Dim','I3Dim','SimPar','FocusPar','TissuePar','TissueType', ...
    'AcousticPar','MatrixType','SoundFieldMethod','ArrayPar', 'FocusHeatingPower');