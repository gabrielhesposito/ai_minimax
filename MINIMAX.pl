#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Storable qw(dclone);

##simply define one variable to begin
## can't define both
my $mini=1;
my $max;


####global scope####
my @A__=(0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,1,1,1);
my @B__=(0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,1,0,0,0,1);
my @C__=(0,0,0,1,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,1);
my @D__=(1,0,0,1,0,0,0,1,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0);

my $max_depth =64;

#list of victories branches
my @hs;
# array to contain pruneded parents
my @pruned;

my @tree;
#current branch being traversed 
my @branch;

my %stock_values =(
					'A'=>10,
					'B'=>10,
					'C'=>10,
					'D'=>10
					);





sub init
{
	#max
	my @player_1=('A', 'B');

	#mini
	my @player_2=('C', 'D');

	push(@branch, \@player_1);
	depth(\@tree, \@branch, 0, \@player_1, \@player_2);
}


sub depth
{

	my $tree = shift;
	my $branch = shift;
	my $current_depth= shift;
	my $player_1=shift;
	my $player_2=shift;

	# RETURNS IF PARENT IS IN PRUNED LIST
	if(prune($branch, $current_depth))
	{
		return;
	}

	#EVALUATES STOCK VALUE BASED ON DEPTH
	my ($stock_values, $flag) = stock_evaluate($player_1, $player_2, $current_depth, $branch);
	#RETURNS IF COMBINED PROFILE OF A PLAYER IS EQUAL OR LESS THAN ZERO
	#IF STOCK HAS A VALUE OF ZERO, OR A COMBINATION OF THE PLAYERS WORTH IS ZERO
	if($flag)
	{

		record_results($branch, $stock_values, $current_depth);
		return;
	}
	#IF MAX DEPTH HAS BEEN REAHED
	if ($current_depth >= $max_depth)
	{

		record_results($branch, $stock_values, $current_depth);
		return;
	}
	#generates one level at a time, 
	#this is actually breadth
	$tree[$current_depth]->[0]= generate($player_1, $player_2);


	#add onto our current branch the leftmost node
	push($branch, $tree[$current_depth]->[0]->[0] );
		depth(
				$tree, 
				$branch, 
				$current_depth+1, 
				$tree[$current_depth]->[0]->[0], 
				compliment($tree[$current_depth]->[0]->[0]->[0], $tree[$current_depth]->[0]->[0]->[1]) 
				);
	#already explored leftmost node, remove it from the stack
	shift($tree[$current_depth]->[0]);
	my $i=0;
	foreach(@{$tree[$current_depth]->[0]})
	{	
		pop(@{$branch});
		push(@{$branch}, $_);
		depth(	
			    # breadth
				$_,
				# current branch being traversed
				$branch, 	
				$current_depth+1, 
				#player one
				$tree[$current_depth]->[0]->[$i], 
				#player 2
				compliment($tree[$current_depth]->[0]->[$i]->[0], $tree[$current_depth]->[0]->[$i]->[1])
				);
		$i++;
}
	pop(@branch);
	return;
}


##increments stock or decrements based on value of prediction
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

##	based on depth this function creates new stock values
##	this is to avoid the overhead of saving this hash in every state
##	but really is quite sloppy
sub stock_evaluate
{
	my $player_1 = shift;
	my $player_2 = shift;
	my $current_depth = shift;
	my %is = %stock_values;
	my  $ref_val= \%is;
	if($current_depth==0)
	{
		#no need to evalute stock worth
		return ($ref_val, 0);
	}

	my $index=0;
	for(my $i=0; $i<$current_depth; $i++)
	{
		if($index == 31)
		{
			$index=0;
		}
		$ref_val = revalute($A__[$index], $B__[$index], $C__[$index], $D__[$index], $ref_val);
		if($i)
		{
		my $traded = arr_return($branch[$i], $branch[$i+1]);

		$ref_val->{$traded->[0]} =$ref_val->{$traded->[0]}+1;
		$ref_val->{$traded->[1]} =$ref_val->{$traded->[1]}+1;
		}
		$index++;
	}

	my $stock_1 = $ref_val->{$player_1->[0]};
	my $stock_2 = $ref_val->{$player_1->[1]};
		
	my $stock_3 = $ref_val->{$player_2->[0]};
	my $stock_4 = $ref_val->{$player_2->[1]};

	if (($stock_1+$stock_2) <= 0) 
	{

		return ($ref_val,1);
	}
	if($stock_1<=0)
	{
		return($ref_val,1);
	}
	if($stock_2<=0)
	{
		return($ref_val,1);
	}
	if($stock_3<=0)
	{
		return($ref_val,1);
	}
	if($stock_4<=0)
	{
		return($ref_val,1);
	}

	if(($stock_3+$stock_4) <= 0)
	{
		return ($ref_val,1);
	}

	return ($ref_val,0);
}

## makes a copy of existing data (as a hash)
## pushes the data into an array of victorious moves
## also prints to a csv
sub record_results
{
	my $tree= shift;
	my @branch=@{$tree};
	my $stock=shift;
	my $current_depth = shift;



	my @data_new = @{ dclone(\@branch) };
	my %data_stock = %{ dclone($stock) };
	my @last_node = $data_new[$current_depth];
	my @parent =@{ dclone(\@branch) };
	my $raw = $stock->{$last_node[0]->[0]} +  $stock->{$last_node[0]->[1]};

	my %has_new =(branch => \@data_new,
				  stock => \%data_stock,
				  value=>  $raw,
				  parent=> $parent[1],
				  depth=> $current_depth
					);
	if(prune_time($parent[1], $raw))
	{
		# push(@pruned, $parent[1]);
	}else
		{
			push (@hs, \%has_new);


			open(my $fh, '>>', "results.csv");
			print $fh "Value,".$raw."\n";
			print $fh "depth,". $current_depth."\n";
			print $fh "parent(one of the initial 4 moves ),". $parent[1]->[0].$parent[1]->[1]."\n";
			print $fh "stock data,A=>,".$data_stock{A}.",B=>,".$data_stock{B}.",C=>,".$data_stock{C}.",B=>,".$data_stock{D};
			print $fh "\n";
			foreach(@data_new)
			{
				print $fh $_->[0]. $_->[1].","
			}
			print $fh "BRANCH END\n\n\n";
			close $fh;

		}

}

##	for all existing values
##	determine if the branches parent should be pruned
sub prune_time
{
	my $parent = shift;
	my $value = shift;
	foreach(@hs)
	{
		
		# if (array_diff($parent,$_->{'parent'}))
		# {
		if($mini)
		{
			if($_->{'value'} < $value)
			{
				##the value found is greater than a known value
				## it's useless lets prune
				return 1;
			}
		}
		if($max)
		{


			if($_->{'value'} > $value)
			{
				##the value found is less than a known value
				## it's useless lets prune
				return 1;
			}
		}
		# } 
	}
	return 0;
}


## if a given branches parent
## is in the "pruned" list
## this function will return true
sub prune
{
	my $branch = shift;
	my $current_depth=shift;

	if($current_depth ==0)
	{
		return 0;
	}
	foreach(@pruned)
	{

		if(array_diff($branch[1],$_))
		{
		
			return 1;
		}
	}
	 return 0;
}

## given player one and two
## it produces the next possible trades
## for player one
## these are the child nodes of the previous trade
sub generate
{
	my @tree;
	my $player_1 = $_[0];
	my $player_2 = $_[1];
	foreach(@{$player_1})
	{
		my $unit = $_;
		my @baby_tree;
		foreach(@{$player_2})
		{
			my @ar;
			push(@ar, $unit, $_);
			push(@tree, \@ar);
		}
	}
	return \@tree;
}
## 	provides the compliment of a given stock profile
## given a and b it produces c and d
##
sub compliment
{
	my @list =('A','B','C','D');
	my @compliments;
	my $compa = $_[0];
	my $compb = $_[1];
	foreach(@list)
	{
		if(!($compa =~ /$_/) && !($compb =~ /$_/) )
		{
			push(@compliments, $_);
		}
	}
	return(\@compliments);
}


## insures the trade took place correctly
##	also determines if two arrays/nodes are identical
##
##
sub array_diff 
{
	my $arry_1 = shift;
	my $arry_2 = shift;
	my $num=0;
	foreach(@{$arry_1})
	{
		my $unit = $_;
		foreach(@{$arry_2})
		{
			if($unit eq $_)
			{
				$num++;
			}
		}

	}   
	if($num == 2)
	{
		return 1;
	}
	return 0;
}
## insures the trade took place correctly
##	returns the difference between two arrays/nodes
##
##
sub arr_return
{
	my $list1=shift;
	my $list2=shift;

	my @diff;
	my %repeats;

	for (@{$list1}, @{$list2}) { $repeats{$_}++ }
	for (keys %repeats) {
	    push @diff, $_ unless $repeats{$_} > 1;
	}
	    return \@diff;

}





init();

print"\n\n\n\n";

print Dumper (\@hs);