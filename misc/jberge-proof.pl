use Mojo::Base -signatures;

use Mojo::AsyncAwait;
use Mojo::Promise;
use Mojo::UserAgent;
use Mojo::IOLoop;
use Mojo::Util qw(trim);
use DDP;

my $ua = Mojo::UserAgent->new;

async get_title_p => sub ($url) {
    my $tx = await $ua->get_p($url);
    return trim $tx->res->dom->at('title')->text;
};

async main => sub (@urls) {
    my @promises = map { get_title_p($_) } @urls;
    my @titles   = await Mojo::Promise->all(@promises);
    say for map { $_->[0] } @titles;
};

my @URLS = (
    qw(
      https://mojolicious.org
      https://mojolicious.io
      https://metacpan.org
      )
);

Mojo::IOLoop->timer(
    2 => sub {
        my $loop = shift;
        main(@URLS)->wait;
    }
);

Mojo::IOLoop->start unless Mojo::IOLoop->is_running;

