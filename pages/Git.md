# Git

## Index

- Ignore tracked files:

  ```bash
  git update-index --assume-unchanged [<file> ...]
  ```

- Undo and start tracking again:

  ```bash
  git update-index --no-assume-unchanged [<file> ...]
  ```

- Show changes in commit:

  ```bash
  git show <commit>
  ```

## Submodules

- Add submodule:

  ```bash
  git submodule add git://…
  ```

- Clone project with submodules:

  ```bash
  git clone git://…
  ```

- Checkout submodule code:

  ```bash
  git submodule update --init
  ```

  Or:

  ```bash
  git clone --recurse-submodules git://…
  ```

- Git pull and submodule update together:

  ```bash
  git pull --recurse-submodules
  ```

- Get upstream changes:

  ```bash
  # change to submod directory and run
  git pull origin master

  # Or from main project
  git submodule update --remote --recursive
  ```

- Get diff of submodule:

  ```bash
  git diff --submodule
  ```

## Logs

### Example Graph

```
      1-2 A
     /
0-0-5-3-4 B
```

### Commits only in B

```bash
$ git log A..B
3
4
```

### Commits in A and B

```bash
$ git log A...B
1
2
3
4
```

### Common ancestor in two branches (branch point)

```bash
$ git merge-base A B
5
```

### Changes on a specific file

```bash
git log --follow <filename>
```

### Only file names

```bash
git log --name-only
```

## Branching

- Check all merged branches:

  ```bash
  git branch --merged | egrep -v "(^\*|master|develop)"
  ```

- Delete local branch:

  ```bash
  git branch --delete <branch>
  ```

- Delete remote tracking branch:

  ```bash
  git branch -dr origin/<branch>
  ```

- Delete remote branch:

  ```bash
  git push origin --delete <branch>
  ```

- Do all the above:

  ```bash
  for i in `git branch --merged | egrep -v "(^\*|master|develop)"`; do
    git branch --delete $i
    git branch -dr origin/$i
    git push origin --delete $i
  done
  ```

## Cleanup

- Revert changes on local copy:

  ```bash
  git checkout .
  ```

- Delete untracked files:

  ```bash
  git clean -f
  ```

- Delete untracked directories:

  ```bash
  git clean -d
  ```

- Delete branch:

  ```bash
  git branch -D feat
  git push origin :feat # delete remote
  git push origin --delete feat
  ```

- Undo last commit:

  ```bash
  git reset --hard HEAD~1
  ```

- Revert merge commit:

  ```bash
  git revert -m 1 <commit>
  ```

## GitLab Flow

![GitLab_Flow.png](../assets/GitLab_Flow.png)
