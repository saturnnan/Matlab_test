% 2017/03/16
% Alpha Version 1.0
% 输入焦点位置、声压信息和声场范围

%% Focus Parameter
FocusPar.NumFocus = 1;      %Focus number;
FocusPar.FocusCoord = [0.010,0.000,0.000];           %Focus coordinates;
FocusPar.FocusXCoord = FocusPar.FocusCoord(1);       %Focus's X coordinates;
FocusPar.FocusYCoord = FocusPar.FocusCoord(2);       %Focus's Y coordinates;
FocusPar.FocusZCoord = FocusPar.FocusCoord(3);       %Focus's Z coordinates;
FocusPar.Voltage = 5;       %Voltage of the transducer;
FocusPar.FocusP = (0.3661*FocusPar.Voltage + 0.2206)*1e6;   %Pressure of the focus;
FocusPar.FocusI = FocusPar.FocusP^2 / (2 * TissueType.Dens * TissueType.SoundSpeed);   %Intensity of the Focus for 1 Volt;

%% Parameters of the simulation area
% SimPar.AxisRange = [0.02,0.02,0.02];
SimPar.AxisStep = [0.0002,0.0002,0.0002];
SimPar.XRange = [-0.010, 0.015];
SimPar.XStep = SimPar.AxisStep(1);
SimPar.YRange = [-0.010, 0.010];
SimPar.YStep = SimPar.AxisStep(2);
SimPar.ZRange = [-0.030, 0.015];
SimPar.ZStep = SimPar.AxisStep(3);

% save('FocusInfo','FocusPar','SimPar');
