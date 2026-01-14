# Git

## Index

- Ignore tracked files: `git update-index --assume-unchanged [<file> ...]`
- Undo and start tracking again:
  `git update-index --no-assume-unchanged [<file> ...]`
- Show changes in commit: `git show <commit>`

## Submodules

- Add submodule: `git submodule add git://…`
- Clone project with submodules: `git clone git://…`
- Checkout submodule code: `git submodule update --init` or
  `git clone --recurse-submodules git://…`
- Git pull and submodule update together: `git pull --recurse-submodules`
- Get upstream changes:

  ```
  # change to submod directory and run
  git pull origin master

  # Or from main project
  git submodule update --remote --recursive
  ```

- Get diff of submodule: `git diff --submodule`

## Logs

- Example:

  ```
      1-2 A
     /
  0-0-5-3-4 B
  ```

  - Commits only in B:

    ```
    $ git log A..B
    3
    4
    ```

  - Commits in A and B:

    ```
    $ git log A...B
    1
    2
    3
    4
    ```

  - Common ancestor in two branches (branch point):

    ```
    $ git merge-base A B
    5
    ```

- Changes on a specific file: `git log --follow <filename>`
- Only file names: `git log --name-only`

## Branching

- Check all merged branches:
  `git branch --merged | egrep -v "(^\*|master|develop)"`
- Delete local branch: `git branch --delete <branch>`
- Delete remote tracking branch: `git branch -dr origin/<branch>`
- Delete remote branch: `git push origin --delete <branch>`
- Do all the above:

  ```
  for i in `git branch --merged | egrep -v "(^\*|master|develop)"`; do
    git branch --delete $i
    git branch -dr origin/$i
    git push origin --delete $i
  done
  ```

## Cleanup

- Revert changes on local copy: `git checkout .`
- Delete untracked files: `git clean -f`
- Delete untracked dir: `git clean -d`
- Delete branch:

  ```
  git branch -D feat
  git push origin :feat # delete remote
  git push origin --delete feat
  ```

- Undo last commit: `git reset --hard HEAD~1`
- Revert merge commit: `git revert -m 1 <commit>`

## GitLab Flow

![GitLab_Flow.png](../assets/GitLab_Flow.png)
