clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%% Load and Preprocess Training Data

url = "https://github.com/brendenlake/omniglot/raw/master/python/images_background.zip";
downloadFolder = tempdir;
filename = fullfile(downloadFolder,"images_background.zip");

trainingSetFolder = fullfile(downloadFolder,'images_background');
if (~exist(trainingSetFolder,"dir"))
    disp("Downloading Omniglot training data (4.5 MB)...")
    websave(filename,url);
    unzip(filename,downloadFolder);
end
disp("Training data downloaded.")


% load the Omniglot training dataset
imds = omniglotImageDatastore(trainingSetFolder);


% display a random selection of the sample images
idxs = randperm(numel(imds.Files),8);
for i = 1:numel(idxs)
    subplot(4,2,i)
    imshow(readimage(imds,idxs(i)))
    title(imds.Labels(idxs(i)), "Interpreter","none");
end


%% Create Pairs of Similar and Dissimilar Images

batchSize = 10;
[pairImage1,pairImage2,pairLabel] = getSiameseBatch(imds,batchSize);

% display the generated pairs of images
for i = 1:batchSize
    if pairLabel(i) == 1
        s = "similar";
    else
        s = "dissimilar";
    end
    subplot(2,5,i)
    imshow([pairImage1(:,:,:,i) pairImage2(:,:,:,i)]);
    title(s)
end


%% Define Network Architecture

layers = [
    imageInputLayer([105 105 1],'Name','input1','Normalization','none')
    convolution2dLayer(10,64,'Name','conv1','WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer('Name','relu1')
    maxPooling2dLayer(2,'Stride',2,'Name','maxpool1')
    convolution2dLayer(7,128,'Name','conv2','WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer('Name','relu2')
    maxPooling2dLayer(2,'Stride',2,'Name','maxpool2')
    convolution2dLayer(4,128,'Name','conv3','WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer('Name','relu3')
    maxPooling2dLayer(2,'Stride',2,'Name','maxpool3')
    convolution2dLayer(5,256,'Name','conv4','WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer('Name','relu4')
    fullyConnectedLayer(4096,'Name','fc1','WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')];

lgraph = layerGraph(layers);


% convert the layer graph to a dlnetwork object
dlnet = dlnetwork(lgraph);

fcWeights = dlarray(0.01*randn(1,4096));
fcBias = dlarray(0.01*randn(1,1));
fcParams = struct("FcWeights",fcWeights,"FcBias",fcBias);


%% Specify Training Options

numIterations = 10000;
miniBatchSize = 180;

learningRate = 6e-5;
trailingAvgSubnet = [];
trailingAvgSqSubnet = [];
trailingAvgParams = [];
trailingAvgSqParams = [];
gradDecay = 0.9;
gradDecaySq = 0.99;

executionEnvironment = "auto";
plots = "training-progress";

plotRatio = 16/9;

if plots == "training-progress"
    trainingPlot = figure;
    trainingPlot.Position(3) = plotRatio*trainingPlot.Position(4);
    trainingPlot.Visible = 'on';
    
    trainingPlotAxes = gca;
    
    lineLossTrain = animatedline(trainingPlotAxes);
    xlabel(trainingPlotAxes,"Iteration")
    ylabel(trainingPlotAxes,"Loss")
    title(trainingPlotAxes,"Loss During Training")
end


%% Train Model

% Loop over mini-batches.
for iteration = 1:numIterations
    
    % Extract mini-batch of image pairs and pair labels
    [X1,X2,pairLabels] = getSiameseBatch(imds,miniBatchSize);
    
    % Convert mini-batch of data to dlarray. Specify the dimension labels
    % 'SSCB' (spatial, spatial, channel, batch) for image data
    dlX1 = dlarray(single(X1),'SSCB');
    dlX2 = dlarray(single(X2),'SSCB');
    
    % If training on a GPU, then convert data to gpuArray.
    if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
        dlX1 = gpuArray(dlX1);
        dlX2 = gpuArray(dlX2);
    end
    
    % Evaluate the model gradients and the generator state using
    % dlfeval and the modelGradients function listed at the end of the
    % example.
    [gradientsSubnet, gradientsParams,loss] = dlfeval(@modelGradients,dlnet,fcParams,dlX1,dlX2,pairLabels);
    lossValue = double(gather(extractdata(loss)));
    
    % Update the Siamese subnetwork parameters.
    [dlnet,trailingAvgSubnet,trailingAvgSqSubnet] = ...
        adamupdate(dlnet,gradientsSubnet, ...
        trailingAvgSubnet,trailingAvgSqSubnet,iteration,learningRate,gradDecay,gradDecaySq);
    
    % Update the fullyconnect parameters.
    [fcParams,trailingAvgParams,trailingAvgSqParams] = ...
        adamupdate(fcParams,gradientsParams, ...
        trailingAvgParams,trailingAvgSqParams,iteration,learningRate,gradDecay,gradDecaySq);
    
    % Update the training loss progress plot.
    if plots == "training-progress"
        addpoints(lineLossTrain,iteration,lossValue);
    end
    drawnow;
    iteration
end


%% Evaluate the Accuracy of the Network

url = 'https://github.com/brendenlake/omniglot/raw/master/python/images_evaluation.zip';
downloadFolder = tempdir;
filename = fullfile(downloadFolder,'images_evaluation.zip');

testingSetFolder = fullfile(downloadFolder,'images_evaluation');
if (~exist(testingSetFolder,'dir'))
    disp('Downloading Omniglot test data (3.2 MB)...')
    websave(filename,url);
    unzip(filename,downloadFolder);
end
disp("Test data downloaded.")

%
imdsTest = omniglotImageDatastore(testingSetFolder);
numClasses = numel(unique(imdsTest.Labels));


% evaluate the network predictions and calculate the average accuracy over the minibatches
accuracy = zeros(1,5);
accuracyBatchSize = 150;
for i = 1:5
    
    % Extract mini-batch of image pairs and pair labels
    [XAcc1,XAcc2,pairLabelsAcc] = getSiameseBatch(imdsTest,accuracyBatchSize);
    
    % Convert mini-batch of data to dlarray. Specify the dimension labels
    % 'SSCB' (spatial, spatial, channel, batch) for image data.
    dlXAcc1 = dlarray(single(XAcc1),'SSCB');
    dlXAcc2 = dlarray(single(XAcc2),'SSCB');
    
    % If using a GPU, then convert data to gpuArray.
    if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
        dlXAcc1 = gpuArray(dlXAcc1);
        dlXAcc2 = gpuArray(dlXAcc2);
    end
    
    % Evaluate predictions using trained network
    dlY = predictSiamese(dlnet,fcParams,dlXAcc1,dlXAcc2);
    
    % Convert predictions to binary 0 or 1
    Y = gather(extractdata(dlY));
    Y = round(Y);
    
    % Compute average accuracye for the minibatch
    accuracy(i) = sum(Y == pairLabelsAcc)/accuracyBatchSize;
end

% Compute accuracy over all minibatches
averageAccuracy = mean(accuracy)*100


%% Display a Test Set of Images with Predictions

testBatchSize = 10;
[XTest1,XTest2,pairLabelsTest] = getSiameseBatch(imdsTest,testBatchSize);

% Convert test batch of data to dlarray. Specify the dimension labels
% 'SSCB' (spatial, spatial, channel, batch) for image data and 'CB'
% (channel, batch) for labels
dlXTest1 = dlarray(single(XTest1),'SSCB');
dlXTest2 = dlarray(single(XTest2),'SSCB');

% If using a GPU, then convert data to gpuArray
if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
    dlXTest1 = gpuArray(dlXTest1);
    dlXTest2 = gpuArray(dlXTest2);
end

% Calculate the predicted probability
dlYScore = predictSiamese(dlnet,fcParams,dlXTest1,dlXTest2);
YScore = gather(extractdata(dlYScore));

% Convert predictions to binary 0 or 1
YPred = round(YScore);

% Extract data to plot
XTest1 = extractdata(dlXTest1);
XTest2 = extractdata(dlXTest2);

% Plot images with predicted label and predicted score
testingPlot = figure;
testingPlot.Position(3) = plotRatio*testingPlot.Position(4);
testingPlot.Visible = 'on';

for i = 1:numel(pairLabelsTest)
    
    if YPred(i) == 1
        predLabel = "similar";
    else
        predLabel = "dissimilar" ;
    end
    
    if pairLabelsTest(i) == YPred(i)
        testStr = "\bf\color{darkgreen}Correct\rm\newline";
        
    else
        testStr = "\bf\color{red}Incorrect\rm\newline";
    end
    
    subplot(2,5,i)
    imshow([XTest1(:,:,:,i) XTest2(:,:,:,i)]);
    
    title(testStr + "\color{black}Predicted: " + predLabel + "\newlineScore: " + YScore(i));
end


