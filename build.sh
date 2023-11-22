rm -fr docs
hugo
mv public docs
eval `ssh-agent`
ssh-add ~/.ssh/privato

git config user.name "Marco Carnini"
git config user.email "marcocarnini@gmail.com"
git add --all
git commit -m "Updating site"
