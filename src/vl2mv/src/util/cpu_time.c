/* LINTLIBRARY */

#include <stdio.h>
#include "util.h"

#ifdef IBM_WATC		/* IBM Waterloo-C compiler (same as bsd 4.2) */
#define void int
#define BSD
#endif

#ifdef hpux		/* HPUX/C compiler -- times() with 50 HZ clock */
#define UNIX50
#endif

#ifdef vms		/* VAX/C compiler -- times() with 100 HZ clock */
#define UNIX100
#endif

#ifdef BSD
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>
#endif

#ifdef UNIX50
#include <sys/types.h>
#include <sys/times.h>
#endif

#ifdef UNIX60
#include <sys/types.h>
#include <sys/times.h>
#endif

#ifdef UNIX100
#include <sys/types.h>
#include <sys/times.h>
#endif



/*
 *   util_cpu_time -- return a long which represents the elapsed processor
 *   time in milliseconds since some constant reference
 */
long 
util_cpu_time()
{
    long t = 0;

#ifdef BSD
    struct rusage rusage;
    (void) getrusage(RUSAGE_SELF, &rusage);
    t = (long) rusage.ru_utime.tv_sec*1000 + rusage.ru_utime.tv_usec/1000;
#endif

#ifdef IBMPC
    long ltime;
    (void) time(&ltime);
    t = ltime * 1000;
#endif

#ifdef UNIX50			/* times() with 50 Hz resolution */
    struct tms buffer;
    times(&buffer);
    t = buffer.tms_utime * 20;
#endif

#ifdef UNIX60			/* times() with 60 Hz resolution */
    struct tms buffer;
    times(&buffer);
    t = buffer.tms_utime * 16.6667;
#endif

#ifdef UNIX100
    struct tms buffer;		/* times() with 100 Hz resolution */
    times(&buffer);
    t = buffer.tms_utime * 10;
#endif

#ifdef vms			/* VAX/C compiler - times() with 100 HZ clock */
    struct {int p1, p2, p3, p4;} buffer;
    static long ref_time;
    times(&buffer);
    t = buffer.p1 * 10;
    if (ref_time == 0)
      ref_time = t;
    t = t - ref_time;
#endif


    return t;
}
