# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl ICanHasCheezburger-lolcats.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
BEGIN { use_ok('ICanHasCheezburger::lolcats') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $obj = ICanHasCheezburger::lolcats->new();
if($obj->feedUrl){ pass("Get Feed URL"); }else{ fail("Get Feed URL"); }
$obj->feedUrl('http://google.com');
if($obj->feedUrl eq "http://google.com"){ pass("Set Feed URL"); }else{ fail("Set Feed URL") }
my $objtwo = ICanHasCheezburger::lolcats->new();
if($objtwo->getImageUrl){ pass("Get Image URL"); }else{ fail("Get Image URL"); }
if($objtwo->getImage){ pass("Get Image"); }else{ fail("Get Image"); }
if($objtwo->getPageUrl){ pass("Get Page URL"); }else{ fail("Get Page URL"); }
if($objtwo->getUpdatedTime){ pass("Get Update Time"); }else{ fail("Get Update Time"); }
