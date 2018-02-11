k=0; 
for i = 1:100:5500
     k = k+1;
tmp = mean(gamma(i:i+500, :).^2, 1);
scatter(tmp, max_force);
[R, P] = corrcoef(max_force, tmp);
r(k) = R(1, 2);
p(k) = P(1, 2);
title(num2str(R(1, 2)))
i
pause(0.1)
end