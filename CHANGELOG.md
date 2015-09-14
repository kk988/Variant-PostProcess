
#Changelog

##Date: 14 Sep 2015

**bProcess.sh**
* Path to postProcess was hardcoded, fixed to use $SDIR

**postProcess.sh**
* checked to see if python was in path, if not, exported python path from paths.sh
* Same thing for tabix and samtools

**paths.sh**
* added PYTHON_PATH, TABIX_PATH, SAMTOOLS_PATH
* commented out VARIANTSPIPEDIR because that is SDIR (?right?)

**TCGA.py**
* changed Match_Norm_Sample_UUID to Matched_Norm_Sample_UUID

**README.md**
* took out (v1) because its master now, not v1 (?right?)

**CHANGELOG.md** 
* Created changelog!
