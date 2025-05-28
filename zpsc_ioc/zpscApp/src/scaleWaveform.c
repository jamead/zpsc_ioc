#include <stdio.h>
#include <aSubRecord.h>
#include <epicsExport.h>
#include <registryFunction.h>


static long scaleWaveform(aSubRecord *prec) {
    double *in_wave = (double *)prec->a;  // waveform input
    double *scalar = (double *)prec->b;   // scalar input
    double *out = (double *)prec->vala;   // output waveform

    int n = prec->nova;  // number of elements in waveform
    printf("Hello scaleWaveform:  %d\n",n);
    for (int i = 0; i < n; i++) {
           out[i] = in_wave[i] * (*scalar);
    }

    prec->neva = n;
    return 0;
}

epicsRegisterFunction(scaleWaveform);

