git config --global user.name "Chris Carl"
git config --global user.email "chrisbcarl@outlook.com"

git config --global pull.rebase false  # makes merge the default rather than rebase

git config --global core.autocrlf false  # set everything to LF rather than CRLF


# merge 2 repositories - https://stackoverflow.com/a/10548919
cd path/to/project-a
git checkout some-branch

cd path/to/project-b
git remote add project-a /path/to/project-a
git fetch project-a --tags
git merge --allow-unrelated-histories project-a/some-branch
git remote remove project-a


# does it for the whole branch...
# https://github.com/newren/git-filter-repo/blob/main/INSTALL.md
pip install git-filter-repo
# https://stackoverflow.com/a/64563565
git filter-repo --invert-paths --path FORWARD_SLASH_PATH --force