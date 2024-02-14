classdef testReflectivityCalculations < matlab.unittest.TestCase
%%
% testReflectivityCalculations Class based unit tests for RAT API, the
% reflectivity calculation and pre- and post-processing routines.
%
% We are using the test cases for a non-polarised TF reflectivity
% calculation to test the routines. We consider standard layers, custom
% layers and custom XY examples. For the reflectivity calculation itself,
% we consider the serial and parallel versions (both points and contrasts),
% using both the MATLAB and compiled (MEX) versions.

%% Declare properties and parameters

    properties (ClassSetupParameter)
        inputsFile = {'standardLayersInputs.mat', 'customLayersInputs.mat', 'customXYInputs.mat'}
        outputsFile = {'standardLayersOutputs.mat', 'customLayersOutputs.mat', 'customXYOutputs.mat'}
        TFFile = {'standardLayersTFParams.mat', 'customLayersTFParams.mat',  'customXYTFParams.mat'} % TF Params test data
    end

    properties (TestParameter)    
        whichParallel = {'single', 'points', 'contrasts'} % How the reflectivity calculation is parallelised
        useCompiled = {false, true}                       % Choose either the MATLAB or MEX version
    end

    properties
        inputs                     % Test input parameters read from file
        outputs                    % Test output parameters read from file
        TFParams                   % Test TF Parameters read from file
        project                    % Input projectClass object
        problemStruct              % Input parameters for the test problem
        problemCells               % Input cell arays for the test problem
        problemLimits              % Input limits for the test problem
        priors                     % Input priors for the test problem
        controlsInput              % Instrument controls class for the input problem
        controls                   % Instrument controls struct for the input problem
        expectedContrastParams     % Expected output value of the contrastParams struct
        expectedContrastParamsMain % Expected output value of the contrastParams struct from RATMain
        expectedProblemDefStruct   % Expected output value of the problemStruct struct
        expectedProject            % Expected output value of the projectClass object
        expectedResultCells        % Expected output value of the results cell array
        expectedResultCellsMain    % Expected output value of the results cell array from RATMain
        expectedResultStruct       % Expected output value of the initial results struct
        expectedResult             % Expected output value of the final results struct
        expectedBayesResults       % Expected output value of the bayes results struct
        TFReflectivity
        TFSimulation
        TFShiftedData
        TFLayerSLDs
        TFSLDProfiles
        TFAllLayers
        TFOutSsubs
        TFBackgroundParams
        TFQzshifts
        TFScalefactors
        TFBulkIn
        TFBulkOut
        TFResolutionParams
        TFChis
        TFAllRoughs
        tolerance = 1.0e-12     % Relative tolerance for equality of floats
        absTolerance = 1.0e-5   % Absolute tolerance for equality of floats
    end

%% Read in test data

    methods (TestClassSetup, ParameterCombination='sequential')

        function loadTestDataInputs(testCase, inputsFile)
            testCase.inputs = load(inputsFile);

            testCase.project = testCase.inputs.inputs.project;
            testCase.problemStruct = testCase.inputs.inputs.problemStruct;
            testCase.problemCells = testCase.inputs.inputs.problemCells;
            testCase.problemLimits = testCase.inputs.inputs.problemLimits;
            testCase.priors = testCase.inputs.inputs.priors;
            testCase.controlsInput = testCase.inputs.inputs.controlsInput;
            testCase.controls = testCase.inputs.inputs.controls;
        end
        
        function loadTestDataOutputs(testCase, outputsFile)
            testCase.outputs = load(outputsFile);

            testCase.expectedContrastParams = testCase.outputs.outputs.contrastParams;
            testCase.expectedContrastParamsMain = testCase.outputs.outputs.contrastParamsMain;
            testCase.expectedProject = testCase.outputs.outputs.project;
            testCase.expectedProblemDefStruct = testCase.outputs.outputs.problemStruct;
            testCase.expectedResult = testCase.outputs.outputs.result;
            testCase.expectedResultStruct = testCase.outputs.outputs.resultStruct;
            testCase.expectedResultCells = testCase.outputs.outputs.resultCells;
            testCase.expectedResultCellsMain = testCase.outputs.outputs.resultCellsMain;
            testCase.expectedBayesResults = testCase.outputs.outputs.bayesResults;
        end

        function loadTFParams(testCase, TFFile)
            testCase.TFParams = load(TFFile);

            testCase.TFReflectivity = testCase.TFParams.TFParams.reflectivity;
            testCase.TFSimulation = testCase.TFParams.TFParams.simulation;
            testCase.TFShiftedData = testCase.TFParams.TFParams.shiftedData;
            testCase.TFLayerSLDs = testCase.TFParams.TFParams.layerSlds;
            testCase.TFSLDProfiles = testCase.TFParams.TFParams.sldProfiles;
            testCase.TFAllLayers = testCase.TFParams.TFParams.allLayers;

            testCase.TFOutSsubs = testCase.TFParams.TFParams.outSsubs;
            testCase.TFBackgroundParams = testCase.TFParams.TFParams.backgroundParams;
            testCase.TFQzshifts = testCase.TFParams.TFParams.qzshifts;
            testCase.TFScalefactors = testCase.TFParams.TFParams.scalefactors;
            testCase.TFBulkIn = testCase.TFParams.TFParams.bulkIn;
            testCase.TFBulkOut = testCase.TFParams.TFParams.bulkOut;
            testCase.TFResolutionParams = testCase.TFParams.TFParams.resolutionParams;
            testCase.TFChis = testCase.TFParams.TFParams.chis;
            testCase.TFAllRoughs = testCase.TFParams.TFParams.allRoughs;
        end
        
    end

%%
    methods (Test, ParameterCombination='exhaustive')
%% Test High Level RAT Routines

        function testRAT(testCase)
            [projectOutput, result] = RAT(testCase.project,testCase.controlsInput);

            testCase.verifyEqual(projectOutput, testCase.expectedProject, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(result, testCase.expectedResult, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testRATMain(testCase)
            % Test the routine that determines the calculation RAT will perform
            % Note that we test only a single reflectivity calculation at
            % present

            [testProblemDefStruct, problem, resultCells, bayesResults] = RATMain(testCase.problemStruct,testCase.problemCells,testCase.problemLimits,testCase.controls,testCase.priors);

            testCase.verifyEqual(testProblemDefStruct, testCase.expectedProblemDefStruct, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(problem, testCase.expectedContrastParamsMain, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultCells, testCase.expectedResultCellsMain, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bayesResults, testCase.expectedBayesResults, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

%% Test Reflectivity Calculation Routines

        function testReflectivityCalculation(testCase, whichParallel, useCompiled)
            % Test the reflectivity calculation.
            % We will test the serial and parallel (over both points and
            % contrasts) versions of the calculation, using both the MATLAB
            % and compiled (MEX) versions of each.
            
            if useCompiled
                % Skip the mex tests if coder is not installed. These tests will be marked as incomplete
                testCase.assumeEqual(license('test', 'MATLAB_Coder'), 1, 'MATLAB Coder is not installed');
            end
            
            testCase.controls.parallel = whichParallel;
            if useCompiled
                [problem, resultCells] = reflectivityCalculation_mex(testCase.problemStruct, testCase.problemCells, testCase.controls);
            else        
                [problem, resultCells] = reflectivityCalculation(testCase.problemStruct, testCase.problemCells, testCase.controls);
            end
            testCase.verifyEqual(problem, testCase.expectedContrastParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultCells, testCase.expectedResultCells, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testNonPolarisedTFReflectivityCalculation(testCase)
            [problem, reflectivity, simulation, shiftedData, layerSLDs, SLDProfiles, allLayers] = nonPolarisedTF.reflectivityCalculation(testCase.problemStruct, testCase.problemCells, testCase.controls);

            testCase.verifyEqual(problem, testCase.expectedContrastParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(reflectivity, testCase.TFReflectivity, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(simulation, testCase.TFSimulation, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(shiftedData, testCase.TFShiftedData, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(layerSLDs, testCase.TFLayerSLDs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(SLDProfiles, testCase.TFSLDProfiles, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allLayers, testCase.TFAllLayers, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testNonPolarisedTFLayersReflectivityCalc(testCase, TFFile)
            % Choose the appropriate routine for each test case
            switch TFFile
                case 'standardLayersTFParams.mat'
                    [problem, reflectivity, simulation, shiftedData, layerSLDs, SLDProfiles, allLayers] = nonPolarisedTF.standardLayers.calculate(testCase.problemStruct, testCase.problemCells,  testCase.controls);
                case 'customLayersTFParams.mat'
                    [problem, reflectivity, simulation, shiftedData, layerSLDs, SLDProfiles, allLayers] = nonPolarisedTF.customLayers.calculate(testCase.problemStruct, testCase.problemCells,  testCase.controls);
                case 'customXYTFParams.mat'
                    [problem, reflectivity, simulation, shiftedData, layerSLDs, SLDProfiles, allLayers] = nonPolarisedTF.customXY.calculate(testCase.problemStruct, testCase.problemCells,  testCase.controls);
            end

            testCase.verifyEqual(problem, testCase.expectedContrastParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(reflectivity, testCase.TFReflectivity, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(simulation, testCase.TFSimulation, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(shiftedData, testCase.TFShiftedData, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(layerSLDs, testCase.TFLayerSLDs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(SLDProfiles, testCase.TFSLDProfiles, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allLayers, testCase.TFAllLayers, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testNonPolarisedTFLayersSerialReflectivityCalc(testCase, TFFile)
            % Choose the appropriate routine for each test case
            switch TFFile
                case 'standardLayersTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.standardLayers.single(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
                case 'customLayersTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.customLayers.single(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
                case 'customXYTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.customXY.single(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
            end

            testCase.verifyEqual(outSsubs, testCase.TFOutSsubs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(backgroundParams, testCase.TFBackgroundParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(qzshifts, testCase.TFQzshifts, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(scalefactors, testCase.TFScalefactors, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkIn, testCase.TFBulkIn, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkOut, testCase.TFBulkOut, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resolutionParams, testCase.TFResolutionParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(chis, testCase.TFChis, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(reflectivity, testCase.TFReflectivity, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(simulation, testCase.TFSimulation, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(shiftedData, testCase.TFShiftedData, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(layerSLDs, testCase.TFLayerSLDs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(SLDProfiles, testCase.TFSLDProfiles, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allLayers, testCase.TFAllLayers, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allRoughs, testCase.TFAllRoughs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testNonPolarisedTFLayersParallelContrastsReflectivityCalc(testCase, TFFile)
            % Choose the appropriate routine for each test case
            switch TFFile
                case 'standardLayersTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.standardLayers.parallelContrasts(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
                case 'customLayersTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.customLayers.parallelContrasts(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
                case 'customXYTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.customXY.parallelContrasts(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
            end

            testCase.verifyEqual(outSsubs, testCase.TFOutSsubs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(backgroundParams, testCase.TFBackgroundParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(qzshifts, testCase.TFQzshifts, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(scalefactors, testCase.TFScalefactors, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkIn, testCase.TFBulkIn, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkOut, testCase.TFBulkOut, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resolutionParams, testCase.TFResolutionParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(chis, testCase.TFChis, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(reflectivity, testCase.TFReflectivity, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(simulation, testCase.TFSimulation, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(shiftedData, testCase.TFShiftedData, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(layerSLDs, testCase.TFLayerSLDs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(SLDProfiles, testCase.TFSLDProfiles, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allLayers, testCase.TFAllLayers, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allRoughs, testCase.TFAllRoughs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testNonPolarisedTFLayersParallelPointsReflectivityCalc(testCase, TFFile)
            % Choose the appropriate routine for each test case
            switch TFFile
                case 'standardLayersTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.standardLayers.parallelPoints(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
                case 'customLayersTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.customLayers.parallelPoints(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
                case 'customXYTFParams.mat'
                    [outSsubs,backgroundParams,qzshifts,scalefactors,bulkIn,bulkOut,resolutionParams,chis,reflectivity,...
                    simulation,shiftedData,layerSLDs,SLDProfiles,allLayers,...
                    allRoughs] = nonPolarisedTF.customXY.parallelPoints(testCase.problemStruct,testCase.problemCells,...
                    testCase.controls);
            end

            testCase.verifyEqual(outSsubs, testCase.TFOutSsubs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(backgroundParams, testCase.TFBackgroundParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(qzshifts, testCase.TFQzshifts, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(scalefactors, testCase.TFScalefactors, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkIn, testCase.TFBulkIn, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkOut, testCase.TFBulkOut, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resolutionParams, testCase.TFResolutionParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(chis, testCase.TFChis, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(reflectivity, testCase.TFReflectivity, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(simulation, testCase.TFSimulation, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(shiftedData, testCase.TFShiftedData, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(layerSLDs, testCase.TFLayerSLDs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(SLDProfiles, testCase.TFSLDProfiles, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allLayers, testCase.TFAllLayers, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allRoughs, testCase.TFAllRoughs, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

%% Test Pre- and Post-Processing Routines

        function testParseClasstoStructs(testCase)
            [testProblemDefStruct, testProblemDefCells, testProblemDefLimits, testPriors, testControls] = parseClassToStructs(testCase.project, testCase.controlsInput);

            testCase.verifyEqual(testProblemDefStruct, testCase.problemStruct, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(testProblemDefCells, testCase.problemCells, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(testProblemDefLimits, testCase.problemLimits, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(testPriors, testCase.priors, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(testControls, testCase.controls, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testParseCells(testCase)
            [repeatLayers,allData,dataLimits,simLimits,contrastLayers,layersDetails,customFiles] = parseCells(testCase.problemCells);

            testCase.verifyEqual(repeatLayers, testCase.problemCells{1}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(allData, testCase.problemCells{2}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(dataLimits, testCase.problemCells{3}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(simLimits, testCase.problemCells{4}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastLayers, testCase.problemCells{5}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(layersDetails, testCase.problemCells{6}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(customFiles, testCase.problemCells{14}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end        

        function testExtractProblemParams(testCase)
            [numberOfContrasts, geometry, contrastBackgrounds, contrastQzshifts, contrastScalefactors, contrastBulkIns, contrastBulkOuts,...
            contrastResolutions, backgroundParams, qzshifts, scalefactors, bulkIn, bulkOut, resolutionParams, dataPresent, nParams, params,...
            numberOfLayers, resample, backgroundParamsType, contrastCustomFiles] =  extractProblemParams(testCase.problemStruct);

            testCase.verifyEqual(numberOfContrasts, testCase.problemStruct.numberOfContrasts, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(geometry, testCase.problemStruct.geometry, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastBackgrounds, testCase.problemStruct.contrastBackgrounds, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastQzshifts, testCase.problemStruct.contrastQzshifts, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastScalefactors, testCase.problemStruct.contrastScalefactors, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastBulkIns, testCase.problemStruct.contrastBulkIns, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastBulkOuts, testCase.problemStruct.contrastBulkOuts, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastResolutions, testCase.problemStruct.contrastResolutions, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(backgroundParams, testCase.problemStruct.backgroundParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(qzshifts, testCase.problemStruct.qzshifts, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(scalefactors, testCase.problemStruct.scalefactors, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkIn, testCase.problemStruct.bulkIn, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(bulkOut, testCase.problemStruct.bulkOut, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resolutionParams, testCase.problemStruct.resolutionParams, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(dataPresent, testCase.problemStruct.dataPresent, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(nParams, length(testCase.problemStruct.params), 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(params, testCase.problemStruct.params, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(numberOfLayers, testCase.problemStruct.numberOfLayers, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resample, testCase.problemStruct.resample, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(backgroundParamsType, testCase.problemStruct.contrastBackgroundsType, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(contrastCustomFiles, testCase.problemStruct.contrastCustomFiles, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testParseResultToStruct(testCase)
            resultStruct = parseResultToStruct(testCase.expectedContrastParamsMain, testCase.expectedResultCellsMain);
            testCase.verifyEqual(resultStruct, testCase.expectedResultStruct, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);

            testCase.verifyEqual(resultStruct.reflectivity, testCase.expectedResultCellsMain{1}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultStruct.simulation, testCase.expectedResultCellsMain{2}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultStruct.shiftedData, testCase.expectedResultCellsMain{3}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultStruct.layerSlds, testCase.expectedResultCellsMain{4}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultStruct.sldProfiles, testCase.expectedResultCellsMain{5}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultStruct.allLayers, testCase.expectedResultCellsMain{6}, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
            testCase.verifyEqual(resultStruct.calculationResults, testCase.expectedContrastParamsMain.calculations, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

        function testParseOutToProjectClass(testCase)
            problemOut = parseOutToProjectClass(testCase.project, testCase.expectedProblemDefStruct);
            testCase.verifyEqual(problemOut, testCase.expectedProject, 'RelTol', testCase.tolerance, 'AbsTol', testCase.absTolerance);
        end

    end
end