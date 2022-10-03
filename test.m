clear;
close all;

figure;
disp("Video loading...");
shuttleAvi = VideoReader('output.mp4');
disp("Video loaded");

detector=load('YoloV2detector-20210527T233958.mat');
detector=detector.detector;

outputVideo = VideoWriter(fullfile('.','shuttle_out2.mp4'),'MPEG-4');
open(outputVideo);


num=1;
 
while hasFrame(shuttleAvi)
    
%     disp("Going to next frame "+num+ "...");
%     for a=1:150
%         readFrame(shuttleAvi);
%     end
%    disp("Detecting this frame...");
    
    img=im2frame(readFrame(shuttleAvi));
    img=img.cdata;

    [bboxes,scores] = detect(detector,img);
    
    
    
    if length(scores)~=0
        index=find(max(scores)==scores);
        disp(index);
        
        bbox=bboxes(index,:);
        score=scores(index);

        annotation = sprintf('Confidence = %.1f',score);
        img = insertObjectAnnotation(img,'rectangle',bbox,annotation);
    end
    %[bboxes,scores]= selectStrongestBbox(bboxes,scores);
    
%     if length(scores)~=0        
%         for i = 1:length(scores)
% 
%            
%            annotation = sprintf('Confidence = %.1f',scores(i));
%            img = insertObjectAnnotation(img,'rectangle',bboxes(i,:),annotation);
%            
%         end
        
        %disp("SCORED "+num2str(num));
        %imshow(img);
%    end
    
    if rem(num,30)==0
        disp(num2str(num/30)+"sec");
        imshow(img);
    end
    
    writeVideo(outputVideo,img);
    num=num+1;
end

close(outputVideo);