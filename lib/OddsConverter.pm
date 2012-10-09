package OddsConverter;
use v5.12;
use Moose;
use POSIX;

=head1 NAME

OddsConverter

=head1 SYNOPSIS

    my $oc = OddsConverter->new(probability => 0.5);
    print $oc->decimal_odds;    # '2.00' (always to 2 decimal places)
    print $oc->roi;             # '100%' (always whole numbers or 'Inf.')

=cut

has probability =>(is => 'ro',isa => 'Str');

#calculation of decimal odds
sub decimal_odds{
    my $self=shift;
    my $prob=$self->probability;
    if($prob=~/e/g){  #checking for exponents
        $prob=~s/e//g;
        if($prob=~/\-/g){
            my ($first,$sec)=split(/\-/,$prob);
            $prob=(($first)/(10**$sec));  #calculating the  exponent value base on minus sign
        }elsif($prob=~/\+/g){
            my ($first,$sec)=split(/\+/,$prob);
            $prob=(($first)*(10**$sec)); #calculating the exponent based on the plus sign
        }else{
            $prob=$prob;
        }
    }else{
        $prob=$self->probability;
    }
    my $ret=();
    if($prob==abs($prob)){
        eval{$ret=((1-$prob)/$prob)+1;$ret=sprintf("%.2f",$ret);}  #calculating the decimal odds for the given probability using the formula ((1-x)/x)+1
    }
    if($@){
        $ret='Inf.';  #checking for infinite value and replacing the string.
    }
    return($ret);
}

#calculation of ROI

sub roi{
    my $self=shift;
    my $prob=$self->probability;
    if($prob=~/e/g){
        $prob=~s/e//g;
        if($prob=~/\-/g){
            my ($first,$sec)=split(/\-/,$prob);
            $prob=(($first)/(10**$sec)); #calculating the exponent based on minus sign
        }elsif($prob=~/\+/g){
            my ($first,$sec)=split(/\+/,$prob);
            $prob=(($first)*(10**$sec));  #calculating the exponent based on the plus sign
        }else{
            $prob=$prob;
        }
    }else{
        $prob=$self->probability;
    }
    my $ret=();
    if($prob==abs($prob)){
        eval{
            $ret=((1-$prob)/$prob)+1;
            $ret=sprintf("%.2f",$ret);
            $ret=100 * (sprintf("%.2f",($ret-($prob*$ret))));  #calculating the ROI using the formula (100 *(decimal_odds-(probability*decimal_odds))
            $ret=sprintf("%d%",$ret); #conveting to percentage
        }
    }
    if($@){
        $ret='Inf.'; #Handling infinite values
    }
    return($ret);
}
1;
