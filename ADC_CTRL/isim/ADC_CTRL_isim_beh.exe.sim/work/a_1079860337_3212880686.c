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
static const char *ng0 = "/media/design/fpga/projects/ADC_CTRL/SREG_CONTROL.vhd";
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

LAB0:    xsi_set_current_line(112, ng0);
    t2 = (t0 + 1312U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    xsi_set_current_line(141, ng0);
    t2 = (t0 + 2312U);
    t4 = *((char **)t2);
    t2 = (t0 + 5016);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t4, 96U);
    xsi_driver_first_trans_fast(t2);
    t2 = (t0 + 4792);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(115, ng0);
    t4 = (t0 + 1512U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    t2 = (t0 + 2912U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB13;

LAB14:    t1 = (unsigned char)0;

LAB15:    if (t1 != 0)
        goto LAB11;

LAB12:
LAB9:    xsi_set_current_line(128, ng0);
    t2 = (t0 + 3248U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t1 = (t20 == 12);
    if (t1 != 0)
        goto LAB16;

LAB18:
LAB17:    xsi_set_current_line(132, ng0);
    t2 = (t0 + 2792U);
    t4 = *((char **)t2);
    t2 = (t0 + 7952U);
    t5 = (t0 + 8204);
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

LAB8:    xsi_set_current_line(116, ng0);
    t4 = xsi_get_transient_memory(96U);
    memset(t4, 0, 96U);
    t11 = t4;
    memset(t11, (unsigned char)2, 96U);
    t12 = (t0 + 4888);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 96U);
    xsi_driver_first_trans_fast(t12);
    xsi_set_current_line(117, ng0);
    t2 = (t0 + 4952);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(118, ng0);
    t2 = (t0 + 3248U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB9;

LAB11:    xsi_set_current_line(122, ng0);
    t4 = (t0 + 2312U);
    t8 = *((char **)t4);
    t17 = (95 - 95);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t4 = (t8 + t19);
    t11 = (t0 + 4888);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t4, 88U);
    xsi_driver_first_trans_delta(t11, 8U, 88U, 0LL);
    xsi_set_current_line(123, ng0);
    t2 = (t0 + 2792U);
    t4 = *((char **)t2);
    t17 = (7 - 7);
    t18 = (t17 * 1U);
    t19 = (0 + t18);
    t2 = (t4 + t19);
    t5 = (t0 + 4888);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 8U);
    xsi_driver_first_trans_delta(t5, 0U, 8U, 0LL);
    xsi_set_current_line(125, ng0);
    t2 = (t0 + 3248U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t21 = (t20 + 1);
    t2 = (t0 + 3248U);
    t5 = *((char **)t2);
    t2 = (t5 + 0);
    *((int *)t2) = t21;
    goto LAB9;

LAB13:    t4 = (t0 + 2952U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB15;

LAB16:    xsi_set_current_line(129, ng0);
    t2 = (t0 + 4952);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t11 = (t8 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    goto LAB17;

LAB19:    xsi_set_current_line(133, ng0);
    t12 = (t0 + 4952);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    *((unsigned char *)t16) = (unsigned char)2;
    xsi_driver_first_trans_fast(t12);
    xsi_set_current_line(134, ng0);
    t2 = xsi_get_transient_memory(96U);
    memset(t2, 0, 96U);
    t4 = t2;
    memset(t4, (unsigned char)2, 96U);
    t5 = (t0 + 4888);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t2, 96U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(135, ng0);
    t2 = (t0 + 4952);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(136, ng0);
    t2 = (t0 + 3248U);
    t4 = *((char **)t2);
    t2 = (t4 + 0);
    *((int *)t2) = 0;
    goto LAB20;

}

static void work_a_1079860337_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(145, ng0);

LAB3:    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5080);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4808);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_1079860337_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1079860337_3212880686_p_0,(void *)work_a_1079860337_3212880686_p_1};
	xsi_register_didat("work_a_1079860337_3212880686", "isim/ADC_CTRL_isim_beh.exe.sim/work/a_1079860337_3212880686.didat");
	xsi_register_executes(pe);
}
