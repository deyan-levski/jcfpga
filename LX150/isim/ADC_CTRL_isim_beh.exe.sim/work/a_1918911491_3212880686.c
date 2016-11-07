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
static const char *ng0 = "/media/data/git/jcfpga/LX150/hdl/BASIC_UART.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_2763492388968962707_503743352(char *, char *, unsigned int , unsigned int );
char *ieee_p_3620187407_sub_2255506239096166994_3965413181(char *, char *, char *, char *, int );
char *ieee_p_3620187407_sub_2255506239096238868_3965413181(char *, char *, char *, char *, int );
unsigned char ieee_p_3620187407_sub_970019341842465249_3965413181(char *, char *, char *, int );


static void work_a_1918911491_3212880686_p_0(char *t0)
{
    char t12[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    int t11;
    unsigned int t13;
    unsigned int t14;
    char *t15;

LAB0:    xsi_set_current_line(65, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 992U);
    t3 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 6224);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(66, ng0);
    t1 = xsi_get_transient_memory(12U);
    memset(t1, 0, 12U);
    t5 = t1;
    memset(t5, (unsigned char)2, 12U);
    t6 = (t0 + 6384);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 12U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(67, ng0);
    t1 = (t0 + 6448);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

LAB5:    xsi_set_current_line(69, ng0);
    t2 = (t0 + 3272U);
    t5 = *((char **)t2);
    t2 = (t0 + 11112U);
    t11 = (2604 - 1);
    t4 = ieee_p_3620187407_sub_970019341842465249_3965413181(IEEE_P_3620187407, t5, t2, t11);
    if (t4 != 0)
        goto LAB7;

LAB9:    xsi_set_current_line(73, ng0);
    t1 = (t0 + 6448);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(74, ng0);
    t1 = (t0 + 3272U);
    t2 = *((char **)t1);
    t1 = (t0 + 11112U);
    t5 = ieee_p_3620187407_sub_2255506239096166994_3965413181(IEEE_P_3620187407, t12, t2, t1, 1);
    t6 = (t12 + 12U);
    t13 = *((unsigned int *)t6);
    t14 = (1U * t13);
    t3 = (12U != t14);
    if (t3 == 1)
        goto LAB10;

LAB11:    t7 = (t0 + 6384);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t15 = *((char **)t10);
    memcpy(t15, t5, 12U);
    xsi_driver_first_trans_fast(t7);

LAB8:    goto LAB3;

LAB7:    xsi_set_current_line(70, ng0);
    t6 = (t0 + 6448);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(71, ng0);
    t1 = xsi_get_transient_memory(12U);
    memset(t1, 0, 12U);
    t2 = t1;
    memset(t2, (unsigned char)2, 12U);
    t5 = (t0 + 6384);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 12U);
    xsi_driver_first_trans_fast(t5);
    goto LAB8;

LAB10:    xsi_size_not_matching(12U, t14, 0);
    goto LAB11;

}

static void work_a_1918911491_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    xsi_set_current_line(82, ng0);
    t1 = (t0 + 1192U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 992U);
    t3 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 6240);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(83, ng0);
    t1 = (t0 + 6512);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    xsi_set_current_line(84, ng0);
    t1 = xsi_get_transient_memory(8U);
    memset(t1, 0, 8U);
    t2 = t1;
    memset(t2, (unsigned char)2, 8U);
    t5 = (t0 + 6512);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 8U);
    xsi_driver_first_trans_delta(t5, 5U, 8U, 0LL);
    xsi_set_current_line(85, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6512);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 4U);
    xsi_driver_first_trans_delta(t5, 13U, 4U, 0LL);
    xsi_set_current_line(86, ng0);
    t1 = (t0 + 6512);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 17U, 1, 0LL);
    xsi_set_current_line(87, ng0);
    t1 = (t0 + 6576);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)0;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    xsi_set_current_line(88, ng0);
    t1 = xsi_get_transient_memory(9U);
    memset(t1, 0, 9U);
    t2 = t1;
    memset(t2, (unsigned char)3, 9U);
    t5 = (t0 + 6576);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 9U);
    xsi_driver_first_trans_delta(t5, 5U, 9U, 0LL);
    xsi_set_current_line(89, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6576);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 4U);
    xsi_driver_first_trans_delta(t5, 14U, 4U, 0LL);
    xsi_set_current_line(90, ng0);
    t1 = (t0 + 6576);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)3;
    xsi_driver_first_trans_delta(t1, 18U, 1, 0LL);
    goto LAB3;

LAB5:    xsi_set_current_line(92, ng0);
    t2 = (t0 + 2632U);
    t5 = *((char **)t2);
    t2 = (t0 + 6512);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t5, 24U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(93, ng0);
    t1 = (t0 + 2952U);
    t2 = *((char **)t1);
    t1 = (t0 + 6576);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 24U);
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

}

static void work_a_1918911491_3212880686_p_2(char *t0)
{
    char t27[16];
    char t28[16];
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    unsigned int t15;
    char *t16;
    char *t17;
    char *t18;
    unsigned char t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    unsigned int t25;
    unsigned int t26;
    int t29;
    unsigned int t30;
    static char *nl0[] = {&&LAB3, &&LAB4};

LAB0:    xsi_set_current_line(100, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (0 + 0U);
    t1 = (t2 + t3);
    t4 = *((unsigned char *)t1);
    t5 = (char *)((nl0) + t4);
    goto **((char **)t5);

LAB2:    t1 = (t0 + 6256);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(103, ng0);
    t6 = xsi_get_transient_memory(4U);
    memset(t6, 0, 4U);
    t7 = t6;
    memset(t7, (unsigned char)2, 4U);
    t8 = (t0 + 6640);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t6, 4U);
    xsi_driver_first_trans_delta(t8, 1U, 4U, 0LL);
    xsi_set_current_line(104, ng0);
    t1 = xsi_get_transient_memory(8U);
    memset(t1, 0, 8U);
    t2 = t1;
    memset(t2, (unsigned char)2, 8U);
    t5 = (t0 + 6640);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 8U);
    xsi_driver_first_trans_delta(t5, 5U, 8U, 0LL);
    xsi_set_current_line(105, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6640);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 4U);
    xsi_driver_first_trans_delta(t5, 13U, 4U, 0LL);
    xsi_set_current_line(106, ng0);
    t1 = (t0 + 6640);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 17U, 1, 0LL);
    xsi_set_current_line(107, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t13 = (t4 == (unsigned char)2);
    if (t13 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(112, ng0);
    t1 = (t0 + 6640);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)0;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);

LAB6:    goto LAB2;

LAB4:    xsi_set_current_line(116, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 6640);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 24U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(117, ng0);
    t1 = (t0 + 3112U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t13 = (t4 == (unsigned char)3);
    if (t13 != 0)
        goto LAB8;

LAB10:
LAB9:    goto LAB2;

LAB5:    xsi_set_current_line(109, ng0);
    t1 = (t0 + 6640);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)1;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    goto LAB6;

LAB8:    xsi_set_current_line(118, ng0);
    t1 = (t0 + 2472U);
    t5 = *((char **)t1);
    t3 = (0 + 1U);
    t1 = (t5 + t3);
    t6 = (t0 + 8056);
    t7 = xsi_record_get_element_type(t6, 1);
    t8 = (t7 + 72U);
    t9 = *((char **)t8);
    t14 = ieee_p_3620187407_sub_970019341842465249_3965413181(IEEE_P_3620187407, t1, t9, 8);
    if (t14 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(128, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (0 + 1U);
    t1 = (t2 + t3);
    t5 = (t0 + 8056);
    t6 = xsi_record_get_element_type(t5, 1);
    t7 = (t6 + 72U);
    t8 = *((char **)t7);
    t9 = ieee_p_3620187407_sub_2255506239096166994_3965413181(IEEE_P_3620187407, t27, t1, t8, 1);
    t10 = (t27 + 12U);
    t15 = *((unsigned int *)t10);
    t25 = (1U * t15);
    t4 = (4U != t25);
    if (t4 == 1)
        goto LAB21;

LAB22:    t11 = (t0 + 6640);
    t12 = (t11 + 56U);
    t16 = *((char **)t12);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t9, 4U);
    xsi_driver_first_trans_delta(t11, 1U, 4U, 0LL);
    goto LAB9;

LAB11:    xsi_set_current_line(120, ng0);
    t10 = (t0 + 2472U);
    t11 = *((char **)t10);
    t15 = (0 + 13U);
    t10 = (t11 + t15);
    t12 = (t0 + 8056);
    t16 = xsi_record_get_element_type(t12, 3);
    t17 = (t16 + 72U);
    t18 = *((char **)t17);
    t19 = ieee_p_3620187407_sub_970019341842465249_3965413181(IEEE_P_3620187407, t10, t18, 9);
    if (t19 != 0)
        goto LAB14;

LAB16:    xsi_set_current_line(124, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t1 = (t0 + 2472U);
    t5 = *((char **)t1);
    t3 = (7 - 7);
    t15 = (t3 * 1U);
    t25 = (0 + 5U);
    t26 = (t25 + t15);
    t1 = (t5 + t26);
    t7 = ((IEEE_P_2592010699) + 4000);
    t8 = (t28 + 0U);
    t9 = (t8 + 0U);
    *((int *)t9) = 7;
    t9 = (t8 + 4U);
    *((int *)t9) = 1;
    t9 = (t8 + 8U);
    *((int *)t9) = -1;
    t29 = (1 - 7);
    t30 = (t29 * -1);
    t30 = (t30 + 1);
    t9 = (t8 + 12U);
    *((unsigned int *)t9) = t30;
    t6 = xsi_base_array_concat(t6, t27, t7, (char)99, t4, (char)97, t1, t28, (char)101);
    t30 = (1U + 7U);
    t13 = (8U != t30);
    if (t13 == 1)
        goto LAB17;

LAB18:    t9 = (t0 + 6640);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t16 = *((char **)t12);
    memcpy(t16, t6, 8U);
    xsi_driver_first_trans_delta(t9, 5U, 8U, 0LL);
    xsi_set_current_line(125, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (0 + 13U);
    t1 = (t2 + t3);
    t5 = (t0 + 8056);
    t6 = xsi_record_get_element_type(t5, 3);
    t7 = (t6 + 72U);
    t8 = *((char **)t7);
    t9 = ieee_p_3620187407_sub_2255506239096166994_3965413181(IEEE_P_3620187407, t27, t1, t8, 1);
    t10 = (t27 + 12U);
    t15 = *((unsigned int *)t10);
    t25 = (1U * t15);
    t4 = (4U != t25);
    if (t4 == 1)
        goto LAB19;

LAB20:    t11 = (t0 + 6640);
    t12 = (t11 + 56U);
    t16 = *((char **)t12);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t9, 4U);
    xsi_driver_first_trans_delta(t11, 13U, 4U, 0LL);

LAB15:    goto LAB12;

LAB14:    xsi_set_current_line(121, ng0);
    t20 = (t0 + 6640);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)0;
    xsi_driver_first_trans_delta(t20, 0U, 1, 0LL);
    xsi_set_current_line(122, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t1 = (t0 + 6640);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_delta(t1, 17U, 1, 0LL);
    goto LAB15;

LAB17:    xsi_size_not_matching(8U, t30, 0);
    goto LAB18;

LAB19:    xsi_size_not_matching(4U, t25, 0);
    goto LAB20;

LAB21:    xsi_size_not_matching(4U, t25, 0);
    goto LAB22;

}

static void work_a_1918911491_3212880686_p_3(char *t0)
{
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    xsi_set_current_line(137, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (0 + 17U);
    t1 = (t2 + t3);
    t4 = *((unsigned char *)t1);
    t5 = (t0 + 6704);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t4;
    xsi_driver_first_trans_fast_port(t5);
    xsi_set_current_line(138, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (0 + 5U);
    t1 = (t2 + t3);
    t5 = (t0 + 6768);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 8U);
    xsi_driver_first_trans_fast_port(t5);
    t1 = (t0 + 6272);
    *((int *)t1) = 1;

LAB1:    return;
}

static void work_a_1918911491_3212880686_p_4(char *t0)
{
    char t11[16];
    char t21[16];
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned char t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    int t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    static char *nl0[] = {&&LAB3, &&LAB4};

LAB0:    xsi_set_current_line(144, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t3 = (0 + 0U);
    t1 = (t2 + t3);
    t4 = *((unsigned char *)t1);
    t5 = (char *)((nl0) + t4);
    goto **((char **)t5);

LAB2:    t1 = (t0 + 6288);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(147, ng0);
    t6 = (t0 + 1832U);
    t7 = *((char **)t6);
    t8 = *((unsigned char *)t7);
    t9 = (t8 == (unsigned char)3);
    if (t9 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(156, ng0);
    t1 = xsi_get_transient_memory(9U);
    memset(t1, 0, 9U);
    t2 = t1;
    memset(t2, (unsigned char)3, 9U);
    t5 = (t0 + 6832);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t1, 9U);
    xsi_driver_first_trans_delta(t5, 5U, 9U, 0LL);
    xsi_set_current_line(157, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6832);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t1, 4U);
    xsi_driver_first_trans_delta(t5, 14U, 4U, 0LL);
    xsi_set_current_line(158, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6832);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t1, 4U);
    xsi_driver_first_trans_delta(t5, 1U, 4U, 0LL);
    xsi_set_current_line(159, ng0);
    t1 = (t0 + 6832);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)0;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    xsi_set_current_line(160, ng0);
    t1 = (t0 + 6832);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)3;
    xsi_driver_first_trans_delta(t1, 18U, 1, 0LL);

LAB6:    goto LAB2;

LAB4:    xsi_set_current_line(164, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t1 = (t0 + 6832);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t10 = *((char **)t7);
    memcpy(t10, t2, 24U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(165, ng0);
    t1 = (t0 + 3112U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t8 = (t4 == (unsigned char)3);
    if (t8 != 0)
        goto LAB12;

LAB14:
LAB13:    goto LAB2;

LAB5:    xsi_set_current_line(149, ng0);
    t6 = (t0 + 1672U);
    t10 = *((char **)t6);
    t12 = ((IEEE_P_2592010699) + 4000);
    t13 = (t0 + 11000U);
    t6 = xsi_base_array_concat(t6, t11, t12, (char)97, t10, t13, (char)99, (unsigned char)2, (char)101);
    t14 = (8U + 1U);
    t15 = (9U != t14);
    if (t15 == 1)
        goto LAB8;

LAB9:    t16 = (t0 + 6832);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t6, 9U);
    xsi_driver_first_trans_delta(t16, 5U, 9U, 0LL);
    xsi_set_current_line(150, ng0);
    t1 = (t0 + 11269);
    t5 = (t21 + 0U);
    t6 = (t5 + 0U);
    *((int *)t6) = 0;
    t6 = (t5 + 4U);
    *((int *)t6) = 3;
    t6 = (t5 + 8U);
    *((int *)t6) = 1;
    t22 = (3 - 0);
    t3 = (t22 * 1);
    t3 = (t3 + 1);
    t6 = (t5 + 12U);
    *((unsigned int *)t6) = t3;
    t6 = ieee_p_3620187407_sub_2255506239096166994_3965413181(IEEE_P_3620187407, t11, t1, t21, 10);
    t7 = (t11 + 12U);
    t3 = *((unsigned int *)t7);
    t14 = (1U * t3);
    t4 = (4U != t14);
    if (t4 == 1)
        goto LAB10;

LAB11:    t10 = (t0 + 6832);
    t12 = (t10 + 56U);
    t13 = *((char **)t12);
    t16 = (t13 + 56U);
    t17 = *((char **)t16);
    memcpy(t17, t6, 4U);
    xsi_driver_first_trans_delta(t10, 14U, 4U, 0LL);
    xsi_set_current_line(151, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6832);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t1, 4U);
    xsi_driver_first_trans_delta(t5, 1U, 4U, 0LL);
    xsi_set_current_line(152, ng0);
    t1 = (t0 + 6832);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)1;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    xsi_set_current_line(153, ng0);
    t1 = (t0 + 6832);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_delta(t1, 18U, 1, 0LL);
    goto LAB6;

LAB8:    xsi_size_not_matching(9U, t14, 0);
    goto LAB9;

LAB10:    xsi_size_not_matching(4U, t14, 0);
    goto LAB11;

LAB12:    xsi_set_current_line(166, ng0);
    t1 = (t0 + 2792U);
    t5 = *((char **)t1);
    t3 = (0 + 1U);
    t1 = (t5 + t3);
    t6 = (t0 + 8168);
    t7 = xsi_record_get_element_type(t6, 1);
    t10 = (t7 + 72U);
    t12 = *((char **)t10);
    t9 = ieee_p_3620187407_sub_970019341842465249_3965413181(IEEE_P_3620187407, t1, t12, 15);
    if (t9 != 0)
        goto LAB15;

LAB17:
LAB16:    xsi_set_current_line(180, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t3 = (0 + 1U);
    t1 = (t2 + t3);
    t5 = (t0 + 8168);
    t6 = xsi_record_get_element_type(t5, 1);
    t7 = (t6 + 72U);
    t10 = *((char **)t7);
    t12 = ieee_p_3620187407_sub_2255506239096166994_3965413181(IEEE_P_3620187407, t11, t1, t10, 1);
    t13 = (t11 + 12U);
    t14 = *((unsigned int *)t13);
    t30 = (1U * t14);
    t4 = (4U != t30);
    if (t4 == 1)
        goto LAB25;

LAB26:    t16 = (t0 + 6832);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t12, 4U);
    xsi_driver_first_trans_delta(t16, 1U, 4U, 0LL);
    goto LAB13;

LAB15:    xsi_set_current_line(168, ng0);
    t13 = (t0 + 2792U);
    t16 = *((char **)t13);
    t14 = (0 + 14U);
    t13 = (t16 + t14);
    t17 = (t0 + 8168);
    t18 = xsi_record_get_element_type(t17, 3);
    t19 = (t18 + 72U);
    t20 = *((char **)t19);
    t15 = ieee_p_3620187407_sub_970019341842465249_3965413181(IEEE_P_3620187407, t13, t20, 0);
    if (t15 != 0)
        goto LAB18;

LAB20:    xsi_set_current_line(176, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t3 = (8 - 8);
    t14 = (t3 * 1U);
    t30 = (0 + 5U);
    t31 = (t30 + t14);
    t1 = (t2 + t31);
    t6 = ((IEEE_P_2592010699) + 4000);
    t7 = (t21 + 0U);
    t10 = (t7 + 0U);
    *((int *)t10) = 8;
    t10 = (t7 + 4U);
    *((int *)t10) = 1;
    t10 = (t7 + 8U);
    *((int *)t10) = -1;
    t22 = (1 - 8);
    t32 = (t22 * -1);
    t32 = (t32 + 1);
    t10 = (t7 + 12U);
    *((unsigned int *)t10) = t32;
    t5 = xsi_base_array_concat(t5, t11, t6, (char)99, (unsigned char)3, (char)97, t1, t21, (char)101);
    t32 = (1U + 8U);
    t4 = (9U != t32);
    if (t4 == 1)
        goto LAB21;

LAB22:    t10 = (t0 + 6832);
    t12 = (t10 + 56U);
    t13 = *((char **)t12);
    t16 = (t13 + 56U);
    t17 = *((char **)t16);
    memcpy(t17, t5, 9U);
    xsi_driver_first_trans_delta(t10, 5U, 9U, 0LL);
    xsi_set_current_line(177, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t3 = (0 + 14U);
    t1 = (t2 + t3);
    t5 = (t0 + 8168);
    t6 = xsi_record_get_element_type(t5, 3);
    t7 = (t6 + 72U);
    t10 = *((char **)t7);
    t12 = ieee_p_3620187407_sub_2255506239096238868_3965413181(IEEE_P_3620187407, t11, t1, t10, 1);
    t13 = (t11 + 12U);
    t14 = *((unsigned int *)t13);
    t30 = (1U * t14);
    t4 = (4U != t30);
    if (t4 == 1)
        goto LAB23;

LAB24:    t16 = (t0 + 6832);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    memcpy(t20, t12, 4U);
    xsi_driver_first_trans_delta(t16, 14U, 4U, 0LL);

LAB19:    goto LAB16;

LAB18:    xsi_set_current_line(170, ng0);
    t23 = xsi_get_transient_memory(9U);
    memset(t23, 0, 9U);
    t24 = t23;
    memset(t24, (unsigned char)3, 9U);
    t25 = (t0 + 6832);
    t26 = (t25 + 56U);
    t27 = *((char **)t26);
    t28 = (t27 + 56U);
    t29 = *((char **)t28);
    memcpy(t29, t23, 9U);
    xsi_driver_first_trans_delta(t25, 5U, 9U, 0LL);
    xsi_set_current_line(171, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6832);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t1, 4U);
    xsi_driver_first_trans_delta(t5, 14U, 4U, 0LL);
    xsi_set_current_line(172, ng0);
    t1 = xsi_get_transient_memory(4U);
    memset(t1, 0, 4U);
    t2 = t1;
    memset(t2, (unsigned char)2, 4U);
    t5 = (t0 + 6832);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t10 = (t7 + 56U);
    t12 = *((char **)t10);
    memcpy(t12, t1, 4U);
    xsi_driver_first_trans_delta(t5, 1U, 4U, 0LL);
    xsi_set_current_line(173, ng0);
    t1 = (t0 + 6832);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)0;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    xsi_set_current_line(174, ng0);
    t1 = (t0 + 6832);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)3;
    xsi_driver_first_trans_delta(t1, 18U, 1, 0LL);
    goto LAB19;

LAB21:    xsi_size_not_matching(9U, t32, 0);
    goto LAB22;

LAB23:    xsi_size_not_matching(4U, t30, 0);
    goto LAB24;

LAB25:    xsi_size_not_matching(4U, t30, 0);
    goto LAB26;

}

static void work_a_1918911491_3212880686_p_5(char *t0)
{
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;

LAB0:    xsi_set_current_line(189, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t3 = (0 + 18U);
    t1 = (t2 + t3);
    t4 = *((unsigned char *)t1);
    t5 = (t0 + 6896);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t4;
    xsi_driver_first_trans_fast_port(t5);
    xsi_set_current_line(190, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t10 = (0 - 8);
    t3 = (t10 * -1);
    t11 = (1U * t3);
    t12 = (0 + 5U);
    t13 = (t12 + t11);
    t1 = (t2 + t13);
    t4 = *((unsigned char *)t1);
    t5 = (t0 + 6960);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t4;
    xsi_driver_first_trans_fast_port(t5);
    t1 = (t0 + 6304);
    *((int *)t1) = 1;

LAB1:    return;
}


extern void work_a_1918911491_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1918911491_3212880686_p_0,(void *)work_a_1918911491_3212880686_p_1,(void *)work_a_1918911491_3212880686_p_2,(void *)work_a_1918911491_3212880686_p_3,(void *)work_a_1918911491_3212880686_p_4,(void *)work_a_1918911491_3212880686_p_5};
	xsi_register_didat("work_a_1918911491_3212880686", "isim/ADC_CTRL_isim_beh.exe.sim/work/a_1918911491_3212880686.didat");
	xsi_register_executes(pe);
}
