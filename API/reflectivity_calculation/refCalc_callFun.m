global RAT_DEBUG DEBUGVARS

RAT_DEBUG = 0;
DEBUGVARS = 0;


%callParams = load('callParams.mat');

%callParams = load('newInputs_AL.mat');
%callParams = callParams.newInputs;
% callParams = load('newVars.mat');
% callParams = callParams.newVars;
callParams = load('callVars.mat');
callParams = callParams.callVars;


% callParams = load('customVars.mat');
% callParams = callParams.customVars;


problemDef = callParams.problemDef;
problemDef_cells = callParams.problemDef_cells;
problemDef_limits = callParams.problemDef_limits;
controls = callParams.controls;
% fn = problemDef.modelFilename;
% [p,n,e] = fileparts(fn);
% problemDef.modelFilename = n;
probleDef.modelFilename = ' ';
[problem,result] = reflectivity_calculation(problemDef,problemDef_cells,problemDef_limits,controls);