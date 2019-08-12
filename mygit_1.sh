git remote set-url origin https://github.com/HCarlos/CCT_iOS
git config --global user.email "r0@tecnointel.mx"
git config --global user.name "HCarlos"
git config --global color.ui true
git config core.fileMode false
git config --global push.default simple

git checkout master

git status

git add .

git commit -m "UIPE - Update 1.2 Alfa"

git push -u origin master --force

exit


