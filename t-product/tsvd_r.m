function [U, S, V] = tsvd_r(X, r)


[n1, n2, n3] = size(X);
X = fft(X, [], 3);

U = zeros(n1, r, n3);
S = zeros(r, r, n3);
V = zeros(n2, r, n3);

% i=1
[U(:, :, 1), S(:, :, 1), V(:, :, 1)] = svds(X(:, :, 1), r);
% i=2,...,halfn3
halfn3 = round(n3/2);
for i = 2:halfn3
    [U(:, :, i), S(:, :, i), V(:, :, i)] = svds(X(:, :, i), r);
    U(:, :, n3+2-i) = conj(U(:, :, i));
    V(:, :, n3+2-i) = conj(V(:, :, i));
    S(:, :, n3+2-i) = S(:, :, i);
end
% if n3 is even
if mod(n3, 2) == 0
    i = halfn3 + 1;
    [U(:, :, i), S(:, :, i), V(:, :, i)] = svds(X(:, :, i), r);
end

U = ifft(U, [], 3);
S = ifft(S, [], 3);
V = ifft(V, [], 3);
