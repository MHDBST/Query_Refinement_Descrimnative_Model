function [x,fval,exitflag,output]= findLambda(h,f)

% options = optimset(@fminunc);
% options = optimset(options,'Display','iter','LargeScale','off','HessUpdate','bfgs');
options.Method='lbfgs';
options.numDiff = 1;
lambda0 = [0.5,0.5,0.5]; % Starting guess
NormLmbd = norm(h);
c = 100000000000;
myf = @(lambda)myOptimFunc(lambda,h(1),h(2),f,c,NormLmbd);
% [x,fval,exitflag,output] = fminunc(myf,lambda0,options);

[x,fval,exitflag,output] = minFunc(myf,lambda0,options);
end