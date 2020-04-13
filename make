#!/bin/sh -e
#
# Simple static site builder.

name="ARYA"

cat <<EOF > /tmp/meow
<!doctype html><html lang=en>
<link href='data:image/gif;base64,R0lGODlhEAAQAPH/AAAAAP8AAP8AN////yH5BAUAAAQALAAAAAAQABAAAAM2SLrc/jA+QBUFM2iqA2bAMHSktwCCWJIYEIyvKLOuJt+wV69ry5cfwu7WCVp2RSPoUpE4n4sEADs=' rel=icon><title>"$name"'s Art Manager</title>
<meta charset=utf-8><meta name=Description content="A collection of reviews and rememberances for some of the art I have consumed"><style>body{text-align:center;overflow-y:scroll;font:calc(0.75em + 1vmin) monospace}pre pre{text-align:left;display:inline-block}img{max-width:57ch;display:block;height:auto;width:100%}@media(prefers-color-scheme:dark){body{background:#000;color:#fff}a{color:#6CF}}</style><pre>
<a href=/><b>KISS</b></a><span style='color:#e60000'> 💋</span>  <a href=/books>Books</a>  <a href=/movies>Movies</a>  <a href=/tv_shows>TV Shows</a>  <a href=/vis_art>Visual Art</a> <a href=https://github.com/aryakaul/art_mgr>Github -&gt;</a>
</pre>
EOF

rm    -f  docs/*.txt docs/*.html
mkdir -p  docs
cd        docs

# Iterate over each file in the source tree under /site/.
(cd ../si*; find . -type f -a -not -path \*/\.\* -a -not -path ./templates/\*) |

while read -r page; do
    mkdir -p "${page%/*}"

    case $page in
        *.txt)
            sed -E "s|([^=][^\'\"])(https[:]//[^ )]*)|\1<a href='\2'>\2</a>|g" \
                "../site/$page" |

            sed -E "s|^(https[:]//[^ )]{50})([^ )]*)|<a href='\0'>\1</a>|g" |

            sed '/%%CONTENT%%/r /dev/stdin' /tmp/meow |
            sed '/%%CONTENT%%/d' |

            sed "s	%%SOURCE%%	/${page##./}	" \
                > "${page%%.txt}.html"

            ln -f "../site/$page" "$page"

            printf '%s\n' "CC $page"
        ;;

        # Copy over any images or non-txt files.
        *)
            cp "../site/$page" "$page"

            printf '%s\n' "CP $page"
        ;;
    esac
done

# Workaround for broken repology link.
#mkdir -p p, , ackage-system
#ln -sf ../package-system.html package-system/index.html
