function [IMF]=HistogramBasedIMF(ImgRef,ImgCur,row,col,IMF)
Ref_His = zeros(256,1);
Cur_His = zeros(256,1);
for ii=1:row
    for jj=1:col
        intR = ImgRef(ii, jj);
        intX = ImgCur(ii, jj);
        Ref_His(intR+1) = Ref_His(intR+1)+1;
        Cur_His(intX+1) = Cur_His(intX+1)+1;
    end
end    
for ii=2:256
    Ref_His(ii) = Ref_His(ii-1)+Ref_His(ii);
    Cur_His(ii) = Cur_His(ii-1)+Cur_His(ii);
end
IMF = HistogramOptimization(Ref_His, Cur_His, IMF);
clear Ref_His;
clear Cur_His;
