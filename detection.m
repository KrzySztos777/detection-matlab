function detection()

%include helpers.cpp: getFrame, printFrame, printErr
coder.cinclude("helpers.cpp");

%script is prepared for square input frame. side=width=height
side=224;

%yolov2 CNN holder
persistent yolov2Obj;

%loading example CNN- this above "if" is not necessary since inifinite loop applied
%THERE MUST BE NO SPACES IN FILENAME
if isempty(yolov2Obj)
    yolov2Obj = coder.loadDeepLearningNetwork('YoloV2detector-20210527T233958.mat');
end

%declaration of "img"- memory allocation for compiler:ones(width,height,3)
img=ones(side, side, 3, 'uint8');
%coder.ceval('printErr', 'superowato'); %<---DEMO OF printErr

while 1
    %getting frame from stdin
    coder.ceval('getFrame', coder.ref(img), side);
    
    %detection...
    [bboxes,scores,labels] = yolov2Obj.detect(img,'Threshold',0.5);
    
    %printing annotations on image
    if ~isempty(scores)%annotations if objects found
        m=max(scores);
        index=0;
        for i = 1:length(scores)
            if scores(i)==m
                index=i;
            end
        end
        
        x=bboxes(index,1)+bboxes(index,3)/2;
        y=bboxes(index,2)+bboxes(index,4)/2;
        ang=atan2(double(x-side/2),double((side/2)*tan(62.2*(pi/180))))*180/pi;
        
        annotation = sprintf('C:%.1f A:%.1f',scores(index),ang);
        img = insertObjectAnnotation(img,'rectangle',bboxes(index,:),annotation);
        
        coder.ceval('printErr',[ sprintf('%0.0d',int32(ang)) 10 ]);
    else
        img = insertText(img,[1 1],'no detections','FontSize',12,'BoxColor',[255 0 0],'BoxOpacity',0.4,'TextColor',[255 255 255]);

    end
    coder.ceval('printFrame', img, side);
end


