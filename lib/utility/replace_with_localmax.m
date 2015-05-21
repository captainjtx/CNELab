function trg=replace_with_localmax(trg,N)
% function lm=remplace_with_localmax(trg,N)
% Replaces the data which is different than zero with the local max
% of a window length of N

L=length(trg);
k=N+1;
while k<L-N
    Ix=k-N:k+N;
    mx=max(trg(Ix));
    if mx
        Ixx= trg(Ix)>0;
        trg(Ix(Ixx))=mx;
    end
    k=k+1;
end