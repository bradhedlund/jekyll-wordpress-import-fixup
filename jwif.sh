#!/bin/bash

# This script is specifically designed to clean up and reformat html to markdown for Wordpress posts imported into Jekyll using the Jekyll Wordpress Import tool.
# This script uses GNU sed. If you're using Mac OSX see this: http://stackoverflow.com/questions/30003570/how-to-use-gnu-sed-on-mac-os-x
# Note: This script uses the inverted interrobang and doubledagger characters as handlers: ⸘ ‡
# If your content uses these characters, find/replace them with an equally obscure character not found in your content or this script.
# Suggestions for other handlers might be: § † ‱ ❡
echo 'Jekyll Wordpress Import Fixup'
echo '-----------------------------'
echo 'Creating .bak backup of all .md files...'
echo 'Replacing HTLM entities...'
# Replace HTML entities with actual character and create original .bak backup files
sed -r -i.bak '
s/&#47;/\//g
s/%2F/\//g
s/&nbsp;/ /g
s/&mdash;/--/g
s/&ndash;/--/g
s/&amp;/\&/g
s/&ldquo;/"/g
s/&rdquo;/"/g
' *.md

sed -r -i.bak2 "s/&rsquo;/\'/g" *.md

echo 'Placing hyperlink markers...'
# Place a marker around hyperlink URLs. Protect original .bak files by calling bak2 from now on.
sed -r -i.bak2 '
s/href="[^"]*"/⸘-urlMarker1-⸘&⸘-urlMarker2-⸘/g
' *.md

echo 'Spacing paragraphs...'
# Make sure paragraphs are separated by a blank line. Insert a blank line below </p>.
sed -i.bak2 '/<\/p>/G' *.md

echo 'Removing whitepace inside emphasis...'
# Remove whitepace between bold or emphasis and the text it surrounds
sed -r -i.bak2 '
s|<strong>[ ]*|<strong>|g
s|[ ]*</strong>|</strong>|g
s|<em>[ ]*|<em>|g
s|[ ]*</em>|</em>|g
' *.md

echo 'Inserting whitepace outside emphasis...'
# Insert whitespace before and after bold or emphasis
sed -r -i.bak2 '
s|(</strong>)([^ ])|\1 \2|g
s|([^ ])(<strong>)|\1 \2|g
s|(</em>)([^ ])|\1 \2|g
s|([^ ])(<em>)|\1 \2|g
' *.md

echo 'Replacing HTML lists and emphasis with markdown...'
# Replace html emphasis and list items with markdown
sed -r -i.bak2 '
s/<li>/+ /g
s/<strong><em>/***/g
s/<em><strong>/***/g
s/<\/em><\/strong>/***/g
s/<\/strong><\/em>/***/g
s/<strong>/**/g
s/<\/strong>/**/g
s/<em>/_/g
s/<\/em>/_/g
' *.md

echo 'Cleaning up list, line break, and paragraph HTML...'
# Clean up simple list, line break, and paragraph html
sed -r -i.bak2 '
s/<\/li>//g
s/<ol>//g
s/<\/ol>//g
s/<p[^>]*>//g
s/<\/p>//g
s/<br[^>]*>//g
s/<ul>//g
s/<\/ul>//g
' *.md

echo 'Placing a marker on image captions...'
# mark image captions
sed -r -i.bak2 '
s|\[/caption\]|‡-captionMarker2-‡|g
s|>([^>]*)‡-captionMarker2-‡|>‡-captionMarker1-‡\1‡-captionMarker2-‡|g
' *.md

echo 'Cleaning up image captions...'
# Cleanup wordpress image [caption]
sed -r -i.bak2 '
s|\[caption[^]]*\]||g
' *.md

echo 'Placing handlers for images...'
# Place a temporary handler ahead of src=" for img
sed -r -i.bak2 '
/<img / s/src="/‡&/g
' *.md

# Place a leading marker for images
sed -r -i.bak2 '
s/‡src="/⸘-imgMarker1-⸘/g
' *.md

echo 'Placing handlers and makers for hyperlinks... '
# Place a temporary handler ahead of </a>
sed -r -i.bak2 '
s_</a>_‡&_g
' *.md

# Place a marker around clickable content
sed -r -i.bak2 '
s_⸘-urlMarker2-⸘[^>]*>([^‡]*)‡</a>_⸘-urlMarker2-⸘‡-clickMarker1-‡\1‡-clickMarker2-‡_g
' *.md

echo 'Cleaning up hyperlink HTML...'
# Cleanup <a href=" and "
sed -r -i.bak2 '
s/<a[^⸘]*⸘-urlMarker1-⸘href="/⸘-urlMarker1-⸘/g
s/"⸘-urlMarker2-⸘/⸘-urlMarker2-⸘/g
' *.md

echo 'Placing markers for image HTML...'
# Place a marker around img src urls
sed -r -i.bak2 '
s/⸘-imgMarker1-⸘/&⸘-imgSrcMarker1-⸘/g
s/⸘-imgSrcMarker1-⸘[^"]*/&⸘-imgSrcMarker2-⸘/g
s/⸘-imgSrcMarker2-⸘"/⸘-imgSrcMarker2-⸘/g
' *.md

# Place marker around img alt text
sed -r -i.bak2 '
/⸘-imgMarker1-⸘/ s/alt="[^"]*"/&⸘-altMarker2-⸘/g
/⸘-imgMarker1-⸘/ s/alt="/⸘-altMarker1-⸘&/g
' *.md

echo 'Cleaning up image HTML...'
# Remove img width and height if it exists
sed -r -i.bak2 '
/⸘-imgSrcMarker1-⸘/ s/width="[0-9][0-9][0-9]?"//g
/⸘-imgSrcMarker1-⸘/ s/height="[0-9][0-9][0-9]?"//g
' *.md

# Clean up alt=""
sed -r -i.bak2 '
s/⸘-altMarker1-⸘alt="/⸘-altMarker1-⸘/g
s/"⸘-altMarker2-⸘/⸘-altMarker2-⸘/g
' *.md

## Reorder img markers.
# Move Alt text ahead of the img src URL
sed -r -i.bak2 '
s/(⸘-imgSrcMarker1-⸘[^⸘]*⸘-imgSrcMarker2-⸘)[^⸘]*(⸘-altMarker1-⸘[^⸘]*⸘-altMarker2-⸘)/\2\1/g
' *.md

# Move imgMarker1 ahead of Alt markers if needed
sed -r -i.bak2 '
s/(⸘-altMarker1-⸘[^⸘]*⸘-altMarker2-⸘)[^⸘]*(⸘-imgMarker1-⸘)/\2\1/g
' *.md

# Clean up <img to imgMarker1
sed -r -i.bak2 '
s/<img[^⸘]*⸘-imgMarker1-⸘/⸘-imgMarker1-⸘/g
' *.md

# Tighten up img marker1 to altMarker1
sed -r -i.bak2 '
s/⸘-imgMarker1-⸘[^⸘]*⸘-altMarker1-⸘/⸘-imgMarker1-⸘⸘-altMarker1-⸘/g
' *.md

# Tighten up altMarker2 to imgSrcMarker1
sed -r -i.bak2 '
s/⸘-altMarker2-⸘[^⸘]*⸘-imgSrcMarker1-⸘/⸘-altMarker2-⸘⸘-imgSrcMarker1-⸘/g
' *.md

# Tighten up imgSrcMarker2 to clickMarker2 if we're dealing with a clickable image
sed -r -i.bak2 '
s/⸘-imgSrcMarker2-⸘[^⸘]*‡-clickMarker2-‡/⸘-imgSrcMarker2-⸘‡-clickMarker2-‡/g
' *.md

# Remove whitespace from caption markers to caption text
sed -r -i.bak2 '
s/‡-captionMarker1-‡[ ]*/‡-captionMarker1-‡/g
s/[ ]*‡-captionMarker2-‡/‡-captionMarker2-‡/g
' *.md

# After tightening lets make sure there's a clickMarker1 in the right spot if wer're dealing with a clickable image
sed -r -i.bak2 '
s/⸘-urlMarker2-⸘[^⸘]*⸘-imgMarker1-⸘/⸘-urlMarker2-⸘‡-clickMarker1-‡⸘-imgMarker1-⸘/g
' *.md

# Place image captions on the line below the image (clickable image)
sed -r -i.bak2 '
s/‡-clickMarker2-‡[^‡]*‡-captionMarker1/‡-clickMarker2-‡\n‡-captionMarker1/g
' *.md

# Place image captions on the line below the image (no clickable image)
sed -r -i.bak2 '
s/⸘-imgSrcMarker2-⸘[^‡]*‡-captionMarker1/⸘-imgSrcMarker2-⸘\n‡-captionMarker1/g
' *.md

# Move clickable text or image before its url target
sed -r -i.bak2 '
s/(⸘-urlMarker1-⸘[^⸘]*⸘-urlMarker2-⸘)[^‡]*(‡-clickMarker1-‡[^‡]*‡-clickMarker2-‡)/\2\1/g
' *.md

# Fixup headers
# Make sure there's an empty line above the header. Append a blank line above header html.
sed -r -i.bak2 '
/<[h,H][1-6]>/{x;p;x;}
' *.md

# Replace header html with markdown
sed -r -i.bak2 '
s/<[h,H]1>/# /g
s/<[h,H]2>/## /g
s/<[h,H]3>/### /g
s/<[h,H]4>/#### /g
s/<[h,H]5>/##### /g
s/<[h,H]6>/###### /g
' *.md

# Clean up leftover header html
sed -r -i.bak2 '
s/<\/[H][1-6]>//ig
' *.md

# Find a range of text encapsulated by <blockquote> and convert it to markdown by preceding each line with >
sed -r -i.bak2 '
/<blockquote>/,/<\/blockquote>/ s/^./> &/g
' *.md

# Insert a blank line below </blockquote>.
sed -i.bak2 '/<\/blockquote>/G' *.md

# Now remove the <blockquote> html
sed -r -i.bak2 '
s/<blockquote>//g
s/<\/blockquote>//g
' *.md

# Make sure there's a blank line above and below horizontal rule html
sed -r -i.bak2 '
/<hr[ ]?[\/]?>/{x;p;x;G;}
' *.md

# Replace horizontal rule html with markdown
sed -r -i.bak2 '
s/<hr[ ]?[\/]?>/---/g
' *.md

# Find and remove <div> html
sed -r -i.bak2 '
s/<div [^>]*>//g
s/<\/div>//g
' *.md

# Find and remove <span> html
sed -r -i.bak2 '
s/<span [^>]*>//g
s/<\/span>//g
' *.md

# Find and remove <address> html
sed -r -i.bak2 '
s/<address>//g
s/<\/address>//g
' *.md

# YouTube embeds:
# When using Wordpress you embed YouTube videos by placing the YouTube URL on a line by itself (or using Wordpress shortcode) and Wordpress will embed automatically at page load time.
# Lets find YouTube links and put them in an iframe for embedding, which IMO, still works better than markdown embeds.
# But first lets make sure the YouTube link is not a hyperlink or already embeded with an iframe.  If it's either, we'll leave it alone.
# We'll know it's not a hyperlink becuase we'll match youtube URLs only at the beginning of a line.
# We're assuming all YouTube identifiers are exactly 11 characters long.
# You can adjust the width and height settings if necessary, or just remove them.

# Match and remove Wordpress short code if it exists
sed -r -i.bak2 '
s/\[ youtube (http[s]?\:\/\/[w]{0,3}[\.]?youtube\.com\/watch\?v=[0-9a-zA-Z]{11}) ]/\1/g
s/\[ youtube (http[s]?\:\/\/youtu\.be\/[0-9a-zA-Z]{11}) ]/\1/g
' *.md

# Match youtu.be and www.youtube.com/watch?v= -- and wrap with iframe if the YouTube url begins a line.
sed -r -i.bak2 '
/^http[s]?\:\/\/youtu\.be/ s/http[s]?\:\/\/youtu\.be\/[0-9a-zA-Z]{11}/<iframe title="YouTube video player" width="560" height="315" src="&?rel=0" frameborder="0" allowfullscreen><\/iframe>/g
/^http[s]?\:\/\/[w]{0,3}[\.]?youtube\.com\/watch\?v=/ s/http[s]?\:\/\/[w]{0,3}[\.]?youtube\.com\/watch\?v=[0-9a-zA-Z]{11}/<iframe title="YouTube video player" width="560" height="315" src="&?rel=0" frameborder="0" allowfullscreen><\/iframe>/g
' *.md

# Final markdown formatting.  Replace the makers and handlers with markdown.

# Replace clickmarkers with [] to surround the clickable content
sed -r -i.bak2 '
s/‡-clickMarker1-‡/\[/g
s/‡-clickMarker2-‡/\]/g
' *.md

# Replace urlmarkers with () to surrond the target URL
sed -r -i.bak2 '
s/⸘-urlMarker1-⸘/\(/g
s/⸘-urlMarker2-⸘/\)/g
' *.md

# Replace image marker with !
sed -r -i.bak2 '
s/⸘-imgMarker1-⸘/\!/g
' *.md

# Replace img alt markers with [] to surround the img alt text
sed -r -i.bak2 '
s/⸘-altMarker1-⸘/\[/g
s/⸘-altMarker2-⸘/\]/g
' *.md

# Replace img src markers with () to surround the img src URL
sed -r -i.bak2 '
s/⸘-imgSrcMarker1-⸘/\(/g
s/⸘-imgSrcMarker2-⸘/\)/g
' *.md

# Replace caption markers with emphasis
sed -r -i.bak2 '
s/‡-captionMarker[1-2]-‡/*/g
' *.md

# Final cleanup

# Cleanup whitespace at the beginning or end of a line.
sed -r -i.bak2 '
s/^[ \t]+|[ \t]+$//g
' *.md

# Remove any leftover />
sed -r -i.bak2 '
s|/>$||g
' *.md

echo 'Cleaning up working files.'
rm *.bak2
echo 'All finished!'
