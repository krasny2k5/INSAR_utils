#!/bin/bash

###############################################
### BIG DEM GENERATOR FOR IBERIAN PENINSULA ###
###  Joaquin Escayo 2016 j.escayo@csic.es   ###
###############################################
#
# IMPORTANT: THIS PROGRAM USES GDAL 2.0.2. OTHER VERSION MAY NOT WORK AS INTENDED.
# version 4.0 17/02/2016 
# TO-DO:
# 1. Check if user has write permission on output directory.
# 2. Some files has spaces after the extension, for examaple "MDT25-0000-LIDAR.zip      ". Checking and removal of this problem.
# 3. Test for MDT05 (not tested)

# IMPORTANT:
# Some zip files has directories inside (WTF?!), used -j option in unzip command to avoid directory recreation in output directory
# Used -o option to avoid problems with sheet 1032B (it's currently on 1033 file). TO-DO: Inform IGN about this error.


# USAGE:
# wap_dem_generator.sh directory_of_ign_files output_directory

# Bold text variables
bold=$(tput bold)
normal=$(tput sgr0)

# Debugging output, if $DEBUG=1 verbose mode is active.

DEBUG=0

# Parsing of initial directories

if [ -z "$1" ]; then
	echo "########################  ERROR  ############################"	
	echo "                    DEM FILES NOT FOUND"
    echo "Usage this program as follows:"
	echo "wap_dem_generator.sh directory_of_ign_files [output_directory]"
    echo "To use current directory use . , output directory is optional"
    echo "#############################################################"
    exit
elif [ $1 == "." ]; then
	DEMFILES=$(pwd)
else
	DEMFILES=$1/
fi

if [ -z "$2" ]; then
    echo "######################################"
    echo "No output directory has been specified"
    echo "same folder as dem files will be used"
    echo "Do you want continue?"
    read -p "Press [Enter] to continue"
    TEMPDIR=$DEMFILES/temp
    RESULTDIR=$DEMFILES/results
elif [ $2 == "." ]; then
	TEMPDIR=$(pwd)/temp
    RESULTDIR=$(pwd)/results
else
    TEMPDIR=$2/temp
    RESULTDIR=$2/results
fi

if [ -f $DEMFILES/EGM08_REDNAP.asc ]; then
    echo "GEOID FILE FOUND"
    GEOID=$DEMFILES/EGM08_REDNAP.asc
else
    echo "####################################"
    echo "       GEOID FILE NOT FOUND"
    echo "Place geoid file (EGM08_REDNAP.asc)"
    echo "in the same directory as MDT files"
    echo "####################################"
    exit
fi

if [ $DEBUG == 1 ]; then
    echo "DEMFILES DIRECTORY" $DEMFILES
    echo "TEMPDIR DIRECTORY" $TEMPDIR
    echo "RESULTDIR DIRECTORY" $RESULTDIR
    echo "GEOID FILE:" $GEOID
fi

# Selection of MDT(05,25,200) (not tested for MDT200 or MDT05)
MDT=25

# check if path exists, if not create temp directory:
if [ ! -d "$TEMPDIR" ]; then
    mkdir $TEMPDIR
else
    echo "TEMP DIR ALREADY EXISTS!"
    echo "remove this directory"
    echo $TEMPDIR
    echo "and run the program again"
    exit
fi

# check if path exists, if not create results directory:
if [ ! -d "$RESULTDIR" ]; then
    mkdir $RESULTDIR
else
    echo "RESULTS DIRECTORY ALREADY EXISTS"
    echo "remove this directory"
    echo $RESULTDIR
    echo "and run the program again"
    exit
fi



# Old method variables, keeped only as information
#utm29="0001 0002 0003 0006 0007 0008 0009 0010 0011 0012 0013 0020 0021 0022 0023 0024 0025 0026 0027 0028 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0092 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0260 0261 0262 0263 0264 0265 0266 0267 0268 0269 0298 0299 0300B 0300 0301 0302B 0302 0303B 0303 0304 0305 0306 0307 0336 0337 0338 0339 0367 0368 0395 0396 0422 0423 0424 0449 0450 0451 0474 0475 0476 0477 0500 0501 0502 0525 0526 0527 0550 0551 0552 0572 0573 0574 0575 0595 0596 0597 0598 0620 0621 0622 0623 0648 0649 0650 0651 0674 0675 0676 0677 0678 0679 0701 0702 0703 0704 0705 0726 0727 0728 0729 0730 0750 0751 0752 0753 0775 0776 0777 0778 0800 0801 0802 0803 0804 0826 0827 0828 0829 0830 0851 0852 0853 0854 0855 0873 0874 0875 0876 0877 0895 0896 0897 0898 0915 0916 0917 0918 0919 0936 0937 0938 0939 0940 0958 0959 0960 0961 0962 0980 0981 0982 0983 0984 0998 0999 1000 1001 1002 1016 1017 1018 1019 1032B 1033 1034 1047 1048 1061 1062 1068 1069 1073 1076"
#utm30="0014 0015 0018 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0091B 0103 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0145B 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244 0245 0246 0247 0248 0270 0271 0272 0273 0274 0275 0276 0277 0278 0279 0280 0281 0282 0283 0284 0285 0286 0308 0309 0310 0311 0312 0313 0314 0315 0316 0317 0318 0319 0320 0321 0322 0323 0324 0340 0341 0342 0343 0344 0345 0346 0347 0348 0349 0350 0351 0352 0353 0354 0355 0356 0369 0370 0371 0372 0373 0374 0375 0376 0377 0378 0379 0380 0381 0382 0383 0384 0385 0397 0398 0399 0400 0401 0402 0403 0404 0405 0406 0407 0408 0409 0410 0411 0412 0413 0425 0426 0427 0428 0429 0430 0431 0432 0433 0434 0435 0436 0437 0438 0439 0440 0441 0452 0453 0454 0455 0456 0457 0458 0459 0460 0461 0462 0463 0464 0465 0466 0467 0468 0478 0479 0480 0481 0482 0483 0484 0485 0486 0487 0488 0489 0490 0491 0492 0493 0494 0503 0504 0505 0506 0507 0508 0509 0510 0511 0512 0513 0514 0515 0516 0517 0518 0519 0528 0529 0530 0531 0532 0533 0534 0535 0536 0537 0538 0539 0540 0541 0542 0543 0544 0553 0554 0555 0556 0557 0558 0559 0560 0561 0562 0563 0564 0565 0566 0567 0568 0569 0576 0577 0578 0579 0580 0581 0582 0583 0584 0585 0586 0587 0588 0589 0590 0591 0592 0599 0600 0601 0602 0603 0604 0605 0606 0607 0608 0609 0610 0611 0612 0613 0614 0615 0624 0625 0626 0627 0628 0629 0630 0631 0632 0633 0634 0635 0636 0637 0638 0639 0640 0652 0653 0654 0655 0656 0657 0658 0659 0660 0661 0662 0663 0664 0665 0666 0667 0668 0680 0681 0682 0683 0684 0685 0686 0687 0688 0689 0690 0691 0692 0693 0694 0695 0696 0706 0707 0708 0709 0710 0711 0712 0713 0714 0715 0716 0717 0718 0719 0720 0721 0722 0731 0732 0733 0734 0735 0736 0737 0738 0739 0740 0741 0742 0743 0744 0745 0746 0747 0754 0755 0756 0757 0758 0759 0760 0761 0762 0763 0764 0765 0766 0767 0768 0769 0770 0779 0780 0781 0782 0783 0784 0785 0786 0787 0788 0789 0790 0791 0792 0793 0794 0795 0805 0806 0807 0808 0809 0810 0811 0812 0813 0814 0815 0816 0817 0818 0819 0820 0821 0831 0832 0833 0834 0835 0836 0837 0838 0839 0840 0841 0842 0843 0844 0845 0846 0847 0856 0857 0858 0859 0860 0861 0862 0863 0864 0865 0866 0867 0868 0869 0870 0871 0872 0878 0879 0880 0881 0882 0883 0884 0885 0886 0887 0888 0889 0890 0891 0892 0893 0894 0899 0900 0901 0902 0903 0904 0905 0906 0907 0908 0909 0910 0911 0912 0913 0914 0920 0921 0922 0923 0924 0925 0926 0927 0928 0929 0930 0931 0932 0933 0934 0935 0941 0942 0943 0944 0945 0946 0947 0948 0949 0950 0951 0952 0953 0954 0955 0956 0963 0964 0965 0966 0967 0968 0969 0970 0971 0972 0973 0974 0975 0976 0977 0978 0985 0986 0987 0988 0989 0990 0991 0992 0993 0994 0995 0996 0997 0997B 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 1030 1031 1032 1035 1036 1037 1038 1039 1040 1041 1042 1043 1044 1045 1046 1049 1050 1051 1052 1053 1054 1055 1056 1057 1058 1059 1060 1063 1064 1065 1066 1067 1070 1071 1072 1072B 1074 1075 1077 1078"
#utm31="0118B 0146 0147 0148 0149B 0149 0150 0178 0179 0180 0181 0182 0183 0211 0212 0213 0214 0215 0216 0217B 0217 0218 0219 0220 0221 0249 0250 0251 0252 0253 0254 0255 0256 0257 0258 0259 0287 0288 0289 0290 0291 0292 0293 0294 0295 0296 0297 0325 0326 0327 0328 0329 0330 0331 0332 0333 0334 0335 0357 0358 0359 0360 0361 0362 0363 0364 0365 0366 0386 0387 0388 0389 0390 0391 0392 0393 0394 0414 0415 0416 0417 0418 0419 0420 0421B 0421 0442 0443 0444 0445 0446 0447 0448 0469 0470 0471 0472 0473B 0473 0495 0496 0497 0498 0520 0521 0522 0523 0545 0546 0547 0570 0571B 0571 0593 0594 0616 0617 0641 0669 0771 0796 0822 0823 0848"

files="0001 0002 0003 0006 0007 0008 0009 0010 0011 0012 0013 0020 0021 0022 0023 0024 0025 0026 0027 0028 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0092 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0260 0261 0262 0263 0264 0265 0266 0267 0268 0269 0298 0299 0300B 0300 0301 0302B 0302 0303B 0303 0304 0305 0306 0307 0336 0337 0338 0339 0367 0368 0395 0396 0422 0423 0424 0449 0450 0451 0474 0475 0476 0477 0500 0501 0502 0525 0526 0527 0550 0551 0552 0572 0573 0574 0575 0595 0596 0597 0598 0620 0621 0622 0623 0648 0649 0650 0651 0674 0675 0676 0677 0678 0679 0701 0702 0703 0704 0705 0726 0727 0728 0729 0730 0750 0751 0752 0753 0775 0776 0777 0778 0800 0801 0802 0803 0804 0826 0827 0828 0829 0830 0851 0852 0853 0854 0855 0873 0874 0875 0876 0877 0895 0896 0897 0898 0915 0916 0917 0918 0919 0936 0937 0938 0939 0940 0958 0959 0960 0961 0962 0980 0981 0982 0983 0984 0998 0999 1000 1001 1002 1016 1017 1018 1019 1033 1034 1047 1048 1061 1062 1068 1069 1073 1076 0014 0015 0018 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0091B 0103 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0145B 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244 0245 0246 0247 0248 0270 0271 0272 0273 0274 0275 0276 0277 0278 0279 0280 0281 0282 0283 0284 0285 0286 0308 0309 0310 0311 0312 0313 0314 0315 0316 0317 0318 0319 0320 0321 0322 0323 0324 0340 0341 0342 0343 0344 0345 0346 0347 0348 0349 0350 0351 0352 0353 0354 0355 0356 0369 0370 0371 0372 0373 0374 0375 0376 0377 0378 0379 0380 0381 0382 0383 0384 0385 0397 0398 0399 0400 0401 0402 0403 0404 0405 0406 0407 0408 0409 0410 0411 0412 0413 0425 0426 0427 0428 0429 0430 0431 0432 0433 0434 0435 0436 0437 0438 0439 0440 0441 0452 0453 0454 0455 0456 0457 0458 0459 0460 0461 0462 0463 0464 0465 0466 0467 0468 0478 0479 0480 0481 0482 0483 0484 0485 0486 0487 0488 0489 0490 0491 0492 0493 0494 0503 0504 0505 0506 0507 0508 0509 0510 0511 0512 0513 0514 0515 0516 0517 0518 0519 0528 0529 0530 0531 0532 0533 0534 0535 0536 0537 0538 0539 0540 0541 0542 0543 0544 0553 0554 0555 0556 0557 0558 0559 0560 0561 0562 0563 0564 0565 0566 0567 0568 0569 0576 0577 0578 0579 0580 0581 0582 0583 0584 0585 0586 0587 0588 0589 0590 0591 0592 0599 0600 0601 0602 0603 0604 0605 0606 0607 0608 0609 0610 0611 0612 0613 0614 0615 0624 0625 0626 0627 0628 0629 0630 0631 0632 0633 0634 0635 0636 0637 0638 0639 0640 0652 0653 0654 0655 0656 0657 0658 0659 0660 0661 0662 0663 0664 0665 0666 0667 0668 0680 0681 0682 0683 0684 0685 0686 0687 0688 0689 0690 0691 0692 0693 0694 0695 0696 0706 0707 0708 0709 0710 0711 0712 0713 0714 0715 0716 0717 0718 0719 0720 0721 0722 0731 0732 0733 0734 0735 0736 0737 0738 0739 0740 0741 0742 0743 0744 0745 0746 0747 0754 0755 0756 0757 0758 0759 0760 0761 0762 0763 0764 0765 0766 0767 0768 0769 0770 0779 0780 0781 0782 0783 0784 0785 0786 0787 0788 0789 0790 0791 0792 0793 0794 0795 0805 0806 0807 0808 0809 0810 0811 0812 0813 0814 0815 0816 0817 0818 0819 0820 0821 0831 0832 0833 0834 0835 0836 0837 0838 0839 0840 0841 0842 0843 0844 0845 0846 0847 0856 0857 0858 0859 0860 0861 0862 0863 0864 0865 0866 0867 0868 0869 0870 0871 0872 0878 0879 0880 0881 0882 0883 0884 0885 0886 0887 0888 0889 0890 0891 0892 0893 0894 0899 0900 0901 0902 0903 0904 0905 0906 0907 0908 0909 0910 0911 0912 0913 0914 0920 0921 0922 0923 0924 0925 0926 0927 0928 0929 0930 0931 0932 0933 0934 0935 0941 0942 0943 0944 0945 0946 0947 0948 0949 0950 0951 0952 0953 0954 0955 0956 0963 0964 0965 0966 0967 0968 0969 0970 0971 0972 0973 0974 0975 0976 0977 0978 0985 0986 0987 0988 0989 0990 0991 0992 0993 0994 0995 0996 0997 0997B 1003 1004 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 1030 1031 1032 1035 1036 1037 1038 1039 1040 1041 1042 1043 1044 1045 1046 1049 1050 1051 1052 1053 1054 1055 1056 1057 1058 1059 1060 1063 1064 1065 1066 1067 1070 1071 1072 1072B 1074 1075 1077 1078 0118B 0146 0147 0148 0149B 0149 0150 0178 0179 0180 0181 0182 0183 0211 0212 0213 0214 0215 0216 0217B 0217 0218 0219 0220 0221 0249 0250 0251 0252 0253 0254 0255 0256 0257 0258 0259 0287 0288 0289 0290 0291 0292 0293 0294 0295 0296 0297 0325 0326 0327 0328 0329 0330 0331 0332 0333 0334 0335 0357 0358 0359 0360 0361 0362 0363 0364 0365 0366 0386 0387 0388 0389 0390 0391 0392 0393 0394 0414 0415 0416 0417 0418 0419 0420 0421B 0421 0442 0443 0444 0445 0446 0447 0448 0469 0470 0471 0472 0473B 0473 0495 0496 0497 0498 0520 0521 0522 0523 0545 0546 0547 0570 0571B 0571 0593 0594 0616 0617 0641 0669 0771 0796 0822 0823 0848"

# Error counter
ERRORS=0
GOOD=0

# Fix for certain bad files:

# 1032B sheet (contained in 1033 zip file):
echo "#########################"
echo "Processing special sheets"
echo "#########################"
if [ -f $DEMFILES/MDT$MDT-1033.zip ]; then
    unzip -qoj $DEMFILES/MDT$MDT-1033.zip -d $TEMPDIR
    echo "Converting NON-LIDAR sheet ${bold}1032B${normal} to GeoTiff (UTM 30N + WGS84)"
    gdalwarp -q -ot Float32 -s_srs '+proj=utm +zone=29 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' -t_srs '+proj=utm +zone=30 +datum=WGS84 +no_defs' $TEMPDIR/MDT$MDT-1032B-H29.asc $TEMPDIR/1032B.tif
    if [ -f $TEMPDIR/1032B.tif ];then
        rm "$TEMPDIR"/MDT"$MDT-103"*.asc
        GOOD=$((GOOD+1))
    else
        echo "###########################"
        echo "    ${bold}ERROR${normal} ON FILE 1032B       "
        echo "###########################"
        echo "Sheet ${bold}1032B${normal} failed" >> $TEMPDIR/errors.log
        ERRORS=$((ERRORS+1))
    fi
fi

# 895 sheet doesn't have H30, only H29. Converting before the rest.
if [ -f $DEMFILES/MDT$MDT-0895-LIDAR.zip ]; then
    unzip -qoj $DEMFILES/MDT$MDT-0895-LIDAR.zip -d $TEMPDIR
    echo "Converting LIDAR sheet ${bold}0895${normal} to GeoTiff (UTM 30N + WGS84)"
    gdalwarp -q -ot Float32 -s_srs '+proj=utm +zone=29 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' -t_srs '+proj=utm +zone=30 +datum=WGS84 +no_defs' $TEMPDIR/MDT$MDT-0895-H29-LIDAR.asc $TEMPDIR/0895.tif
    if [ -f $TEMPDIR/0895.tif ];then
        rm "$TEMPDIR"/MDT"$MDT-0895"-*.asc
        GOOD=$((GOOD+1))
    else
        echo "###########################"
        echo "    ${bold}ERROR${normal} ON FILE 895       "
        echo "###########################"
        echo "Sheet ${bold}0895${normal} failed" >> $TEMPDIR/errors.log
        ERRORS=$((ERRORS+1))
    fi
fi

# UTM 29N FILES
echo "#########################"
echo "   Processing sheets"
echo "#########################"
for i in $files
do  
    # file unzipping
    # check if sheet is lidar or no lidar version, if lidar version exists choose this one.
    if [ -f $DEMFILES/MDT$MDT-$i-LIDAR.zip ]
    then
        # we have LIDAR version of this sheet
        #echo "$i is a LIDAR sheet"
        LIDAR=TRUE
        ZIP=MDT$MDT-$i-LIDAR.zip
        ASCFILE=$TEMPDIR/MDT$MDT-$i-H30-LIDAR.asc
        GOOD=$((GOOD+1))
    elif [ -f $DEMFILES/MDT$MDT-$i.zip ]; then
        #echo "$i is a NON-LIDAR sheet"
        LIDAR=FALSE
        ZIP=MDT$MDT-$i.zip
        ASCFILE=$TEMPDIR/MDT$MDT-$i-H30.asc
        GOOD=$((GOOD+1))
    else
        echo "${bold}Sheet $i is missing${normal}"
        echo "${bold}Sheet $i is missing${normal}" >> $TEMPDIR/errors.log
        ERRORS=$((ERRORS+1))
    fi    

    # unzip file    
    unzip -qoj $ZIP -d $TEMPDIR
    if [ $LIDAR == TRUE ]
    then
        echo "Converting LIDAR sheet ${bold}$i${normal} to GeoTiff (UTM 30N + WGS84)"
    else
        echo "Converting NON-LIDAR sheet ${bold}$i${normal} to GeoTiff (UTM 30N + WGS84)"
    fi
    gdalwarp -q -ot Float32 -s_srs '+proj=utm +zone=30 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs' -t_srs '+proj=utm +zone=30 +datum=WGS84 +no_defs' $ASCFILE $TEMPDIR/$i.tif
    # delete asc file if
    if [ -f $TEMPDIR/$i.tif ]
    then
        rm "$TEMPDIR"/MDT"$MDT-$i"-*.asc
    else
        echo "###########################"
        echo "    ${bold}ERROR${normal} ON FILE $i       "
        echo "###########################"
        echo "${bold}Error converting sheet $i${normal}" >> $TEMPDIR/errors.log
        ERRORS=$((ERRORS+1))
    fi
done

#Check if there was any error. If errors ocurred, ask for confirmation to continue.
if [ $ERRORS -ne 0 ]; then
    echo "There was some error processing sheets"
    echo "following sheets are missing:"
    cat $TEMPDIR/errors.log
    read -p "Press [Enter] to continue or Ctrl+C to cancel"
else
    echo "DONE!"
    echo "$GOOD sheets has been processed"
fi

echo "###########################"
echo "   GENERATING BIG DEM   "
echo "###########################"

gdal_merge.py -a_nodata -9999 -n -999 -o "$TEMPDIR"/big_dem.tif "$TEMPDIR"/*.tif

echo "###########################"
echo "  GENERATING GEOID MODEL "
echo "###########################"

# Geoid model and interpolated to MDT05/25
if [ $MDT == 25 ]
then
    #MDT ==25, 25 meters == 000283817840743 degrees
    gdalwarp -s_srs EPSG:4258 -t_srs '+proj=utm +zone=30 +datum=WGS84 +no_defs' -srcnodata -999 -dstnodata -9999 -tr 25 25 $GEOID $TEMPDIR/geoid.tif
else
    #MDT == 05, 5 meters == 0.000056765707368 degrees
    gdalwarp -s_srs EPSG:4258 -t_srs '+proj=utm +zone=30 +datum=WGS84 +no_defs' -srcnodata -999 -dstnodata -9999 -tr 5 5 $GEOID $TEMPDIR/geoid.tif
fi

echo "###########################"
echo "  GENERATING CUTLINE      "
echo "###########################"

gdaltindex $TEMPDIR/clipper.shp $TEMPDIR/big_dem.tif

echo "###########################"
echo "        GEOID's CUT      "
echo "###########################"

gdalwarp -cutline $TEMPDIR/clipper.shp -crop_to_cutline $TEMPDIR/geoid.tif $TEMPDIR/geoid_clipped.tif

echo "###########################"
echo "GENERATING ELLIPSOIDAL DEM"
echo "###########################"

gdal_calc.py -A $TEMPDIR/geoid_clipped.tif -B $TEMPDIR/big_dem.tif --outfile $TEMPDIR/big_dem_ellipsoidal.tif --NoDataValue=-9999 --calc="A+B"

echo "###########################"
echo " COPYING FINAL RESULTS    "
echo "###########################"

mv $TEMPDIR/big_dem.tif $RESULTDIR/DEM_IBERIAN_PENINSULA_"$MDT"m_UTM30_WGS84_ORTHOMETRIC.tif
mv $TEMPDIR/big_dem_ellipsoidal.tif $RESULTDIR/DEM_IBERIAN_PENINSULA_"$MDT"m_UTM30_WGS84_ELLIPSOIDAL.tif

echo "DONE!"

# delete temporal directories
rm -r $TEMPDIR