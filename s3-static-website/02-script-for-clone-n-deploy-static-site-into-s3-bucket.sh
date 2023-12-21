# clone repo for source code
git clone https://github.com/Hamid-R1/multipages-static-website-for-s3-bucket.git

# change directory
cd multipages-static-website-for-s3-bucket/

# check all contents
ls
contact.html  css/  fonts/  images/  index.html  js/  LICENSE  README.md  topics-detail.html  topics-listing.html

# remove .git folder
rm -rf .git/

# # copy all contents (except LICENSE, README.md) from currect directory to S3 Bucket
aws s3 sync . s3://staticwebsite-hr-123456"/ --exclude "LICENSE" --exclude "README.md"
