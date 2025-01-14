problem = createProject(name='20nM_data', calcType='normal', model='standard layers', geometry='air/substrate', absorption=false);

problem.setParameter(1, 'min', 3, 'max', 7, 'value', 6.99082582831175);
problem.setParameterFit(1, true);
problem.setParameterPrior(1, 'uniform', 0, Inf);

paramGroup = {
              {'Tails thick', 12, 18.7690679408915, 20, true, 'uniform', 0, Inf};
              {'Deuterated tails SLD', 5e-06, 6.93558772796193e-06, 9e-06, true, 'uniform', 0, Inf};
              {'Tails roughness', 3, 3.00000000000748, 7, true, 'uniform', 0, Inf};
              {'Hydrogenated tails SLD', -6e-07, -2.19078531097092e-07, -2e-07, true, 'uniform', 0, Inf};
              {'Head thickness', 7, 7.0000000001179, 12, true, 'uniform', 0, Inf};
              {'Deuterated head SLD', 3e-06, 5.85512914352937e-06, 6e-06, true, 'uniform', 0, Inf};
              {'Head roughness', 3, 3.00000000000003, 7, true, 'uniform', 0, Inf};
              {'Hydrogenated head SLD', 1e-06, 1.80793981414406e-06, 2e-06, true, 'uniform', 0, Inf};
              {'Head hydration', 0, 9.33740417574095, 20, true, 'uniform', 0, Inf};
              };

problem.addParameterGroup(paramGroup);

problem.removeBulkIn(1);
problem.addBulkIn('Air', 0, 0, 0, false, 'uniform', 0, Inf);

problem.removeBulkOut(1);
problem.addBulkOut('D2O', 6.3e-06, 6.35e-06, 6.4e-06, false, 'uniform', 0, Inf);
problem.addBulkOut('ACMW', -5e-07, 3.49289801862442e-08, 5e-07, false, 'uniform', 0, Inf);

problem.removeScalefactor(1);
problem.addScalefactor('Scalefactor 1', 0.1, 0.232513579315991, 0.4, true, 'uniform', 0, Inf);

problem.removeBackgroundParam(1);
problem.addBackgroundParam('Backs parameter 1', 1e-07, 2.8894659208167e-06, 7e-06, true, 'uniform', 0, Inf);
problem.addBackgroundParam('Backs parameter 2', 1e-07, 5.17288453906304e-06, 7e-06, true, 'uniform', 0, Inf);

problem.removeResolutionParam(1);
problem.addResolutionParam('Resolution par 1', 0.01, 0.03, 0.05, false, 'uniform', 0, Inf);

problem.removeData(1);
problem.addData('Simulation');
problem.setData(1, 'dataRange', [0.051793 0.58877]);
problem.setData(1, 'simRange', [0.051793 0.58877]);

data_2 = readmatrix('d70acmw20.dat');
problem.addData('d70acmw20', data_2);
problem.setData(2, 'dataRange', [0.051793 0.58877]);
problem.setData(2, 'simRange', [0.051793 0.58877]);

data_3 = readmatrix('d70d2o20.dat');
problem.addData('d70d2o20', data_3);
problem.setData(3, 'dataRange', [0.051793 0.58877]);
problem.setData(3, 'simRange', [0.051793 0.58877]);

data_4 = readmatrix('d13acmw20.dat');
problem.addData('d13acmw20', data_4);
problem.setData(4, 'dataRange', [0.051793 0.58877]);
problem.setData(4, 'simRange', [0.051793 0.58877]);

data_5 = readmatrix('d13d2o20.dat');
problem.addData('d13d2o20', data_5);
problem.setData(5, 'dataRange', [0.051793 0.58877]);
problem.setData(5, 'simRange', [0.051793 0.58877]);

data_6 = readmatrix('d83acmw20.dat');
problem.addData('d83acmw20', data_6);
problem.setData(6, 'dataRange', [0.051793 0.58877]);
problem.setData(6, 'simRange', [0.051793 0.58877]);

data_7 = readmatrix('d83d2o20.dat');
problem.addData('d83d2o20', data_7);
problem.setData(7, 'dataRange', [0.051793 0.58877]);
problem.setData(7, 'simRange', [0.051793 0.58877]);

data_8 = readmatrix('hd2o20.dat');
problem.addData('hd2o20', data_8);
problem.setData(8, 'dataRange', [0.051793 0.58877]);
problem.setData(8, 'simRange', [0.051793 0.58877]);

problem.removeBackground(1);
problem.removeResolution(1);

problem.addLayer('Deuterated tails', 'Tails thick', 'Deuterated tails SLD', 'Tails roughness', '', 'bulk out');
problem.addLayer('Hydrogenated tails', 'Tails thick', 'Hydrogenated tails SLD', 'Tails roughness', '', 'bulk out');
problem.addLayer('Deuterated heads', 'Head thickness', 'Deuterated head SLD', 'Head roughness', 'Head hydration', 'bulk out');
problem.addLayer('Hydrogenated heads', 'Head thickness', 'Hydrogenated head SLD', 'Head roughness', 'Head hydration', 'bulk out');

problem.addBackground('Background  D2O', 'constant', 'Backs parameter 1', '', '', '', '', '');
problem.addBackground('Background ACMW', 'constant', 'Backs parameter 2', '', '', '', '', '');

problem.addResolution('Resolution 1', 'constant', 'Resolution par 1', '', '', '', '', '');

problem.addContrast('background', 'Background ACMW', 'backgroundAction', 'add', 'bulkIn', 'Air', 'bulkOut', 'ACMW', 'data', 'd70acmw20', 'name', 'd70, acmw', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(1, 'resample', false);
problem.setContrastModel(1, {'Deuterated tails' 'Hydrogenated heads'});

problem.addContrast('background', 'Background  D2O', 'backgroundAction', 'add', 'bulkIn', 'Air', 'bulkOut', 'D2O', 'data', 'd70d2o20', 'name', 'd70 d2o', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(2, 'resample', false);
problem.setContrastModel(2, {'Deuterated tails' 'Hydrogenated heads'});

problem.addContrast('background', 'Background ACMW', 'backgroundAction', 'add', 'bulkIn', 'Air', 'bulkOut', 'ACMW', 'data', 'd13acmw20', 'name', 'd13 acmw', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(3, 'resample', false);
problem.setContrastModel(3, {'Hydrogenated tails' 'Deuterated heads'});

problem.addContrast('background', 'Background  D2O', 'backgroundAction', 'add', 'bulkIn', 'Air', 'bulkOut', 'D2O', 'data', 'd13d2o20', 'name', 'd13 d2o', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(4, 'resample', false);
problem.setContrastModel(4, {'Hydrogenated tails' 'Deuterated heads'});

problem.addContrast('background', 'Background ACMW', 'backgroundAction', 'add', 'bulkIn', 'Air', 'bulkOut', 'ACMW', 'data', 'd83acmw20', 'name', 'd83 acmw', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(5, 'resample', false);
problem.setContrastModel(5, {'Deuterated tails' 'Deuterated heads'});

problem.addContrast('background', 'Background  D2O', 'backgroundAction', 'add', 'bulkIn', 'Air', 'bulkOut', 'D2O', 'data', 'd83d2o20', 'name', 'd83 d2o', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(6, 'resample', false);
problem.setContrastModel(6, {'Deuterated tails' 'Deuterated heads'});

problem.addContrast('background', 'Background  D2O', 'backgroundAction', 'add', 'bulkIn', 'Air', 'bulkOut', 'D2O', 'data', 'hd2o20', 'name', 'fully h, D2O', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(7, 'resample', false);
problem.setContrastModel(7, {'Hydrogenated tails' 'Hydrogenated heads'});

controls = controlsClass();
[problem, results] = RAT(problem, controls);

plotRefSLD(problem, results);
