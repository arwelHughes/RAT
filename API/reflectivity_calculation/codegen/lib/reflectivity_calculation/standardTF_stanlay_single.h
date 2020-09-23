/*
 * Non-Degree Granting Education License -- for use at non-degree
 * granting, nonprofit, educational organizations only. Not for
 * government, commercial, or other organizational use.
 *
 * standardTF_stanlay_single.h
 *
 * Code generation for function 'standardTF_stanlay_single'
 *
 */

#ifndef STANDARDTF_STANLAY_SINGLE_H
#define STANDARDTF_STANLAY_SINGLE_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "omp.h"
#include "reflectivity_calculation_types.h"

/* Function Declarations */
extern void standardTF_stanlay_single(const emxArray_real_T *resample, double
  numberOfContrasts, const emxArray_char_T *geometry, const emxArray_cell_wrap_0
  *repeatLayers, const emxArray_real_T *cBacks, const emxArray_real_T *cShifts,
  const emxArray_real_T *cScales, const emxArray_real_T *cNbas, const
  emxArray_real_T *cNbss, const emxArray_real_T *cRes, const emxArray_real_T
  *backs, const emxArray_real_T *shifts, const emxArray_real_T *sf, const
  emxArray_real_T *nba, const emxArray_real_T *nbs, const emxArray_real_T *res,
  const emxArray_real_T *dataPresent, const emxArray_cell_wrap_1 *allData, const
  emxArray_cell_wrap_0 *dataLimits, const emxArray_cell_wrap_0 *simLimits,
  double nParams, const emxArray_real_T *params, const emxArray_cell_wrap_0
  *contrastLayers, const emxArray_cell_wrap_2 *layersDetails, const
  emxArray_real_T *backsType, emxArray_real_T *outSsubs, emxArray_real_T *backgs,
  emxArray_real_T *qshifts, emxArray_real_T *sfs, emxArray_real_T *nbas,
  emxArray_real_T *nbss, emxArray_real_T *resols, emxArray_real_T *chis,
  emxArray_cell_wrap_9 *reflectivity, emxArray_cell_wrap_9 *Simulation,
  emxArray_cell_wrap_1 *shifted_data, emxArray_cell_wrap_1 *layerSlds,
  emxArray_cell_wrap_9 *sldProfiles, emxArray_cell_wrap_8 *allLayers,
  emxArray_real_T *allRoughs);

#endif

/* End of code generation (standardTF_stanlay_single.h) */