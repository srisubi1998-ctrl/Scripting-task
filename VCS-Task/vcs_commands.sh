#!/bin/bash
mkdir -p VCS-Task
echo "print('initial code')" > VCS-Task/app.py
git add VCS-Task/app.py
git commit -m "Add initial app.py"
echo "# WIP stash changes" >> VCS-Task/app.py
git stash
git stash list
git stash pop
git add VCS-Task/app.py
git commit -m "Update app.py with stashed content"
git checkout -b feature-merge
echo "print('feature merge branch code')" >> VCS-Task/app.py
git add VCS-Task/app.py
git commit -m "Commit on feature-merge branch"

git checkout main
git merge feature-merge

git checkout -b feature-rebase
echo "print('rebase branch change')" >> VCS-Task/app.py
git add VCS-Task/app.py
git commit -m "Commit on feature-rebase branch"

git checkout main
echo "print('main branch update')" >> VCS-Task/app.py
git add VCS-Task/app.py
git commit -m "Main branch update before rebase"

git checkout feature-rebase
git rebase main || true
echo -e "print('initial code')\nprint('feature merge branch code')\nprint('main branch update')\nprint('rebase branch change')" > VCS-Task/app.py
git add VCS-Task/app.py
git rebase --continue

git checkout main
git merge feature-rebase
