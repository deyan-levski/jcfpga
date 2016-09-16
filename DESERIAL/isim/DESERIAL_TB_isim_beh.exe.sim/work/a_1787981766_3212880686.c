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
static const char *ng0 = "/media/design/fpga/projects/DESERIAL/DESERIAL.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_374109322130769762_503743352(char *, unsigned char );


static void work_a_1787981766_3212880686_p_0(char *t0)
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
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    int t17;
    int t18;

LAB0:    xsi_set_current_line(43, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    xsi_set_current_line(70, ng0);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB20;

LAB21:    t1 = (unsigned char)0;

LAB22:    if (t1 != 0)
        goto LAB17;

LAB19:
LAB18:    t2 = (t0 + 4152);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(45, ng0);
    t4 = (t0 + 1192U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(51, ng0);
    t2 = (t0 + 1352U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 4376);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t1;
    xsi_driver_first_trans_delta(t2, 5U, 1, 0LL);
    xsi_set_current_line(52, ng0);
    t2 = (t0 + 1992U);
    t4 = *((char **)t2);
    t14 = (5 - 4);
    t15 = (t14 * 1U);
    t16 = (0 + t15);
    t2 = (t4 + t16);
    t5 = (t0 + 4376);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 5U);
    xsi_driver_first_trans_delta(t5, 0U, 5U, 0LL);
    xsi_set_current_line(53, ng0);
    t2 = (t0 + 1512U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 4440);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t1;
    xsi_driver_first_trans_delta(t2, 5U, 1, 0LL);
    xsi_set_current_line(54, ng0);
    t2 = (t0 + 2152U);
    t4 = *((char **)t2);
    t14 = (5 - 4);
    t15 = (t14 * 1U);
    t16 = (0 + t15);
    t2 = (t4 + t16);
    t5 = (t0 + 4440);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 5U);
    xsi_driver_first_trans_delta(t5, 0U, 5U, 0LL);
    xsi_set_current_line(56, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t17 = *((int *)t4);
    t1 = (t17 == 6);
    if (t1 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t17 = *((int *)t4);
    t1 = (t17 == 3);
    if (t1 != 0)
        goto LAB14;

LAB16:
LAB15:    xsi_set_current_line(67, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t17 = *((int *)t4);
    t18 = (t17 + 1);
    t2 = (t0 + 2608U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t18;
    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(46, ng0);
    t4 = (t0 + 2608U);
    t11 = *((char **)t4);
    t4 = (t11 + 0);
    *((int *)t4) = 4;
    xsi_set_current_line(47, ng0);
    t2 = xsi_get_transient_memory(12U);
    memset(t2, 0, 12U);
    t4 = t2;
    memset(t4, (unsigned char)2, 12U);
    t5 = (t0 + 4248);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 12U);
    xsi_driver_first_trans_delta(t5, 0U, 12U, 0LL);
    xsi_set_current_line(48, ng0);
    t2 = (t0 + 4312);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    goto LAB9;

LAB11:    xsi_set_current_line(57, ng0);
    t2 = (t0 + 1992U);
    t5 = *((char **)t2);
    t2 = (t0 + 4248);
    t8 = (t2 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t5, 6U);
    xsi_driver_first_trans_delta(t2, 0U, 6U, 0LL);
    xsi_set_current_line(58, ng0);
    t2 = (t0 + 2152U);
    t4 = *((char **)t2);
    t2 = (t0 + 4248);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 6U);
    xsi_driver_first_trans_delta(t2, 6U, 6U, 0LL);
    xsi_set_current_line(59, ng0);
    t2 = (t0 + 2312U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t1);
    t2 = (t0 + 4312);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(60, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB12;

LAB14:    xsi_set_current_line(64, ng0);
    t2 = (t0 + 2312U);
    t5 = *((char **)t2);
    t3 = *((unsigned char *)t5);
    t6 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t3);
    t2 = (t0 + 4312);
    t8 = (t2 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t6;
    xsi_driver_first_trans_fast(t2);
    goto LAB15;

LAB17:    xsi_set_current_line(72, ng0);
    t4 = (t0 + 1192U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB23;

LAB25:
LAB24:    xsi_set_current_line(78, ng0);
    t2 = (t0 + 1352U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 4376);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t1;
    xsi_driver_first_trans_delta(t2, 5U, 1, 0LL);
    xsi_set_current_line(79, ng0);
    t2 = (t0 + 1992U);
    t4 = *((char **)t2);
    t14 = (5 - 4);
    t15 = (t14 * 1U);
    t16 = (0 + t15);
    t2 = (t4 + t16);
    t5 = (t0 + 4376);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 5U);
    xsi_driver_first_trans_delta(t5, 0U, 5U, 0LL);
    xsi_set_current_line(80, ng0);
    t2 = (t0 + 1512U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 4440);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t1;
    xsi_driver_first_trans_delta(t2, 5U, 1, 0LL);
    xsi_set_current_line(81, ng0);
    t2 = (t0 + 2152U);
    t4 = *((char **)t2);
    t14 = (5 - 4);
    t15 = (t14 * 1U);
    t16 = (0 + t15);
    t2 = (t4 + t16);
    t5 = (t0 + 4440);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 5U);
    xsi_driver_first_trans_delta(t5, 0U, 5U, 0LL);
    xsi_set_current_line(83, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t17 = *((int *)t4);
    t1 = (t17 == 6);
    if (t1 != 0)
        goto LAB26;

LAB28:
LAB27:    xsi_set_current_line(90, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t17 = *((int *)t4);
    t1 = (t17 == 3);
    if (t1 != 0)
        goto LAB29;

LAB31:
LAB30:    xsi_set_current_line(94, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t17 = *((int *)t4);
    t18 = (t17 + 1);
    t2 = (t0 + 2608U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t18;
    goto LAB18;

LAB20:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)2);
    t1 = t7;
    goto LAB22;

LAB23:    xsi_set_current_line(73, ng0);
    t4 = (t0 + 2608U);
    t11 = *((char **)t4);
    t4 = (t11 + 0);
    *((int *)t4) = 4;
    xsi_set_current_line(74, ng0);
    t2 = xsi_get_transient_memory(12U);
    memset(t2, 0, 12U);
    t4 = t2;
    memset(t4, (unsigned char)2, 12U);
    t5 = (t0 + 4248);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 12U);
    xsi_driver_first_trans_delta(t5, 0U, 12U, 0LL);
    xsi_set_current_line(75, ng0);
    t2 = (t0 + 4312);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    goto LAB24;

LAB26:    xsi_set_current_line(84, ng0);
    t2 = (t0 + 1992U);
    t5 = *((char **)t2);
    t2 = (t0 + 4248);
    t8 = (t2 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t5, 6U);
    xsi_driver_first_trans_delta(t2, 0U, 6U, 0LL);
    xsi_set_current_line(85, ng0);
    t2 = (t0 + 2152U);
    t4 = *((char **)t2);
    t2 = (t0 + 4248);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 6U);
    xsi_driver_first_trans_delta(t2, 6U, 6U, 0LL);
    xsi_set_current_line(86, ng0);
    t2 = (t0 + 2312U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t1);
    t2 = (t0 + 4312);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(87, ng0);
    t2 = (t0 + 2608U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB27;

LAB29:    xsi_set_current_line(91, ng0);
    t2 = (t0 + 2312U);
    t5 = *((char **)t2);
    t3 = *((unsigned char *)t5);
    t6 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t3);
    t2 = (t0 + 4312);
    t8 = (t2 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t6;
    xsi_driver_first_trans_fast(t2);
    goto LAB30;

}

static void work_a_1787981766_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(99, ng0);

LAB3:    t1 = (t0 + 2312U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 4504);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4168);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1787981766_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1787981766_3212880686_p_0,(void *)work_a_1787981766_3212880686_p_1};
	xsi_register_didat("work_a_1787981766_3212880686", "isim/DESERIAL_TB_isim_beh.exe.sim/work/a_1787981766_3212880686.didat");
	xsi_register_executes(pe);
}
