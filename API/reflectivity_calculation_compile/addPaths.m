%ratRoot = '/Users/arwelhughes/coding/RAT/'; %OSX
ratRoot = '/home/arwel/Documents/RascalDev/RAT'; %Linux


ratPaths = {fullfile(ratRoot,'targetFunctions','common');
    fullfile(ratRoot,'targetFunctions','common','backSorts');
    fullfile(ratRoot,'targetFunctions','common','callModules');
    fullfile(ratRoot,'targetFunctions','common','callReflectivity');
    fullfile(ratRoot,'targetFunctions','common','chiSquared');
    fullfile(ratRoot,'targetFunctions','common','groupLayers');
    fullfile(ratRoot,'targetFunctions','common','makeSLDProfiles');
    fullfile(ratRoot,'targetFunctions','common','shiftData');
    fullfile(ratRoot,'targetFunctions','common','standard_layers_mod');
    fullfile(ratRoot,'targetFunctions','common','unpackParams');
    fullfile(ratRoot,'targetFunctions','common','legacyChanges');
    fullfile(ratRoot,'targetFunctions','common','resampleLayers');
    fullfile(ratRoot,'targetFunctions','common','matlabEngineCaller_customLayers');
    fullfile(ratRoot,'targetFunctions','standard_TF');
    fullfile(ratRoot,'targetFunctions','standard_TF','standardTF_stanLay_single');
    fullfile(ratRoot,'targetFunctions','standard_TF','standardTF_stanLay_parallel');
    fullfile(ratRoot,'targetFunctions','standard_TF','standardTF_custLay_single');
    fullfile(ratRoot,'API');
%     fullfile(ratRoot,'API','reflectivity_calculation');
    fullfile(ratRoot,'API','outputFcn');
    fullfile(ratRoot,'API','problemDef_class');
    fullfile(ratRoot,'API','controlsDef_class');
%     fullfile(ratRoot,'tests');
%     fullfile(ratRoot,'minimisers','simplex');
%     fullfile(ratRoot,'minimisers','generalUtils');
%     fullfile(ratRoot,'minimisers','DE');
%     fullfile(ratRoot,'minimisers','NSMain');
%     fullfile(ratRoot,'minimisers','mcmcstat');
%     fullfile(ratRoot,'utilities');
%     fullfile(ratRoot,'utilities','plotting');
%     fullfile(ratRoot,'utilities','testing');
};

%addpath('/home/arwel/eclipseWorkspace_new/matlabEngine_demo/src');
%addpath('/home/arwel/Documents/RascalDev/RAT/targetFunctions/standard_TF/old_standardTF');

for i = 1:length(ratPaths)
    addpath(ratPaths{i});
end

addpath(ratRoot);

disp('debug');


    