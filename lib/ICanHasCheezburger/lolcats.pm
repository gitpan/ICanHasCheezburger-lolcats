package ICanHasCheezburger::lolcats;

require LWP::UserAgent;
require XML::Simple;
use strict;
our $VERSION=0.01;

=head1 NAME

ICanHasCheezburger::lolcats - Retrieves the latest from ICanHasCheezburger.

=head1 SYNOPSIS

	use lolcats;
	my $lolcat = ICanHasCheezburger::lolcats->new;
	my $rofl = $lolcat->getImage;
	open(FILE, ">rofl.jpg");
	print FILE $rofl;
	close(FILE);

=head1 DESCRIPTION

This module is designed for retreiving lolcat images from the ICanHasCheezburger RSS feed using LWP.

=head2 Methods

=head3 new

	my $lolcat = ICanHasCheezburger::lolcats->new;
	my $lolcat = ICanHasCheezburger::lolcats->new( feedUrl => 'http://server.tld/feed.rss' );
	
	Creates a new object for retrieval of lolcats. If a C<$feedUrl> is given, it is passed to C<< $lolcat->feedUrl >> and will be used instead of the default.

=cut

sub new {
	my ($class, %args) = @_;
	
	my $self = bless({}, $class);
	
	my $defaultFeed = "http://feeds.feedburner.com/ICanHasCheezburger";
	my $feedUrl = exists $args{feedUrl} ? $args{feedUrl} : $defaultFeed;
	$self->feedUrl ($feedUrl);
	
	return $self;
}

=head3 feedUrl

	my $feedUrl = $lolcat->feedUrl;
	$lolcat->feedUrl($feedUrl);
	
	Gets or sets the Feed URL to use for retrieval of lolcats.
	
=cut

sub feedUrl {
	my $self = shift;
	
	if(@_){
		my $feedUrl = shift;
		$self->{feedUrl} = $feedUrl;
	}
	
	return $self->{feedUrl};
}

=head3 getImageUrl

	my $imageUrl = $lolcat->getImageUrl;
	
	Gets the URL for the latest image to be posted to the lolcats feed. Returns nothing on failure.

=cut

sub getImageUrl {
	my $self = shift;
	
	my $feed = $self->feed;
	
	if(!$feed){ return; }
	
	my ($imageUrl) = $feed =~ /\<media\:content url\=\"(.+?)\" medium=\"image\"\>/;
	return $imageUrl;
}

=head3 getImage

	my $image = $lolcat->getImage;
	my $image = $lolcat->getImage($imageUrl);
	
	Uses LWP to fetch C<$imageUrl>. If none is specified, will call C<< $lolcat->getImageUrl >> and fetch that. It will return the actual image, or nothing on failure.
	
=cut


sub getImage {
	my $self = shift;
	my $imageUrl;
	
	if(@_){
		$imageUrl = shift;
	}else{
		$imageUrl = $self->getImageUrl;
	}
	
	if(!$imageUrl){ return; }
	
	my $imgBrowser = LWP::UserAgent->new;
	my $imgResponse = $imgBrowser->get($imageUrl);
	
	if($imgResponse->is_success){
		return $imgResponse->content;
	}else{
		return;
	}
}

=head3 getPageUrl

	my $pageUrl = $lolcat->getPageUrl;
	
	Gets the URL for the latest page to be posted to the lolcats feed. Returns nothing on failure.

=cut

sub getPageUrl {
	my $self = shift;
	
	my $feed = $self->feed;
	
	if(!$feed){ return; }
	
	my ($pageUrl) = $feed =~ /\<feedburner\:origLink\>(.+?)\<\/feedburner:origLink\>/;
	
	return $pageUrl;
}

=head3 getUpdatedTime

	my $lastUpdate = $lolcat->getUpdatedTime;
	
	Gets the time and date of the last update to the lolcats feed. Returns nothing on failure.

=cut

sub getUpdatedTime {
	my $self = shift;
	
	my $feed = $self->feed;
	
	if(!$feed){ return; }
	
	my ($updated) = $feed =~ /\<pubDate\>(.+?)\<\/pubDate\>/;
	
	return $updated;
}

=head3 feed

	my $rssFeed = $lolcat->feed;
	
	Uses LWP to fetch C<< $self->feedUrl >>, and returns it. Returns nothing on failure.
	
=cut


sub feed {
	my $self = shift;
	
	my $feedBrowser = LWP::UserAgent->new;
	my $feedResponse = $feedBrowser->get($self->feedUrl);
	
	if($feedResponse->is_success){
		return $feedResponse->content;
	}else{
		return;
	}
}

1;
__END__
