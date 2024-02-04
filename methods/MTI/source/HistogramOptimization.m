function [IMF]=HistogramOptimization(His1, His2, IMF)
for ii=1:256
    if ii==1
        bb = 1;
    else
        bb = IMF(ii-1);
    end
    aa = abs(His1(ii)-His2(bb));
    IMF(ii) = bb;
    for jj=(bb+1):256
        cc = abs(His1(ii)-His2(jj));
        if cc<aa;
            IMF(ii) = jj;
            aa = cc;
        end
    end
end
 