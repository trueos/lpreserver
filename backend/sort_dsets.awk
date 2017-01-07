#!/usr/bin/awk -f
# Sort datasets in the correct order for replication
######################################################################

# Given a line of "name name origin" triples, print Make dependency
# specifications.  Each dataset should depend on its parent (unless it's the
# root dataset of a pool), and its origin (if it's a clone).  For example:
#
# foo/bar/baz foo/bar/baz foo/blue@1 => foo/bar/baz: foo/bar foo/blue
# foo/bar/baz foo/bar/baz - => foo/bar/baz: foo/bar
# foo foo - => foo:
#
# There are two additional requirements:
# * Every target must be .PHONY so it will always be rebuilt
# * The base dataset must not have any dependencies

		{
			printf ".PHONY: %s\n%s: ", $1, $1
		}
$1 == basedset	{
			# The base dset must not have any dependencies
			printf "\n"
			print "	@echo $@"
			next
		}
$2 ~ /\//	{
			sub(/\/[^\/]*$/, "", $2)
			printf "%s", $2
		}
$3 ~ /[^-]/	{
			split($3, orig, "@")
			printf " %s", orig[1]
		}
		{
			printf "\n"
			print "	@echo $@"
		}
