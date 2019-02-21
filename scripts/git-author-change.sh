#!/bin/sh

##
# Based on https://help.github.com/articles/changing-author-info/
#

REPOS="\
foo
bar
baz
"

OLD_EMAIL=""
CORRECT_NAME="Brian H. Buchholz"

CORRECT_EMAIL="4773480+bhb603@users.noreply.github.com"
HOST=git@github.com:bhb603

CORRECT_EMAIL="3230751-bhb603@users.noreply.gitlab.com"
HOST=git@gitlab.com:bhb603

DIR=$(pwd)

change_author_info()
{
  git filter-branch --env-filter '

  if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
  then
      export GIT_COMMITTER_NAME="$CORRECT_NAME"
      export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
  fi
  if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
  then
      export GIT_AUTHOR_NAME="$CORRECT_NAME"
      export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
  fi
  ' --tag-name-filter cat -- --branches --tags
}


for repo in $REPOS; do
  echo "Cloning $repo"
  git clone --bare "$HOST/$repo.git"
  cd "$repo.git"
  change_author_info
  git push --force --tags origin 'refs/heads/*'
  cd "$DIR"
  rm -rf "$repo.git"
done
