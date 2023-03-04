%% Main
%SUPPFIG2A generates data for supplementary figure 12a and is written for 
% running on clusters.

parpool(48);

addpath("../functions/");

nd = 90; %number of data points
ns = linspace(22,200,nd); %generate data points for number of nodes
k = 4; md = k*2;
beta = 0.15;


rs = ns./2; %number of rebels
alpha = 0.8; %attributing parameter



nrp = 10000; %number of repeats

Res = zeros(nrp,4,nd); %preallocate results

t = 10000; %number of steps
tau = 50; %choose tail length

parfor i = 1:nd

    i

    R = zeros(nrp,4); %preallocate temporary data

    n = ns(i); 
    r = rs(i); %load parameters

    for j = 1:nrp

        IC = -ones(n,1); %set initial choices
        % [G,A] = randomnetwork(n,md,eta); %generate a social network
        G = WattsStrogatz(n,k,beta);

        TD = attributetraits(G,r,alpha); %get trait distribution

        [xir,xic,xii] = mixingparameters(G,TD); %get mixing parameters

        [CM,CL] = proceed(IC,G,TD,t); %run the deterministic process

        [result,PH] = ispredictable(CL,tau); %examine the predictability

        R(j,1) = result;
        R(j,2) = xir;
        if result
            R(j,3) = PH(2)-PH(1); %length of eventual period
            R(j,4) = (abs(CM(PH(2)) - CM(PH(1))))/(PH(2) - PH(1)); 
        else
            R(j,3) = -1;
            R(j,4) = -1;
        end

    end

    Res(:,:,i) = R; %record data

end

save("SuppFig12a.mat")