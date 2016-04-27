#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $print_debug=3;

####global scope####
my @A__=(0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,1,1,1);
my @B__=(0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,1);
my @C__=(0,0,0,1,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,1);
my @D__=(1,0,0,1,0,0,0,1,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0);

my $max_depth =4;
#Hash to contain victorious actions for max
my %rs=();

my @hs;
# array to contain depth

my @tree;

my @branch;


sub init
{


# array to contain depth

#Hash to contain victorious actions for min
my %mini_records;



#max
my @player_1=('A', 'B');

#mini
my @player_2=('C', 'D');


#stock_values IN JC
my %stock_values =(
					'A'=>10,
					'B'=>10,
					'C'=>10,
					'D'=>10
					);


push(@branch, \@player_1);

depth(\@tree, \@branch, 0, \@player_1, \@player_2, \%stock_values, 0,0,0,0);
}

init();
sub depth
{


my $tree = shift;

my $branch = shift;

#current depth
my $current_depth= shift;

my $player_1=shift;
#mini
my $player_2=shift;
#stock_values IN JC
my $stock_values =shift;
#indexs
my $A_=shift;
my $B_=shift;
my $C_=shift;
my $D_=shift;
my $find_leaf=shift;

#wrap around
# if ($find_leaf) 
# {
# 	return;
# }

if ($current_depth >= $max_depth)
{
	print"RECORDING RESULT\n";
	record_results($branch, $stock_values);
	return;
}
# if(broke($player_1, $player_2))
# {
# 	record_results(@tree, $stock_values);
# 	return;
# }





debug("value of  stock depth : ".$current_depth, $stock_values);

#prune based on current value of V
# $tree = prune($tree, $min);






#generates one level at a time

$tree[$current_depth]->[0]= generate($player_1, $player_2);

# debug("current tree depth : ".$current_depth, $tree);
# $player_1=
# print Dumper(@{$tree[$current_depth]->[0]);
# print Dumper($tree[$current_depth]->[0]->[0]);
# print Dumper($tree[$current_depth]->[0]);

# debug("current branch", \@branch);
debug("current player 1 depth :".$current_depth, $player_1);

# my $len = length($branch);
debug("current branch depth :".$current_depth, $branch);

push($branch, $tree[$current_depth]->[0]->[0] );
debug("current branch after push depth :".$current_depth, $branch);

debug("current  tree[current_depth] depth :".$current_depth,  $tree[$current_depth]);
debug("current  tree[current_depth]->[0] depth :".$current_depth,  $tree[$current_depth]->[0]);
debug("current tree[current_depth]->[0]->[0] depth :".$current_depth,  $tree[$current_depth]->[0]->[0]);
if($A_==31)
{
	$A_=$B_=$C_=$D_=0;
}
#changes based on prediction
$stock_values = revalute($A__[$A_], $B__[$B_], $C__[$C_], $D__[$D_],$stock_values);
	depth(
			$tree, 
			$branch, 
			$current_depth+1, 
			$tree[$current_depth]->[0]->[0], 
			compliment($tree[$current_depth]->[0]->[0]->[0], $tree[$current_depth]->[0]->[0]->[1]), 
			$stock_values, 
			$A_+1, $B_+1, $C_+1, $D_+1, 
			1);

#di
# my $node_counter=0;
#exploring terminal nodes
# print Dumper($tree[$current_depth]->[0]);
shift($tree[$current_depth]->[0]);
# shift (@branch);
my $i=0;

foreach(@{$tree[$current_depth]->[0]})
{	

	
	# print Dumper("ele in foreach\n", $_);
 	pop(@{$branch});

	push(@{$branch}, $_);

	# print Dumper("branch to be eval\n", \@branch);
	 		

	depth(	
		    # breadth
			$_,

			# current branch being traversed
			$branch, 

			
			$current_depth+1, 

			#player one
			$tree[$current_depth]->[0]->[$i], 
			#player 2
			compliment($tree[$current_depth]->[0]->[$i]->[0], $tree[$current_depth]->[0]->[$i]->[1]), 

			$stock_values, 
			#indexes
			$A_, $B_, $C_, $D_,

			0

			);
	$i++;

	
# print "!\n";
}

pop(@branch);



return ;

}

sub revalute
{
	my $stock_values = $_[4];

	if($_[0])
	{
		$stock_values->{'A'} = $stock_values->{'A'} + 1;
	} else
		{
			$stock_values->{'A'} = $stock_values->{'A'} - 1;

		}
	if($_[1])
	{
		$stock_values->{'B'} = $stock_values->{'B'} + 1;
	} else
		{
			$stock_values->{'B'} = $stock_values->{'B'} - 1;

		}
	if($_[2])
	{
		$stock_values->{'C'} = $stock_values->{'C'} + 1;
	} else
		{
			$stock_values->{'C'} = $stock_values->{'C'} - 1;

		}
	if($_[3])
	{
		$stock_values->{'D'} = $stock_values->{'D'} + 1;
	} else
		{
			$stock_values->{'D'} = $stock_values->{'D'} - 1;

		}
	return $stock_values;
}

sub prune
{

}

sub record_results
{
my $tree= shift;
my @branch=@{$tree};
my $stock=shift;


# my @last_value = $branch[$max_depth];
# # @last_value = $branch[0]->[1];
# my $vala = $stock->{$last_value[0]->[0]};

# my $valb = $stock->{$last_value[0]->[1]};

# my $name = $last_value[0]->[0].$last_value[0]->[1];
	
# my @ar = (\@branch, $vala+$valb);
# $rs{$name} = (\@ar);

 print Dumper(\@branch);

#  my @trouble;
# push(@trouble, @branch);
# push (@hs, @trouble);
# # print Dumper(\@branch);
# # sleep(5);

}

sub generate
{
	my @tree;
	my @tree_compliment;
	my $player_1 = $_[0];
	my $player_2 = $_[1];
	foreach(@{$player_1})
	{
		my $unit = $_;
		my @baby_tree;
		# my @baby_compliment;
		foreach(@{$player_2})
		{
			my @ar;
			push(@ar, $unit, $_);
			push(@tree, \@ar);

			# my ($compa, $compb) = compliment($unit, $_);
			# push(@baby_compliment, $compa, $compb)
		}
		# push(@tree, \@baby_tree);
		# push(@tree_compliment, \@baby_compliment);
		# print Dumper(\@tree);
	}
	#tree-leftmost is max compliment-rightmost is mini
 	#push(@tree, \@tree_compliment);
	return \@tree;
}


sub compliment
{
	my @list =('A','B','C','D');
	my @compliments;
	my $compa = $_[0];
	my $compb = $_[1];
	# print "trouble mite\n";
	# print Dumper($compa, $compb);	
	foreach(@list)
	{
		if(!($compa =~ /$_/) && !($compb =~ /$_/) )
		{
			push(@compliments, $_);
		}
	}
	# print "trouble mite\n";
	# print Dumper(\@compliments);
	return(\@compliments);
}


sub debug
{

	if ($print_debug)
	{
		 # print Dumper ($_[0],$_[1]);
	}

}

print"\n\n\n\n";

print Dumper (\%rs);
print"\n\n\n\n";

print Dumper (\@hs);