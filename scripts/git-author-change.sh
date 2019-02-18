#!/bin/sh

##
# Based on https://help.github.com/articles/changing-author-info/
#

repos="\
foo
bar
"

dir=$(pwd)

change_author_info()
{
  git filter-branch --env-filter '

  OLD_EMAIL="foo@bar.com"
  OLD_EMAIL_2="bar@baz.com"
  CORRECT_NAME="Foo J. Bar"
  CORRECT_EMAIL="anon@users.noreply.github.com"

  if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ] || [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL_2" ]
  then
      export GIT_COMMITTER_NAME="$CORRECT_NAME"
      export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
  fi
  if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ] || [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL_2" ]
  then
      export GIT_AUTHOR_NAME="$CORRECT_NAME"
      export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
  fi
  ' --tag-name-filter cat -- --branches --tags
}


for repo in $repos; do
  echo "Cloning $repo"
  git clone --bare "git@github.com:bhb603/$repo.git"
  cd "$repo.git"
  change_author_info
  git push --force --tags origin 'refs/heads/*'
  cd "$dir"
  rm -rf "$repo.git"
done
