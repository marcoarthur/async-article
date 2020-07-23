use Test::More;
use Mojo::Base -strict, -signatures, -async_await;
use User;

# Make tests async
async sub tests {

    # create 10 users
    my @users = map { User->new } 1 .. 10;

    foreach my $user (@users) {
        # try to get user profile
        my $got = eval { await $user->get_profile_p };
        # could not got check for undefined response
        unless ( $got ) {
            ok ! defined $got, "Expected undefine return for failed promise";
            next;
        }
        # got it, so show the data
        ok $got, "Got something";
        note explain $got;
    }

    done_testing;
}

tests()->wait;
