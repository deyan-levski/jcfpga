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
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_3488546069778340532_503743352(char *, unsigned char , unsigned char );


static void work_a_3050171595_3212880686_p_0(char *t0)
{
    char *t1;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(49, ng0);

LAB3:    t1 = (t0 + 9036);
    t3 = (t0 + 5736);
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

static void work_a_3050171595_3212880686_p_1(char *t0)
{
    char *t1;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(50, ng0);

LAB3:    t1 = (t0 + 9042);
    t3 = (t0 + 5800);
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

static void work_a_3050171595_3212880686_p_2(char *t0)
{
    char *t1;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(51, ng0);

LAB3:    t1 = (t0 + 9054);
    t3 = (t0 + 5864);
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

static void work_a_3050171595_3212880686_p_3(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t17;
    int t18;
    int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;

LAB0:    xsi_set_current_line(62, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 5624);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(64, ng0);
    t4 = (t0 + 1192U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t12 = (5 - 4);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = xsi_get_transient_memory(5U);
    memcpy(t5, t2, 5U);
    t8 = (t0 + 2608U);
    t11 = *((char **)t8);
    t20 = (5 - 5);
    t21 = (t20 * 1U);
    t22 = (0 + t21);
    t8 = (t11 + t22);
    memcpy(t8, t5, 5U);
    t15 = (t0 + 2552U);
    xsi_variable_act(t15);
    xsi_set_current_line(81, ng0);
    t2 = (t0 + 2728U);
    t4 = *((char **)t2);
    t12 = (5 - 4);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = xsi_get_transient_memory(5U);
    memcpy(t5, t2, 5U);
    t8 = (t0 + 2728U);
    t11 = *((char **)t8);
    t20 = (5 - 5);
    t21 = (t20 * 1U);
    t22 = (0 + t21);
    t8 = (t11 + t22);
    memcpy(t8, t5, 5U);
    t15 = (t0 + 2672U);
    xsi_variable_act(t15);
    xsi_set_current_line(82, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t19 = (t18 + 1);
    t2 = (t0 + 2848U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t19;
    t8 = (t0 + 2792U);
    xsi_variable_act(t8);
    xsi_set_current_line(84, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t1 = (t18 == 6);
    if (t1 != 0)
        goto LAB14;

LAB16:    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t1 = (t18 == 12);
    if (t1 != 0)
        goto LAB17;

LAB18:
LAB15:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(65, ng0);
    t4 = (t0 + 1832U);
    t11 = *((char **)t4);
    t12 = (11 - 11);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t4 = (t11 + t14);
    t15 = (t0 + 2608U);
    t16 = *((char **)t15);
    t15 = (t16 + 0);
    memcpy(t15, t4, 6U);
    t17 = (t0 + 2552U);
    xsi_variable_act(t17);
    xsi_set_current_line(66, ng0);
    t2 = (t0 + 1832U);
    t4 = *((char **)t2);
    t12 = (11 - 5);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = (t0 + 2728U);
    t8 = *((char **)t5);
    t5 = (t8 + 0);
    memcpy(t5, t2, 6U);
    t11 = (t0 + 2672U);
    xsi_variable_act(t11);
    xsi_set_current_line(68, ng0);
    t2 = (t0 + 2968U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t19 = (t18 + 1);
    t2 = (t0 + 2968U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t19;
    t8 = (t0 + 2912U);
    xsi_variable_act(t8);
    xsi_set_current_line(69, ng0);
    t2 = (t0 + 3088U);
    t4 = *((char **)t2);
    t18 = (5 - 5);
    t12 = (t18 * -1);
    t13 = (1U * t12);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t1 = *((unsigned char *)t2);
    t5 = (t0 + 5928);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t15 = (t11 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = t1;
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(71, ng0);
    t2 = (t0 + 3088U);
    t4 = *((char **)t2);
    t12 = (5 - 4);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = xsi_get_transient_memory(5U);
    memcpy(t5, t2, 5U);
    t8 = (t0 + 3088U);
    t11 = *((char **)t8);
    t20 = (5 - 5);
    t21 = (t20 * 1U);
    t22 = (0 + t21);
    t8 = (t11 + t22);
    memcpy(t8, t5, 5U);
    t15 = (t0 + 3032U);
    xsi_variable_act(t15);
    xsi_set_current_line(72, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    t5 = (t0 + 2792U);
    xsi_variable_act(t5);
    xsi_set_current_line(74, ng0);
    t2 = (t0 + 2968U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t1 = (t18 == 6);
    if (t1 != 0)
        goto LAB11;

LAB13:
LAB12:    goto LAB9;

LAB11:    xsi_set_current_line(75, ng0);
    t2 = (t0 + 1672U);
    t5 = *((char **)t2);
    t2 = (t0 + 3088U);
    t8 = *((char **)t2);
    t2 = (t8 + 0);
    memcpy(t2, t5, 6U);
    t11 = (t0 + 3032U);
    xsi_variable_act(t11);
    xsi_set_current_line(76, ng0);
    t2 = (t0 + 2968U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    t5 = (t0 + 2912U);
    xsi_variable_act(t5);
    goto LAB12;

LAB14:    xsi_set_current_line(85, ng0);
    t2 = (t0 + 1992U);
    t5 = *((char **)t2);
    t12 = (11 - 11);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t5 + t14);
    t8 = (t0 + 2608U);
    t11 = *((char **)t8);
    t8 = (t11 + 0);
    memcpy(t8, t2, 6U);
    t15 = (t0 + 2552U);
    xsi_variable_act(t15);
    xsi_set_current_line(86, ng0);
    t2 = (t0 + 1992U);
    t4 = *((char **)t2);
    t12 = (11 - 5);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = (t0 + 2728U);
    t8 = *((char **)t5);
    t5 = (t8 + 0);
    memcpy(t5, t2, 6U);
    t11 = (t0 + 2672U);
    xsi_variable_act(t11);
    goto LAB15;

LAB17:    xsi_set_current_line(88, ng0);
    t2 = (t0 + 1832U);
    t5 = *((char **)t2);
    t12 = (11 - 11);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t5 + t14);
    t8 = (t0 + 2608U);
    t11 = *((char **)t8);
    t8 = (t11 + 0);
    memcpy(t8, t2, 6U);
    t15 = (t0 + 2552U);
    xsi_variable_act(t15);
    xsi_set_current_line(89, ng0);
    t2 = (t0 + 1832U);
    t4 = *((char **)t2);
    t12 = (11 - 5);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = (t0 + 2728U);
    t8 = *((char **)t5);
    t5 = (t8 + 0);
    memcpy(t5, t2, 6U);
    t11 = (t0 + 2672U);
    xsi_variable_act(t11);
    xsi_set_current_line(90, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    t5 = (t0 + 2792U);
    xsi_variable_act(t5);
    goto LAB15;

}

static void work_a_3050171595_3212880686_p_4(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    unsigned char t6;
    char *t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;

LAB0:    xsi_set_current_line(104, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t14 = (t0 + 2608U);
    t15 = *((char **)t14);
    t16 = (5 - 5);
    t17 = (t16 * -1);
    t18 = (1U * t17);
    t19 = (0 + t18);
    t14 = (t15 + t19);
    t20 = *((unsigned char *)t14);
    t21 = (t0 + 5992);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    *((unsigned char *)t25) = t20;
    xsi_driver_first_trans_fast_port(t21);

LAB2:    t26 = (t0 + 5640);
    *((int *)t26) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 2152U);
    t5 = *((char **)t1);
    t6 = *((unsigned char *)t5);
    t1 = (t0 + 2312U);
    t7 = *((char **)t1);
    t8 = *((unsigned char *)t7);
    t9 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t6, t8);
    t1 = (t0 + 5992);
    t10 = (t1 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t9;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_3050171595_3212880686_p_5(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t17;
    int t18;
    int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;

LAB0:    xsi_set_current_line(110, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 5656);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(112, ng0);
    t4 = (t0 + 1192U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t12 = (5 - 4);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = xsi_get_transient_memory(5U);
    memcpy(t5, t2, 5U);
    t8 = (t0 + 2608U);
    t11 = *((char **)t8);
    t20 = (5 - 5);
    t21 = (t20 * 1U);
    t22 = (0 + t21);
    t8 = (t11 + t22);
    memcpy(t8, t5, 5U);
    t15 = (t0 + 2552U);
    xsi_variable_act(t15);
    xsi_set_current_line(129, ng0);
    t2 = (t0 + 2728U);
    t4 = *((char **)t2);
    t12 = (5 - 4);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = xsi_get_transient_memory(5U);
    memcpy(t5, t2, 5U);
    t8 = (t0 + 2728U);
    t11 = *((char **)t8);
    t20 = (5 - 5);
    t21 = (t20 * 1U);
    t22 = (0 + t21);
    t8 = (t11 + t22);
    memcpy(t8, t5, 5U);
    t15 = (t0 + 2672U);
    xsi_variable_act(t15);
    xsi_set_current_line(130, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t19 = (t18 + 1);
    t2 = (t0 + 2848U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t19;
    t8 = (t0 + 2792U);
    xsi_variable_act(t8);
    xsi_set_current_line(132, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t1 = (t18 == 6);
    if (t1 != 0)
        goto LAB14;

LAB16:    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t1 = (t18 == 12);
    if (t1 != 0)
        goto LAB17;

LAB18:
LAB15:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)2);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(113, ng0);
    t4 = (t0 + 1832U);
    t11 = *((char **)t4);
    t12 = (11 - 11);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t4 = (t11 + t14);
    t15 = (t0 + 2608U);
    t16 = *((char **)t15);
    t15 = (t16 + 0);
    memcpy(t15, t4, 6U);
    t17 = (t0 + 2552U);
    xsi_variable_act(t17);
    xsi_set_current_line(114, ng0);
    t2 = (t0 + 1832U);
    t4 = *((char **)t2);
    t12 = (11 - 5);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = (t0 + 2728U);
    t8 = *((char **)t5);
    t5 = (t8 + 0);
    memcpy(t5, t2, 6U);
    t11 = (t0 + 2672U);
    xsi_variable_act(t11);
    xsi_set_current_line(116, ng0);
    t2 = (t0 + 3088U);
    t4 = *((char **)t2);
    t18 = (5 - 5);
    t12 = (t18 * -1);
    t13 = (1U * t12);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t1 = *((unsigned char *)t2);
    t5 = (t0 + 6056);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t15 = (t11 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = t1;
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(117, ng0);
    t2 = (t0 + 2968U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t19 = (t18 + 1);
    t2 = (t0 + 2968U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t19;
    t8 = (t0 + 2912U);
    xsi_variable_act(t8);
    xsi_set_current_line(119, ng0);
    t2 = (t0 + 3088U);
    t4 = *((char **)t2);
    t12 = (5 - 4);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = xsi_get_transient_memory(5U);
    memcpy(t5, t2, 5U);
    t8 = (t0 + 3088U);
    t11 = *((char **)t8);
    t20 = (5 - 5);
    t21 = (t20 * 1U);
    t22 = (0 + t21);
    t8 = (t11 + t22);
    memcpy(t8, t5, 5U);
    t15 = (t0 + 3032U);
    xsi_variable_act(t15);
    xsi_set_current_line(120, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    t5 = (t0 + 2792U);
    xsi_variable_act(t5);
    xsi_set_current_line(122, ng0);
    t2 = (t0 + 2968U);
    t4 = *((char **)t2);
    t18 = *((int *)t4);
    t1 = (t18 == 6);
    if (t1 != 0)
        goto LAB11;

LAB13:
LAB12:    goto LAB9;

LAB11:    xsi_set_current_line(123, ng0);
    t2 = (t0 + 1672U);
    t5 = *((char **)t2);
    t2 = (t0 + 3088U);
    t8 = *((char **)t2);
    t2 = (t8 + 0);
    memcpy(t2, t5, 6U);
    t11 = (t0 + 3032U);
    xsi_variable_act(t11);
    xsi_set_current_line(124, ng0);
    t2 = (t0 + 2968U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    t5 = (t0 + 2912U);
    xsi_variable_act(t5);
    goto LAB12;

LAB14:    xsi_set_current_line(133, ng0);
    t2 = (t0 + 1992U);
    t5 = *((char **)t2);
    t12 = (11 - 11);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t5 + t14);
    t8 = (t0 + 2608U);
    t11 = *((char **)t8);
    t8 = (t11 + 0);
    memcpy(t8, t2, 6U);
    t15 = (t0 + 2552U);
    xsi_variable_act(t15);
    xsi_set_current_line(134, ng0);
    t2 = (t0 + 1992U);
    t4 = *((char **)t2);
    t12 = (11 - 5);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = (t0 + 2728U);
    t8 = *((char **)t5);
    t5 = (t8 + 0);
    memcpy(t5, t2, 6U);
    t11 = (t0 + 2672U);
    xsi_variable_act(t11);
    goto LAB15;

LAB17:    xsi_set_current_line(136, ng0);
    t2 = (t0 + 1832U);
    t5 = *((char **)t2);
    t12 = (11 - 11);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t5 + t14);
    t8 = (t0 + 2608U);
    t11 = *((char **)t8);
    t8 = (t11 + 0);
    memcpy(t8, t2, 6U);
    t15 = (t0 + 2552U);
    xsi_variable_act(t15);
    xsi_set_current_line(137, ng0);
    t2 = (t0 + 1832U);
    t4 = *((char **)t2);
    t12 = (11 - 5);
    t13 = (t12 * 1U);
    t14 = (0 + t13);
    t2 = (t4 + t14);
    t5 = (t0 + 2728U);
    t8 = *((char **)t5);
    t5 = (t8 + 0);
    memcpy(t5, t2, 6U);
    t11 = (t0 + 2672U);
    xsi_variable_act(t11);
    xsi_set_current_line(138, ng0);
    t2 = (t0 + 2848U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    t5 = (t0 + 2792U);
    xsi_variable_act(t5);
    goto LAB15;

}


extern void work_a_3050171595_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3050171595_3212880686_p_0,(void *)work_a_3050171595_3212880686_p_1,(void *)work_a_3050171595_3212880686_p_2,(void *)work_a_3050171595_3212880686_p_3,(void *)work_a_3050171595_3212880686_p_4,(void *)work_a_3050171595_3212880686_p_5};
	xsi_register_didat("work_a_3050171595_3212880686", "isim/DESERIAL_TB_isim_beh.exe.sim/work/a_3050171595_3212880686.didat");
	xsi_register_executes(pe);
}
