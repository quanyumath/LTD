function UVt = OPtsvd(X)


[n1, n2, n3] = size(X);
X = fft(X, [], 3);

min12 = min(n1, n2);
U = zeros(n1, min12, n3);
V = zeros(n2, min12, n3);
UVt = zeros(n1, n2, n3);
% i=1
[U(:, :, 1), ~, V(:, :, 1)] = svd(X(:, :, 1), 'econ');
UVt(:, :, 1) = U(:, :, 1) * V(:, :, 1)';
% i=2,...,halfn3
halfn3 = round(n3/2);
for i = 2:halfn3
    [U(:, :, i), ~, V(:, :, i)] = svd(X(:, :, i), 'econ');
    UVt(:, :, i) = U(:, :, i) * V(:, :, i)';
    UVt(:, :, n3+2-i) = conj(UVt(:, :, i));
end
% if n3 is even
if mod(n3, 2) == 0
    i = halfn3 + 1;
    [U(:, :, i), ~, V(:, :, i)] = svd(X(:, :, i), 'econ');
    UVt(:, :, i) = U(:, :, i) * V(:, :, i)';
end


UVt = ifft(UVt, [], 3);
