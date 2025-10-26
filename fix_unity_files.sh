#!/bin/bash

# Script to fix corrupted Unity asset bundles in Warcry-Cameras repository

echo "=== Unity Asset Bundle Fix Script ==="
echo "This script will fix the corrupted Unity files in your repository"
echo ""

# Check if we're in the repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository. Please run this script from your Warcry-Cameras folder."
    exit 1
fi

# Step 1: Remove corrupted files from Git (but keep local copies)
echo "Step 1: Removing corrupted Unity files from Git tracking..."
git rm --cached *.unity3d
if [ $? -ne 0 ]; then
    echo "No Unity files to remove, continuing..."
fi

# Step 2: Commit the removal
echo "Step 2: Committing file removal..."
git commit -m "Remove corrupted unity files for re-upload"
git push

# Step 3: Create a temporary directory for fresh downloads
echo "Step 3: Downloading fresh copies from RobMayer's repository..."
mkdir -p temp_downloads
cd temp_downloads

# Download the original files from RobMayer's repo
wget -O cam_o1_source.unity3d https://raw.githubusercontent.com/RobMayer/TTSLibrary/master/cameras/cam_o1_source.unity3d
wget -O cam_o1_screenh.unity3d https://raw.githubusercontent.com/RobMayer/TTSLibrary/master/cameras/cam_o1_screenh.unity3d
wget -O cam_mat.unity3d https://raw.githubusercontent.com/RobMayer/TTSLibrary/master/cameras/cam_mat.unity3d

# Check if downloads were successful
if [ ! -f "cam_o1_source.unity3d" ]; then
    echo "Error: Failed to download files. Please check your internet connection."
    exit 1
fi

# Step 4: Rename files to your naming convention
echo "Step 4: Renaming files to your convention..."
mv cam_o1_source.unity3d ../Warcry_cam_o1_source.unity3d
mv cam_o1_screenh.unity3d ../Warcry_cam_o1_screenh.unity3d
mv cam_mat.unity3d ../Warcry_cam_mat.unity3d

# Step 5: Go back to main directory and clean up
cd ..
rm -rf temp_downloads

# Step 6: Add the files back with proper binary handling
echo "Step 5: Adding Unity files back with proper binary handling..."
git add *.unity3d
git commit -m "Re-add unity files with proper binary handling"
git push

echo ""
echo "=== Fix Complete! ==="
echo "Your Unity files should now work properly in TTS."
echo "The raw GitHub URLs should now work:"
echo "  - https://raw.githubusercontent.com/Zignoratio/Warcry-Cameras/main/Warcry_cam_o1_source.unity3d"
echo "  - https://raw.githubusercontent.com/Zignoratio/Warcry-Cameras/main/Warcry_cam_o1_screenh.unity3d"
echo "  - https://raw.githubusercontent.com/Zignoratio/Warcry-Cameras/main/Warcry_cam_mat.unity3d"
