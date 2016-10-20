% Generate linear classification data set with some variables flipped
nInstances = 400;
nVars = 2;
[X,y] = makeData('classificationFlip',nInstances,nVars);

% Add bias
X = [ones(nInstances,1) X];

fprintf('Training logistic regression model...\n');
wLogistic = minFunc(@LogisticLoss,zeros(nVars+1,1),options,X,y);

trainErr = sum(y ~= sign(X*wLogistic))/length(y)

fprintf('Training probit regression model...\n');
wProbit = minFunc(@ProbitLoss,zeros(nVars+1,1),options,X,y);

trainErr = sum(y ~= sign(X*wProbit))/length(y)

% Plot the result
figure;
subplot(1,2,1);
plotClassifier(X,y,wProbit,'Probit Regression');
subplot(1,2,2);
plotClassifier(X,y,wLogistic,'Logistic Regression');
pause;
