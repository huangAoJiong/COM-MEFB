% This is used to set the evaluation metrics that to be computed
%
% Author:Xingchen Zhang, Ping Ye, Gang Xiao
% Contact: xingchen.zhang@imperial.ac.uk

function metrics=working_configMetrics
 
    metricsInformationTheory={
         struct('name','Entropy'),...
         struct('name','Psnr'),...
         };

     metricsImageFeature={
         struct('name','Avg_gradient'),...
           struct('name','Edge_intensity'),...
           struct('name','Spatial_frequency'),...
         };

      metricsStructural={
           struct('name','MEF_SSIM'),...
         };

       metricsPerception={
       };
       metricsNoReference ={
           struct('name','ILNIQE'),...
           struct('name','BRISQUE'),...
       };

    metrics = [metricsInformationTheory, metricsImageFeature, metricsStructural, metricsNoReference];

end
