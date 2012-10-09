use Test::More (tests => 9);
use Test::Exception;
push(@INC,'/Users/saravase/Documents/work/perl/mal/rmg-odds/libs');
use OddsConverter;

use_ok('OddsConverter');

new_ok('OddsConverter' => [probability => 0.5]);
new_ok('OddsConverter' => [probability => 0]);
new_ok('OddsConverter' => [probability => 1]);
new_ok('OddsConverter' => [probability => 5e-2]);

dies_ok { OddConverter->new } 'No empty constructors';
dies_ok { OddsConverter->new(probability => -1) } 'No negative probabilities';
dies_ok { OddsConverter->new(probability => 1.1) } 'No probabilities > 1';
dies_ok { OddsConverter->new(probability => 'one') } 'No non-numeric probabilities';
