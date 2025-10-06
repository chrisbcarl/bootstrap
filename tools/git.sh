git config --global user.name "Chris Carl"
git config --global user.email "chrisbcarl@outlook.com"

git config --global pull.rebase false  # makes merge the default rather than rebase

git config --global core.autocrlf false  # set everything to LF rather than CRLF


# merge 2 repositories - merge project b INTO project a - (modified from) https://stackoverflow.com/a/10548919
cd path/to/project-a
git checkout main
git remote add project-b /path/to/project-b
git fetch project-b --tags
git merge --allow-unrelated-histories project-b/main
git remote remove project-b


# does it for the whole branch...
# https://github.com/newren/git-filter-repo/blob/main/INSTALL.md
pip install git-filter-repo
# https://stackoverflow.com/a/64563565
git filter-repo --invert-paths --path FORWARD_SLASH_PATH --force