git config --global user.name "Chris Carl"
git config --global user.email "chrisbcarl@outlook.com"

git config --global pull.rebase false



# does it for the whole branch...
# https://github.com/newren/git-filter-repo/blob/main/INSTALL.md
pip install git-filter-repo
# https://stackoverflow.com/a/64563565
git filter-repo --invert-paths --path FORWARD_SLASH_PATH --force