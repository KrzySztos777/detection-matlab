clear;
close all;

cfg = coder.config('exe');

cfg.GenCodeOnly = false;
cfg.TargetLang = 'C++';
cfg.GenerateExampleMain= 'GenerateCodeAndCompile';
%cfg.CustomSource = 'main.cpp';

dlcfg = coder.DeepLearningConfig('arm-compute');
dlcfg.ArmArchitecture = 'armv7';%'armv8'
dlcfg.ArmComputeVersion = '19.02';
cfg.DeepLearningConfig = dlcfg;

r = raspi('192.168.137.237','pi','raspberry');
%r = raspi('192.168.0.10','pi','raspberry');

hw = coder.hardware('Raspberry Pi');
cfg.Hardware = hw;

cfg.Hardware.BuildDir = '~/matlabCodegens';


codegen -config cfg detection -args {} -d detection -o detection -report

