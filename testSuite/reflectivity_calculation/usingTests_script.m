% How To Use the Test Files
% Start by loading in one of the test inputs 

runWhichType = 'Custom Layers';

switch runWhichType
    case 'Custom Layers'

        % Load inputs for Custom layers 
        theseInputs = load('customLayersInputs.mat');
        
        % Split the input into the variables needed to call the function
        problemDef = theseInputs.customLayersInputs.problemDef;
        problemDef_cells = theseInputs.customLayersInputs.problemDef_cells;
        problemDef_limits = theseInputs.customLayersInputs.problemDef_limits;
        controls = theseInputs.customLayersInputs.controls;
        
        % Load the expected outputs for customLayers
        expectedOutput = load('customLayersOutput.mat');
        expectedProblem = expectedOutput.customLayersOutput.problem;
        expectedResult = expectedOutput.customLayersOutput.result; 
        
    case 'Standard Layers'
        
        % Load inputs for Standard layers 
        theseInputs = load('standardLayersInputs.mat');
        
        % Split the input into the variables needed to call the function
        problemDef = theseInputs.standardLayersInputs.problemDef;
        problemDef_cells = theseInputs.standardLayersInputs.problemDef_cells;
        problemDef_limits = theseInputs.standardLayersInputs.problemDef_limits;
        controls = theseInputs.standardLayersInputs.controls;
        
        % Load the expected outputs for standardLayers
        expectedOutput = load('standardLayersOutput.mat');
        expectedProblem = expectedOutput.standardLayersOutput.problem;
        expectedResult = expectedOutput.standardLayersOutput.result;        
           
    case 'Custom XY'
        
        % Load inputs for Custom XY 
        theseInputs = load('customXYInputs.mat');
        
        % Split the input into the variables needed to call the function
        problemDef = theseInputs.customXYInputs.problemDef;
        problemDef_cells = theseInputs.customXYInputs.problemDef_cells;
        problemDef_limits = theseInputs.customXYInputs.problemDef_limits;
        controls = theseInputs.customXYInputs.controls;
        
        % Load the expected outputs for standardLayers
        expectedOutput = load('customXYOutput.mat');
        expectedProblem = expectedOutput.customXYOutput.problem;
        expectedResult = expectedOutput.customXYOutput.result; 
        
        
end


% The inputs control which type of calculation is tested  (standard layers, 
% custom layers or cistom XY). Additionally, we need to pass two parameters controlling 
% parallelisation, and whether to use compiled or not....
whichParallel = 'single';   % Test the single threaded calculation
useCompiled = false;           % Test the matlab code
[testOutProblem1,testOutResult1] = reflectivity_calculation_testing_wrapper(problemDef, problemDef_cells,problemDef_limits,...
                                                                                controls, useCompiled, whichParallel);
% Now run it again using the mex
useCompied = true;
[testOutProblem2,testOutResult2] = reflectivity_calculation_testing_wrapper(problemDef, problemDef_cells,problemDef_limits,...
                                                                                controls, useCompiled, whichParallel);                                                                       
% Asuucessful test should give the same outputs for both...
success = isequal(testOutProblem1,expectedProblem);
if success
    disp('''Problem'' comparison passed for mfiles');
else
    disp('''Problem'' comparison failed for mfiles');
end

success = isequal(testOutResult1,expectedResult);
if success
    disp('''Result'' comparison passed for mfiles');
else
    disp('''Result'' comparison failed for mfiles');
end


success = isequal(testOutProblem2,expectedProblem);
if success
    disp('''Problem'' comparison passed for mex');
else
    disp('''Problem'' comparison failed for mex');
end

success = isequal(testOutResult2,expectedResult);
if success
    disp('''Result'' comparison passed for mex');
else
    disp('''Result'' comparison failed for mex');
end
                                                                            % 