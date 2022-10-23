use strict;
use warnings;
use Test::More;

sub diag_version
{
	my ($module, $version, $return) = @_;
	
	if ($module =~ /\//) {
		my @modules  = split /\s*\/\s*/, $module;
		my @versions = map diag_version($_, undef, 1), @modules;
		return @versions if $return;
		return diag sprintf('  %-43s %s', join("/", @modules), join("/", @versions));
	}
	
	unless (defined $version) {
		eval "use $module ()";
		$version =  $module->VERSION;
	}
	
	if (!defined $version) {
		return 'undef' if $return;
		return diag sprintf('  %-40s    undef', $module);
	}
	
	my ($major, $rest) = split /\./, $version;
	$major =~ s/^v//;
	return "$major\.$rest" if $return;
	return diag sprintf('  %-40s % 4d.%s', $module, $major, $rest);
}

sub diag_env {
	require B;
	my $var = shift;
	return diag sprintf('  $%-40s   %s', $var, exists $ENV{$var} ? B::perlstring($ENV{$var}) : "undef");
}

while (<DATA>)
{
	chomp;
	
	if (/^#\s*(.*)$/ or /^$/)
	{
		diag($1 || "");
		next;
	}

	if (/^\$(.+)$/)
	{
		diag_env($1);
		next;
	}

	if (/^perl$/)
	{
		diag_version("Perl", $]);
		next;
	}
	
	diag_version($_) if /\S/;
}

require Types::Standard;
diag("");
diag(
	!Types::Standard::Str()->_has_xsub
		? ">>>> Type::Tiny is not using XS"
		: $INC{'Type/Tiny/XS.pm'}
			? ">>>> Type::Tiny is using Type::Tiny::XS"
			: ">>>> Type::Tiny is using Mouse::XS"
);
diag("");

ok 1;
done_testing;

__END__

perl
Exporter::Tiny
Import::Into
Scalar::Util/List::Util/Sub::Util
Module::Runtime
namespace::autoclean/namespace::clean

Keyword::Simple/PPR
B::Hooks::EndOfScope/Variable::Magic
Path::ScanINC

Moo/MooX::TypeTiny/Class::XSAccessor
Moose
Mouse

Type::Tiny/Type::Tiny::XS
Class::Method::Modifiers/Sub::Quote
Role::Tiny

MooX::Press
Devel::StrictMode
Syntax::Keyword::Try
MooX::Enumeration/MooseX::Enumeration
Sub::HandlesVia
Sub::MultiMethod
Lexical::Accessor
Role::Hooks

Test::More/Test::Fatal/Test::Requires

$AUTOMATED_TESTING
$NONINTERACTIVE_TESTING
$EXTENDED_TESTING
$AUTHOR_TESTING
$RELEASE_TESTING
