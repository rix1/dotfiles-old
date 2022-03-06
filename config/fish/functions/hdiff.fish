function hdiff
    echo "running: heroku pipelines:diff -a $1-staging"
    heroku pipelines:diff -a $argv-staging
end
