Execute the commands in a new worktree/branch for the repo.

Follow these steps:

1. cd into the main branch (Should share the name of the parent directory minus "-project"
2. Come up with a succinct branch name from $ARGUMENTS
3. Run `worktree {branch_name}` with the branch_name you came up with, which will create a new worktree and cd into it.
4. Follow instructions defined by: $ARGUMENTS
5. Your work after step 3 should be done in the worktree that was created. Do not cd back out of the worktree directory.

