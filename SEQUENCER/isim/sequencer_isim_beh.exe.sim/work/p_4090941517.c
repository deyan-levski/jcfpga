/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif



void work_p_4090941517_sub_2524682579582893620_3023356647(char *t0, char *t1, char *t2, int t3, int t4, int t5, char *t6)
{
    char t8[32];
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned char t14;
    int t15;
    unsigned char t16;
    int t17;
    unsigned char t18;
    char *t19;

LAB0:    t9 = (t8 + 4U);
    *((char **)t9) = t2;
    t10 = (t8 + 12U);
    *((int *)t10) = t3;
    t11 = (t8 + 16U);
    *((int *)t11) = t4;
    t12 = (t8 + 20U);
    *((int *)t12) = t5;
    t13 = (t8 + 24U);
    *((char **)t13) = t6;
    t15 = *((int *)t6);
    t16 = (t15 >= t3);
    if (t16 == 1)
        goto LAB5;

LAB6:    t14 = (unsigned char)0;

LAB7:    if (t14 != 0)
        goto LAB2;

LAB4:    t19 = (t2 + 0);
    *((unsigned char *)t19) = (unsigned char)2;

LAB3:    t15 = *((int *)t6);
    t14 = (t15 == t5);
    if (t14 != 0)
        goto LAB8;

LAB10:
LAB9:    t15 = *((int *)t6);
    t17 = (t15 + 1);
    t19 = (t6 + 0);
    *((int *)t19) = t17;

LAB1:    return;
LAB2:    t19 = (t2 + 0);
    *((unsigned char *)t19) = (unsigned char)3;
    goto LAB3;

LAB5:    t17 = *((int *)t6);
    t18 = (t17 <= t4);
    t14 = t18;
    goto LAB7;

LAB8:    t19 = (t6 + 0);
    *((int *)t19) = 0;
    goto LAB9;

}

void work_p_4090941517_sub_17524214358953597906_3023356647(char *t0, char *t1, char *t2, int t3, int t4, int t5, int t6, int t7, char *t8)
{
    char t10[40];
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned char t18;
    unsigned char t19;
    int t20;
    unsigned char t21;
    int t22;
    unsigned char t23;
    unsigned char t24;
    int t25;
    unsigned char t26;
    int t27;
    unsigned char t28;
    char *t29;

LAB0:    t11 = (t10 + 4U);
    *((char **)t11) = t2;
    t12 = (t10 + 12U);
    *((int *)t12) = t3;
    t13 = (t10 + 16U);
    *((int *)t13) = t4;
    t14 = (t10 + 20U);
    *((int *)t14) = t5;
    t15 = (t10 + 24U);
    *((int *)t15) = t6;
    t16 = (t10 + 28U);
    *((int *)t16) = t7;
    t17 = (t10 + 32U);
    *((char **)t17) = t8;
    t20 = *((int *)t8);
    t21 = (t20 >= t3);
    if (t21 == 1)
        goto LAB8;

LAB9:    t19 = (unsigned char)0;

LAB10:    if (t19 == 1)
        goto LAB5;

LAB6:    t25 = *((int *)t8);
    t26 = (t25 >= t6);
    if (t26 == 1)
        goto LAB11;

LAB12:    t24 = (unsigned char)0;

LAB13:    t18 = t24;

LAB7:    if (t18 != 0)
        goto LAB2;

LAB4:    t29 = (t2 + 0);
    *((unsigned char *)t29) = (unsigned char)2;

LAB3:    t20 = *((int *)t8);
    t18 = (t20 == t5);
    if (t18 != 0)
        goto LAB14;

LAB16:
LAB15:    t20 = *((int *)t8);
    t22 = (t20 + 1);
    t29 = (t8 + 0);
    *((int *)t29) = t22;

LAB1:    return;
LAB2:    t29 = (t2 + 0);
    *((unsigned char *)t29) = (unsigned char)3;
    goto LAB3;

LAB5:    t18 = (unsigned char)1;
    goto LAB7;

LAB8:    t22 = *((int *)t8);
    t23 = (t22 <= t4);
    t19 = t23;
    goto LAB10;

LAB11:    t27 = *((int *)t8);
    t28 = (t27 <= t7);
    t24 = t28;
    goto LAB13;

LAB14:    t29 = (t8 + 0);
    *((int *)t29) = 0;
    goto LAB15;

}


extern void work_p_4090941517_init()
{
	static char *se[] = {(void *)work_p_4090941517_sub_2524682579582893620_3023356647,(void *)work_p_4090941517_sub_17524214358953597906_3023356647};
	xsi_register_didat("work_p_4090941517", "isim/sequencer_isim_beh.exe.sim/work/p_4090941517.didat");
	xsi_register_subprogram_executes(se);
}
