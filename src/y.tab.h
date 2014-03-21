/* A Bison parser, made by GNU Bison 2.7.12-4996.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     SYSTEM_IDENTIFIER = 259,
     STRING = 260,
     TIME_LITERAL = 261,
     TYPE_IDENTIFIER = 262,
     PACKAGE_IDENTIFIER = 263,
     DISCIPLINE_IDENTIFIER = 264,
     PATHPULSE_IDENTIFIER = 265,
     BASED_NUMBER = 266,
     DEC_NUMBER = 267,
     UNBASED_NUMBER = 268,
     REALTIME = 269,
     K_PLUS_EQ = 270,
     K_MINUS_EQ = 271,
     K_INCR = 272,
     K_DECR = 273,
     K_LE = 274,
     K_GE = 275,
     K_EG = 276,
     K_EQ = 277,
     K_NE = 278,
     K_CEQ = 279,
     K_CNE = 280,
     K_LP = 281,
     K_LS = 282,
     K_RS = 283,
     K_RSS = 284,
     K_SG = 285,
     K_CONTRIBUTE = 286,
     K_PO_POS = 287,
     K_PO_NEG = 288,
     K_POW = 289,
     K_PSTAR = 290,
     K_STARP = 291,
     K_DOTSTAR = 292,
     K_LOR = 293,
     K_LAND = 294,
     K_NAND = 295,
     K_NOR = 296,
     K_NXOR = 297,
     K_TRIGGER = 298,
     K_SCOPE_RES = 299,
     K_edge_descriptor = 300,
     K_always = 301,
     K_and = 302,
     K_assign = 303,
     K_begin = 304,
     K_buf = 305,
     K_bufif0 = 306,
     K_bufif1 = 307,
     K_case = 308,
     K_casex = 309,
     K_casez = 310,
     K_cmos = 311,
     K_deassign = 312,
     K_default = 313,
     K_defparam = 314,
     K_disable = 315,
     K_edge = 316,
     K_else = 317,
     K_end = 318,
     K_endcase = 319,
     K_endfunction = 320,
     K_endmodule = 321,
     K_endprimitive = 322,
     K_endspecify = 323,
     K_endtable = 324,
     K_endtask = 325,
     K_event = 326,
     K_for = 327,
     K_force = 328,
     K_forever = 329,
     K_fork = 330,
     K_function = 331,
     K_highz0 = 332,
     K_highz1 = 333,
     K_if = 334,
     K_ifnone = 335,
     K_initial = 336,
     K_inout = 337,
     K_input = 338,
     K_integer = 339,
     K_join = 340,
     K_large = 341,
     K_macromodule = 342,
     K_medium = 343,
     K_module = 344,
     K_nand = 345,
     K_negedge = 346,
     K_nmos = 347,
     K_nor = 348,
     K_not = 349,
     K_notif0 = 350,
     K_notif1 = 351,
     K_or = 352,
     K_output = 353,
     K_parameter = 354,
     K_pmos = 355,
     K_posedge = 356,
     K_primitive = 357,
     K_pull0 = 358,
     K_pull1 = 359,
     K_pulldown = 360,
     K_pullup = 361,
     K_rcmos = 362,
     K_real = 363,
     K_realtime = 364,
     K_reg = 365,
     K_release = 366,
     K_repeat = 367,
     K_rnmos = 368,
     K_rpmos = 369,
     K_rtran = 370,
     K_rtranif0 = 371,
     K_rtranif1 = 372,
     K_scalared = 373,
     K_small = 374,
     K_specify = 375,
     K_specparam = 376,
     K_strong0 = 377,
     K_strong1 = 378,
     K_supply0 = 379,
     K_supply1 = 380,
     K_table = 381,
     K_task = 382,
     K_time = 383,
     K_tran = 384,
     K_tranif0 = 385,
     K_tranif1 = 386,
     K_tri = 387,
     K_tri0 = 388,
     K_tri1 = 389,
     K_triand = 390,
     K_trior = 391,
     K_trireg = 392,
     K_vectored = 393,
     K_wait = 394,
     K_wand = 395,
     K_weak0 = 396,
     K_weak1 = 397,
     K_while = 398,
     K_wire = 399,
     K_wor = 400,
     K_xnor = 401,
     K_xor = 402,
     K_Shold = 403,
     K_Snochange = 404,
     K_Speriod = 405,
     K_Srecovery = 406,
     K_Ssetup = 407,
     K_Ssetuphold = 408,
     K_Sskew = 409,
     K_Swidth = 410,
     KK_attribute = 411,
     K_bool = 412,
     K_logic = 413,
     K_automatic = 414,
     K_endgenerate = 415,
     K_generate = 416,
     K_genvar = 417,
     K_localparam = 418,
     K_noshowcancelled = 419,
     K_pulsestyle_onevent = 420,
     K_pulsestyle_ondetect = 421,
     K_showcancelled = 422,
     K_signed = 423,
     K_unsigned = 424,
     K_Sfullskew = 425,
     K_Srecrem = 426,
     K_Sremoval = 427,
     K_Stimeskew = 428,
     K_cell = 429,
     K_config = 430,
     K_design = 431,
     K_endconfig = 432,
     K_incdir = 433,
     K_include = 434,
     K_instance = 435,
     K_liblist = 436,
     K_library = 437,
     K_use = 438,
     K_wone = 439,
     K_uwire = 440,
     K_alias = 441,
     K_always_comb = 442,
     K_always_ff = 443,
     K_always_latch = 444,
     K_assert = 445,
     K_assume = 446,
     K_before = 447,
     K_bind = 448,
     K_bins = 449,
     K_binsof = 450,
     K_bit = 451,
     K_break = 452,
     K_byte = 453,
     K_chandle = 454,
     K_class = 455,
     K_clocking = 456,
     K_const = 457,
     K_constraint = 458,
     K_context = 459,
     K_continue = 460,
     K_cover = 461,
     K_covergroup = 462,
     K_coverpoint = 463,
     K_cross = 464,
     K_dist = 465,
     K_do = 466,
     K_endclass = 467,
     K_endclocking = 468,
     K_endgroup = 469,
     K_endinterface = 470,
     K_endpackage = 471,
     K_endprogram = 472,
     K_endproperty = 473,
     K_endsequence = 474,
     K_enum = 475,
     K_expect = 476,
     K_export = 477,
     K_extends = 478,
     K_extern = 479,
     K_final = 480,
     K_first_match = 481,
     K_foreach = 482,
     K_forkjoin = 483,
     K_iff = 484,
     K_ignore_bins = 485,
     K_illegal_bins = 486,
     K_import = 487,
     K_inside = 488,
     K_int = 489,
     K_interface = 490,
     K_intersect = 491,
     K_join_any = 492,
     K_join_none = 493,
     K_local = 494,
     K_longint = 495,
     K_matches = 496,
     K_modport = 497,
     K_new = 498,
     K_null = 499,
     K_package = 500,
     K_packed = 501,
     K_priority = 502,
     K_program = 503,
     K_property = 504,
     K_protected = 505,
     K_pure = 506,
     K_rand = 507,
     K_randc = 508,
     K_randcase = 509,
     K_randsequence = 510,
     K_ref = 511,
     K_return = 512,
     K_sequence = 513,
     K_shortint = 514,
     K_shortreal = 515,
     K_solve = 516,
     K_static = 517,
     K_string = 518,
     K_struct = 519,
     K_super = 520,
     K_tagged = 521,
     K_this = 522,
     K_throughout = 523,
     K_timeprecision = 524,
     K_timeunit = 525,
     K_type = 526,
     K_typedef = 527,
     K_union = 528,
     K_unique = 529,
     K_var = 530,
     K_virtual = 531,
     K_void = 532,
     K_wait_order = 533,
     K_wildcard = 534,
     K_with = 535,
     K_within = 536,
     K_timeprecision_check = 537,
     K_timeunit_check = 538,
     K_accept_on = 539,
     K_checker = 540,
     K_endchecker = 541,
     K_eventually = 542,
     K_global = 543,
     K_implies = 544,
     K_let = 545,
     K_nexttime = 546,
     K_reject_on = 547,
     K_restrict = 548,
     K_s_always = 549,
     K_s_eventually = 550,
     K_s_nexttime = 551,
     K_s_until = 552,
     K_s_until_with = 553,
     K_strong = 554,
     K_sync_accept_on = 555,
     K_sync_reject_on = 556,
     K_unique0 = 557,
     K_until = 558,
     K_until_with = 559,
     K_untyped = 560,
     K_weak = 561,
     K_implements = 562,
     K_interconnect = 563,
     K_nettype = 564,
     K_soft = 565,
     K_above = 566,
     K_abs = 567,
     K_absdelay = 568,
     K_abstol = 569,
     K_access = 570,
     K_acos = 571,
     K_acosh = 572,
     K_ac_stim = 573,
     K_aliasparam = 574,
     K_analog = 575,
     K_analysis = 576,
     K_asin = 577,
     K_asinh = 578,
     K_atan = 579,
     K_atan2 = 580,
     K_atanh = 581,
     K_branch = 582,
     K_ceil = 583,
     K_connect = 584,
     K_connectmodule = 585,
     K_connectrules = 586,
     K_continuous = 587,
     K_cos = 588,
     K_cosh = 589,
     K_ddt = 590,
     K_ddt_nature = 591,
     K_ddx = 592,
     K_discipline = 593,
     K_discrete = 594,
     K_domain = 595,
     K_driver_update = 596,
     K_endconnectrules = 597,
     K_enddiscipline = 598,
     K_endnature = 599,
     K_endparamset = 600,
     K_exclude = 601,
     K_exp = 602,
     K_final_step = 603,
     K_flicker_noise = 604,
     K_floor = 605,
     K_flow = 606,
     K_from = 607,
     K_ground = 608,
     K_hypot = 609,
     K_idt = 610,
     K_idtmod = 611,
     K_idt_nature = 612,
     K_inf = 613,
     K_initial_step = 614,
     K_laplace_nd = 615,
     K_laplace_np = 616,
     K_laplace_zd = 617,
     K_laplace_zp = 618,
     K_last_crossing = 619,
     K_limexp = 620,
     K_ln = 621,
     K_log = 622,
     K_max = 623,
     K_merged = 624,
     K_min = 625,
     K_nature = 626,
     K_net_resolution = 627,
     K_noise_table = 628,
     K_paramset = 629,
     K_potential = 630,
     K_pow = 631,
     K_resolveto = 632,
     K_sin = 633,
     K_sinh = 634,
     K_slew = 635,
     K_split = 636,
     K_sqrt = 637,
     K_tan = 638,
     K_tanh = 639,
     K_timer = 640,
     K_transition = 641,
     K_units = 642,
     K_white_noise = 643,
     K_wreal = 644,
     K_zi_nd = 645,
     K_zi_np = 646,
     K_zi_zd = 647,
     K_zi_zp = 648,
     K_TAND = 649,
     K_OR_EQ = 650,
     K_AND_EQ = 651,
     K_MOD_EQ = 652,
     K_DIV_EQ = 653,
     K_MUL_EQ = 654,
     K_RSS_EQ = 655,
     K_RS_EQ = 656,
     K_LS_EQ = 657,
     K_XOR_EQ = 658,
     UNARY_PREC = 659,
     less_than_K_else = 660
   };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define SYSTEM_IDENTIFIER 259
#define STRING 260
#define TIME_LITERAL 261
#define TYPE_IDENTIFIER 262
#define PACKAGE_IDENTIFIER 263
#define DISCIPLINE_IDENTIFIER 264
#define PATHPULSE_IDENTIFIER 265
#define BASED_NUMBER 266
#define DEC_NUMBER 267
#define UNBASED_NUMBER 268
#define REALTIME 269
#define K_PLUS_EQ 270
#define K_MINUS_EQ 271
#define K_INCR 272
#define K_DECR 273
#define K_LE 274
#define K_GE 275
#define K_EG 276
#define K_EQ 277
#define K_NE 278
#define K_CEQ 279
#define K_CNE 280
#define K_LP 281
#define K_LS 282
#define K_RS 283
#define K_RSS 284
#define K_SG 285
#define K_CONTRIBUTE 286
#define K_PO_POS 287
#define K_PO_NEG 288
#define K_POW 289
#define K_PSTAR 290
#define K_STARP 291
#define K_DOTSTAR 292
#define K_LOR 293
#define K_LAND 294
#define K_NAND 295
#define K_NOR 296
#define K_NXOR 297
#define K_TRIGGER 298
#define K_SCOPE_RES 299
#define K_edge_descriptor 300
#define K_always 301
#define K_and 302
#define K_assign 303
#define K_begin 304
#define K_buf 305
#define K_bufif0 306
#define K_bufif1 307
#define K_case 308
#define K_casex 309
#define K_casez 310
#define K_cmos 311
#define K_deassign 312
#define K_default 313
#define K_defparam 314
#define K_disable 315
#define K_edge 316
#define K_else 317
#define K_end 318
#define K_endcase 319
#define K_endfunction 320
#define K_endmodule 321
#define K_endprimitive 322
#define K_endspecify 323
#define K_endtable 324
#define K_endtask 325
#define K_event 326
#define K_for 327
#define K_force 328
#define K_forever 329
#define K_fork 330
#define K_function 331
#define K_highz0 332
#define K_highz1 333
#define K_if 334
#define K_ifnone 335
#define K_initial 336
#define K_inout 337
#define K_input 338
#define K_integer 339
#define K_join 340
#define K_large 341
#define K_macromodule 342
#define K_medium 343
#define K_module 344
#define K_nand 345
#define K_negedge 346
#define K_nmos 347
#define K_nor 348
#define K_not 349
#define K_notif0 350
#define K_notif1 351
#define K_or 352
#define K_output 353
#define K_parameter 354
#define K_pmos 355
#define K_posedge 356
#define K_primitive 357
#define K_pull0 358
#define K_pull1 359
#define K_pulldown 360
#define K_pullup 361
#define K_rcmos 362
#define K_real 363
#define K_realtime 364
#define K_reg 365
#define K_release 366
#define K_repeat 367
#define K_rnmos 368
#define K_rpmos 369
#define K_rtran 370
#define K_rtranif0 371
#define K_rtranif1 372
#define K_scalared 373
#define K_small 374
#define K_specify 375
#define K_specparam 376
#define K_strong0 377
#define K_strong1 378
#define K_supply0 379
#define K_supply1 380
#define K_table 381
#define K_task 382
#define K_time 383
#define K_tran 384
#define K_tranif0 385
#define K_tranif1 386
#define K_tri 387
#define K_tri0 388
#define K_tri1 389
#define K_triand 390
#define K_trior 391
#define K_trireg 392
#define K_vectored 393
#define K_wait 394
#define K_wand 395
#define K_weak0 396
#define K_weak1 397
#define K_while 398
#define K_wire 399
#define K_wor 400
#define K_xnor 401
#define K_xor 402
#define K_Shold 403
#define K_Snochange 404
#define K_Speriod 405
#define K_Srecovery 406
#define K_Ssetup 407
#define K_Ssetuphold 408
#define K_Sskew 409
#define K_Swidth 410
#define KK_attribute 411
#define K_bool 412
#define K_logic 413
#define K_automatic 414
#define K_endgenerate 415
#define K_generate 416
#define K_genvar 417
#define K_localparam 418
#define K_noshowcancelled 419
#define K_pulsestyle_onevent 420
#define K_pulsestyle_ondetect 421
#define K_showcancelled 422
#define K_signed 423
#define K_unsigned 424
#define K_Sfullskew 425
#define K_Srecrem 426
#define K_Sremoval 427
#define K_Stimeskew 428
#define K_cell 429
#define K_config 430
#define K_design 431
#define K_endconfig 432
#define K_incdir 433
#define K_include 434
#define K_instance 435
#define K_liblist 436
#define K_library 437
#define K_use 438
#define K_wone 439
#define K_uwire 440
#define K_alias 441
#define K_always_comb 442
#define K_always_ff 443
#define K_always_latch 444
#define K_assert 445
#define K_assume 446
#define K_before 447
#define K_bind 448
#define K_bins 449
#define K_binsof 450
#define K_bit 451
#define K_break 452
#define K_byte 453
#define K_chandle 454
#define K_class 455
#define K_clocking 456
#define K_const 457
#define K_constraint 458
#define K_context 459
#define K_continue 460
#define K_cover 461
#define K_covergroup 462
#define K_coverpoint 463
#define K_cross 464
#define K_dist 465
#define K_do 466
#define K_endclass 467
#define K_endclocking 468
#define K_endgroup 469
#define K_endinterface 470
#define K_endpackage 471
#define K_endprogram 472
#define K_endproperty 473
#define K_endsequence 474
#define K_enum 475
#define K_expect 476
#define K_export 477
#define K_extends 478
#define K_extern 479
#define K_final 480
#define K_first_match 481
#define K_foreach 482
#define K_forkjoin 483
#define K_iff 484
#define K_ignore_bins 485
#define K_illegal_bins 486
#define K_import 487
#define K_inside 488
#define K_int 489
#define K_interface 490
#define K_intersect 491
#define K_join_any 492
#define K_join_none 493
#define K_local 494
#define K_longint 495
#define K_matches 496
#define K_modport 497
#define K_new 498
#define K_null 499
#define K_package 500
#define K_packed 501
#define K_priority 502
#define K_program 503
#define K_property 504
#define K_protected 505
#define K_pure 506
#define K_rand 507
#define K_randc 508
#define K_randcase 509
#define K_randsequence 510
#define K_ref 511
#define K_return 512
#define K_sequence 513
#define K_shortint 514
#define K_shortreal 515
#define K_solve 516
#define K_static 517
#define K_string 518
#define K_struct 519
#define K_super 520
#define K_tagged 521
#define K_this 522
#define K_throughout 523
#define K_timeprecision 524
#define K_timeunit 525
#define K_type 526
#define K_typedef 527
#define K_union 528
#define K_unique 529
#define K_var 530
#define K_virtual 531
#define K_void 532
#define K_wait_order 533
#define K_wildcard 534
#define K_with 535
#define K_within 536
#define K_timeprecision_check 537
#define K_timeunit_check 538
#define K_accept_on 539
#define K_checker 540
#define K_endchecker 541
#define K_eventually 542
#define K_global 543
#define K_implies 544
#define K_let 545
#define K_nexttime 546
#define K_reject_on 547
#define K_restrict 548
#define K_s_always 549
#define K_s_eventually 550
#define K_s_nexttime 551
#define K_s_until 552
#define K_s_until_with 553
#define K_strong 554
#define K_sync_accept_on 555
#define K_sync_reject_on 556
#define K_unique0 557
#define K_until 558
#define K_until_with 559
#define K_untyped 560
#define K_weak 561
#define K_implements 562
#define K_interconnect 563
#define K_nettype 564
#define K_soft 565
#define K_above 566
#define K_abs 567
#define K_absdelay 568
#define K_abstol 569
#define K_access 570
#define K_acos 571
#define K_acosh 572
#define K_ac_stim 573
#define K_aliasparam 574
#define K_analog 575
#define K_analysis 576
#define K_asin 577
#define K_asinh 578
#define K_atan 579
#define K_atan2 580
#define K_atanh 581
#define K_branch 582
#define K_ceil 583
#define K_connect 584
#define K_connectmodule 585
#define K_connectrules 586
#define K_continuous 587
#define K_cos 588
#define K_cosh 589
#define K_ddt 590
#define K_ddt_nature 591
#define K_ddx 592
#define K_discipline 593
#define K_discrete 594
#define K_domain 595
#define K_driver_update 596
#define K_endconnectrules 597
#define K_enddiscipline 598
#define K_endnature 599
#define K_endparamset 600
#define K_exclude 601
#define K_exp 602
#define K_final_step 603
#define K_flicker_noise 604
#define K_floor 605
#define K_flow 606
#define K_from 607
#define K_ground 608
#define K_hypot 609
#define K_idt 610
#define K_idtmod 611
#define K_idt_nature 612
#define K_inf 613
#define K_initial_step 614
#define K_laplace_nd 615
#define K_laplace_np 616
#define K_laplace_zd 617
#define K_laplace_zp 618
#define K_last_crossing 619
#define K_limexp 620
#define K_ln 621
#define K_log 622
#define K_max 623
#define K_merged 624
#define K_min 625
#define K_nature 626
#define K_net_resolution 627
#define K_noise_table 628
#define K_paramset 629
#define K_potential 630
#define K_pow 631
#define K_resolveto 632
#define K_sin 633
#define K_sinh 634
#define K_slew 635
#define K_split 636
#define K_sqrt 637
#define K_tan 638
#define K_tanh 639
#define K_timer 640
#define K_transition 641
#define K_units 642
#define K_white_noise 643
#define K_wreal 644
#define K_zi_nd 645
#define K_zi_np 646
#define K_zi_zd 647
#define K_zi_zp 648
#define K_TAND 649
#define K_OR_EQ 650
#define K_AND_EQ 651
#define K_MOD_EQ 652
#define K_DIV_EQ 653
#define K_MUL_EQ 654
#define K_RSS_EQ 655
#define K_RS_EQ 656
#define K_LS_EQ 657
#define K_XOR_EQ 658
#define UNARY_PREC 659
#define less_than_K_else 660



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
