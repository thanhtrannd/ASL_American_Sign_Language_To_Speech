# ASL_American_Sign_Language_To_Speech


Data can be downloaded from https://www.kaggle.com/datasets/grassknoted/asl-alphabet.

Dataset should be downloaded separately from the link above. The downloaded dataset folder should be unzipped and renamed to "data" which should be placed in the main directory "ASL_American_Sign_Language_To_Speech/data" (relative path)

Note: The structure of the dataset directory should be kept as it is when newly downloaded.

RECOMMENDED: FOLLOWING THIS PROCEDURE TO EASE THE DOWNLOADING DATA WITH ONLY ONE COMMAND LATER ON
    <br />(If kaggle has been setup on your machine, step 1 and 2 can be skipped.)
    <ul>
        <li>1. Install kaggle to allow API downloading</li>
            <ul>
                <li>$ pip install kaggle</li>
                <li>This step will also create a ".kaggle" folder. On Windows machine, the default location is "C:\{user}\.kaggle"</li>
            </ul>
        <li>2. Get API user credentials</li>
            <ul>
                <li>Log into your kaggle account</li>
                <li>Go to "Account"</li>
                <li>Click on "Create New API Token"</li>
                <li>Save the to-be-downloaded "kaggle.json" to the ".kaggle\kaggle.json"</li>
            </ul>
        <li>3. Now, kaggle has been setup. Datasets can be downloaded using Kaggle API with one command (Example for this project)</li>
            <ul>
                <li>Note: Make sure that this repository directory is the current working directory</li>
                <li>$ kaggle datasets download -d grassknoted/asl-alphabet -p ./data.zip --unzip</li>
                <li>The command will download the data needed for this project, rename and unzip it. No more setup steps are needed.</li>
            </ul>
    </ul>
