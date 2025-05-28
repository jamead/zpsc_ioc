#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <aSubRecord.h>
#include <epicsExport.h>
#include <registryFunction.h>

long epoch2string(aSubRecord *prec) {
    long *epoch_ptr = (long *)prec->a;     // INPA
    unsigned char *out = (unsigned char *)prec->vala;  // VALA output (string)

    if (!epoch_ptr || !out) {
        return -1;
    }

    //printf("Hello EPOCH 2 String\n");
    time_t rawtime = (time_t)(*epoch_ptr);
    struct tm ts;

    // Use local time (or use gmtime_r for UTC)
    if (localtime_r(&rawtime, &ts) == NULL) {
        strcpy((char *)out, "Invalid time");
        return -1;
    }

    strftime((char *)out, prec->nova, "%Y-%m-%d %H:%M:%S", &ts);
    //printf("Formatted timestamp: %s\n", out);

    return 0;
}
epicsRegisterFunction(epoch2string);

