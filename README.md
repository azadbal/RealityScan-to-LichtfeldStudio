# RealityScan → LichtFeldStudio

Batch scripts for going from RealityScan image alignment to Gaussian splat training in LichtFeldStudio with minimal setup.

## Tutorial

[![Watch the tutorial](https://img.youtube.com/vi/HuwLE33Dod4/hqdefault.jpg)](https://www.youtube.com/watch?v=HuwLE33Dod4)

## Overview

This repo provides two ways to move from RealityScan to LichtFeldStudio:

1. **Use an existing RealityScan alignment**
2. **Run the full pipeline automatically** (alignment → export → training)

## Setup

1. Download this repo and extract it into the **root folder of your project**.
2. Place your images in:

```
images/
```

3. Check the executable paths inside the scripts:

- `RealityScan.exe`
- `LichtFeldStudio.exe`

4. Edit training settings in:

```
User_Settings.txt
```

Example setting:

```
TRAINING_STEPS=15000
```

## Option 1 — Use an existing RealityScan alignment

If you already aligned your images in RealityScan and want to keep that result:

1. Open the `.rccmd` file inside `RCCMD/`
2. Replace the placeholder directory with the folder path where the file sits
3. Drag the `.rccmd` file into RealityScan

RealityScan will export:

- Undistorted images
- COLMAP camera poses

These will appear in the `colmap/` folder.

You can then load this folder directly in LichtFeldStudio and start training.

## Option 2 — Full automated pipeline

Place the repo in your project root so the structure looks like:

```
project_root/
  images/
  RS-to-LichtFeldStudio/
```

Run:

```
_RunAllSteps.bat
```

This will:

1. Launch RealityScan
2. Import images
3. Group cameras by calibration
4. Align images
5. Export COLMAP poses and undistorted images
6. Save the RealityScan project
7. Launch LichtFeldStudio
8. Start splat training

## Retraining

If the COLMAP folder already exists and you only want to retrain with different settings:

```
2-LFS-train.bat
```

Edit `User_Settings.txt` first to change training parameters.

## Folder layout

```
images/   source images
colmap/   undistorted images + COLMAP poses
output/   splat output
RS/       RealityScan project files
scripts/  batch scripts
```

