use Test::More;
use Mojo::Base -strict, -signatures, -async_await;
use Syntax::Keyword::Try;
use User;

# Make tests async
async sub tests {

    # create 10 users
    my @users = map { User->new } 1 .. 10;

    my $got;

    foreach my $user (@users) {
        # try to get user profile
        try { $got = await $user->get_profile_p }
        catch { 
            # check error message
            like $@, qr/Fake error/, "Right error message" or note explain $@;
            next;
        }

        # got it, so show the data
        ok $got, "Got something";
        note explain $got;
    }

    done_testing;
}

tests()->wait;
