function [T, T_dim, T_mat] = tmult(X, A, n)
% [T, T_dim, T_mat] = tmult(X, A, n, X_dim)
% this function is caluculating mode-n procudt of X and A
%
% input:
% X: a tensor
% A: a matrix
% n: a mode
%
% output:
% T: a tensor (X x_n A)
% T_dim: a dimension of T
% T_mat: matrix of not folding T
    
    if ~ismatrix(A)
        error('A is not a matrix')
    end
    X_dim = size(X);
    [J, In] = size(A);
    if size(X, n) ~= In
        error('dimension of X or A is invalid')
    end
    T_dim = X_dim;
    T_dim(n) = J;
    T_mat = A * Unfold(X, X_dim, n);
    T = Fold(T_mat, T_dim, n);
end