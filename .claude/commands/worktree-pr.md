Execute the commands in a new worktree/branch for the repo.

Follow these steps:

1. `cd` into the main git repo of the project defined in the `.claude/README.md` file.
2. Come up with a succinct branch name that encapsulates the task defined by the feature request: $ARGUMENTS
3. Run `worktree {branch_name}` with the branch_name you came up with, which will create a new worktree and cd into it.
4. DO NOT cd back into the main repo. Make all changes in the worktree directory that was created by the `worktree` command.
5. Follow instructions defined by: $ARGUMENTS
6. Run all tests. Make sure they are all passing.
7. Make sure there are no tokens, secrets, and private information that will be commited. If there are, follow the "Security Best Practices" defined in the README.md to ensure they aren't committed and/or pushed up to github.
8. Once all tests are passing, commit your changes.
9. Push up your branch.
10. Open a pull request against the master branch.
