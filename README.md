# beco-project
main repo of the project, we will try to keep it as a monorepo and work by branches

## Workflow

Create a new branch where `<new_branch>` is the `<issue_number>` + `-<issue_name>` , e.g. `1-define-repo-structure`:
```
git checkout -b <new_branch>
git push -u origin <new_branch>
```
Work on the branch and when you are finished just commit and push the changes.    
Then create a Pull Request (PR) and wait for its merging :)

The issue associated will be closed and the task on the kanban will automatically be marked as "completed".

(Alternatively you can do this through github GUI)


count lines of code: (crec)
```
git ls-files | xargs wc -l
```
