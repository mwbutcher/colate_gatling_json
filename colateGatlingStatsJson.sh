# Gatling doesn't store result data in a json file.  They store it in a javascript file (stats.js).
# The statements in this script parse that js file and extract the json so that
# it can be parsed by a clojure library.

baseDir=`pwd`
targetDir=${1?}
scenarioName=${2?}
cd ${targetDir?}
filename="output`date +%s`.csv"
echo 'getting a list of reports to parse'
ls -d */ -r > reportdirsRev.txt

while read p; do
#   extracting json
    sed s/var\ stats\ \=\ \{/\{/ ${p}/js/stats.js > ${p}/js/stats2.js
    head -n 553 ${p}/js/stats2.js > ${p}/js/tmp.json;
    cat ${p}/js/tmp.json > ${p}/js/stats.json
    \rm -f ${p}/js/tmp.json
    \rm -f ${p}/js/stats2.js

#   Also, the json Gatling generates is non-compliant.
#   fixing json structure
    sed -i '' s/name\:/\"name\"\:/ ${p}/js/stats.json
    sed -i '' s/type\:/\"type\"\:/ ${p}/js/stats.json
    sed -i '' s/path\:/\"path\"\:/ ${p}/js/stats.json
    sed -i '' s/pathFormatted\:/\"pathFormatted\"\:/ ${p}/js/stats.json
    sed -i '' s/stats\:/\"stats\"\:/ ${p}/js/stats.json
    sed -i '' s/contents\:/\"contents\"\:/ ${p}/js/stats.json

#   fixing file meta names
    sed -i '' s/\"filemeta-[0-9,a-z]*\"/\"filemetas\"/  ${p}/js/stats.json
done <  reportdirsRev.txt

cd ${baseDir}
echo 'running the parser'

lein run ${targetDir?} ${scenarioName?}

# put a datestamp on the output filename
mv output.csv ${filename}

# cleaning up the output so it can be imported into google docs
echo 'cleaning up the output'
sed -i '' 's/\"\ \"/,/g' ${filename}
perl -pi -e 's/\"\)\(\(\#\"/\n/mg' ${filename}
perl -pi -e 's/\"\)\ \(\#\"/\n/mg' ${filename}
sed -i '' s/\-\.\{5\}// ${filename}
sed -i '' s/^\(\"// ${filename}
sed -i '' s/\"\)\)// ${filename}
perl -pi -e 's/-\[0-9a-z\]\*//g' ${filename}
