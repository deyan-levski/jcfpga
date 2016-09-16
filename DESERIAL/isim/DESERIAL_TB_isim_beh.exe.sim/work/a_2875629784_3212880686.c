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
static const char *ng0 = "/media/design/fpga/projects/DESERIAL/DESERIAL_TB.vhd";



static void work_a_2875629784_3212880686_p_0(char *t0)
{
    int64 t1;
    char *t2;
    char *t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;

LAB0:    xsi_set_current_line(96, ng0);

LAB3:    t1 = (1 * 1000LL);
    t2 = (t0 + 1032U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t2 = (t0 + 3544);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_delta(t2, 0U, 1, t1);
    t9 = (t0 + 3544);
    xsi_driver_intertial_reject(t9, t1, t1);

LAB2:    t10 = (t0 + 3464);
    *((int *)t10) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_2875629784_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2875629784_3212880686_p_0};
	xsi_register_didat("work_a_2875629784_3212880686", "isim/DESERIAL_TB_isim_beh.exe.sim/work/a_2875629784_3212880686.didat");
	xsi_register_executes(pe);
}
