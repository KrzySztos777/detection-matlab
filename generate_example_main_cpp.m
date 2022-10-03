%using this file is unnecessary since "detection.m" is good prepared ("while" loop added)

clear;
close all;

cfg = coder.config('lib');

cfg.GenCodeOnly = true;
cfg.TargetLang = 'C++';

dlcfg = coder.DeepLearningConfig('arm-compute');
dlcfg.ArmArchitecture = 'armv7';%'armv8'
dlcfg.ArmComputeVersion = '19.02';
cfg.DeepLearningConfig = dlcfg;

cfg.HardwareImplementation.ProdHWDeviceType = 'ARM Compatible->ARM Cortex';%'ARM Compatible->ARM 64-bit (LP64)';

codegen -config cfg detection -args {} -d generate_example_main_cpp