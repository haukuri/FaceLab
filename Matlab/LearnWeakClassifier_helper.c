#include "mex.h"
#include "matrix.h"
#include "math.h"
#include "stdio.h"


void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    /* inputs:
     * prhs[0]  weights                 Nx1
     * prhs[1]  feature i for each img. Nx1
     * prhs[2]  label for each image    Nx1
     *
     * outputs:
     * plhs[0]  theta                   1x1
     * plhs[1]  negative error          1x1
     * plhs[2]  positive error          1x1
     */
    size_t N = mxGetM(prhs[0]);
    
    // Right hand side
    double* ws = mxGetPr(prhs[0]);
    double* fs = mxGetPr(prhs[1]);
    double* ys = mxGetPr(prhs[2]);
    
    // Left hand side declarations
    double* theta;
    double* eneg;
    double* epos;
    
    // Loop counter
    int i;
    
    // Accumulators
    double mup_num, mup_den, mun_num, mun_den;
    
    // Left hand side declarations
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL); // theta
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL); // eneg
    plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL); // epos
    theta   = mxGetPr(plhs[0]);
    eneg    = mxGetPr(plhs[1]);
    epos    = mxGetPr(plhs[2]);
    
    for (i = 0; i < N; i++) {
        mup_num += ws[i] * fs[i] * ys[i];
        mup_den += ws[i] * ys[i];
        mun_num += ws[i] * fs[i] * (1 - ys[i]);
        mun_den += ws[i] * (1 - ys[i]);
    }
    theta[0] = 0.5 * (mup_num/mup_den + mun_num/mun_den);
    
    for (i = 0; i< N; i++) {
        eneg[0] += ws[i] * abs(ys[i] - (double)(fs[i] > theta[0]));
        epos[0] += ws[i] * abs(ys[i] - (double)(fs[i] < theta[0]));
    }   
}
