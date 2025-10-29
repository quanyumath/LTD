function [E1, E2, C, B, D, Z, R, Err] = LTD(H, opts, mask)

%% Parameters and defaults
if isfield(opts,'maxiter')  maxiter = opts.maxiter;   else maxiter = 100;  end
if isfield(opts,'tol')      tol = opts.tol;           else tol = 1e-3;     end
if isfield(opts,'p')        p = opts.p;               else p = 1;          end
if isfield(opts,'b')        b = opts.b;               else b = 5;          end
if isfield(opts,'lambda')   lambda = opts.lambda;     else lambda = [1 1 1 1 1 1];         end
if isfield(opts,'rho')      rho = opts.rho;           else rho = 1e-2 * [1 1 1 1 1 1];     end

%% Data preprocessing and initialization
Nway = size(H);
n1 = Nway(1);
n2 = Nway(2);
n3 = Nway(3);
Nway_new = [n1, n2, b];
r_add = []; r_subtract = [];

H_3 = Unfold(H, Nway, 3);
[U, ~, ~] = svd(H_3, 'econ');
B = U(:, 1:b); C = tmult(H, B', 3);
E1 = zeros(Nway); E2 = zeros(Nway_new);
[U, S, V] = tsvd(C);
D = U; Z = tprod(V, tran(S));
zero_counter = zeros(size(Z, 2), 1); r(1) = n2;
fprintf('Iteration:     ');
for t = 1:maxiter
    fprintf('\b\b\b\b\b%5i', t);

    %% update C
    l_C = lambda(3) * norm(B, 2)^2 + lambda(6);
    nabla_Cf = lambda(3) * tmult(tmult(C, B, 3)+E1-H, B', 3) + ...
        lambda(6) * (C - tprod(D, tran(Z)) - E2);
    C_hat = ((l_C + rho(1)) * C - nabla_Cf) / (l_C + rho(1));
    C = C_hat ./ repmat(sqrt(sum(C_hat.^2, 3)), [1, 1, b]);

    %% update B
    C_3 = Unfold(C, Nway_new, 3);
    l_B = lambda(3) * norm(C_3, 2)^2 + lambda(1);
    nabla_Bf = lambda(3) * (B * C_3 + Unfold(E1-H, Nway, 3)) * C_3' + lambda(1) * B;
    B = max(0, (l_B + rho(2))*B-nabla_Bf) / (l_B + rho(2));


    %% update E1
    CB3 = tmult(C, B, 3);
    E1 = prox_l1l1l2((lambda(3) * (H - CB3) + rho(3) * E1) ...
        /(lambda(3) + rho(3)), lambda(2)/(lambda(3) + rho(3)));

    %% update D
%     [U, ~, V] = tsvd(lambda(5)*tprod(C-E2, Z)+rho(4)*D);
%     D = tprod(U, tran(V));
      D = OPtsvd(lambda(6)*tprod(C-E2, Z)+rho(4)*D);

    %% update Z
    Z = prox_Fp((lambda(6) * tprod(tran(C-E2), D) + rho(5) * Z)/(lambda(6) + rho(5)) ...
        , lambda(4)/(lambda(6) + rho(5)), p);


    %% update E2
    CDZ = C - tprod(D, tran(Z));
    E2 = prox_l1l1l2((lambda(6) * CDZ + rho(6) * E2) ...
        /(lambda(6) + rho(6)), lambda(5)/(lambda(6) + rho(6)));
    
    
    %% 判断上一步删掉的是否合理，不合理就增加上一步删除的列
    r_add(t) = 0;
    if t > 1
        ac = any(cols_to_delete);
        if ac
            Z0 = prox_Fp((lambda(6) * tprod(tran(C-E2), DCD0))/(lambda(6) + rho(5)) ...
            , lambda(4)/(lambda(6) + rho(5)), p);
            norms_z0 = sqrt(sum(Z0.^2, [1 3]));
            [~, idx] = sort(norms_z0, 'descend');  % 不能增加过大
            Index = idx(1:min(5, size(Z0, 2)));
            Z = cat(2, Z, Z0(:,Index,:)); D = cat(2, D, DCD0(:,Index,:));
            r_add(t) = sum(squeeze(all(all(Z0(:,Index,:) ~= 0, 1), 3)));
        end
        zero_counter = zeros(size(Z, 2), 1);
    end
    
    
    
    %% Remove the zero lateral slices of D and Z.
    zero_slices = squeeze(all(all(Z == 0, 1), 3));
%    zero_slices = squeeze(all(arrayfun(@(j) norm(squeeze(Z(:, j, :)), 'fro') < 1, 1:size(Z, 2)), 1));
    zero_counter = zero_counter + zero_slices';
    zero_counter(~zero_slices') = 0;
    cols_to_delete = (zero_counter >= 1) & (size(Z, 2) - sum(zero_counter >= 1) >= 1);
    if any(cols_to_delete)
        DCD0 = D(:, cols_to_delete, :);
        D(:, cols_to_delete, :) = [];
        Z(:, cols_to_delete, :) = [];
        zero_counter(cols_to_delete) = [];
    end
    r(t) = size(Z, 2); 
    if t>1 && ac
        r_subtract(t) = sum(cols_to_delete) - sum(squeeze(all(all(Z0(:,Index,:) == 0, 1), 3)));
    else
        r_subtract(t) = sum(cols_to_delete);
    end

    

    

    %% judge whether converges
    lambda(3) = min(lambda(3) * 1.2, 1e10); % 1.1 / 1.2
    lambda(4) = min(lambda(4) * 1.2, 1e0);    % 1.5
    lambda(6) = min(lambda(6) * 1.15, 1e10); % 1.1 / 1.2
    err_v1 = CDZ - E2; err_v2 = CB3 + E1 - H;
    err1 = norm(err_v1(:), 'inf'); err2 = norm(err_v2(:), 'inf'); 
    Err(t) = max(err1, err2);

    if max(err1, err2) < tol
        break;
    end
    %resa(t) = AUC(sqrt(sum(E1.^2, 3)), mask);
end
R{1} = r; R{2} = r_add; R{3} = r_subtract;
end