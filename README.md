# ASL_American_Sign_Language_To_Speech


Data can be downloaded from https://www.kaggle.com/datasets/grassknoted/asl-alphabet.

Dataset should be downloaded separately from the link above. The downloaded dataset folder should be unzipped and renamed to "data" which should be placed in the main directory "ASL_American_Sign_Language_To_Speech/data" (relative path)

Note: The structure of the dataset directory should be kept as it is when newly downloaded.

RECOMMENDED: FOLLOWING THIS PROCEDURE TO EASE THE DOWNLOADING DATA WITH ONLY ONE COMMAND LATER ON
    (If kaggle has been setup on your machine, step 1 and 2 can be skipped.)
    1. Install kaggle to allow API downloading
        $ pip install kaggle
      This step will also create a ".kaggle" folder. On Windows machine, the default location is "C:\{user}\.kaggle"
    2. Get API user credentials
        - Log into your kaggle account
        - Go to "Account"
        - Click on "Create New API Token"
        - Save the to-be-downloaded "kaggle.json" to the ".kaggle\kaggle.json"
    3. Now, kaggle has been setup. Datasets can be downloaded using Kaggle API with one command (Example for this project)
        $ kaggle datasets download -d grassknoted/asl-alphabet -p ./data.zip --unzip
      The command will download the data needed for this project, rename and unzip it. No more setup steps are needed.
