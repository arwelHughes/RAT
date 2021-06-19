/*
 * Non-Degree Granting Education License -- for use at non-degree
 * granting, nonprofit, educational organizations only. Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "rt_nonfinite.h"
#include "groupLayers_Mod.h"
#include "main.h"
#include "groupLayers_Mod_terminate.h"
#include "groupLayers_Mod_emxAPI.h"
#include "groupLayers_Mod_initialize.h"

/* Function Declarations */
static emxArray_char_T *argInit_1xUnbounded_char_T(void);
static emxArray_real_T *argInit_Unboundedxd5_real_T(void);
static char argInit_char_T(void);
static double argInit_real_T(void);
static void main_groupLayers_Mod(void);

/* Function Definitions */
static emxArray_char_T *argInit_1xUnbounded_char_T(void)
{
  emxArray_char_T *result;
  static int iv1[2] = { 1, 2 };

  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_char_T(2, iv1);

  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result->data[result->size[0] * idx1] = argInit_char_T();
  }

  return result;
}

static emxArray_real_T *argInit_Unboundedxd5_real_T(void)
{
  emxArray_real_T *result;
  static int iv0[2] = { 2, 2 };

  int idx0;
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result = emxCreateND_real_T(2, iv0);

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
         Change this value to the value that the application requires. */
      result->data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }

  return result;
}

static char argInit_char_T(void)
{
  return '?';
}

static double argInit_real_T(void)
{
  return 0.0;
}

static void main_groupLayers_Mod(void)
{
  emxArray_real_T *outLayers;
  emxArray_real_T *allLayers;
  double allRoughs;
  emxArray_char_T *geometry;
  double outSsubs;
  emxInitArray_real_T(&outLayers, 2);

  /* Initialize function 'groupLayers_Mod' input arguments. */
  /* Initialize function input argument 'allLayers'. */
  allLayers = argInit_Unboundedxd5_real_T();
  allRoughs = argInit_real_T();

  /* Initialize function input argument 'geometry'. */
  geometry = argInit_1xUnbounded_char_T();

  /* Call the entry-point 'groupLayers_Mod'. */
  groupLayers_Mod(allLayers, allRoughs, geometry, argInit_real_T(),
                  argInit_real_T(), outLayers, &outSsubs);
  emxDestroyArray_real_T(outLayers);
  emxDestroyArray_char_T(geometry);
  emxDestroyArray_real_T(allLayers);
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  groupLayers_Mod_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_groupLayers_Mod();

  /* Terminate the application.
     You do not need to do this more than one time. */
  groupLayers_Mod_terminate();
  return 0;
}

/* End of code generation (main.c) */