Jekyll Wordpress Import Fixup -- **jwif.sh**

## What is this script for?
This is a shell script written for [Jekyll](http://jekyllrb.com) users that will fixup Wordpress posts into markdown after you've imported them into Jekyll using the [Jekyll Wordpress import tool](http://import.jekyllrb.com/docs/wordpress/).

After you've successfully imported your Wordpress site into Jekyll, you may notice that the content area of each post is still formatted in the same messy HTML created by your Wordpress editor, and not the beautiful markdown that you really want.  

You can still render and upload your site with the old messy HTML, but it may cause HTML rendering problems (as it did for me).
With well over 100 lengthy posts, manually editing each Wordpress imported post into markdown would have taken me weeks and been a real bore.

So I decided to create this shell script using stream editor that will edit hundreds or thousands of Jekyll imported Wordpress posts into proper markdown, in seconds.

This script was tested with [Amazon S3 static website hosting](http://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html), but should work fine for [GitHub pages](https://pages.github.com) as well.

***WARNING:*** This script is experimental and still under continued development.  Please, please, please, make several backups of your original posts before you attempt to use this script.

***WARNING:*** Do not run this script twice on the same set of files.  Run it once.  If you find that you need to edit the script and run it again, copy a fresh set of original .md files back into the directory.

This script uses the GNU version of sed.  If you're going to use this script on Mac OSX you'll need to install GNU sed using ```brew install gnu-sed --default-names``` (Close and reopen your terminal program after installation).  You'll know GNU sed is installed if this command works: ```sed --version```

## What does this script do?
+ Makes an untouched backup of your files in the same directory with the ```.bak``` extension.
+ Converts HTML hyperlinks into proper markdown
+ Converts HTML entities into characters
+ Converts ```<blockquote>``` sections into markdown
+ Converts image HTML into proper markdown
+ Works with image captions created in Wordpress
+ Converts headers and lists into proper markdown
+ Converts your Wordpress YouTube embeds into an iframe
+ Converts HTML emphasis like ```<strong>``` and ```<em>``` into markdown
+ Insures HTML headers and horizontal rules have proper line spacing
+ Insures bold and italic emphasis have proper placement
+ Converts simple Wordpress YouTube embeds into an iframe
+ Cleans up ```<div>``` ```<span>``` and other unnecessary html

## What do this script NOT do?
+ does nothing with table HTML
+ does nothing with code snippets
+ does nothing java scripts and ```<head>``` or ```<body>``` or other page structure HTML
+ and there's much more that it doesn't do -- please improve it!

## How do I run the script?
1. **Important:** Make several backups of your ```_posts``` directory before doing anything. In fact, you might want to test the script in a test area first and see if it works for you before you run it in your Jekyll ```_posts``` directory.
2. Place the script in your `_posts` directory where you've just imported your Wordpress posts.
3. Make it executable ```chmod +x jwif.sh```
4. Run the script ```./jwif.sh```

