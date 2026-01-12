## Index

    - Ignore tracked files
      `git update-index --assume-unchanged [<file> ...]`
    - To undo and start tracking again
      `git update-index --no-assume-unchanged [<file> ...]
    - show changes in commit
      `git show <commit>`

- ## Submodules
  - add submodule `git submodule add git://…`
  - clone project with submodules `git clone git://…`
  - checkout submodule code `git submodule update --init` or
    `git clone --recurse-submodules git://…`
  - git pull and submodule update together `git pull --recurse-submodules`
  - get upstream changes

    ```
    # change to submod directory and run
    git pull origin master

    # Or from main project
    git submodule update --remote --recursive
    ```

  - get diff of submodule `git diff --submodule`

- ## Logs
  - Example collapsed:: true

    ```
        1-2 A
       /
    0-0-5-3-4 B
    ```

    - commits only in B
      ```
      $ git log A..B
      3
      4
      ```
    - commits in A and B
      ```
      $ git log A...B
      1
      2
      3
      4
      ```
    - common ancestor in two branches (branch point)
      ```
      $ git merge-base A B
      5
      ```

  - changes on a specific file  
    `git log --follow <filename>`
  - only file names `git log --name-only`

- ## Branching
  - Check all merged branches
    `git branch --merged | egrep -v "(^\*|master|develop)`
  - delete local branch  
    `git branch --delete <branch>`
  - delete remote tracking branch  
    `git branch -dr origin/<branch>`
  - delete remote branch  
    `git push origin --delete <branch>`
  - do all the above
    ```
    for i in `git branch --merged | egrep -v "(^\*|master|develop)"`; do git branch --delete $i; git branch -dr origin/$i; git push origin --delete $i; done
    ```
- ## Cleanup
  - revert changes on local copy  
    `git checkout .`
  - delete untracked files  
    `git clean -f`
  - delete untracked dir  
    `git clean -d`
  - delete branch
    ```
    git branch -D feat
    git push origin :feat # delete remote
    git push origin --delete feat
    ```
  - undo last commit  
    `git reset --hard HEAD~1`
  - revert merge commit  
    `git revert -m 1 <commit>`
- ## GitLab flow
- ![GitLab_Flow.png](../assets/GitLab_Flow.png)
