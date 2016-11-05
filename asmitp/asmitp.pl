#!/usr/bin/perl
#==============================================================================
#
# asmitp.pl: ADC Testchip instruction decoder
#
# DESCRIPTION
#
#   Usage: asmitp.pl <file> [options]
#
#   Example: ./asmitp.pl instructions.asm
#
# AUTHOR
#   
#==============================================================================
# Version: A, 2014-01-31
#==============================================================================
use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Text::Wrap;

#=============
# Subroutines
#=============

# Print help message
sub print_help
{
	print<<EOM;

Usage: $0 <file> [--output=<file>] [--help]

Options:
    <file>             Input netlist file name.
    -o|--output <file> Output netlist file (default same as "input file name".asm[.hex])
    -h|--help          Print this help message

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
# INSTRUCTION TABLE
# Bit Positions from Left to Right
# Actual posisiton is +1 Right
# E.g. bit 5 in this table corresponds to bit 6
	#
	my $SHR_POS = 5;
	my $SHS_POS = 6;


	my $topars_line = $_[0];
	my $lst_line = $_[1];
	my $ram_width = $_[2];
	my $parsd_line = '';

	if ($topars_line =~ /^NOP$|^NOP\s*$/) {
		$parsd_line = $lst_line;
	}
	elsif ($topars_line =~ /^NOP\s*(\d+)\s*$/) {
		my $ops = $1;
		for (my $i=0; $i < $ops; $i++) {
			if (length($parsd_line) == 0) {
				$parsd_line = $lst_line;
			}
			else {
				$parsd_line = $parsd_line . "\n" . $lst_line;
			}
		}
	}
	elsif ($topars_line =~ /^START$|^START\s*$/) {
		$parsd_line = "0" x $ram_width;
	}

	elsif ($topars_line =~ /^MOV.*SHR\s*(\d+)\s*$/) {
		substr($lst_line, $SHR_POS, 1, $1);
		$parsd_line = $lst_line;
	}
	elsif ($topars_line =~ /^MOV.*SHS\s*(\d+)\s*$/) {
		substr($lst_line, $SHS_POS, 1, $1);
		$parsd_line = $lst_line;
	}
	elsif ($topars_line =~ /^LOAD.*SPE2\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)\s*$/) {
		substr($lst_line, $1, 1, $2);
		substr($lst_line, $3, 1, $4);
		$parsd_line = $lst_line;
	}


	else{
	}



	return $parsd_line;

}

# Print line and fold if too long
sub print_line
{
	my($filehandle, $line) = @_;
	$Text::Wrap::columns = 80;
	$Text::Wrap::separator2 = "\n+";
	if ($line =~/^\s*$/){	# don't print empty lines / unrecognized instructions
	}
	else
	{
		print {$filehandle} wrap('', '', $line) . "\n";
	}
}

#=============
# Main
#=============
my $help_flag = '';
my $ofile_flag = '';
my $ifname = '';
my $ifpath = '';
my $ifsuffix = '';
my $ofname = '';
my $ofpath = '';
my $ofsuffix = '';

my $ram_width = 32;
my $ram_depth = 8196;

# Parse command line arguments
GetOptions('h|help'     => \$help_flag,
	'o|output=s' => \$ofile_flag)
	or exit 1;

if ($help_flag || $#ARGV lt 0)
{
	print_help();
	exit;
}

($ifname, $ifpath, $ifsuffix) = fileparse($ARGV[0],'.asm') or exit 1;
if ($ofile_flag)
{
	($ofname, $ofpath, $ofsuffix) = fileparse($ofile_flag,'.hex') or exit 1;
}
else
{
	$ofname = $ifname . '.hex';
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

while (defined($line = get_line($ifile, \$prev_line)))
{
	$parsd_line = parse_line($line,$lst_line,$ram_width);
	$lst_line = substr($parsd_line, $ram_width*(-1));
	print_line($ofile,$parsd_line);
}


# Close files
close($ifile);
close($ofile);
