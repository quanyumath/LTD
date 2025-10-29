function data = NormalizeData(data)

[M, N, D] = size(data);
data = reshape(data, [M * N, D]);
Max = max(data, [], 1);
Min = min(data, [], 1);
data = (data - repmat(Min, M*N, 1)) ./ (repmat(Max-Min, M*N, 1));
data = reshape(data, [M, N, D]);

end
