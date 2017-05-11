function [matchedPoints1,matchedPoints2]=surf2(I1,I2,No,MT,Ns)
    points1 = detectSURFFeatures(I1,'NumOctaves',No,'MetricThreshold',MT,'NumScaleLevels' ,Ns);
    points2 = detectSURFFeatures(I2,'NumOctaves',No,'MetricThreshold',MT,'NumScaleLevels' ,Ns);

    [f1,vpts1] = extractFeatures(I1,points1);
    [f2,vpts2] = extractFeatures(I2,points2);

    indexPairs = matchFeatures(f1,f2,'Unique',true) ;
    matchedPoints1 = vpts1(indexPairs(:,1));
    matchedPoints2 = vpts2(indexPairs(:,2));
end