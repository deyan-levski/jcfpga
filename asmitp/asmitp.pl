#!/usr/bin/perl
#|------------------------------------------------------------|
#| asmitp.pl: ADC Instruction Decoder for FPGA ROM            |
#|------------------------------------------------------------|
#| DESCRIPTION                                                |
#| Usage: asmitp.pl <file> [options]                          |
#|                                                            |
#|                                                            |
#| Example: ./asmitp.pl program.asm -o machinecode.bin        |
#|                                                            |
#| Program file must always begin with the START command.     |
#| Instruction list is found under the parse_line subroutine. |
#|                                                            |
#|                                                            |
#| AUTHOR:                                                    |
#| Deyan Levski, deyan.levski@eng.ox.ac.uk                    |
#|------------------------------------------------------------|
#|------------------------------------------------------------|
#| Version: A, 25-11-2016                                     |
#|------------------------------------------------------------|
#
#

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Text::Wrap;
use Fcntl qw(SEEK_END);
use Fcntl qw(SEEK_CUR);
use Fcntl qw(SEEK_SET);

#|-------------|
#| Subroutines |
#|-------------|

# Print help
sub print_help
{
	print<<EOM;

Usage: $0 <file> [--output=<file>] [--help]

Options:
    <file>             Input assembler instruction list.
    -o|--output <file> Output ROM content 
    -h|--hex	       Output in hex format
    -h|--help          Help

EOM
}

# Get a line,
sub get_line
{
	my $filehandle = shift;
	my $line_ptr = shift;
	my $this_line = ${$line_ptr};
	LINE: while (defined(${$line_ptr} = <$filehandle>))
	{
		chomp(${$line_ptr});
		last LINE;
	}
	return $this_line;
}

# Parse line,
sub parse_line
{

#|------------------------------------------------|
#| INSTRUCTION TABLE                              |
#|------------------------------------------------|
#| Bit Positions from Left (n) to Right (0) = MSB |
#|------------------------------------------------|
#| $ram_width and $ram_depth in the main          |
#| routine control the machine code width         |
#| and length                                     |
#|------------------------------------------------|
#| e.g. $ROW_00 is in bit position 0, $ROW_01 - 1 |
#|------------------------------------------------|

	#
	my $ROW_00 = 0;
	my $ROW_01 = 1;
	my $ROW_02 = 2;
	my $ROW_03 = 3;
	my $ROW_04 = 4;

	my $SHX_00 = 5;
	my $SHX_01 = 6;
	my $ADX_01 = 7; # swp err
	my $ADX_00 = 8; # swp err

	my $COM_00 = 9;
	my $COM_01 = 10;

	my $CNT_00 = 11;
	my $CNT_01 = 12;
	my $CNT_02 = 13;
	my $CNT_03 = 14;
	my $CNT_04 = 15;
	my $CNT_05 = 16;
	my $CNT_06 = 17;
	my $CNT_07 = 18;
	my $CNT_08 = 19;

	my $MEM_00 = 20;

	my $REF_00 = 21;
	my $REF_01 = 22;
	my $REF_02 = 23;
	my $REF_03 = 24;

	my $SER_00 = 25;

	my $FVAL_00 = 26;
	my $LVAL_00 = 27;

#|-+-|

	my $topars_line = $_[0]; # line to parse from asm file
	my $lst_line = $_[1];  # last line/instruction (used for NOP operation)
	my $ram_width = $_[2]; # internal ram_width (defined in main)
	my $parsd_line = '';   # output parsed line
	my $prnt_flag = '';    # flag placed here to stop printing beginning and START of file
	my $ld_flag = $_[3];   # load flag, contrlled by LD PAR & LD SET

#|-------------------------|
#| Instruction Regex Match |
#|-------------------------|

	if ($topars_line =~ /(^NOP\s*$)|(^NOP\s*;.*$)/) {
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^NOP\s*(\d+)(\s*|\s*;.*)$/) {
		my $ops = $1;
		for (my $i=0; $i < $ops; $i++) {
			if (length($parsd_line) == 0) {
				$parsd_line = $lst_line;
			}
			else {
				$parsd_line = $parsd_line . ",\n" . $lst_line;
			}
		}
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /(^START\s*$)|(^START\s;.*$)/) {
		$parsd_line = "0" x $ram_width;
		$prnt_flag = '0';
	}

	elsif ($topars_line =~ /(^LOAD\s*PAR\s*$)|(^LOAD\s*PAR\s*;.*$)/) {
		$parsd_line = $lst_line;
		$ld_flag = '0';
		$prnt_flag = '0';
	}
	elsif ($topars_line =~ /(^SET\s*PAR\s*$)|(^SET\s*PAR\s*;.*$)/) {
		$ld_flag = '1';
		$prnt_flag = '1';
		$parsd_line = $lst_line;
	}

	elsif ($topars_line =~ /^MOV\s*ROW\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		# last line, $ROW_00 position, 1-bit, fetch regex falue from asm code
		substr($lst_line, $ROW_00, 1, $1);
		# push substituted string to parsed line
		$parsd_line = $lst_line;
		# print flag on / off, based on LOAD PAR/SET PAR or none
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*ROW\s*0x01\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $ROW_01, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*ROW\s*0x02\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $ROW_02, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*ROW\s*0x03\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $ROW_03, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*ROW\s*0x04\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $ROW_04, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*SHX\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $SHX_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*SHX\s*0x01\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $SHX_01, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*ADX\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $ADX_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*ADX\s*0x01\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $ADX_01, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*COM\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $COM_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*COM\s*0x01\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $COM_01, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x01\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_01, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x02\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_02, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x03\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_03, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x04\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_04, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x05\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_05, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x06\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_06, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x07\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_07, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*CNT\s*0x08\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $CNT_08, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*MEM\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $MEM_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*REF\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $REF_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*REF\s*0x01\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $REF_01, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*REF\s*0x02\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $REF_02, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*REF\s*0x03\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $REF_03, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*SER\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $SER_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^LOAD\s*SPE2\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $1, 1, $2);
		substr($lst_line, $3, 1, $4);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*FVAL\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $FVAL_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	elsif ($topars_line =~ /^MOV\s*LVAL\s*0x00\s*(\d+)(\s*|\s*;.*)$/) {
		substr($lst_line, $LVAL_00, 1, $1);
		$parsd_line = $lst_line;
		$prnt_flag = $ld_flag;
	}
	else{
		$prnt_flag = '0';
		$parsd_line = $lst_line;
	}

	return ($parsd_line, $prnt_flag, $ld_flag);
}

# Print line and fold
sub print_line
{

	my($filehandle, $line, $oformat_flag) = @_;
	if ($line =~/^\s*$/){	# don't print empty lines / unrecognized instructions
	}
	else
	{
		if ($oformat_flag) { print {$filehandle} $line; }
		else { print {$filehandle} wrap('', '', $line) . "\n"; }
	}
}

sub b2h {
    my $num   = shift;
    my $WIDTH = 32;
    my $index = length($num) - $WIDTH;
    my $hex = '';
    do {
        my $width = $WIDTH;
        if ($index < 0) {
            $width += $index;
            $index = 0;
        }
        my $cut_string = substr($num, $index, $width);
        $hex = sprintf('%8X', oct("0b$cut_string")) . $hex;
	$hex=~ tr/ /0/; # add leading zeros
        $index -= $WIDTH;
    } while ($index > (-1 * $WIDTH));
    return $hex;
}

#|------|
#| Main |
#|------|
#
my $help_flag = '';
my $ofile_flag = '';
my $oformat_flag = '';
my $ifname = '';
my $ifpath = '';
my $ifsuffix = '';
my $ofname = '';
my $ofpath = '';
my $ofsuffix = '';
#|---------------------|
#| ROM width and depth |
#|---------------------|
my $ram_width = 32;
my $ram_depth = 1080;
#|---------------------|
#
# Parse command line arguments
GetOptions('h|help'     => \$help_flag,
	'o|output=s' => \$ofile_flag,
	'h|hex'	=> \$oformat_flag)
	or exit 1;

if ($help_flag || $#ARGV lt 0)
{
	print_help();
	exit;
}

($ifname, $ifpath, $ifsuffix) = fileparse($ARGV[0],'.asm') or exit 1;
if ($ofile_flag)
{
	($ofname, $ofpath, $ofsuffix) = fileparse($ofile_flag,'.bin') or exit 1; # default extension
}
else
{
	$ofname = $ifname . '.bin';
	$ofpath = $ifpath;
	$ofsuffix = $ifsuffix;
}

# Open files
open(my $ifile, "<" . $ifpath . $ifname . $ifsuffix) or die $!;
open(my $ofile, ">" . $ofpath . $ofname . $ofsuffix) or die $!;

# Parse input file
my $prev_line = <$ifile>;
my $line = '';
my $parsd_line = '';
my $lst_line = '';
my $prnt_flag = '';
my $ld_flag = '';
my $ld_flag_old = '';

#|----------------|
#| Prepare header |
#|----------------|
#
if ($oformat_flag){
print_line($ofile,"AE"); # add start character AE
seek $ofile, -1, SEEK_END; # (nasty hack) removes \n after start character (AE)
}
else
{
print_line($ofile,"memory_initialization_radix=2;");
print_line($ofile,"memory_initialization_vector=");
}
#
#|----------------|

while (defined($line = get_line($ifile, \$prev_line)))    # for every line
{ 
	($parsd_line, $prnt_flag, $ld_flag) = parse_line($line,$lst_line,$ram_width,$ld_flag_old);
	$ld_flag_old = $ld_flag;
	$lst_line = substr($parsd_line, $ram_width*(-1)); # 
	if ($prnt_flag =~ /1/){
		if ($oformat_flag){
			$parsd_line=~ s/,//g; # add remove trailing commas from NOP
			$parsd_line=~ s/\n//g; # add remove trailing commas from NOP
			my $parsd_line_hex = b2h($parsd_line);
			print_line($ofile,$parsd_line_hex,$oformat_flag);
		}
		else {
			print_line($ofile,$parsd_line . ",",$oformat_flag);
		}
	}
}

if($oformat_flag){
#seek $ofile, -1, SEEK_END; # add stop character (AF)
print $ofile "AF";
}
else{
seek $ofile, -2, SEEK_END; # replaces last , character with ;
print $ofile ";\n";
}

# Close files
close($ifile);
close($ofile);

if (!$oformat_flag)
{
# Open machine code and read number of extra lines over ram depth
# Reopening files, for sake of code flexibility
open(my $ofilerd, "<" . $ofpath . $ofname . $ofsuffix) or die $!;
while (<$ofilerd>) {}
my $cut_lines = $. - $ram_depth - 2; # lines to be chopped (-2 due to header)
seek $ofilerd, 0, SEEK_SET;

open(my $ofilechp, ">" . $ofpath . $ofname . $ofsuffix . ".chp") or die $!;

my $index = 0; # So we can loop over the buffer
my @buffer;
my $counter = 0;
while (<$ofilerd>) {
    if ($counter++ >= $cut_lines) {
        print $ofilechp $buffer[$index];
    }
    $buffer[$index++] = $_;
    $index = 0 if $cut_lines == $index;
}
seek $ofilechp, -2, SEEK_END; # replaces last , character with ;
print $ofilechp ";\n";
close($ofilechp);

# Overwrite old file
use File::Copy;
move($ofpath . $ofname . $ofsuffix . ".chp", $ofpath . $ofname . $ofsuffix) or die $!;
}
