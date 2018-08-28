% 2017/03/07
% Alpha Version 1.0
% 输入组织参数
% 组织参数查询：https://www.itis.ethz.ch/virtual-population/tissue-properties/database/
% 请自行查询，并添加不同的组织参数。

%% Tissue Parameter: 

% 1. Tissue is Muscle:
TissuePar.Muscle.Type = 'Muscle';
TissuePar.Muscle.Dens = 1090;           % Tissue Density (kg/m^3);
TissuePar.Muscle.HeatCap = 3421;        % Tissue Heat Capacity (J/kg/°C);
TissuePar.Muscle.ThermalCond = 0.49;    % Tissue Thermal Conductivity (W/m/°C);
TissuePar.Muscle.SoundSpeed = 1588.4;	% Tissue Sound Speed (m/s)
TissuePar.Muscle.Atten = 7.1088;        % Tissue Sound Attenuation (Np/m/MHz) (not dB/m!!!1Np=8.68589dB)

% 2. Tissue is Blood:
TissuePar.Blood.Type = 'Blood';
TissuePar.Blood.Dens = 1050;          	% Blood Density (kg/m^3);
TissuePar.Blood.HeatCap = 3617;         % Blood Heat Capacity (J/kg/°C);
TissuePar.Blood.ThermalCond = 0.52;     % Tissue Thermal Conductivity (W/m/°C);
TissuePar.Blood.SoundSpeed = 1578.2;    % Tissue Sound Speed (m/s)
TissuePar.Blood.Atten = 2.3676;         % Blood Sound Attenuation (Np/m/MHz) (not dB/m!!!1Np=8.68589dB)

% 3. Water (Degased)
TissuePar.Water.Type = 'Water';
TissuePar.Water.Dens = 994;
TissuePar.Water.HeatCap = 4178;
TissuePar.Water.ThermalCond = 0.60;
TissuePar.Water.SoundSpeed = 1482.3;
TissuePar.Water.Atten = 0.025328436023;	% Water Sound Attenuation (Np/m/MHz) (not dB/m!!!1Np=8.68589dB)

%% Define Tissue Type:
TissueType = TissuePar.Water;

%% Acoustic Parameter: Determined by TissueType. 
%超声频率，单位：Hz
AcousticPar.Freq = 1.36e6;              % Ultrasound frequency.
AcousticPar.WaveNum = 2 * pi * AcousticPar.Freq / TissueType.SoundSpeed;    % Ultrasound wave number.
AcousticPar.Alpha = TissueType.Atten * AcousticPar.Freq / 1e6;              % 这里以后可能要修改，如果使用其他的形式的话。

% save('TissueInfo','TissuePar','TissueType','AcousticPar');
