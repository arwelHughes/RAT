//
// Non-Degree Granting Education License -- for use at non-degree
// granting, nonprofit, educational organizations only. Not for
// government, commercial, or other organizational use.
// File: allocateParamsToLayers.cpp
//
// MATLAB Coder version            : 5.0
// C/C++ source code generated on  : 15-Apr-2021 10:46:16
//

// Include Files
#include "allocateParamsToLayers.h"
#include "reflectivity_calculation.h"
#include "rt_nonfinite.h"
#include "standardTF_stanlay_paraAll.h"

// Function Definitions

//
// This function takes the list of all layers (in terms of parameter
// numbers) in layersDetails, and loops through putting in the correct
// parameter value from the parameter array in each layer.
// Arguments    : const coder::array<double, 2U> *params
//                const coder::array<cell_wrap_2, 1U> *layersDetails
//                coder::array<cell_wrap_15, 2U> *outLayers
// Return Type  : void
//
void allocateParamsToLayers(const coder::array<double, 2U> &params, const coder::
  array<cell_wrap_2, 1U> &layersDetails, coder::array<cell_wrap_15, 2U>
  &outLayers)
{
  int i;
  double thisOutLayer[5];
  for (i = 0; i < 5; i++) {
    thisOutLayer[i] = 0.0;
  }

  outLayers.set_size(1, layersDetails.size(0));
  i = layersDetails.size(0);
  for (int b_i = 0; b_i < i; b_i++) {
    int i1;
    i1 = layersDetails[b_i].f1.size(1);
    for (int n = 0; n <= i1 - 2; n++) {
      if (!rtIsNaN(layersDetails[b_i].f1[n])) {
        thisOutLayer[n] = params[static_cast<int>(layersDetails[b_i].f1[n]) - 1];
      } else {
        thisOutLayer[n] = rtNaN;
      }
    }

    thisOutLayer[layersDetails[b_i].f1.size(1) - 1] = layersDetails[b_i]
      .f1[layersDetails[b_i].f1.size(1) - 1];
    for (i1 = 0; i1 < 5; i1++) {
      outLayers[b_i].f1[i1] = thisOutLayer[i1];
    }
  }
}

//
// File trailer for allocateParamsToLayers.cpp
//
// [EOF]
//
