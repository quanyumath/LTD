function [AUC_PFPD, AUC_tauPD, AUC_tauPF, AUC_OD, AUC_SNPR] = AUC_pro(det_map, GT)

num_map = size(det_map, 2);

for k = 1:num_map
    [PF{k}, PD{k}, tau{k}] = perfcurve(logical(GT), det_map(:, k), 1);
end

% Compute a1, a0, b1 and b0 and normalized PD PF
a1 = min(cellfun(@(x) min(x(:)), PD));
a0 = max(cellfun(@(x) max(x(:)), PD));
b1 = min(cellfun(@(x) min(x(:)), PF));
b0 = max(cellfun(@(x) max(x(:)), PF));


AUCnor.a1 = a1;
AUCnor.a0 = a0;
AUCnor.b1 = b1;
AUCnor.b0 = b0;


% AUC(PF, PD) and Nor_AUC(PF, PD)
for i = 1:num_map
    AUC0 = trapz(PF{i}, PD{i});
    AUC.PFPD(i, 1) = round(AUC0, 6);
    AUCnor.PFPD(i, 1) = round((AUC0 - a1)/((a0 - a1) * (b0 - b1)), 6);
end

% AUC(PD, tau) and Nor_AUC(PD, tau)
for i = 1:num_map
    AUC0 = -trapz(tau{i}, PD{i});
    AUC.tauPD(i, 1) = round(AUC0, 6);
    AUCnor.tauPD(i, 1) = round((AUC0 - a1)/(a0 - a1), 6);
end

% AUC(PF£¬tau£©and Nor_AUC(PF£¬tau£©
for i = 1:num_map
    AUC0 = abs(trapz(tau{i}, PF{i}));
    AUC.tauPF(i, 1) = round(AUC0, 6);
    AUCnor.tauPF(i, 1) = round((AUC0 - b1)/(b0 - b1), 6);
end
AUC_PFPD = AUC.PFPD;
AUC_tauPD = AUC.tauPD;
AUC_tauPF = AUC.tauPF;

AUC_OD = AUCnor.PFPD + AUCnor.tauPD - AUCnor.tauPF;
AUC_SNPR = AUCnor.tauPD ./ AUCnor.tauPF;