function imds = omniglotImageDatastore(path)
% omniglotImageDatastore accepts the folder path to the Omniglot
% dataset, loads the data into MATLAB as an ImageDatastore object and
% labels the images based on the file paths.

    % Load the data as an ImageDatastore object
    imds = imageDatastore(path,'IncludeSubfolders',true,'LabelSource','none');
    
    % Generate labels for each image from the names of the last two
    % directories for that image location
    files = string(imds.Files);
    parts = split(files,filesep);
    labels = join(parts(:,(end-2):(end-1)),'_');
    imds.Labels = categorical(labels);
end