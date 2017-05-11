function matchedPoints2=surf2(I1,I2)
    points1 = detectSURFFeatures(I1,'NumOctaves',3,'MetricThreshold',20,'NumScaleLevels' ,6);
    points2 = detectSURFFeatures(I2,'NumOctaves',3,'MetricThreshold',20,'NumScaleLevels' ,6);

    [f1,vpts1] = extractFeatures(I1,points1);
    [f2,vpts2] = extractFeatures(I2,points2);

    indexPairs = matchFeatures(f1,f2,'Unique',true) ;
    matchedPoints2 = vpts2(indexPairs(:,2));
end