alias gs=git status

worktree(){
  project_name=${PWD##*/}
  feature_name=$1
  worktree_name="$project_name-$feature_name"
  git worktree add ../$worktree_name -b $feature_name

  cd ../$worktree_name
}


