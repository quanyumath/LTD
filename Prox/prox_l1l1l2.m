function E = prox_l1l1l2(X, lambda)

[~, ~, D] = size(X);
nm = sqrt(sum(X.^2, 3));
%nms = max(nm-lambda, 0);
nms = prox_CapLp(nm, lambda, 1, 1);
sw = repmat(nms./nm, [1, 1, D]);
E = sw .* X;

end