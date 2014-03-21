#ifndef ARRAY_H
#define ARRAY_H


typedef struct array_struct array_t;
struct array_struct {
    char *space;
    int num;		/* number of array elements */
    int n_size;		/* size of 'data' array (in objects) */
    int obj_size;	/* size of each array object */
};


EXTERN array_t *array_do_alloc ARGS((int size, int number));
EXTERN array_t *array_dup ARGS((array_t* old));
EXTERN array_t *array_join ARGS((array_t* array1, array_t* array2));
EXTERN void array_free ARGS((array_t* array));
EXTERN void array_append ARGS((array_t* array1, array_t* array2));
EXTERN void array_sort ARGS((array_t* array, int (*compare)()));
EXTERN void array_uniq ARGS((array_t* array, int (*compare)(), void (*free_func)()));
EXTERN int array_abort ARGS((int i));
EXTERN int array_resize ARGS((array_t* array, int new_size));
EXTERN char *array_do_data ARGS((array_t* array));

extern int array_i;


#define array_alloc(type, number)		\
    array_do_alloc(sizeof(type), number)

#define array_insert(type, a, i, datum)		\
    (array_i = (i),				\
      array_i < 0 ? array_abort(0) : 0,		\
      sizeof(type) != (a)->obj_size ? array_abort(1) : 0,\
      array_i >= (a)->n_size ? array_resize(a, array_i + 1) : 0,\
      array_i >= (a)->num ? (a)->num = array_i + 1 : 0,\
      *((type *) ((a)->space + array_i * (a)->obj_size)) = datum)

#define array_fetch(type, a, i)			\
    (array_i = (i),				\
      (array_i < 0 || array_i >= (a)->num) ? array_abort(0) : 0,\
      *((type *) ((a)->space + array_i * (a)->obj_size)))

#define array_insert_last(type, array, datum)	\
    array_insert(type, array, (array)->num, datum)

#define array_fetch_last(type, array)		\
    array_fetch(type, array, ((array)->num)-1)

#define array_n(array)				\
    (array)->num

#define array_data(type, array)			\
    (type *) array_do_data(array)

#endif
