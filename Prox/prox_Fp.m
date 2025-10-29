function Y = prox_Fp(X, lambda, p)

[H, ~, D] = size(X);
nm = sqrt(sum(X.^2, [1, 3]));
nms = prox_CapLp(nm, lambda, p, 1000)./nm;
%nms = prox_Lp(nm, lambda, 1)./nm;
sw = repmat(nms, [H, 1, D]);
Y = sw .* X;

end