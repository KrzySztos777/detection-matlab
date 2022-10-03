clear;
close all;

gTruth  = load('labels.mat');
gTruth=gTruth.gTruth;

folder='trainImages';
mkdir(folder);
trainingDataTable=objectDetectorTrainingData(gTruth,'WriteLocation',folder);

summary(trainingDataTable)

allBoxes = vertcat(trainingDataTable.pilka{:});

aspectRatio = allBoxes(:,3) ./ allBoxes(:,4);
area = prod(allBoxes(:,3:4),2);

figure
subplot(1,2,1);
scatter(area,aspectRatio)
xlabel("Powierzchnia obszaru zakotwiczenia w pikselach")
ylabel("Proporcja szerokoœci do wysokoœci obrazu");
title("Powierzchnia a proporcja obrazu")

trainingData = boxLabelDatastore(trainingDataTable(:,2:end));

maxNumAnchors = 15;
meanIoU = zeros([maxNumAnchors,1]);
anchorBoxes = cell(maxNumAnchors, 1);
for k = 1:maxNumAnchors
    % Estimate anchors and mean IoU.
    [anchorBoxes{k},meanIoU(k)] = estimateAnchorBoxes(trainingData,k);    
end

subplot(1,2,2);
plot(1:maxNumAnchors,meanIoU,'-o')
ylabel("Wspó³czynnik dopasowania")
xlabel("Liczba obszarów zakotwiczenia")
title("Iloœæ obszarów zakotwiczenia a ich dopasowanie")

%Generate anchor boxes:
anchorBoxes
meanIoU