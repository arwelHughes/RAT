/*
 * Non-Degree Granting Education License -- for use at non-degree
 * granting, nonprofit, educational organizations only. Not for
 * government, commercial, or other organizational use.
 *
 * matlabEngineCaller_customLayers.h
 *
 * Code generation for function 'matlabEngineCaller_customLayers'
 *
 */

#ifndef MATLABENGINECALLER_CUSTOMLAYERS_H
#define MATLABENGINECALLER_CUSTOMLAYERS_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "covrt.h"
#include "rtwtypes.h"
#include "matlabEngineCaller_customLayers_types.h"

/* Function Declarations */
extern void matlabEngineCaller_customLayers(const emlrtStack *sp, const real_T
  params[8], real_T contrast, const char_T funcName[10], const char_T funcPath
  [122], real_T bulkIn, real_T bulkOut, emxArray_real_T *output, real_T
  sRough_data[], int32_T sRough_size[2]);

#endif

/* End of code generation (matlabEngineCaller_customLayers.h) */