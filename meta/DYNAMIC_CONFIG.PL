if (eval { require Variable::Magic }) {
	$meta->{prereqs}{runtime}{requires}{'Variable::Magic'} = '0.62';
}
