function [F,MEF_SSIM] = main_api_2021KaraPAS(I)
I = double(uint8(I*255));

%% PAS-MEF
run install
[Fused, ~, run_time, MEF_SSIM] = PAS_MEF(I);

%% Uninstall PAS-MEF
F= Fused;
run uninstall

end