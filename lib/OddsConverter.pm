package OddsConverter;
use v5.12;
use Moose;    #Using moose for object orientation

=head1 NAME

OddsConverter

=head1 SYNOPSIS
    Using Moose for object orientation.
    my $oc = OddsConverter->new(probability => 0.5);
    print $oc->decimal_odds;    # '2.00' (always to 2 decimal places)
    print $oc->roi;             # '100%' (always whole numbers or 'Inf.')

=cut

has probability => ( is => 'ro', isa => 'Str' );

#calculation of decimal odds
sub decimal_odds {
    my $self = shift;
    my $prob = $self->probability;

    if ( $prob =~ s/e//g ) {    #checking for exponents

        if ( $prob =~ /(\-|\+)/g ) {
            my $sign = $1;
            $prob = $self->calc_sign( $sign, $prob );
        }
    }
    return ($self->calc_dec_odds($prob));
}

#calculation of ROI

sub roi {
    my $self = shift;
    my $prob = $self->probability;
    if ( $prob =~ s/e//g ) {
        if ( $prob =~ /(\-|\+)/g ) {
            my $sign = $1;
            $prob = $self->calc_sign( $sign, $prob );
        }
    }
    my $ret = $self->calc_dec_odds($prob);
    unless ( $ret =~ /Inf\./g ) {
        $ret = ( $ret - ( $prob * $ret ) );
        $ret = sprintf( "%.2f", $ret );
        $ret = 100 * ($ret) ; #calculating the ROI using the formula (100 *(decimal_odds-(probability*decimal_odds))
        $ret .= '%';    #conveting to percentage
    }
    return ($ret);
}

#Subroutine for handling exponents
sub calc_sign {
    my ( $sign, $prob ) = @_;
    my ( $first, $sec ) = split( /^$sign$/, $prob );
    $prob = ( ($first) / ( 10**$sec ) ) if ( $sign =~ /\-/g ); #calculating the  exponent value base on minus sign
    $prob = ( ($first) * ( 10**$sec ) ) if ( $sign =~ /\+/g );    #calculating the exponent based on the plus sign
    return $prob;
}

#calculations for finding decimal odds
sub calc_dec_odds {
    my $self = shift;
    my $prob = shift;
    my $ret  = ();

    if ( $prob == abs($prob) ) {

#calculating the decimal odds for the given probability using the formula ((1-x)/x)+1
        eval {
            $ret = ( ( 1 - $prob ) / $prob ) + 1;
            $ret = sprintf( "%.2f", $ret );
        };
        if ($@) {
            $ret = 'Inf.';    #checking for infinite value and replacing the string.
        }
    }
    return $ret;
}
1;
