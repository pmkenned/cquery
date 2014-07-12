/*
 * Revision Control Information
 *
 * $Source: /vol/opua/opua2/sis/sis-1.1/common/src/sis/list/RCS/list.h,v $
 * $Author: sis $
 * $Revision: 1.2 $
 * $Date: 1992/05/06 18:55:32 $
 *
 */
/*
 * List Management Package Header File
 *
 * David Harrison
 * University of California, 1985
 *
 * This file contains public type definitions for the List Managment
 * package implemented in list.c.  This is stand alone package.
 */

#ifndef LS_DEFINED
#define LS_DEFINED

/* This can be typedef'ed to void if supported */
typedef struct ls_dummy_defn {
    int dummy;			/* Not used */
} ls_dummy;

typedef ls_dummy *lsList;	/* List handle           */
typedef ls_dummy *lsGen;	/* List generator handle */
typedef ls_dummy *lsHandle;	/* Handle to an item     */
typedef int lsStatus;		/* Return codes          */
typedef char *lsGeneric;	/* Generic pointer       */

#define	LS_NIL		0	/* Nil for lsList       */

#define LS_BADSTATE	-3	/* Bad generator state   */
#define LS_BADPARAM	-2	/* Bad parameter value   */
#define LS_NOMORE	-1	/* No more items         */

#define	LS_OK		0

#define LS_BEFORE	1	/* Set spot before object */
#define LS_AFTER	2	/* Set spot after object  */
#define LS_STOP		3	/* Stop generating items  */
#define LS_DELETE	4	/* Delete generated item  */

/*
 * For all those routines that take a handle,  this macro can be
 * used when no handle is required.
 */

#define LS_NH		(lsHandle *) 0

typedef lsGeneric (*LS_PFLSG)();

EXTERN lsList lsCreate ARGS((void));
  /* Create a new list */
EXTERN lsStatus lsDestroy ARGS((lsList list, void (*delFunc)()));
  /* Delete a previously created list */
EXTERN lsList lsCopy ARGS((lsList list, LS_PFLSG copyFunc));
   /* Copies the contents of a list    */

EXTERN lsStatus lsFirstItem ARGS((lsList list, lsGeneric *data, lsHandle *itemHandle));
  /* Gets the first item of a list */
EXTERN lsStatus lsLastItem ARGS((lsList list, lsGeneric *data, lsHandle *itemHandle));
  /* Gets the last item of a list */

EXTERN lsStatus lsNewBegin ARGS((lsList list, lsGeneric data, lsHandle *itemHandle));
  /* Add item to start of list */
EXTERN lsStatus lsNewEnd ARGS((lsList list, lsGeneric data, lsHandle *itemHandle));
  /* Add item to end of list */

EXTERN lsStatus lsDelBegin ARGS((lsList list, lsGeneric *data));
  /* Delete first item of a list */
EXTERN lsStatus lsDelEnd ARGS((lsList list, lsGeneric *data));
  /* Delete last item of a list */

EXTERN int lsLength ARGS((lsList list));
  /* Returns the length of the list */

EXTERN lsGen lsStart ARGS((lsList list));
  /* Begin generation of items in a list */
EXTERN lsGen lsEnd ARGS((lsList list));
  /* Begin generation at end of list */
EXTERN lsGen lsGenHandle ARGS((lsHandle itemHandle, lsGeneric *data, int option));
  /* Produces a generator given a handle */
EXTERN lsStatus lsNext ARGS((lsGen generator, lsGeneric *data, lsHandle *itemhandle));
  /* Generate next item in sequence */
EXTERN lsStatus lsPrev ARGS((lsGen generator, lsGeneric *data, lsHandle *itemHandle));
  /* Generate previous item in sequence */
EXTERN lsStatus lsInBefore ARGS((lsGen generator, lsGeneric data, 
   lsHandle *itemhandle));
  /* Insert an item before the most recently generated by lsNext */
EXTERN lsStatus lsInAfter ARGS((lsGen generator, lsGeneric data, 
   lsHandle *itemhandle));
  /* Insert an item after the most recently generated by lsNext  */
EXTERN lsStatus lsDelBefore ARGS((lsGen generator, lsGeneric *data));
  /* Delete the item before the current spot */
EXTERN lsStatus lsDelAfter ARGS((lsGen generator, lsGeneric *data));
  /* Delete the item after the current spot */
EXTERN lsStatus lsFinish ARGS((lsGen generator));
  /* End generation of items in a list */

EXTERN lsList lsQueryHandle ARGS((lsHandle itemHandle));
  /* Returns the list of a handle */
EXTERN lsGeneric lsFetchHandle ARGS((lsHandle itemHandle));
  /* Returns data associated with handle */
EXTERN lsStatus lsRemoveItem ARGS((lsHandle itemHandle, lsGeneric *userData));
  /* Removes item associated with handle from list */

EXTERN lsStatus lsSort ARGS((lsList list, int (*compare)()));

  /* Sorts a list */
EXTERN lsStatus lsUniq ARGS((lsList list, int (*compare)(), void (*delFunc)() ));
  /* Removes duplicates from a sorted list */

#endif