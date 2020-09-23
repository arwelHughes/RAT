function [problem,result] = standardTF_stanLay_reflectivityCalculation(problemDef,problemDef_cells,problemDef_limits,controls)

global RAT_DEBUG DEBUGVARS

% coder.varsize('problem.backgrounds',[Inf,1],[1 0]); 
% coder.varsize('problem.qshifts',[Inf,1],[1 0]); 
% coder.varsize('problem.scalefactors',[Inf,1],[1 0]);   
% coder.varsize('problem.nbairs',[Inf,1],[1 0]);   
% coder.varsize('problem.nbsubs',[Inf,1],[1 0]);   
% coder.varsize('problem.resolutions',[Inf,1],[1 0]);   
% coder.varsize('problem.allSubRough',[Inf,1],[1 0]);  


[repeatLayers,...
 allData,...
 dataLimits,...
 simLimits,...
 contrastLayers,...
 layersDetails] = RAT_parse_cells(problemDef_cells);


%Extract individual parameters from problemDef
res = problemDef.resample;
numberOfContrasts = problemDef.numberOfContrasts;
geometry = problemDef.geometry;
%nbairs = problemDef.nbairs;
%nbsubs = problemDef.nbsubs;
%repeats = problemDef.repeatLayers;
cBacks = problemDef.contrastBacks;
cShifts = problemDef.contrastShifts;
cScales = problemDef.contrastScales;
cNbas = problemDef.contrastNbas;
cNbss = problemDef.contrastNbss;
cRes = problemDef.contrastRes;
backs = problemDef.backs;
shifts = problemDef.shifts;
sf = problemDef.sf;
nba = problemDef.nba;
nbs = problemDef.nbs;
res = problemDef.res;
dataPresent = problemDef.dataPresent;
%allData = problemDef.allData;
%dataLimits = problemDef.dataLimits;
%simLimits = problemDef.simLimits;
%repeatLayers = problemDef.repeatLayers;
nParams = length(problemDef.params);
params = problemDef.params;
%contrastLayers = problemDef.contrastLayers;
numberOfLayers = problemDef.numberOfLayers;
%layersDetails = problemDef.layersDetails;
resample = problemDef.resample;


%Pre-allocation
outSsubs = params(1);
backgs = zeros(numberOfContrasts,1);
qshifts = zeros(numberOfContrasts,1);
sfs = zeros(numberOfContrasts,1);
nbas = zeros(numberOfContrasts,1);
nbss = zeros(numberOfContrasts,1);
chis = zeros(numberOfContrasts,1);
resols = zeros(numberOfContrasts,1);
allRoughs = zeros(numberOfContrasts,1);

reflectivity = cell(numberOfContrasts,1);
Simulation = cell(numberOfContrasts,1);
shifted_data = cell(numberOfContrasts,1);
layerSlds = cell(numberOfContrasts,1);
sldProfiles = cell(numberOfContrasts,1);
allLayers = cell(numberOfContrasts,1);

para = controls.Para;

switch para
    case 'single'
        [outSsubs,...
            backgs,...
            qshifts,...
            sfs,...
            nbas,...
            nbss,...
            resols,...
            chis,...
            reflectivity,...
            Simulation,...
            shifted_data,...
            layerSlds,...
            sldProfiles,...
            allLayers,...
            allRoughs] = standardTF_stanlay_single(resample, ...
            numberOfContrasts, ...
            geometry, ...
            repeatLayers , ...
            cBacks , ...
            cShifts , ...
            cScales , ...
            cNbas , ...
            cNbss, ...
            cRes , ...
            backs , ...
            shifts , ...
            sf, ...
            nba , ...
            nbs , ...
            res , ...
            dataPresent , ...
            allData , ...
            dataLimits , ...
            simLimits , ...
            nParams , ...
            params , ...
            contrastLayers , ...
            numberOfLayers , ...
            layersDetails, ...
            problemDef_limits);
        
    case 'multi'
%         [outSsubs,...
%             backgs,...
%             qshifts,...
%             sfs,...
%             nbas,...
%             nbss,...
%             resols,...
%             chis,...
%             reflectivity,...
%             Simulation,...
%             shifted_data,...
%             layerSlds,...
%             sldProfiles,...
%             allLayers,...
%             allRoughs] = standardTF_stanlay_parallel(resample, ...
%             numberOfContrasts, ...
%             geometry, ...
%             repeatLayers , ...
%             cBacks , ...
%             cShifts , ...
%             cScales , ...
%             cNbas , ...
%             cNbss, ...
%             cRes , ...
%             backs , ...
%             shifts , ...
%             sf, ...
%             nba , ...
%             nbs , ...
%             res , ...
%             dataPresent , ...
%             allData , ...
%             dataLimits , ...
%             simLimits , ...
%             nParams , ...
%             params , ...
%             contrastLayers , ...
%             numberOfLayers , ...
%             layersDetails, ...
%             problemDef_limits);
end

problem.ssubs = outSsubs;
problem.backgrounds = backgs;
problem.qshifts = qshifts;
problem.scalefactors = sfs;
problem.nbairs = nbas;
problem.nbsubs = nbss;
problem.resolutions = resols;
problem.calculations.all_chis = chis;
problem.calculations.sum_chi = sum(chis);
problem.allSubRough = allRoughs;
%problem.calculations.reflectivity = reflectivity;
%problem.calculations.Simulation = Simulation;
%problem.shifted_data = shifted_data;
%problem.layers = layerSlds;
%problem.calculations.slds = sldProfiles;
%problem.allLayers = allLayers;



result = cell(1,6);



%result = {{};{};{};{};{};{};{}};
result{1} = reflectivity;
result{2} = Simulation;
result{3} = shifted_data;
result{4} = layerSlds;
result{5} = sldProfiles;
result{6} = allLayers;


%Result coder definitions....
 coder.varsize('result{1}',[Inf 1],[1 0]);           %Reflectivity
 coder.varsize('result{1}{:}',[Inf 2],[1 0]);        
% 
 coder.varsize('result{2}',[Inf 1],[1 0]);           %Simulatin
 coder.varsize('result{2}{:}',[Inf 2],[1 0]);
% 
 coder.varsize('result{3}',[Inf 1],[1 0]);           %Shifted data
 coder.varsize('result{3}{:}',[Inf 3],[1 0]);
% 
 coder.varsize('result{4}',[Inf 1],[1 0]);           %Layers slds
 coder.varsize('result{4}{:}',[Inf 3],[1 0]);
% 
 coder.varsize('result{5}',[Inf 1],[1 0]);           %Sld profiles
 coder.varsize('results{5}{:}',[Inf 2],[1 0]);
% 
 coder.varsize('result{6}',[Inf 1],[1 0]);           %All layers 
 coder.varsize('result{6}{:}',[Inf 1],[1 0]);


if coder.target('MATLAB')
    if RAT_DEBUG
        DEBUGVARS.standardTF_stanLay_reflectivityCalculation.problem = problem;
        DEBUGVARS.standardTF_stanLay_reflectivityCalculation.results = results;
    end
end
end