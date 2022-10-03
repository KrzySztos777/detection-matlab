% clear;
% close all

%rozmiar obrazu wejsciowego
imageSize = [224 224 3];

%ilosc wybieranych elementów- 1, bo tylko pilka
numClasses = 1;

%za pomoc¹ estimateMyAnchorBoxes.m
anchorBoxes =[
        36    35
    50    48
    57    67
    42    41
    79    90
    41    49];

%siec do wykrywania
network = squeezenet();
lgraph = layerGraph(network);

%warstwa, po ktorej ma byc dodane wartswy niezbedne dla YOLO
featureLayer = 'relu_conv10';

%tworzenie sieci neuronowej z YOLO
lgraph = yolov2Layers(imageSize,numClasses,anchorBoxes,lgraph,featureLayer);

analyzeNetwork(lgraph);

%wczytywanie zaznaczonych pilek wyexportowanych za pomoc¹ VideoLabeler
gTruth  = load('labels.mat');
gTruth=gTruth.gTruth;

%folder, w ktorym beda klatki podczas pobierania danych treningowych
folder='trainImages';
mkdir(folder);

%tworzenie obiektu danych treningowych
trainingData=objectDetectorTrainingData(gTruth,'WriteLocation',folder);

%opcje treningu
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.001,...
          'Verbose',true,...
          'MiniBatchSize',16,...
          'MaxEpochs',30,...
          'Shuffle','never',...
          'VerboseFrequency',30,...
          'CheckpointPath',tempdir);
      
%trening...
[detector,info] = trainYOLOv2ObjectDetector(trainingData,lgraph,options);

%zapisywanie rezultatów do plików
dt=datetime();
save("YoloV2detector-"+datestr(dt,30),'detector');
save("YoloV2info-"+datestr(dt,30),'info');