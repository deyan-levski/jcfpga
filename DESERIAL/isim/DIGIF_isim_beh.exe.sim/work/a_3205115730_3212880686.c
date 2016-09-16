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
static const char *ng0 = "/media/design/fpga/projects/DESERIAL/DIGIF.vhd";



static void work_a_3205115730_3212880686_p_0(char *t0)
{
    char *t1;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(43, ng0);

LAB3:    t1 = (t0 + 8026);
    t3 = (t0 + 4968);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t1, 6U);
    xsi_driver_first_trans_fast(t3);

LAB2:
LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3205115730_3212880686_p_1(char *t0)
{
    char *t1;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(44, ng0);

LAB3:    t1 = (t0 + 8032);
    t3 = (t0 + 5032);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t1, 12U);
    xsi_driver_first_trans_fast(t3);

LAB2:
LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3205115730_3212880686_p_2(char *t0)
{
    char *t1;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(45, ng0);

LAB3:    t1 = (t0 + 8044);
    t3 = (t0 + 5096);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t1, 12U);
    xsi_driver_first_trans_fast(t3);

LAB2:
LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3205115730_3212880686_p_3(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    int t20;

LAB0:    xsi_set_current_line(56, ng0);
    t1 = (t0 + 992U);
    t2 = xsi_signal_has_event(t1);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4888);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(58, ng0);
    t3 = (t0 + 1192U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:
LAB6:    xsi_set_current_line(67, ng0);
    t1 = (t0 + 1192U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t5 = (t2 == (unsigned char)2);
    if (t5 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(75, ng0);
    t1 = (t0 + 2608U);
    t3 = *((char **)t1);
    t16 = *((int *)t3);
    t2 = (t16 == 6);
    if (t2 != 0)
        goto LAB11;

LAB13:    t1 = (t0 + 2608U);
    t3 = *((char **)t1);
    t16 = *((int *)t3);
    t2 = (t16 == 12);
    if (t2 != 0)
        goto LAB14;

LAB15:
LAB12:    xsi_set_current_line(84, ng0);
    t1 = (t0 + 2728U);
    t3 = *((char **)t1);
    t16 = *((int *)t3);
    t2 = (t16 == 6);
    if (t2 != 0)
        goto LAB16;

LAB18:
LAB17:    xsi_set_current_line(89, ng0);
    t1 = (t0 + 2728U);
    t3 = *((char **)t1);
    t16 = *((int *)t3);
    t20 = (t16 + 1);
    t1 = (t0 + 2728U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t20;
    goto LAB3;

LAB5:    xsi_set_current_line(59, ng0);
    t3 = (t0 + 1832U);
    t7 = *((char **)t3);
    t8 = (11 - 11);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t3 = (t7 + t10);
    t11 = (t0 + 5160);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t3, 6U);
    xsi_driver_first_trans_fast(t11);
    xsi_set_current_line(60, ng0);
    t1 = (t0 + 1832U);
    t3 = *((char **)t1);
    t8 = (11 - 5);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t4 = (t0 + 5224);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 6U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(61, ng0);
    t1 = (t0 + 2848U);
    t3 = *((char **)t1);
    t16 = (5 - 5);
    t8 = (t16 * -1);
    t9 = (1U * t8);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t2 = *((unsigned char *)t1);
    t4 = (t0 + 5288);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t2;
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(62, ng0);
    t1 = (t0 + 2848U);
    t3 = *((char **)t1);
    t16 = (5 - 5);
    t8 = (t16 * -1);
    t9 = (1U * t8);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t2 = *((unsigned char *)t1);
    t4 = (t0 + 5352);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t2;
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(63, ng0);
    t1 = (t0 + 2848U);
    t3 = *((char **)t1);
    t8 = (5 - 4);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t4 = xsi_get_transient_memory(5U);
    memcpy(t4, t1, 5U);
    t7 = (t0 + 2848U);
    t11 = *((char **)t7);
    t17 = (5 - 5);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t7 = (t11 + t19);
    memcpy(t7, t4, 5U);
    xsi_set_current_line(64, ng0);
    t1 = (t0 + 2608U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB6;

LAB8:    xsi_set_current_line(68, ng0);
    t1 = (t0 + 2152U);
    t4 = *((char **)t1);
    t16 = (5 - 5);
    t8 = (t16 * -1);
    t9 = (1U * t8);
    t10 = (0 + t9);
    t1 = (t4 + t10);
    t6 = *((unsigned char *)t1);
    t7 = (t0 + 5288);
    t11 = (t7 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = t6;
    xsi_driver_first_trans_fast_port(t7);
    xsi_set_current_line(69, ng0);
    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t16 = (5 - 5);
    t8 = (t16 * -1);
    t9 = (1U * t8);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t2 = *((unsigned char *)t1);
    t4 = (t0 + 5352);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t2;
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(70, ng0);
    t1 = (t0 + 2152U);
    t3 = *((char **)t1);
    t8 = (5 - 4);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t4 = (t0 + 5160);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 5U);
    xsi_driver_first_trans_delta(t4, 0U, 5U, 0LL);
    xsi_set_current_line(71, ng0);
    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t8 = (5 - 4);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t4 = (t0 + 5224);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 5U);
    xsi_driver_first_trans_delta(t4, 0U, 5U, 0LL);
    xsi_set_current_line(72, ng0);
    t1 = (t0 + 2608U);
    t3 = *((char **)t1);
    t16 = *((int *)t3);
    t20 = (t16 + 1);
    t1 = (t0 + 2608U);
    t4 = *((char **)t1);
    t1 = (t4 + 0);
    *((int *)t1) = t20;
    goto LAB9;

LAB11:    xsi_set_current_line(76, ng0);
    t1 = (t0 + 1992U);
    t4 = *((char **)t1);
    t8 = (11 - 11);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t4 + t10);
    t7 = (t0 + 5160);
    t11 = (t7 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t1, 6U);
    xsi_driver_first_trans_fast(t7);
    xsi_set_current_line(77, ng0);
    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t8 = (11 - 5);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t4 = (t0 + 5224);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 6U);
    xsi_driver_first_trans_fast(t4);
    goto LAB12;

LAB14:    xsi_set_current_line(79, ng0);
    t1 = (t0 + 1832U);
    t4 = *((char **)t1);
    t8 = (11 - 11);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t4 + t10);
    t7 = (t0 + 5160);
    t11 = (t7 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t1, 6U);
    xsi_driver_first_trans_fast(t7);
    xsi_set_current_line(80, ng0);
    t1 = (t0 + 1832U);
    t3 = *((char **)t1);
    t8 = (11 - 5);
    t9 = (t8 * 1U);
    t10 = (0 + t9);
    t1 = (t3 + t10);
    t4 = (t0 + 5224);
    t7 = (t4 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 6U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(81, ng0);
    t1 = (t0 + 2608U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB12;

LAB16:    xsi_set_current_line(85, ng0);
    t1 = (t0 + 1672U);
    t4 = *((char **)t1);
    t1 = (t0 + 2848U);
    t7 = *((char **)t1);
    t1 = (t7 + 0);
    memcpy(t1, t4, 6U);
    xsi_set_current_line(86, ng0);
    t1 = (t0 + 2728U);
    t3 = *((char **)t1);
    t1 = (t3 + 0);
    *((int *)t1) = 0;
    goto LAB17;

}


extern void work_a_3205115730_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3205115730_3212880686_p_0,(void *)work_a_3205115730_3212880686_p_1,(void *)work_a_3205115730_3212880686_p_2,(void *)work_a_3205115730_3212880686_p_3};
	xsi_register_didat("work_a_3205115730_3212880686", "isim/DIGIF_isim_beh.exe.sim/work/a_3205115730_3212880686.didat");
	xsi_register_executes(pe);
}
