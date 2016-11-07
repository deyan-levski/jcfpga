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
static const char *ng0 = "/media/data/git/jcfpga/LX150/hdl/SREG_CONTROL.vhd";
extern char *IEEE_P_3620187407;



static void work_a_1079860337_3212880686_p_0(char *t0)
{
    char t22[16];
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
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    int t20;
    int t21;
    char *t23;
    char *t24;

LAB0:    xsi_set_current_line(152, ng0);
    t2 = (t0 + 1312U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 7064);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(155, ng0);
    t4 = (t0 + 1512U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    t2 = (t0 + 4192U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB13;

LAB14:    t1 = (unsigned char)0;

LAB15:    if (t1 != 0)
        goto LAB11;

LAB12:
LAB9:    xsi_set_current_line(169, ng0);
    t2 = (t0 + 4528U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t1 = (t20 == 17);
    if (t1 != 0)
        goto LAB16;

LAB18:
LAB17:    xsi_set_current_line(174, ng0);
    t2 = (t0 + 4072U);
    t4 = *((char **)t2);
    t2 = (t0 + 11432U);
    t5 = (t0 + 11764);
    t11 = (t22 + 0U);
    t12 = (t11 + 0U);
    *((int *)t12) = 0;
    t12 = (t11 + 4U);
    *((int *)t12) = 7;
    t12 = (t11 + 8U);
    *((int *)t12) = 1;
    t20 = (7 - 0);
    t17 = (t20 * 1);
    t17 = (t17 + 1);
    t12 = (t11 + 12U);
    *((unsigned int *)t12) = t17;
    t1 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t4, t2, t5, t22);
    if (t1 != 0)
        goto LAB19;

LAB21:
LAB20:    goto LAB3;

LAB5:    t4 = (t0 + 1352U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(156, ng0);
    t4 = xsi_get_transient_memory(136U);
    memset(t4, 0, 136U);
    t11 = t4;
    memset(t11, (unsigned char)2, 136U);
    t12 = (t0 + 7224);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 136U);
    xsi_driver_first_trans_fast(t12);
    xsi_set_current_line(157, ng0);
    t2 = (t0 + 7288);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(158, ng0);
    t2 = (t0 + 7352);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(159, ng0);
    t2 = (t0 + 4528U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB9;

LAB11:    xsi_set_current_line(163, ng0);
    t4 = (t0 + 2952U);
    t8 = *((char **)t4);
    t17 = (135 - 135);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t4 = (t8 + t19);
    t11 = (t0 + 7224);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t4, 128U);
    xsi_driver_first_trans_delta(t11, 8U, 128U, 0LL);
    xsi_set_current_line(164, ng0);
    t2 = (t0 + 4072U);
    t4 = *((char **)t2);
    t17 = (7 - 7);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t2 = (t4 + t19);
    t5 = (t0 + 7224);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 8U);
    xsi_driver_first_trans_delta(t5, 0U, 8U, 0LL);
    xsi_set_current_line(166, ng0);
    t2 = (t0 + 4528U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t21 = (t20 + 1);
    t2 = (t0 + 4528U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t21;
    goto LAB9;

LAB13:    t4 = (t0 + 4232U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB15;

LAB16:    xsi_set_current_line(170, ng0);
    t2 = (t0 + 7288);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(171, ng0);
    t2 = (t0 + 7352);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    goto LAB17;

LAB19:    xsi_set_current_line(175, ng0);
    t12 = xsi_get_transient_memory(136U);
    memset(t12, 0, 136U);
    t13 = t12;
    memset(t13, (unsigned char)2, 136U);
    t14 = (t0 + 7224);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t23 = (t16 + 56U);
    t24 = *((char **)t23);
    memcpy(t24, t12, 136U);
    xsi_driver_first_trans_fast(t14);
    xsi_set_current_line(176, ng0);
    t2 = (t0 + 7288);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(177, ng0);
    t2 = (t0 + 7352);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(178, ng0);
    t2 = (t0 + 4528U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB20;

}

static void work_a_1079860337_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    unsigned int t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    xsi_set_current_line(184, ng0);

LAB3:    t1 = (t0 + 2952U);
    t2 = *((char **)t1);
    t3 = (135 - 95);
    t4 = (t3 * 1U);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t6 = (t0 + 7416);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 96U);
    xsi_driver_first_trans_fast(t6);

LAB2:    t11 = (t0 + 7080);
    *((int *)t11) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1079860337_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    unsigned int t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    xsi_set_current_line(185, ng0);

LAB3:    t1 = (t0 + 2952U);
    t2 = *((char **)t1);
    t3 = (135 - 127);
    t4 = (t3 * 1U);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t6 = (t0 + 7480);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 32U);
    xsi_driver_first_trans_fast(t6);

LAB2:    t11 = (t0 + 7096);
    *((int *)t11) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1079860337_3212880686_p_3(char *t0)
{
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    unsigned int t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    xsi_set_current_line(186, ng0);

LAB3:    t1 = (t0 + 2952U);
    t2 = *((char **)t1);
    t3 = (135 - 135);
    t4 = (t3 * 1U);
    t5 = (0 + t4);
    t1 = (t2 + t5);
    t6 = (t0 + 7544);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 8U);
    xsi_driver_first_trans_fast(t6);

LAB2:    t11 = (t0 + 7112);
    *((int *)t11) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1079860337_3212880686_p_4(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(188, ng0);

LAB3:    t1 = (t0 + 3912U);
    t2 = *((char **)t1);
    t3 = (0 - 7);
    t4 = (t3 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = *((unsigned char *)t1);
    t8 = (t0 + 7608);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t7;
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 7128);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1079860337_3212880686_p_5(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(191, ng0);

LAB3:    t1 = (t0 + 3112U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 7672);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 7144);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1079860337_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1079860337_3212880686_p_0,(void *)work_a_1079860337_3212880686_p_1,(void *)work_a_1079860337_3212880686_p_2,(void *)work_a_1079860337_3212880686_p_3,(void *)work_a_1079860337_3212880686_p_4,(void *)work_a_1079860337_3212880686_p_5};
	xsi_register_didat("work_a_1079860337_3212880686", "isim/ADC_CTRL_isim_beh.exe.sim/work/a_1079860337_3212880686.didat");
	xsi_register_executes(pe);
}
